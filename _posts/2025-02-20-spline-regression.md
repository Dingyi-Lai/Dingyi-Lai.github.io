---
layout: post
author: Dingyi Lai
---

Spline regression is a flexible, powerful tool for modeling non‐linear relationships between a response and one or more predictors. Since I am conducting a simulation study involving the calculation of some statistics from a spline regression, I am more than happy trying to introduce the basic idea of spline regression, the relationships among its key parameters, and the procedures for its uncertainty quantification from the perspective of the frequentists. I'll give an example in both R and Python for better illustration.

---

## What are the basis?

In linear algebra, the most straightforward example of the basis for any vector described as a pair number, which means it starts from $$(0,0)$$, are the coordinates in the $$xy$$-coordinate system. Some detailed vivid illustration can be found in [the fantastic blog along with its video by 3B1B](https://www.3blue1brown.com/lessons/span). More precisely, a basis of a vector space can be defined as a set, $$V$$, of elements of the space such that there exist uniquely a linear combination of elements of $$V$$ that is able to express any element of the space.

For example, in a linear regression model $$y = \beta_0 + \beta_1 x+ error$$, the basis functions are 1 and x. Hence, $${1, x}$$ can be viewed as a basis for the vector space in x for all linear polynomials. It can be illustrated by the following figure:

<figure>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/[SR]Figure 3.2.png"
  alt="Conceptual table">
  <figcaption>Figure 1: The simple linear regression model</figcaption>
</figure>

Next, consider the nonlinear regression model such as $$y = \beta_0 + \beta_1 x + \beta_2 x^2 + error$$:

<figure>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/[SR]Figure 3.3.png"
  alt="Conceptual table">
  <figcaption>Figure 2: The quadratic regression model</figcaption>
</figure>

where the basis is obviously $${1, x, x^2}$$

When it's extended to more complex model like the *broken stick* model, the indicator function such as $$(x-0.6)_{+}$$ needs to be included in the basis, as the sloped lines are connected stiffly at $$x=0.6$$. Note that this indicator function mean that if $$x-0.6$$ is positive, then it indicates $$x-0.6$$; rather, it's equal to 0 otherwise.

<figure>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/[SR]Figure 3.4.png"
  alt="Conceptual table">
  <figcaption>Figure 3: The broken stick regression model</figcaption>
</figure>

Moreover, more indicator functions are included when the right-hand half has more intricate structure:

<figure>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/[SR]Figure 3.5.png"
  alt="Conceptual table">
  <figcaption>Figure 4: The whip regression model</figcaption>
</figure>

And its basis can be written as:

<figure>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/[SR]Basis_Whilp.png"
  alt="Conceptual table">
  <figcaption>Figure 4: The whip regression model</figcaption>
</figure>

The turning point $$\kappa$$ in the indicator $(x-\kappa)_{+}$$ is called *knot*, which leads to the introduction of splines below.


## What Are Splines?

Splines are piecewise polynomial functions that are smoothly connected at points **knots** similar to above. Instead of forcing a single polynomial to fit the entire dataset—which can lead to underfitting or overfitting—spline regression fits separate polynomial segments between knots. For example, $$(x-0.6)_{+}$$ can be called as a *linear spline basis function*, where its knot is at 0.6 and the function itself is called a *spline*.

Another great idea to think of spline is to imagine the [connected scatterplots](https://www.youtube.com/watch?v=YMl25iCCRew) for the cartoon figures that you draw in your childhood. You can connect the dots bluntly:

<figure>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/[SR]Connected_Scatterplot.png"
  alt="Conceptual table">
  <figcaption>Figure 5: Vanilla Connected Scatterplot</figcaption>
</figure>

Or you can connect them in a smooth way:

<figure>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/[SR]Connected_Scatterplot_smooth.png"
  alt="Conceptual table">
  <figcaption>Figure 6: "Chocolate" Connected Scatterplot</figcaption>
</figure>

There are mainly three ways to decide the smoothness of the overall curve -- The number of knots, the type of splines and the constraints predefined.

### Number of knots and its Relationship to Degrees of Freedom

- **Number of Knots:** As illustrated in the former section, the more knots there are, the more detailed it is when the line fit the data. Given the number of knots $$K$$ , there are $$2^K$$ possible models for automatic knot selection, if you consider including or excluding each candicate independently.

- **Degrees of Freedom (DF):** In the context of spline regression, the degrees of freedom refer to the number of independent parameters estimated. More knots mean more basis functions and, hence, higher degrees of freedom (more flexibility) but also a higher risk of overfitting.

- **Relationship**: For a spline of degree $$p$$ with $$K$$ interior knots (assuming knots are fixed), the DF is $$K + p + 1$$

### Type of splines

Besides the number of knots, the smoothness constraints (usually continuity of the function and some of its derivatives) at the knots restrict their influence, thus ensuring that the overall curve is smooth.

Accordingly, there are several types of splines:

- **Linear spline** is equivalent to the **vanilla connected scatterplot** 
- **Quadratic spline** bases has a continuous first derivative
<figure>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/refs/heads/main/_images/%5BSR%5DPenalized_Spline_linear_quadratic.png"
  alt="Conceptual table">
  <figcaption>Figure 7: Penalized spline regression fits to the fossil data based on (a) linear spline basis functions and (b) quadratic spline basis functions. In each case, eleven equally space knots are used.</figcaption>
</figure>

Apparently, the spline function with the degree of the piecewise polynomial being $$p$$ has $$p-1$$ continuous derivatives. The higher the $$p$$ is, the smoother the estimated line.

All the spline functions that I've discussed so far is called the truncated power functions, with its basis being:

$$
1,\, x,\, \ldots,\, x^p,\quad (x - \kappa_1)_+^p,\ \ldots,\ (x - \kappa_K)_+^p,
$$

which is known as the **truncated power basis** of degree $$p$$. The $$p$$-th-degree spline is

$$
f(x) \;=\; \beta_0 \;+\; \beta_1\,x \;+\; \cdots \;+\; \beta_p\,x^p \;+\; \sum_{k=1}^{K} \beta_{pk}\,\bigl(x - \kappa_k\bigr)_+^p.
$$

However, there are other types of splines that has equivalent bases with more stable numerical properties such as *B-spline* basis.

- **B splines** is equivalent to the truncated power basis of the same degree in the sense that they span the same set of functions. By *span* it means the set of all possible linear combinations of the basis functions.

- **Natural cubic splines** are cubic splines that impose additional boundary constraints so that the function is linear outside the outermost knots. This helps avoid the wild oscillations that can occur at the boundaries. Natural splines thus have fewer degrees of freedom than a regular cubic spline with the same knots, because of these boundary constraints.

- **Radial basis functions** are commonly used in higher-dimensional settings. An RBF spline typically depends on the distance between the predictor variable (often in multiple dimensions) and the knot location. A popular example is the Gaussian RBF $$\exp\bigl(-\gamma \lVert x - \kappa \rVert^2\bigr)$$. These are especially powerful for smoothing in spatial or multi-dimensional data, but they also come with their own complexities in selecting parameters (like $$\gamma$$).

### Penalized Spline Regression

Consider a spline model with $$K$$ knots, $$\beta$$ in the following formula, which is the coefficients of the knots, has $$K$$ elements. To predefine some constraints on $$\beta$$ given some number $$\lambda \ge 0$$ leads to the solution:

$$
\hat{\beta} = \bigl(X^\mathsf{T}X + \lambda^2 D\bigr)^{-1} X^\mathsf{T}y.
$$

The term $$\lambda^2 \beta^\mathsf{T} D \beta$$ is called a **roughness penalty** because it penalizes fits that are too rough, thus yielding a smoother result. The amount of smoothing is controlled by $$\lambda$$, which is therefore usually referred to as a **smoothing parameter**. 

The fitted values for a penalized spline regression are then given by:

$$
\hat{y} \;=\; X \,\bigl(X^\mathsf{T}X + \lambda^2 D\bigr)^{-1} X^\mathsf{T}y.
$$

 
---

## An Example: Simulating Non-Linear Data

Let’s simulate a dataset where the true relationship is non-linear (say, a sine curve with some noise) and fit spline regressions with different numbers of knots to see how the degrees of freedom change.

### Implementation in R

Below is an R code example using the `splines` package. We’ll simulate data, fit models with varying numbers of knots, and extract the effective degrees of freedom.

```{r}
# Load necessary library
library(splines)
set.seed(123)

# Simulate data: y = sin(x) + noise
n <- 200
x <- seq(0, 10, length.out = n)
y <- sin(x) + rnorm(n, sd = 0.3)
data <- data.frame(x, y)

# Fit spline regression with different numbers of knots
# Model 1: 3 interior knots
model1 <- lm(y ~ bs(x, knots = c(3, 5, 7)), data = data)
df1 <- summary(model1)$df[2]  # residual DF

# Model 2: 5 interior knots
model2 <- lm(y ~ bs(x, knots = c(2, 4, 6, 8, 9)), data = data)
df2 <- summary(model2)$df[2]

# Model 3: 7 interior knots
model3 <- lm(y ~ bs(x, knots = c(1.5, 3, 4.5, 6, 7.5, 9, 10)), data = data)
df3 <- summary(model3)$df[2]

# Print degrees of freedom
cat("Degrees of freedom for model with 3 knots:", df1, "\n")
cat("Degrees of freedom for model with 5 knots:", df2, "\n")
cat("Degrees of freedom for model with 7 knots:", df3, "\n")

# Plot the data and fitted curves
plot(x, y, main = "Spline Regression with Different Numbers of Knots", pch = 19, col = "grey")
lines(x, predict(model1, newdata = data), col = "blue", lwd = 2)
lines(x, predict(model2, newdata = data), col = "red", lwd = 2)
lines(x, predict(model3, newdata = data), col = "green", lwd = 2)
legend("topright", legend = c("3 knots", "5 knots", "7 knots"), col = c("blue", "red", "green"), lwd = 2)
```

<figure>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/[SR]spline_regression_R.png"
  alt="Conceptual table">
  <figcaption>Figure 1: Spline Regression with Different Numbers of Knots in R</figcaption>
</figure>

In this example, you will notice that as the number of knots increases, the model uses more degrees of freedom and can follow the data more closely.

---

### Implementation in Python

Now let’s perform a similar analysis in Python using `patsy` for spline basis creation and `statsmodels` for fitting the regression model.

```python
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from patsy import dmatrix
import statsmodels.api as sm

# Set random seed for reproducibility
np.random.seed(123)

# Simulate data: y = sin(x) + noise
n = 200
x = np.linspace(0, 10, n)
y = np.sin(x) + np.random.normal(scale=0.3, size=n)
data = pd.DataFrame({'x': x, 'y': y})

def fit_spline_model(knots, label):
    # Create spline basis with specified interior knots
    spline_basis = dmatrix("bs(x, knots=knots, degree=3, include_intercept=False)",
                           {"x": data['x'], "knots": knots}, return_type='dataframe')
    model = sm.OLS(data['y'], spline_basis).fit()
    # Effective degrees of freedom: number of parameters estimated
    df = model.df_model + 1  # +1 because df_model does not include the intercept if not in basis
    print(f"Degrees of freedom for model with {len(knots)} knots ({label}): {df}")
    return model, spline_basis

# Fit models with different numbers of knots
model1, basis1 = fit_spline_model([3, 5, 7], "3 knots")
model2, basis2 = fit_spline_model([2, 4, 6, 8, 9], "5 knots")
model3, basis3 = fit_spline_model([1.5, 3, 4.5, 6, 7.5, 9, 10], "7 knots")

# Plot data and fitted curves
plt.figure(figsize=(10,6))
plt.scatter(x, y, facecolors='none', edgecolors='grey', label='Data')

# Generate predictions from the models
x_pred = np.linspace(0, 10, 500)
def predict_curve(model, knots, label, color):
    # Create design matrix for prediction
    X_pred = dmatrix("bs(x, knots=knots, degree=3, include_intercept=False)",
                     {"x": x_pred, "knots": knots}, return_type='dataframe')
    y_pred = model.predict(X_pred)
    plt.plot(x_pred, y_pred, label=label, color=color, lw=2)

predict_curve(model1, [3, 5, 7], "3 knots", "blue")
predict_curve(model2, [2, 4, 6, 8, 9], "5 knots", "red")
predict_curve(model3, [1.5, 3, 4.5, 6, 7.5, 9, 10], "7 knots", "green")

plt.title("Spline Regression with Different Numbers of Knots")
plt.xlabel("x")
plt.ylabel("y")
plt.legend()
plt.show()
```

In Python, we use the `dmatrix` function from the Patsy library to create the spline basis. As with R, increasing the number of knots increases the number of basis functions—and hence the degrees of freedom.

---

## Comparison: R vs. Python

- **Ease of Use:**  
  Both R and Python have robust libraries for spline regression. R’s `splines` package and Python’s combination of Patsy and statsmodels provide similar functionality.  
- **Syntax and Flexibility:**  
  R’s formula interface is very concise and directly integrated into many modeling functions. Python’s approach, using `dmatrix`, is flexible and allows integration with the broader ecosystem (e.g., scikit-learn) but may require a bit more boilerplate code.
- **Interpretation:**  
  In both languages, the number of knots directly influences the degrees of freedom. More knots allow the model to follow the data more closely, but also increase the risk of overfitting.

---

## Conclusion

Spline regression is a versatile method for modeling complex, non-linear relationships. The number of knots is a key tuning parameter that controls the flexibility of your model—the more knots, the higher the degrees of freedom, and the more responsive your model will be to the data. By comparing implementations in R and Python, we see that while the syntax differs, the underlying statistical principles remain the same.

Feel free to experiment with the provided code examples to better understand how the choice of knots affects model flexibility. If you have any questions or insights, share your thoughts in the comments!

---

*Happy modeling!*

Reference: 

1. Ruppert, D., Wand, M.P. and Carroll, R.J. (2003) Semiparametric Regression. Cambridge: Cambridge University Press (Cambridge Series in Statistical and Probabilistic Mathematics).
2. https://www.3blue1brown.com/lessons/span