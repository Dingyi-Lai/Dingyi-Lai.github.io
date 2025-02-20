Spline regression is a flexible, powerful tool for modeling non‐linear relationships between a response and one or more predictors. In this blog, we’ll dive into the basics of spline regression, explain the role of knots and degrees of freedom, and illustrate with concrete examples. We’ll implement these ideas in both R and Python, then compare the two approaches.

---

## What Are Splines?

Splines are piecewise polynomial functions that are smoothly connected at points called **knots**. Instead of forcing a single polynomial to fit the entire dataset—which can lead to underfitting or overfitting—spline regression fits separate polynomial segments between knots. The smoothness constraints (usually continuity of the function and some of its derivatives) at the knots ensure that the overall curve is smooth.

### Knots and Degrees of Freedom

- **Knots:** These are the values of the predictor variable where the polynomial pieces join. The number and placement of knots determine the flexibility of the spline.  
- **Degrees of Freedom (DF):** In the context of spline regression, the degrees of freedom refer to the number of independent parameters estimated. More knots mean more basis functions and, hence, higher degrees of freedom (more flexibility) but also a higher risk of overfitting.

For example, using a cubic spline with no knots would be equivalent to fitting a cubic polynomial (4 degrees of freedom). Adding knots increases the DF roughly by the number of knots added (though this can vary slightly with different spline implementations).

---

## An Example: Simulating Non-Linear Data

Let’s simulate a dataset where the true relationship is non-linear (say, a sine curve with some noise) and fit spline regressions with different numbers of knots to see how the degrees of freedom change.

### Implementation in R

Below is an R code example using the `splines` package. We’ll simulate data, fit models with varying numbers of knots, and extract the effective degrees of freedom.

```bash
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