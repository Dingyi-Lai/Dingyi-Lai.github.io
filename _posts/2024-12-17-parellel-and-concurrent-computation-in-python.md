---
layout: post
author: Dingyi Lai
---

When I first ran my full‐factorial simulation, it took **over 13 hours** on a 16-core machine. By restructuring it to use both **process‐based parallelism** for the outer loop and **thread‐based concurrency** for the inner work, I slashed total runtime to **30 minutes**. Here’s how I did it:

---

## 1. The Challenge  
- **Massive parameter grid**
- **Heavy work per replicate**:  
  - Generating estimation effects via training a DNN on each replicate 
  - Simulating responses with ensured SNR
  - Saving dozens of arrays to disk  

A naïve serial loop ran every combination end-to-end and simply couldn’t finish in a workday.

## 2. Parallelizing the Outer Loop with `multiprocessing.Pool`  
I identify each **(sample size, replicate index)** pair as an independent “task.” By wrapping my `generate_task(...)` function in a `multiprocessing.Pool`, I can schedule dozens of these tasks across all available CPU cores:

```python
import multiprocessing as mp

def scenarios_generate(...):
    tasks = [(..., 'parallel')
             for i in I
             for j in J]
    with mp.Pool(mp.cpu_count()) as pool:
        pool.starmap(f, tasks)
```

- **Why processes?** Each task is CPU‐bound (generateion and DNN training), so separate Python interpreters avoid the GIL.  
- **Result:** Almost perfect scaling up to ~16 cores—13.5 hours → ~1 hour.

## 3. Concurrentizing the Inner Loop with `ThreadPoolExecutor`  
Inside each `generate_task`, I still had to loop over multiple **(distribution, SNR)** combinations. Those steps involve generating data and saving files—operations that mix CPU work with I/O. Spawning new processes here would be heavy, so I used a **thread pool**:

```python
from concurrent.futures import ThreadPoolExecutor

def generate_task(...):
    # ... build effects ...
    with ThreadPoolExecutor() as threads:
        threads.map(
            lambda args: f(*args),
            [(...)
             for i in I
             for j in J]
        )
```

- **Why threads?** I/O operations (file saving) and small compute bursts benefit from lightweight threads without the overhead of new processes.  
- **Nested parallelism**: by combining `Pool` (outer) with `ThreadPoolExecutor` (inner), tasks stay isolated and efficient.

## 5. Results & Lessons Learned  
- **Raw speedup**: 13.5 hours → 0.5 hour (∼27× faster)  
- **Scalability**: As I add more cores, end‐to‐end time shrinks nearly linearly until I/O saturates.  
- **Maintainability**: By isolating `generate_task` inputs/outputs, debugging and retrying failed replicates became trivial.  
- **Trade-offs**:  
  - More cores help, but file‐system contention can become a bottleneck if everyone writes simultaneously.  
  - Thread pools excel at overlapping I/O, but too many threads may exhaust memory.  

## 6. Tips for Your Own Simulations  
- **Identify independent units** (replicates, parameter sets) and parallelize over them first.  
- **Use `multiprocessing.Pool`** for heavy CPU‐bound chunks.  
- **Nest `ThreadPoolExecutor`** if you need lightweight concurrency for I/O or small computations inside each process.  
- **Measure & tune**: run small benchmarks varying batch sizes, number of workers, and I/O patterns.  
- **Keep tasks stateless**: functions should receive all inputs and write all outputs without shared global state.

By combining process‐based and thread‐based concurrency, I turned a over 12-hour overnight batch into a half-hour morning run—freeing up my workstation for other experiments!