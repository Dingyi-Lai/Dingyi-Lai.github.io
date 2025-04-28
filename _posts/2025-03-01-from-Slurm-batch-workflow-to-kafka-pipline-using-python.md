---
layout: post
author: Dingyi Lai
---

中文版本见后半部分。

这篇技术博客将带你一步步复现 HAICORE 上基于 Slurm 的批处理脚本，并演示如何将其改写为基于 `kafka-python` 的 `Producer`/`Consumer` 示例，实现从集群缓存到持久化存储的流式数据管道。我们先简要概述关键流程：HAICORE 平台作业提交流程（登录节点→Slurm 调度→BeeOND/本地临时存储→家目录持久化）与 Kafka 数据管道（Producer→Topic 缓冲→Consumer→外部系统）高度契合，接着给出原始 Slurm 脚本与等效的 Python 代码示例，帮助你快速上手。

## 背景介绍

### HAICORE 平台概览  
HAICORE 是 KIT 的 Helmholtz AI 分区，集成于 HoreKa 超算，共有 16 台计算节点，采用 InfiniBand 4×HDR 互联，提供低延迟高吞吐的计算环境 citeturn3search0。集群操作依赖 Slurm 管理资源调度，并在 BeeOND 临时文件系统中进行高性能中间数据读写，最终将结果同步到用户家目录或并行文件系统 citeturn3search7。

### Slurm 作业流程  
用户在登录节点编写批处理脚本，通过 `sbatch` 提交至 Slurm 控制器，Slurm 按队列和资源可用性分配计算节点并执行脚本 citeturn1search3。脚本开头以 `#SBATCH` 指令声明作业名称、节点数、任务数、运行时长等，随后执行加载模块及核心计算命令 citeturn1search0。脚本运行时，程序可读写 `$TMPDIR`（本地临时目录）或 BeeOND 文件系统，作业结束后将输出结果复制回 `$SLURM_SUBMIT_DIR`（默认作业提交目录）以持久化 citeturn2search0。

## Kafka 数据管道概述  
Apache Kafka 是分布式日志系统，专注于实时消息发布/订阅，具备高吞吐、低延迟的特性，常用作流式数据管道的缓冲层 citeturn0search0。生产者（Producer）将消息写入 Topic，消息被追加存储后可由多个消费者（Consumer）并行拉取并落地至外部系统 citeturn0search3。借助 `kafka-python` 库，Python 应用可快速构建生产者和消费者示例 citeturn0search2。

## 复现 HAICORE/Slurm 作业脚本

### 原始 Slurm 脚本示例  
以下示例脚本假定在登录节点的工作目录下编写 `my_job.slurm` 并提交，脚本加载 Python 模块，然后在本地临时目录处理数据并将结果保存回提交目录：

```bash
#!/bin/bash
#SBATCH --job-name=demo_job            # 作业名称 citeturn1search0
#SBATCH --output=demo_job.out          # 标准输出文件
#SBATCH --error=demo_job.err           # 标准错误文件
#SBATCH --partition=normal             # 作业队列
#SBATCH --nodes=1                      # 节点数量
#SBATCH --ntasks-per-node=1            # 每节点任务数
#SBATCH --cpus-per-task=4              # 每任务 CPU 核心数
#SBATCH --time=02:00:00                # 最长运行时间
#SBATCH --mail-type=END                # 完成时邮件通知
#SBATCH --mail-user=you@example.com    # 邮件接收地址

module load python/3.9                  # 加载 Python 环境
echo "Job starts at $(date)"
cd $SLURM_SUBMIT_DIR                    # 切换到提交目录 citeturn2search0

# 在本地临时目录处理数据
input_file="$TMPDIR/input.csv"
cp data/input.csv $input_file           # 复制至本地高速存储 citeturn3search7
python process_data.py --input $input_file --output $TMPDIR/result.csv

# 同步结果回提交目录
cp $TMPDIR/result.csv $SLURM_SUBMIT_DIR/output_$(date +%s).csv
echo "Job ends at $(date)"
```

## 改写为 kafka-python 的 Producer/Consumer 示例

### 安装依赖  
```bash
pip install kafka-python
```

### KafkaProducer 示例  
下面代码在本地模拟生产者，将处理后的数据流式发送到 Kafka 的 `haicore_topic`。  
```python
from kafka import KafkaProducer
import json, time, os

# 初始化 Producer
producer = KafkaProducer(
    bootstrap_servers=['kafka-broker1:9092'],
    value_serializer=lambda v: json.dumps(v).encode('utf-8')
)  # citeturn0search2

def stream_results():
    # 假设处理脚本输出保存在当前目录 result.csv
    with open('result.csv') as f:
        for line in f:
            record = {'timestamp': time.time(), 'data': line.strip()}
            # 异步发送消息
            producer.send('haicore_topic', record)
            print(f"Sent: {record}")
            time.sleep(0.1)  # 模拟流速

    # 确保所有消息发送完毕
    producer.flush()

if __name__ == '__main__':
    stream_results()
```
- 使用 `KafkaProducer.send()` 将消息异步写入 Topic citeturn0search0。  
- `flush()` 用于在程序退出前阻塞等待所有消息传输完成citeturn0search6。

### KafkaConsumer 示例  
下面示例实现从 `haicore_topic` 拉取消息并写入本地文件，类似于 Slurm 将缓存结果持久化。  
```python
from kafka import KafkaConsumer
import json

# 初始化 Consumer
consumer = KafkaConsumer(
    'haicore_topic',
    bootstrap_servers=['kafka-broker1:9092'],
    auto_offset_reset='earliest',
    enable_auto_commit=True,
    value_deserializer=lambda m: json.loads(m.decode('utf-8'))
)  # citeturn0search3

output_path = 'sink_output.csv'
with open(output_path, 'w') as fout:
    for message in consumer:
        rec = message.value
        fout.write(f"{rec['timestamp']},{rec['data']}\n")
        print(f"Consumed: {rec}")
```
- `auto_offset_reset='earliest'` 确保从最早消息开始消费citeturn0search3。  
- 消费完毕后文件即为持久化结果，等同于 Slurm 脚本中的家目录保存。

## 小结  
通过以上示例，你可以将 HAICORE/Slurm 上的作业脚本思路迁移到 Kafka 流式管道：  
1. **Slurm Producer**：`sbatch` + 本地缓存 → `kafka-python.KafkaProducer` 流式发送；  
2. **中间缓冲**：BeeOND/$TMPDIR ↔ Kafka Topic 分区缓冲；  
3. **Slurm Consumer**：本地文件复制回家目录 ↔ `kafka-python.KafkaConsumer` 消费并落盘。  

这种转换不仅复用了你对集群作业调度、临时存储与家目录同步的理解，也让你具备了构建实时、可扩展数据管道的实战能力。下一步可结合 Spark Streaming 或 Flink 等计算引擎进一步丰富流处理能力。