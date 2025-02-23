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
legend("topright", legend = c("3 knot", "9 knots", "15 knots"),
       col = c("blue", "red", "green"), lwd = 2)
dev.off()
