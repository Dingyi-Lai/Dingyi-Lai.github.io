---
layout: post
author: Dingyi Lai
---

### Why This Matters  
Estimating how treatments or interventions influence outcomes over time is at the heart of causal inference—but real-world systems often react differently at different quantiles (e.g. the worst-affected vs. median cases). In my master’s thesis, I introduce a **unified “global” framework** that marries causal analysis with modern predictive algorithms—allowing us to uncover not just *whether* an intervention worked, but *how* its impact varies across the full outcome distribution.

---

### The Big Question  
> **How would treated units have evolved, at each forecast horizon, if they’d never received the treatment?** 

To answer this, we:
1. **Define** causal mechanisms via Directed Acyclic Graphs (DAGs).  
<figure>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/PCE_DAG_corrected.png"
  alt="Conceptual table">
   <figcaption style="display:block; text-align:center;">
    Figure 1: DAG for Synthetic Control Method in the Thesis
  </figcaption>
</figure>

2. **State** identification assumptions (e.g. no hidden back-doors).  
- **Assumption 1** (Consistency). 
- **Assumption 2** (Generalized fixed-effects model). 
- **Assumption 3** (Existence of synthetic control from classical synthetic control methods)
- ...

3. **Run** placebo tests to validate the model’s ability to reproduce a “null effect.”  
<figure>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/PCE_unrate_prob.png"
  alt="Conceptual table">
   <figcaption style="display:block; text-align:center;">
    Figure 2: Quantile Distribution for the Simulated Treated Units
  </figcaption>
</figure>

4. **Estimate** probabilistic causal effects across quantiles using forecasts.
<figure>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/PCE_911DeepProbCP.png"
  alt="Conceptual table">
   <figcaption style="display:block; text-align:center;">
    Figure 3: Counterfactual Results for Real-world Data from DeepProbCP
  </figcaption>
</figure>
---

### From Classical Tools to a Global Paradigm  
- **Difference-in-Differences & Synthetic Controls** lay the groundwork for panel-data causal inference.  
- **Local methods** like Bayesian Structural Time Series (CausalImpact) build a separate model *per* treated unit.  
- **Global methods** instead pool information across *all* series before vs. after treatment—learning a single predictor that can generate counterfactual paths for every unit simultaneously.
<figure>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/PCE_DeepProbCP_dataset_structure.png"
  alt="Conceptual table">
   <figcaption style="display:block; text-align:center;">
    Figure 4: Dataset Structure for 911 Emergency Call Dataset
  </figcaption>
</figure>

#### Models Compared  
1. **CausalImpact** (local, parametric Bayesian)  
2. **TSMixer** (MLP-based global)  
3. **DeepProbCP** (LSTM-based global with quantile forecasting)  
4. **Temporal Fusion Transformer (TFT)** (attention-based global)

---

### How We Measure Success  
- **Point forecasts**: sMAPE (average relative deviation between predictions and observations), MASE (compares forecast accuracy to a naïve seasonal baseline)  
- **Probabilistic forecasts**: CRPS (the quality of a full predictive distribution by integrating pinball loss over all quantiles)
- **Placebo tests**: ensure that control units (which never receive treatment) show *no* spurious effect.  
- **Quantile treatment effects (QTE)**: compare predicted vs. observed for each quantile.

---

### Key Findings  

1. **Synthetic Data Experiments**  
   - For small, *linear* series: **CausalImpact** wins on point metrics.  
   - As series grow in number or complexity: **TFT** consistently outperforms others, capturing nonlinear dynamics more faithfully.  
   - **DeepProbCP** and **TSMixer** show mixed results—DeepProbCP yields useful probabilistic intervals but occasionally lags in raw accuracy.

2. **Real-World Case: 911 Emergency Calls & COVID-19**  
   - Lockdown measures induced a *negative* treatment effect on call volume—people simply called less.  
   - **DeepProbCP** and **TFT** both pass the placebo test and deliver lower CRPS on the control series, with TFT slightly edging out on point accuracy.  
   - Heterogeneous effects across quantiles (e.g. 10th vs. 90th percentile) reveal that the strongest impact fell on the highest-demand counties.
   <figure>
   <img
   src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/PCE_ATE_prob.png"
   alt="Conceptual table">
      <figcaption style="display:block; text-align:center;">
      Figure 4: Estimation of the Average Treatment Effect on the Treated per Quantile
   </figcaption>
   </figure>

---

### Take-Home Messages  
- **Global modeling** leverages cross-series patterns to improve counterfactual prediction—especially in complex, high-dimensional panels.  
- **Probabilistic causal estimates** (quantile forecasts + spline interpolation) furnish richer insights than point estimates alone.  
- **Placebo testing** remains vital: even the most powerful forecaster can’t be trusted unless it shows *no* effect where none should exist.

---

### What’s Next?  
- Expand to **more quantiles** (beyond 0.1, 0.5, 0.9) and resolve **quantile–crossing** via conditional quantile functions.  
- Integrate **LightGBM**, **Transformer-XL**, or other novel trackers as alternate global predictors.  
- Develop **theoretical guarantees** to formally bridge prediction-based methods with causal-inference assumptions.

By blending deep-learning forecasts with rigorous causal checks, we open a path toward **fine-grained, distributional** causal insights—vital for policy, medicine, and any domain where *how* an intervention moves the needle matters as much as *whether* it does.

---

*Happy modeling—and may your counterfactuals be ever informative!*