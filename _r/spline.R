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
# file.exists("_images")
png("_images/[SR]spline_regression_R.png", width = 800, height = 600)
plot(x, y, main = "Spline Regression with Different Numbers of Knots", 
     pch = 19, col = "grey", xlab = "x", ylab = "y")
lines(x, predict(model1, newdata = data), col = "blue", lwd = 2)
lines(x, predict(model2, newdata = data), col = "red", lwd = 2)
lines(x, predict(model3, newdata = data), col = "green", lwd = 2)
legend("topright", legend = c("3 knots", "5 knots", "7 knots"),
       col = c("blue", "red", "green"), lwd = 2)
dev.off()
