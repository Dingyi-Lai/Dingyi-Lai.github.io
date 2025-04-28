---
layout: post
author: Dingyi Lai
---

Below is a technical deep-dive showing how to reproduce a [HAICORE](https://www.nhr.kit.edu/userdocs/haicore/)/Slurm batch workflow as a real-time Kafka pipeline using Python and `kafka-python`. You’ll learn:

1. How HAICORE’s Slurm → $TMPDIR → $SLURM_SUBMIT_DIR flow maps to Kafka’s Producer → Topic buffer → Consumer model.  
2. An example Slurm script and its equivalent Python Kafka code (Producer & Consumer).  
3. Key considerations for ensuring reliable, high-throughput streaming with Kafka.

## 1. HAICORE + Slurm Batch Workflow

HAICORE is KIT’s Helmholtz AI partition within the HoreKa supercomputer, comprising 16 compute nodes interconnected by InfiniBand 4×HDR for <1 μs latency and high throughput (See [Hardware Overview](https://www.nhr.kit.edu/userdocs/haicore/hardware/)).  
Each node runs RHEL 8.x with open-source tools such as [**Slurm**](https://slurm.schedmd.com/sbatch.html) for job scheduling already installed.  
Users develop and debug interactively on the **login node**, then submit batch jobs via `sbatch` to Slurm, which queues and dispatches them to compute nodes when resources free up (See [ARCH Advanced Research Computing](https://www.arch.jhu.edu/short-tutorial-how-to-create-a-slurm-script/)).  
Within a job, `$TMPDIR` (local SSD or BeeOND mount) is used for high-speed temporary I/O; after processing, output is copied back to the submission directory (`$SLURM_SUBMIT_DIR`) for persistence (See [File Systems - NHR@KIT User Documentation](https://www.nhr.kit.edu/userdocs/haicore/filesystems/)). 

### 1.1 Example Slurm Script

```bash
#!/bin/bash
#SBATCH --job-name=demo_job                # Name of the job
#SBATCH --output=output_%j.log             # Output log (_%j = job ID)
#SBATCH --error=error_%j.log               # Error log (_%j = job ID)
#SBATCH --partition=normal                 # Partition/queue
#SBATCH --nodes=1                          # Number of nodes
#SBATCH --ntask=1                          # Number of tasks
#SBATCH --ntasks-per-node=1                # Tasks per node
#SBATCH --cpus-per-task=4                  # CPUs per task
#SBATCH --time=02:00:00                    # Walltime
#SBATCH --mail-type=ALL                    # Email for starting, ending and failling
#SBATCH --mail-user=you@example.com        # Email address

export TF_ENABLE_ONEDNN_OPTS=0 # disables oneDNN optimizations in TensorFlow to prevent minor floating-point discrepancies due to parallel execution order​
export OMP_NUM_THREADS=1 #  forces OpenMP to use only one thread, preventing oversubscription and context-switch overhead in nested parallel regions

module load python/3.9                      # Load Python  
module load jupyter/ai                      # Load AI environment

cd $SLURM_SUBMIT_DIR                        # Switch to submit dir citeturn4search0

# Copy input to fast local storage (BeeOND or $TMPDIR)
cp data/input.csv $TMPDIR/input.csv         # High-performance I/O 
python process_data.py --input $TMPDIR/input.csv --output $TMPDIR/result.csv

# Copy result back for long-term storage
cp $TMPDIR/result.csv $SLURM_SUBMIT_DIR/output_${SLURM_JOB_ID}.csv
```

## 2. Mapping to a Kafka Data Pipeline

**Apache Kafka** is an open-source distributed event streaming platform for building high-throughput, low-latency data pipelines and streaming applications.  
A **streaming pipeline** “ingests data as it’s generated, buffers it in Kafka topics, and delivers it to one or more consumers”.  

| Slurm Workflow Component                | Kafka Pipeline Component             |
|-----------------------------------------|--------------------------------------|
| `sbatch` submits job to Slurm controller | **Producer** publishes messages to a Topic |
| `$TMPDIR` / BeeOND local cache           | **Topic partition** buffer (in-memory/disk) |
| Copy back to `$SLURM_SUBMIT_DIR`        | **Consumer** reads from Topic and writes to sink |

You can reuse your familiarity with batch submission (producer logic), temporary storage (topic buffering), and final persistence (consumer logic) when transitioning to Kafka.

## 3. Python + `kafka-python` Example

### 3.1 Installing the Client

```bash
pip install kafka-python
```

### 3.2 Producer: Streaming Job Results

```python
from kafka import KafkaProducer
import json, time

# Initialize Producer for topic 'haicore_topic'
producer = KafkaProducer(
    bootstrap_servers=['kafka-broker1:9092'],
    value_serializer=lambda v: json.dumps(v).encode('utf-8')
)  # Asynchronous send by default

def stream_results():
    # Simulate reading processed output
    with open('result.csv', 'r') as f:
        for line in f:
            record = {'timestamp': time.time(), 'data': line.strip()}
            producer.send('haicore_topic', record)
            print(f"Sent: {record}")
            time.sleep(0.1)  # Throttle for demonstration

    # Ensure all pending messages are flushed to brokers
    producer.flush()  # Blocks until all records are sent

if __name__ == '__main__':
    stream_results()
```

- **`producer.send()`** enqueues messages for the background I/O thread.  
- **`producer.flush()`** blocks until all buffered records are acknowledged or error out citeturn8search0.

### 3.3 Consumer: Persisting Streamed Data

```python
from kafka import KafkaConsumer
import json

# Initialize Consumer for 'haicore_topic'
consumer = KafkaConsumer(
    'haicore_topic',
    bootstrap_servers=['kafka-broker1:9092'],
    auto_offset_reset='earliest',
    enable_auto_commit=True,
    value_deserializer=lambda m: json.loads(m.decode('utf-8'))
)  # Lazy offset reset and auto-commit

with open('sink_output.csv', 'w') as fout:
    for msg in consumer:
        rec = msg.value
        fout.write(f"{rec['timestamp']},{rec['data']}\n")
        print(f"Consumed: {rec}")
```

- **`auto_offset_reset='earliest'`** ensures consumption from the beginning.  
- Persisted records in `sink_output.csv` mirror Slurm’s final copy-back step.

## 4. Next Steps

- Integrate **Spark Structured Streaming** or **Flink** for real-time transformations.  
- Use **Kafka Connect** to sink data directly into databases or object stores.  
- Monitor throughput and latency via **Kafka’s metrics** and adjust producer/consumer configs (e.g. `linger_ms`, batch sizes, retries).

