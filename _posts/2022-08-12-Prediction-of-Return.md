---
layout: post
author: Dingyi Lai
---

# Business Setting

A substential part of products purchased online by customers are returned especially in the case of free return shipping. Given the fierce online competition among online retailers, it is important to predict the potential return behaviour so as to take an extra step, for instance, restrict payment options or display additional marketing communication.

When a customer is about to purchase an item, which is likely to be returned, the shop is planning to show a warning message. Pre-tests suggest that the warning message leads approx. 50% of customers to cancel their purchase. In case of a return, the shop calculates with shipping-related costs of 3 EUR plus 10% of the item value in loss of resale value. Thus, the cost-matrix could be written as following:

| Tables        | 	Actual_Keep(0)  | Actual_Return(1)  |
|-------------|:---------------------:| -------------:|
| predicted_Keep(0)	 | C(k,K) = 0 | C(k,R) = 0.5·5·(3+0.1·v) |
| predicted_Return(1) | C(r,K) = 0.5·v  | C(r,R) = 0 |

Note that in the dataset, **a returned item is denoted as the positive class, and v in the cost-matrix denotes the price of the returned item.**

Therefore, besides to predict the return rate as accurately as possible, this model is built to minimize the expected costs, put differently, to maximize the revenue of the online retailer as well. 

# Blueprint Design
It is unrealistic to form a pipeline for data processing once for all. A reasonable way to regulate pipeline systematically is to define potentially adjustable parameters and fragmentary helper functions. Throughout EDA (Exploratory Data Analysis) and different result after all, a relatively optimal pipeline could be wrapped into one `preprocess_df` function. An additional function `transform_columns` is to reduce memory consumption for machine. Codes without accessing to details are presented in [this repo](https://github.com/Dingyi-Lai/-DataScience/blob/main/%5BProject%5DPrediction-of-Return.ipynb)

## Package Import and Helper Function
### Define Parameters
Encounter noisy features, truncation and imputation are worth considering. Note that there are several options for imputation, such as 'median', 'most_frequent', 'constant' 'mean'...

###  Define Methods and Wrap them
Scrutinize date features, when there is missing, mark them as a new category. Find out potential reason why there is outlier or mistake. Valuable information could hide inside. Otherwise, consider to remove outliers. As for categorical features, grouping and correcting potential misspelling is neccessary. Add counting result as frequency is another good move. Let's move to numerical feature. Truncate it or not, which could be indexed by our parameters above, deserve examination.

## EDA and Data Preparation
### Load Data and Take a First Glance
Query some properties of the data such as dimensionality, number of cases and information regarding each feature.

### Conversion After Comparison of Final Evaluation
Change data type to reduce memory consumption, which could speed up model building.

Note that for categorical features, there are mainly two convenient ways to rearrange them: dummy encoding, WoE (Weight-of-Evidence) transformation. **Always remember it is significant to keep test data and train data clearily separable**. Therefore the estimation of WoE score could not be accomplished in this part, since it requires the information of cases with the same category level after all conversions. Low-dimensionalities data is suitable converted by dummy encoding. Unlike WoE encoding, it does not need further constrained information but only the categorical features themselves.

### Some Data Description During Exploration
- General information and slicing
- Count, cross table
- (Stack) Count plot, barplot and violin plot
- Correlation and heatmap
- Categorical feature distribution and woebin_plot
- Numericfal feature distribution, boxplot and histogram

### Feature Selection
High correlation is an indicator that using both of these features will most likely not be benefitial to the model, as the features carry the same information. Besides, a filter function based on information gain is applied. Compare IV and Fisher scores among all variables. 0.02 is commonly used as a threshold for IV.

## Pipeline Construction
### Class Eefinition
Define `ColumnSelector`, `DropColumns` and `WoETransformer` for preprocession.
### Preprocessor Combinition
Combine via `FeatureUnion`.

### Final DataFrame (just an example) and Train-Test Splitting
Split data into training and testing dataset

## Model Construction
I chose to test 4 different models: `Logistic Regression`, `XGBoost`, `Random Forest` and `Light GBM`.

For each one of them, I will perform the following tasks:

1. Define parameter grid and pipeline
2. Perform GridSearchCV to find the best parameters
3. Fit data on the best performing model
4. Plot ROC curve on both training and test data
5. Plot confusion matrix
6. Feature coefficients
7. Calculate gini
8. Calculate stability of the model (perform GridSearchCv with different splits to ensure the performance of the model)
9. Calculate F1 Score (In statistical analysis of binary classification, the F-score or F-measure is a measure of a test's accuracy)
10. Calculate Brier Score (The Brier Score is a strictly proper score function or strictly proper scoring rule that measures the accuracy of probabilistic predictions)
11. Model explanation (only for chosen models)
### Logistic Regression
Logistic regression estimates the probability of an event occurring, such as return or didn't return, based on a given dataset of independent variables. Since the outcome is a probability, the dependent variable is bounded between 0 and 1.

Logistic Regression predicts the test data with accuracy of 69%. The accuracy is the same for the train and test data, which is an indicator, that the model performs well and does not overfit.

If some features have high coefficients, then change their value
### Random Forest

### XGBoost
### Light GBM
The following is a blockquote:

> Suspendisse tempus dolor nec risus sodales posuere. Proin dui dui, mollis a consectetur molestie, lobortis vitae tellus.





## Images

![theme logo](http://www.abhinavsaxena.com/images/abhinav.jpeg)

This is an image[^4]

---
{: data-content="footnotes"}

[^1]: this is a footnote. You should reach here if you click on the corresponding superscript number.
[^2]: hey there, don't forget to read all the footnotes!
[^3]: this is another footnote.
[^4]: this is a very very long footnote to test if a very very long footnote brings some problems or not; hope that there are no problems but you know sometimes problems arise from nowhere.