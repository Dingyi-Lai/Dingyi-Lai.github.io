---
layout: post
author: Dingyi Lai
---

When I designed the simulation studies for my research, I observed that there are quite some differences between the designs for scientific simulation and industry A/B test, such as:

<!-- | Aspect               | Scientific Simulation                                      | Industry A/B Test                                       |
|----------------------|-------------------------------------------------------------|----------------------------------------------------------|
| **Control over DGP** | Complete: I generate every datapoint from known laws       | Limited: users self-select, and the “real world” may shift |
| **Ground truth**     | Fully known (I decide which effects are nonzero)           | Unknown; the goal is to *discover* whether a change works |
| **Replicability**    | High: any researcher can rerun the same code & seeds         | Moderate: depends on rollout timing, user population     |
| **Scale & Cost**     | Computational cost only                                      | Real users—risk of lost revenue or user dissatisfaction   |
| **Ethics & Risk**    | No human subjects, so experiments can be extreme             | Must limit exposure; changes may harm user experience     |
| **Inference focus**  | Method validation (bias, coverage, power)                    | Causal effect estimation under real-world constraints     |
| **Flexibility**      | Try any hypothetical scenario (e.g. extreme noise levels)     | Constrained by legal, business, and ethical considerations | -->

<table>
  <thead>
    <tr>
      <th>Aspect</th>
      <th>Scientific Simulation</th>
      <th>Industry A/B Test</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>Control over DGP</strong></td>
      <td>Complete: I generate every datapoint from known laws</td>
      <td>Limited: users self-select, and the “real world” may shift</td>
    </tr>
    <tr>
      <td><strong>Ground truth</strong></td>
      <td>Fully known (I decide which effects are nonzero)</td>
      <td>Unknown; the goal is to <em>discover</em> whether a change works</td>
    </tr>
    <tr>
      <td><strong>Replicability</strong></td>
      <td>High: any researcher can rerun the same code & seeds</td>
      <td>Moderate: depends on rollout timing, user population</td>
    </tr>
    <tr>
      <td><strong>Scale & Cost</strong></td>
      <td>Computational cost only</td>
      <td>Real users—risk of lost revenue or user dissatisfaction</td>
    </tr>
    <tr>
      <td><strong>Ethics & Risk</strong></td>
      <td>No human subjects, so experiments can be extreme</td>
      <td>Must limit exposure; changes may harm user experience</td>
    </tr>
    <tr>
      <td><strong>Inference focus</strong></td>
      <td>Method validation (bias, coverage, power)</td>
      <td>Causal effect estimation under real-world constraints</td>
    </tr>
    <tr>
      <td><strong>Flexibility</strong></td>
      <td>Try any hypothetical scenario (e.g. extreme noise levels)</td>
      <td>Constrained by legal, business, and ethical considerations</td>
    </tr>
  </tbody>
</table>

In short, **simulation studies** let me **guarantee** my method works when its assumptions hold, and **diagnose** failure modes under controlled stress tests. **A/B tests**, by contrast, operate on **live systems** to measure actual user responses, often trading off experimental purity for real-world relevance.


## What did I Learn from Designing a Rigorous Scientific Simulation Study

### 1. Start with Clear Objectives  
Before any code gets written, ask:  
- **What phenomenon or estimation procedure am I testing?**  
- **Which parts of my model do I want to probe?**  
- **Which performance criteria (e.g. bias, coverage of confidence intervals) matter most?**

Having crisp aims ensures that every simulation choice directly speaks to the question at hand.

### 2. Specify a Data-Generating Process (DGP)  
A scientific simulation constructs data exactly according to my known “ground truth.” By building in components with different modalities, I can stress-test each part of my estimation framework.

### 3. Control Signal-to-Noise and Scenario Factors  
Systematically vary key knobs to see when my method breaks down or excels:  
- **Signal-to-Noise Ratio (SNR):** e.g. choose low and high SNR so I know how much noise my estimator can tolerate.  
- **Sample Size:** simulate small, medium, and large datasets to assess convergence and power.  
- **Distributional Families:** include at least three types (e.g. discrete counts, skewed positives, continuous with changing variance) so my conclusions aren’t tied to a single data type.  

Combine these factors into a grid of scenarios.

### 4. Replicate and Parallelize  
For each scenario, run many independent **replications** to estimate not just average performance but also its variability. Use parallel computing (e.g. Python’s `multiprocessing.Pool` or R’s `future`) to distribute replications across cores, ensuring my total runtime remains manageable.

### 5. Fit the Model and Compute Metrics  
On each replicate:  
1. **Fit the estimation method** under study.  
2. **Extract point estimates**.  
3. **Construct confidence intervals** or credible bands for every component of interest.  
4. **Evaluate performance**  
   - **Bias / RMSE** for point estimates  
   - **Coverage rate**: proportion of intervals that contain the true value  
   - **Interval width**: how tight are my uncertainty bands?  

A simulation study reveals both **accuracy** and **reliability** of my method under controlled conditions.

### 7. Summarize Robustness and Limitations  
Once all scenarios run, visualize results:  
- **Heatmaps** of coverage rates across SNR and sample size  
- **Line plots** of bias vs. sample size  
- **Boxplots** of interval widths per distribution  

Use these to draw principled conclusions about when the method is trustworthy—and where it needs refinement.

## Takeaways

- A well‐designed simulation is my **laboratory** for method development: I control every ingredient, I know the answers, and I can push the model to its limits.  
- Industry A/B tests are my **field trials**: they validate whether a method that “worked in the lab” actually pays off when real users interact with it.  

By mastering both, I can ensure not only **sound methodology** but also **practical impact**.

# Reference
1. Ramert, A. (2019). Understanding the signal to noise ratio in design of experiments. COE-Report- 08-2019.