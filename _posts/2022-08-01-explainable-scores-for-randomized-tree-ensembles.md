---
layout: post
author: Dingyi Lai
---

Starting from a general question: **How to explain the prediction from an machine learning blackbox algorithm?**

This blog will navigate you through the general defintion of XAI, the mainstream methods in general and then specifically for tree-based models. At the end, we compare two methods on some open dataset. Since the intuition of writing this blog is to wrap up what I've learnt from collaborating with Prof. Dr. Markus Loecher, the main reference material is from the paper ![Approximation of SHAP Values for Randomized Tree Ensembles](https://www.researchgate.net/publication/362629537_Approximation_of_SHAP_Values_for_Randomized_Tree_Ensembles) and Markus’s blog: ![CFC-SHAP Visualization](https://markusloecher.github.io/CFC-SHAP-Visualization/#approximation-of-shap-by-cfc).

# Explainable AI (XAI)

I was introduced to this topic in a machine learning course held by TU Berlin, where the XAI (Explainable AI) was defined as understanding how the prediction is produced by the ML model. For example, which features are used during the prediction, how these features are concatenated, or to what input pattern the model reacts the most.

The global XAI methods includes activation maximization where we generate the samples that maximally activates a specific output neuron or class. By choosing the regularizer which could be the log likelihood of observations $$x$$, we compute the typical input $$x^*$$ that maximize the sum of a log-probablity for a specific class or model and the regularizer:

$$x^* = \arg\max_{x} \{ \log p(\omega_c \mid x) + \log p(x) \} = \arg\max_{x} \log p(x \mid \omega_c)$$

However, if we consider locally, the above method couldn't compute the attribute of a single prediction to input features:

<figure>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/[SCT]Attribution_general.png"
  alt="Conceptual table">
   <figcaption style="display:block; text-align:center;">
    Figure 1: Local Explainable Score of a Prediction for Input Feature$$d$$
  </figcaption>
</figure>

# Commonly Used Explainable Scores

## SHAP (SHapley Additive exPlanations)
It originated in the context of game theory (Shapley 1951) for assigning payoffs in a cooperative game, and recently applied to ML models. It works by averaging the marginal effect of adding a feature over every possible order in which the features can be introduced.
### Pros: Strong theoretical foundations (local accuracy, consistency, and missingness)
### Cons: Computationally unfeasible for high-dimensional input data
The SHAP value for the $$i$$-th feature is defined as:

$$\phi_{i}(f,x) = \sum_{r \in R} \frac{1}{M!} \left[ f_{x}(P^{r}_{i} \cup \{i\}) - f_{x}(P^{r}_{i}) \right]$$

where:
- $$R$$: Set of all possible feature orderings,
- $$P^{r}_{i}$$: Set of features that come before feature $$i$$ in ordering $$r$$,
- $$M$$: Total number of input features,
- $$f_{x}(S)$$: Conditional expectation of the model output given the feature subset $$S$$.

The code to compute the SHAP values could be found in Marku's blog ![CFC-SHAP Visualization](https://markusloecher.github.io/CFC-SHAP-Visualization/#approximation-of-shap-by-cfc).

## Conditional feature contributions (CFCs)
CFCs (also known as Saabas values) explain tree-based model predictions by measuring the node-wise reduction of a loss function and computing a weighted average of all nodes over all trees for that feature.

## Pros: Local explanation and efficiency
## Cons: Bias in local explanation and less theoretical guarantees

For the $$i$$-th feature, the CFC (Saabas value) is defined as:

$$\phi^{s}_{i}(f,x) = \sum_{j \in D^{i}_{x}} \left[ f_{x}(A_{j} \cup \{j\}) - f_{x}(A_{j}) \right]$$

where:
- $$D^{i}_{x}$$: Set of nodes on the decision path for instance $$x$$ that split on feature $$i$$,
- $$A_{j}$$: Set of features split on by the ancestors of node $$j$$,
- $$f_{x}(S)$$: Estimated expectation of the model output conditioned on the set $$S$$ of feature values.

# Approximation of SHAP Values for Randomized Tree Ensembles

Randomized tree ensembles—such as random forests and gradient boosted trees—combine multiple decision trees to improve predictive performance and stability. By introducing randomness (e.g., via bootstrapping or random feature selection), these ensembles reduce overfitting and enhance generalization. Both SHAP and CFC methods are applied to these ensembles to interpret the aggregated model behavior. 


> While SHAP values average the importance of introducing a feature over all possible feature orderings, CFC scores only consider the single ordering defined by a tree’s decision path.


Our evaluation of SHAP and CFC methods was performed on a wide array of datasets, including those from the Penn Machine Learning Benchmark and the UCI Machine Learning Repository. This comprehensive evaluation demonstrates the robustness of these methods across different types of prediction tasks, whether classification or regression.

## 
on CFCs

Conclusion