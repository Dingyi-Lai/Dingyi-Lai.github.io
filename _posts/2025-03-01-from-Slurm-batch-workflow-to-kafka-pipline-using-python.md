---
layout: post
author: Dingyi Lai
---

Below is a technical deep-dive showing how to reproduce a HAICORE/Slurm batch workflow as a real-time Kafka pipeline using Python and `kafka-python`. You’ll learn:

1. How HAICORE’s Slurm → $TMPDIR → $SLURM_SUBMIT_DIR flow maps to Kafka’s Producer → Topic buffer → Consumer model.  
2. An example Slurm script and its equivalent Python Kafka code (Producer & Consumer).  
3. Key considerations for ensuring reliable, high-throughput streaming with Kafka.

## 1. HAICORE + Slurm Batch Workflow

HAICORE is KIT’s Helmholtz AI partition within the HoreKa supercomputer, comprising 16 compute nodes interconnected by InfiniBand 4×HDR for <1 μs latency and high throughput citeturn1view0.  
Each node runs RHEL 8.x with open-source tools such as **Slurm** for job scheduling already installed citeturn1view0.  
Users develop and debug interactively on the **login node**, then submit batch jobs via `sbatch` to Slurm, which queues and dispatches them to compute nodes when resources free up citeturn3search0.  
Within a job, `$TMPDIR` (local SSD or BeeOND mount) is used for high-speed temporary I/O; after processing, output is copied back to the submission directory (`$SLURM_SUBMIT_DIR`) for persistence citeturn4search0 citeturn7search0.  

### 1.1 Example Slurm Script

```bash
#!/bin/bash
#SBATCH --job-name=demo_job                # Name of the job citeturn3search0
#SBATCH --output=demo_job.%j.out           # Stdout (with JobID)
#SBATCH --error=demo_job.%j.err            # Stderr (with JobID)
#SBATCH --partition=normal                 # Partition/queue
#SBATCH --nodes=1                          # Number of nodes
#SBATCH --ntasks-per-node=1                # Tasks per node
#SBATCH --cpus-per-task=4                  # CPUs per task
#SBATCH --time=02:00:00                    # Walltime
#SBATCH --mail-type=END                    # Email at end
#SBATCH --mail-user=you@example.com        # Email address

module load python/3.9                      # Load Python  
cd $SLURM_SUBMIT_DIR                        # Switch to submit dir citeturn4search0

# Copy input to fast local storage (BeeOND or $TMPDIR)
cp data/input.csv $TMPDIR/input.csv         # High-performance I/O citeturn7search0
python process_data.py --input $TMPDIR/input.csv --output $TMPDIR/result.csv

# Copy result back for long-term storage
cp $TMPDIR/result.csv $SLURM_SUBMIT_DIR/output_${SLURM_JOB_ID}.csv
```

## 2. Mapping to a Kafka Data Pipeline

**Apache Kafka** is an open-source distributed event streaming platform for building high-throughput, low-latency data pipelines and streaming applications citeturn5search1.  
A **streaming pipeline** “ingests data as it’s generated, buffers it in Kafka topics, and delivers it to one or more consumers” citeturn5search0.  

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
)  # Asynchronous send by default citeturn6search1

def stream_results():
    # Simulate reading processed output
    with open('result.csv', 'r') as f:
        for line in f:
            record = {'timestamp': time.time(), 'data': line.strip()}
            producer.send('haicore_topic', record)
            print(f"Sent: {record}")
            time.sleep(0.1)  # Throttle for demonstration

    # Ensure all pending messages are flushed to brokers
    producer.flush()  # Blocks until all records are sent citeturn8search0

if __name__ == '__main__':
    stream_results()
```

- **`producer.send()`** enqueues messages for the background I/O thread citeturn6search1.  
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
)  # Lazy offset reset and auto-commit citeturn9search0

with open('sink_output.csv', 'w') as fout:
    for msg in consumer:
        rec = msg.value
        fout.write(f"{rec['timestamp']},{rec['data']}\n")
        print(f"Consumed: {rec}")
```

- **`auto_offset_reset='earliest'`** ensures consumption from the beginning citeturn9search0.  
- Persisted records in `sink_output.csv` mirror Slurm’s final copy-back step.

## 4. Next Steps

- Integrate **Spark Structured Streaming** or **Flink** for real-time transformations.  
- Use **Kafka Connect** to sink data directly into databases or object stores.  
- Monitor throughput and latency via **Kafka’s metrics** and adjust producer/consumer configs (e.g. `linger_ms`, batch sizes, retries).

---

By following this recipe, you seamlessly leverage your Slurm/HAICORE expertise to build robust, real-time Kafka pipelines in Python—perfectly aligning with modern “Data Analysis Engineer” roles that demand scalable, streaming data architectures.

Chinese version:

