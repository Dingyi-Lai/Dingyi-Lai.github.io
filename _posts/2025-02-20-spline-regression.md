---
layout: post
author: Dingyi Lai
---

Spline regression is a flexible, powerful tool for modeling non‐linear relationships between a response and one or more predictors. Since I am conducting a simulation study involving the calculation of some statistics from a spline regression, I am happy to introduce the basic idea of spline regression and explain the relationships among its key parameters. I provide examples in both R and Python for clarity.

---

## What Is a Basis?

A **basis** of a vector space is a set of functions (or vectors) such that any element of the space can be written uniquely as a linear combination of those basis functions. In a simple linear regression model

```math
y = \beta_0 + \beta_1 x + \varepsilon,
```

the natural basis functions are \(1\) and \(x\), since every linear polynomial in \(x\) can be expressed as

```math
f(x) = \beta_0 \cdot 1 + \beta_1 \cdot x.
```

When we move to higher‐order or piecewise models, we add additional basis functions such as \(x^2\), \((x-\kappa)_+^p\), etc.

## From Polynomials to Splines

### Truncated Power Basis and Knots

To model non‑linearity, we can use **truncated‑power** basis functions of degree \(p\):

```math
\{\,1, x, x^2, \dots, x^p, (x - \kappa_1)_+^p, \dots, (x - \kappa_K)_+^p\},
```

where each \((x - \kappa_k)_+^p = \max(0, x - \kappa_k)^p\) is “turned on” only to the right of knot \(\kappa_k\).

- **Knots** (\(\kappa_k\)) mark locations where the piecewise polynomial segments join.
- A degree‑\(p\) spline with \(K\) interior knots has **\((p+1) + K\)**** degrees of freedom** (DF) ([bmcmedresmethodol.biomedcentral.com](https://bmcmedresmethodol.biomedcentral.com/articles/10.1186/s12874-019-0666-3?utm_source=chatgpt.com)), counting the intercept and monomial terms plus one basis per knot.

### Continuity at Knots

By construction, a degree‑\(p\) spline is \(C^{p-1}\) continuous at each knot (the function and its first \(p-1\) derivatives are continuous) ([bmcmedresmethodol.biomedcentral.com](https://bmcmedresmethodol.biomedcentral.com/articles/10.1186/s12874-019-0666-3?utm_source=chatgpt.com)).

## Types of Splines

- **Regression Splines**: Fit piecewise polynomials with a fixed knot set and estimate coefficients by least squares.
- **Penalized Splines (P‑splines)**: Use a **reduced** set of knots plus a roughness penalty (e.g. on \(\int f''(x)^2dx\)), trading off fit and smoothness.
- **Smoothing Splines**: Special case where a **knot is placed at every data point** and the only tuning parameter \(\lambda\) controls the penalty on curvature ([en.wikipedia.org](https://en.wikipedia.org/wiki/Smoothing_spline?utm_source=chatgpt.com)).
- **Natural Cubic Splines**: Impose linearity beyond the boundary knots, reducing DF by two so that a natural spline with \(K\) interior knots has exactly **\(K\)**** DF** ([en.wikipedia.org](https://en.wikipedia.org/wiki/List_of_numerical_analysis_topics?utm_source=chatgpt.com)).

### Basis Types

- **Truncated Power Basis**: Intuitive but can be numerically unstable.
- **B‑Spline Basis**: Numerically stable, minimal support, and spans the same space as truncated power splines ([en.wikipedia.org](https://en.wikipedia.org/wiki/B-spline?utm_source=chatgpt.com)).

## Degrees of Freedom and Smoothness

- For a **degree‑****\(p\)**** regression spline** with \(K\) interior knots, DF = \((p+1) + K\).
- For a **natural cubic spline** with \(K\) interior knots, DF = \(K\).
- In **P‑splines**, DF reflects the number of basis functions; in **smoothing splines**, DF equals the trace of the smoother matrix and is chosen via cross‑validation on \(\lambda\).

## Implementation Examples

```r
library(splines)
set.seed(123)

data <- data.frame(
  x = seq(0,10,length=200),
  y = sin(seq(0,10,length=200)) + rnorm(200,0,0.3)
)

# Cubic regression splines with specified DF
model1 <- lm(y ~ bs(x, df = 7, degree = 3), data)
# Note: df=7 → 7 basis functions → 6 interior knots (since intercept counts),
# which implies 6 + 3 + 1 = 10 DF in truncated‑power terms.

# Natural spline with 5 DF
model2 <- lm(y ~ ns(x, df = 5), data)
# ns() uses natural cubic spline → DF = df (no extra adjustment).

# Smoothing spline
model3 <- smooth.spline(data$x, data$y, spar = 0.6)
# Places a knot at each data point; spar controls the penalty.

# Plot
plot(data$x, data$y, pch=19, col='grey')
lines(data$x, predict(model1), col='blue', lwd=2)
lines(data$x, predict(model2), col='red', lwd=2)
lines(model3, col='green', lwd=2)
legend('topright', c('Regression','Natural','Smoothing'),
       col=c('blue','red','green'), lwd=2)
```

### Python (using patsy & statsmodels)

```python
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from patsy import dmatrix
import statsmodels.api as sm

np.random.seed(123)

data = pd.read_csv('_data/spline.csv')
x = data['x']; y = data['y']

# Regression spline design (B-spline basis)
# patsy.bs() by default generates B-spline basis with df basis functions.
X1 = dmatrix('bs(x, df=7, degree=3, include_intercept=True)', {'x':x})
model1 = sm.OLS(y, X1).fit()

# Natural spline via patsy
X2 = dmatrix('cr(x, df=5)', {'x':x})
model2 = sm.OLS(y, X2).fit()

# Plotting
ticks = np.linspace(0,10,500)
X1_pred = dmatrix('bs(x, df=7, degree=3, include_intercept=True)', {'x':ticks})
X2_pred = dmatrix('cr(x, df=5)', {'x':ticks})

plt.scatter(x, y, c='grey', s=10)
plt.plot(ticks, model1.predict(X1_pred), 'b', lw=2)
plt.plot(ticks, model2.predict(X2_pred), 'r', lw=2)
plt.title('Spline Regression: R vs. Python')
plt.show()
```

## Conclusion

Spline regression balances flexibility and interpretability through choice of basis, knot placement, and penalization. Regression splines, P‑splines, smoothing splines, and natural splines each offer a different trade‑off between bias and variance. The corrected DF formulas and basis clarifications should help avoid common misunderstandings.

---

#### References

1. Breheny, P. (2012). Nonparametric Statistics Lecture Notes. Univ. Iowa ([myweb.uiowa.edu](https://myweb.uiowa.edu/pbreheny/uk/teaching/621/notes/11-20.pdf?utm_source=chatgpt.com))
2. Ruppert, D., Wand, M.P., & Carroll, R.J. (2003). Semiparametric Regression. Cambridge Univ. Press.
3. Wikipedia contributors. Truncated power function. *Wikipedia*. ([en.wikipedia.org](https://en.wikipedia.org/wiki/Truncated_power_function?utm_source=chatgpt.com))
4. Wikipedia contributors. Smoothing spline. *Wikipedia*. ([en.wikipedia.org](https://en.wikipedia.org/wiki/Smoothing_spline?utm_source=chatgpt.com))
5. Wikipedia contributors. List of numerical analysis topics (Natural cubic spline DF). *Wikipedia*. ([en.wikipedia.org](https://en.wikipedia.org/wiki/List_of_numerical_analysis_topics?utm_source=chatgpt.com))
6. de Boor, C. (2001). A Practical Guide to Splines. Springer.
7. Smith et al. (2019). Regression Splines in Python. BMC Med Res Methodol. ([bmcmedresmethodol.biomedcentral.com](https://bmcmedresmethodol.biomedcentral.com/articles/10.1186/s12874-019-0666-3?utm_source=chatgpt.com))
8. statsmodels Developers. BSplines API. ([statsmodels.org](https://www.statsmodels.org/dev/generated/statsmodels.gam.smooth_basis.BSplines.html?utm_source=chatgpt.com))
9. Eilers, P.H.C. & Marx, B. Flexible smoothing with B-splines and penalties. *Statistical Science* ([en.wikipedia.org](https://en.wikipedia.org/wiki/Smoothing_spline?utm_source=chatgpt.com))
10. Smith College. Lab 13—Splines in Python. ([science.smith.edu](https://www.science.smith.edu/~jcrouser/SDS293/labs/lab13-py.html?utm_source=chatgpt.com))


<!-- Spline regression is a flexible, powerful tool for modeling non‐linear relationships between a response and one or more predictors. Since I am conducting a simulation study involving the calculation of some statistics from a spline regression, I am more than happy trying to introduce the basic idea of spline regression and the relationships among its key parameters. I'll give an example in both R and Python for better illustration.

---

## What is the basis?

In linear algebra, the most straightforward example of the basis for any vector described as a pair number, which means it starts from $$(0,0)$$, are the coordinates in the $$xy$$-coordinate system. Some detailed vivid illustrations can be found in [the fantastic blog along with its video by 3B1B](https://www.3blue1brown.com/lessons/span). More precisely, a basis of a vector space can be defined as a set, $$V$$, of elements of the space such that there exist a unique linear combination of elements of $$V$$ that is able to express any element of the space.

For example, in a linear regression model $$y = \beta_0 + \beta_1 x+ error$$, the basis functions are 1 and x. Hence, $$\{1, x\}$$ can be viewed as a basis for the vector space in $$x$$ for all linear polynomials. It can be illustrated by the following figure:

<figure>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/[SR]Figure 3.2.png"
  alt="Conceptual table">
   <figcaption style="display:block; text-align:center;">
    Figure 1: The simple linear regression model
  </figcaption>
</figure>

Next, consider the nonlinear regression model such as $$y = \beta_0 + \beta_1 x + \beta_2 x^2 + error$$:

<figure>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/[SR]Figure 3.3.png"
  alt="Conceptual table">
   <figcaption style="display:block; text-align:center;">
    Figure 2: The quadratic regression model
  </figcaption>
</figure>

where the basis is obviously $$\{1, x, x^2\}$$

When it's extended to more complex model like the *broken stick* model, the indicator function such as $$(x-0.6)_{+}$$ needs to be included in the basis, as the sloped lines are connected in a stiff manner at $$x=0.6$$. Note that this indicator function mean that if $$x-0.6$$ is positive, then it indicates itself; otherwise, it's equal to 0.

<figure>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/[SR]Figure 3.4.png"
  alt="Conceptual table">
  <figcaption style="display:block; text-align:center;">Figure 3: The broken stick regression model</figcaption>
</figure>

Moreover, more indicator functions are included when the right-hand half has more intricate structure:

<figure>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/[SR]Figure 3.5.png"
  alt="Conceptual table">
  <figcaption style="display:block; text-align:center;">Figure 4: The whip regression model</figcaption>
</figure>

And its basis can be written as:

<figure>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/[SR]Basis_Whilp.png"
  alt="Conceptual table">
  <figcaption style="display:block; text-align:center;">Figure 4: The whip regression model</figcaption>
</figure>

The turning point $$\kappa$$ in the indicator $$(x-\kappa)_{+}$$ is called *knot*, which leads to the introduction of splines below.


## What Are Splines?

Splines are piecewise polynomial functions that are smoothly connected at points **knots** similar to the above. Instead of forcing a single polynomial to fit the entire dataset—which can lead to underfitting or overfitting—spline regression fits separate polynomial segments between knots. For example, $$(x-0.6)_{+}$$ can be called as a *linear spline basis function*, where its knot is at 0.6 and the function itself is called a *spline*.

Another great idea to think of spline is to imagine the [connected scatterplots](https://www.youtube.com/watch?v=YMl25iCCRew) for the cartoon figures that you draw in your childhood. You can connect the dots bluntly:

<figure>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/[SR]Connected_Scatterplot.png"
  alt="Conceptual table"
  style="width:50%;">
  <figcaption style="display:block; text-align:center;">Figure 5: Vanilla Connected Scatterplot</figcaption>
</figure>

Or you can connect them in a smooth way:

<figure>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/[SR]Connected_Scatterplot_smooth.png"
  alt="Conceptual table"
  style="width:50%;">
  <figcaption style="display:block; text-align:center;">Figure 6: "Chocolate" Connected Scatterplot</figcaption>
</figure>

There are mainly three ways to decide the smoothness of the overall curve -- The number of knots, the type of splines and the constraints predefined.

### Number of knots and its Relationship to Degrees of Freedom

- **Number of Knots:** As illustrated in the former section, the more knots there are, the more detailed it is when the line fit the data. Given the number of knots $$K$$ , there are $$2^K$$ possible models for automatic knot selection, if you consider including or excluding each candicate independently.

- **Degrees of Freedom (DF):** In the context of spline regression, the degrees of freedom refer to the number of independent parameters estimated. More knots mean more basis functions and, hence, higher degrees of freedom (more flexibility) but also a higher risk of overfitting.

- **Relationship**: For a spline of degree $$p$$ with $$K$$ interior knots (assuming knots are fixed), the DF is $$K + p + 1$$ if intercept is included

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

- **Radial basis functions (RBF)** are commonly used in higher-dimensional settings. An RBF spline typically depends on the distance between the predictor variable (often in multiple dimensions) and the knot location. A popular example is the Gaussian RBF $$\exp\bigl(-\gamma \lVert x - \kappa \rVert^2\bigr)$$. These are especially powerful for smoothing in spatial or multi-dimensional data, but they also come with their own complexities in selecting parameters (like $$\gamma$$).

### Penalized Spline Regression

Apart from defining the number of knots and the type of splines, penalizing the spline regression is another method to control the smoothness.

Consider a spline model with $$K$$ knots, $$\beta$$ in the following formula, which is a matrix of the coefficients of the knots, has $$K$$ elements. The constraints on $$\beta$$ given some number $$\lambda \ge 0$$ leads to the solution:

$$
\widehat{\beta} = \bigl(X^\mathsf{T}X + \lambda^2 D\bigr)^{-1} X^\mathsf{T}y.
$$

The term $$\lambda^2 \beta^\mathsf{T} D \beta$$ is called a **roughness penalty** because it penalizes fits that are too rough, thus yielding a smoother result. The amount of smoothing is controlled by $$\lambda$$, which is therefore usually referred to as a **smoothing parameter**. 

The fitted values for a penalized spline regression are then given by:

$$
\widehat{y} \;=\; X \,\bigl(X^\mathsf{T}X + \lambda^2 D\bigr)^{-1} X^\mathsf{T}y.
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

write.csv(data, "_data/spline.csv", row.names = FALSE)

# Fit spline regression with different numbers of knots
# Model 1: 3 interior knots
model1 <- lm(y ~ bs(x, df = 7), data = data)
knots1 <- attr(bs(x, df = 7), "knots")

# Model 2: 5 interior knots
model2 <- lm(y ~ bs(x, df = 12), data = data)
knots2 <- attr(bs(x, df = 12), "knots")

# Model 3: 7 interior knots
model3 <- lm(y ~ bs(x, df=18), data = data)
knots3 <- attr(bs(x, df = 18), "knots")

# Print degrees of freedom
cat("Number of knots for cubic spline model with df=4:", length(knots1), "\n")
cat("Number of knots for cubic spline model with df=10:", length(knots2), "\n")
cat("Number of knots for cubic spline model with df=16:", length(knots3), "\n")

# Plot the data and fitted curves
# file.exists("_images")
png("_images/[SR]spline_regression_R.png", width = 800, height = 600)
plot(x, y, main = "Spline Regression with Different Numbers of Knots", 
     pch = 19, col = "grey", xlab = "x", ylab = "y")
lines(x, predict(model1, newdata = data), col = "blue", lwd = 2)
lines(x, predict(model2, newdata = data), col = "red", lwd = 2)
lines(x, predict(model3, newdata = data), col = "green", lwd = 2)
legend("topright", legend = c("4 knots", "9 knots", "15 knots"),
       col = c("blue", "red", "green"), lwd = 2)
dev.off()

```

<figure>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/[SR]spline_regression_R.png"
  alt="Conceptual table">
  <figcaption>Figure 8: Spline Regression with Different Numbers of Knots in R</figcaption>
</figure>
---

### Implementation in Python

Now let’s perform a similar analysis in Python using `patsy` for spline basis creation and `statsmodels` for fitting the regression model.

```python
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from statsmodels.gam.api import BSplines
import statsmodels.api as sm

# Set random seed for reproducibility
np.random.seed(123)

# Simulate data: y = sin(x) + noise
n = 200
# Read the data from the CSV file
data = pd.read_csv("../_data/spline.csv")

# If you need to extract the 'x' and 'y' values:
x = data['x'].values
y = data['y'].values
# statsmodels expects exogenous variables as a 2D array:
x_2d = x[:, None]

# ---- Model 1: Using 4 degrees of freedom ----
# In this context, we set df=[4] which mimics R's bs(x, df=4) for a single predictor.
bs1 = BSplines(x_2d, df=[8], degree=[3])
# Fit OLS using the spline basis
model1 = sm.OLS(y, bs1.transform(x_2d)).fit()
# Extract knots; bs1.knots is a list (one array per predictor)
knots1 = bs1.dim_basis - bs1.degrees[0]
print("Number of knots for cubic spline model with df=4:", knots1)

# ---- Model 2: Using 10 degrees of freedom ----
bs2 = BSplines(x_2d, df=[13], degree=[3])
model2 = sm.OLS(y, bs2.transform(x_2d)).fit()
knots2 = bs2.dim_basis - bs2.degrees[0]
print("Number of knots for cubic spline model with df=10:", knots2)

# ---- Model 3: Using 16 degrees of freedom ----
bs3 = BSplines(x_2d, df=[19], degree=[3])
model3 = sm.OLS(y, bs3.transform(x_2d)).fit()
knots3 = bs3.dim_basis - bs3.degrees[0]
print("Number of knots for cubic spline model with df=16:", knots3)

# Create a fine grid for prediction
x_pred = np.linspace(0, 10, 500)[:, None]

# Generate predictions from the three models
y_pred1 = model1.predict(bs1.transform(x_pred))
y_pred2 = model2.predict(bs2.transform(x_pred))
y_pred3 = model3.predict(bs3.transform(x_pred))

# Plot the data and fitted curves
plt.figure(figsize=(8, 6))
plt.scatter(x, y, color="grey", s=20, label="Data")
plt.plot(x_pred.flatten(), y_pred1, color="blue", lw=2, label="4 knots")
plt.plot(x_pred.flatten(), y_pred2, color="red", lw=2, label="9 knots")
plt.plot(x_pred.flatten(), y_pred3, color="green", lw=2, label="15 knots")
plt.title("Spline Regression with Different Numbers of Knots")
plt.xlabel("x")
plt.ylabel("y")
plt.legend(loc="upper right")
# Save the plot to a file (ensure that the directory '_images' exists)
plt.savefig("../_images/[SR]spline_regression_python.png", dpi=300)
plt.show()

```

<figure>
  <img
  src="https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/[SR]spline_regression_python.png"
  alt="Conceptual table">
  <figcaption>Figure 9: Spline Regression with Different Numbers of Knots in Python</figcaption>
</figure>

---

## Comparison: R vs. Python

- **R**  
  - df = 7 & cubic -> 4 knots (7 = 4+3)
  - df = 12 & cubic -> 9 knots (12 = 9+3)
  - df = 18 & cubic -> 15 knots (18 = 15+3)
- **Python**  
  - df = 5 & cubic -> 4 knots (4 = 5-1)
  - df = 10 & cubic -> 9 knots (9 = 10-1)
  - df = 16 & cubic -> 15 knots (15 = 16-1)
- **Definition from different versions:**  
  - `df` in R from `library(splines)`: df	
  degrees of freedom; one can specify df rather than knots; bs() then chooses df-degree (minus one if there is an intercept) knots at suitable quantiles of x (which will ignore missing values). The default, NULL, takes the number of inner knots as length(knots). If that is zero as per default, that corresponds to df = degree - intercept
  - `df` in Python from `from statsmodels.gam.api import BSplines`
  number of basis functions or degrees of freedom; should be equal in length to the number of columns of x; may be an integer if x has one column or is 1-D.
  - `df` in Python from `from sddr.splines import spline, Spline`
  Number of degrees of freedom (equals the number of columns in s.basis) because `Intercept` is set to be True by default

---

## Conclusion

Spline regression is a versatile method for modeling complex, non-linear relationships. The number of knots, the type of splines and possible penalty can be used to control the flexibility of your model. By comparing implementations in R and Python, we see that the relationship between the parameter `df` and the number of knots are different in different version.

Feel free to experiment with the provided code examples to better understand how the choice of knots affects model flexibility. If you have any questions or insights, share your thoughts in the comments!

---

*Happy modeling!*

Reference: 

1. Ruppert, D., Wand, M.P. and Carroll, R.J. (2003) Semiparametric Regression. Cambridge: Cambridge University Press (Cambridge Series in Statistical and Probabilistic Mathematics).
2. https://www.3blue1brown.com/lessons/span
3. https://www.youtube.com/watch?v=YMl25iCCRew
4. https://www.rdocumentation.org/packages/splines/versions/3.6.2/topics/bs
5. https://www.statsmodels.org/dev/generated/statsmodels.gam.smooth_basis.BSplines.html
6. https://github.com/HelmholtzAI-Consultants-Munich/PySDDR/tree/master/sddr
7. https://www.kirenz.com/blog/posts/2021-12-06-regression-splines-in-python/ -->