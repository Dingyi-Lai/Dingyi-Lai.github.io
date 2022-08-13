---
layout: post
author: Dingyi Lai
---

# Business Setting

A substential part of products purchased online by customers are returned especially in the case of free return shipping. Given the fierce online competition among online retailers, it is important to predict the potential return behaviour so as to take an extra step, for instance, restrict payment options or display additional marketing communication.

When a customer is about to purchase an item, which is likely to be returned, the shop is planning to show a warning message. Pre-tests suggest that the warning message leads approx. 50% of customers to cancel their purchase. In case of a return, the shop calculates with shipping-related costs of 3 EUR plus 10% of the item value in loss of resale value. Thus, the cost-matrix could be written as following:

| Tables        | 	Actual_Keep(0)  | Actual_Return(1)  |
|-------------|:---------------------:| -------------:|
| predicted_Keep(0)	 | C(k,K) = 0 | $C(k,R) = 0.5*5*(3+0.1*v)$ |
| predicted_Return(1) | C(r,K) = 0.5*v  | C(r,R) = 0 |

Note that in the dataset, **a returned item is denoted as the positive class, and v in the cost-matrix denotes the price of the returned item.**

Therefore, besides to predict the return rate as accurately as possible, this model is built to minimize the expected costs, put differently, to maximize the revenue of the online retailer as well. 

# Blueprint Design
It is unrealistic to form a pipeline for data processing once for all. A reasonable way to regulate pipeline systematically is to define potentially adjustable parameters and fragmentary helper functions. Throughout EDA (Exploratory Data Analysis) and different result after all, a relatively optimal pipeline could be wrapped into one `preprocess_df` function. An additional function `transform_columns` is to reduce memory consumption for machine. Codes without accessing to details are presented in [this repo](https://github.com/Dingyi-Lai/-DataScience/blob/main/%5BProject%5DPrediction-of-Return.ipynb)

## Package Import and Helper Function
### Define Parameters
Try different combinations for best accuracy


###  Define Methods and Wrap them
```Python

```

## EDA and Data Preparation
### Load Data and Take a First Glance
```Python
%%time
df_known = pd.read_csv('.../BADS_WS2021_known.csv', index_col='order_item_id') 
df_known.head()
# Query some properties of the data
print('Dimensionality of the data is {}'.format(df_known.shape))  # .shape returns a tupel
print('The data set has {} cases.'.format(df_known.shape[0]))     # we can also index the elements of that tupel
print('The total number of elements is {}.'.format(df_known.size))
df_known.info()
```

### Conversion After Comparison of Final Evaluation
```Python

```

### Some Data Description During Exploration



## Blockquote

The following is a blockquote:

> Suspendisse tempus dolor nec risus sodales posuere. Proin dui dui, mollis a consectetur molestie, lobortis vitae tellus.

## Thematic breaks (<hr>)

Mauris viverra dictum ultricies[^3]. Vestibulum quis ipsum euismod, facilisis metus sed, varius ipsum. Donec scelerisque lacus libero, eu dignissim sem venenatis at. Etiam id nisl ut lorem gravida euismod. **You can put some text inside the horizontal rule like so.**

---
{: data-content="hr with text"}

Mauris viverra dictum ultricies. Vestibulum quis ipsum euismod, facilisis metus sed, varius ipsum. Donec scelerisque lacus libero, eu dignissim sem venenatis at. Etiam id nisl ut lorem gravida euismod. **Or you can just have an clean horizontal rule.**

---


## Tables

Now a table:

| Tables        | Are           | Cool  |
| ------------- |:-------------:| -----:|
| col 3 is      | right-aligned | $1600 |
| col 2 is      | centered      |   $12 |
| zebra stripes | are neat      |    $1 |

## Images

![theme logo](http://www.abhinavsaxena.com/images/abhinav.jpeg)

This is an image[^4]

---
{: data-content="footnotes"}

[^1]: this is a footnote. You should reach here if you click on the corresponding superscript number.
[^2]: hey there, don't forget to read all the footnotes!
[^3]: this is another footnote.
[^4]: this is a very very long footnote to test if a very very long footnote brings some problems or not; hope that there are no problems but you know sometimes problems arise from nowhere.