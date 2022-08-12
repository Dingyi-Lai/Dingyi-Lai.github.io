---
layout: post
author: Dingyi Lai
---

# Business Setting

A substential part of products purchased online by customers are returned especially in the case of free return shipping. Given the fierce online competition among online retailers, it is important to predict the potential return behaviour so as to take an extra step, for instance, restrict payment options or display additional marketing communication.

When a customer is about to purchase an item, which is likely to be returned, the shop is planning to show a warning message. Pre-tests suggest that the warning message leads approx. 50% of customers to cancel their purchase. In case of a return, the shop calculates with shipping-related costs of 3 EUR plus 10% of the item value in loss of resale value. Thus, the cost-matrix could be written as following:

| Tables        | 	actual_Keep(0)  | actual_Return(1)  |
| ------------- |:---------------------:| -------------:|
| predicted_Keep(0)	 | C(k,K) = 0 | C(k,R) = 0.5*5*(3+0.1*v) |
| predicted_Return(1) | C(r,K) = 0.5*v  | C(r,R) = 0 |

Note that in the dataset, **a returned item is denoted as the positive class, and v in the cost-matrix denotes the price of the returned item.**

Therefore, besides to predict the return rate as accurately as possible, this model is built to minimize the expected costs, put differently, to maximize the revenue of the online retailer as well. 

# Blueprint Design
## Package Import and Helper Function
### Define Parameters
Try different combinations for best accuracy
```Python
# truncation
truncate_item_price = True
truncate_delivery_days = False
truncate_age = False
cut_age = True

# imputation
numeric_imputer_strategy =  'median' # 'median', 'most_frequent', 'constant' 'mean'
numeric_standard_scaler_mean = True
```

###  Define Methods and Wrap them
```Python
def preprocess_df(df, known_data:bool, truncate_delivery_days:bool, truncate_item_price:bool, truncate_age:bool, cut_age:bool):
    # change object variables to datatype category
    # change numeric variables from float64 to float32 (reduce memory consumption)
    # change feature return to boolean (2 categories)
    # change dates to the datetime datatype 'datetime64[ns]'
    df = transform_columns(df, known_data)
    
    # via (df['delivery_date'] - df['order_date']).dt.days
    df = add_delivery_days(df)

    if truncate_delivery_days:
        print('truncate_delivery_days')
        # via outlier_truncation(df['delivery_days'])
        # # Define upper/lower bound
        # # upper = x.quantile(0.75) + factor*IQR
        # # lower = x.quantile(0.25) - factor*IQR
        df = remove_delivery_days_outliers(df)
    
    # via df['delivery_date'].apply(lambda x: False if pd.isnull(x) else True)
    df = add_delivery_date_missing(df)

    # year<2016 is all 1994, which is suspicious
    # via df['delivery_date'].apply(lambda x: True if x.year < 2016 else False)
    df = add_delivery_date_1994_marker(df)

    # via df.loc[df['delivery_date'].dt.year < 2016,['delivery_days']] = np.nan
    df = set_delivery_date_1994_to_nan(df)
    
    # via df['brand_id'].apply(lambda x: (df['brand_id'] == x).sum())
    df = add_brand_id_count(df)

    # via df['item_id'].apply(lambda x: (df['item_id'] == x).sum())
    df = add_item_id_count(df)

    # set it all to lowercase and correct some spelling error
    # then via df['item_color'].apply(lambda x: (df['item_color'] == x).sum())
    df = add_item_color_count(df)
    
    # a practical summary for retailing size:
    # sizes_dict = {
    #     '84': 'xxs', '104': 's', '110': 's', '116': 's', '122': 'm', '128': 'm',
    #     '134': 'l', '140': 'l', '148': 'xl', '152': 'xl', '164': 'xxl', '170': 'xxl',
    #     '176': 'xxxl', '18': 'xs', '19': 's', '20': 's', '21': 'm', '22': 'm', '23': 'l',
    #     '24':  'xl', '25': 'xs', '26': 's', '27': 's', '28': 'm', '29': 'm',  '30': 'l',
    #     '31': 'l', '32': 'xl', '33': 'xxl', '34': 'xxs', '35': 'xs', '36': 'xs', '36+': 's',
    #     '37': 's', '37+': 's', '38': 's', '38+': 's', '39': 'm', '39+': 'm', '40': 'm',
    #     '40+': 'm', '41': 'm', '41+' : 'm', '42': 'l', '42+': 'l', '43': 'l', '43+': 'l',
    #     '44': 'l', '44+' : 'xl', '45' : 'xl', '45+': 'xl', '46': 'xl', '46+' : 'xl',
    #     '47' : 'xl', '48': 'xl', '49': 'xl', '50': 'xxl', '52': 'xxl', '54': 'xxl',
    #     '56': 'xxl', '58': 'xxl', 0: 'xxs', '1': 'xxs', '2': 'xxs', '2+': 'xxs', '3' : 'xxs',
    #     '3+': 'xs', '4':  'xs', '4+': 'xs', '5': 'xs', '5+':'xs', '6':'s', '6+':'s',
    #     '7':'s', '7+':'m', '8':'m', '8+':'m', '9': 'l', '9+': 'l', '10': 'l', '10+': 'xl',
    #     '11': 'xl', '11+': 'xl', '12': 'xl', '12+': 'xxl', '13': 'xxl', '14': 'xxl',
    #     36: 'xxs', 38: 'xs', 40: 's', 42: 'm', 44: 'l', 46: 'xl', 48: 'xxl',
    #     '3132': 'xxs', '3332': 'xs', '3432': 'xs', '3632': 's', '3832': 'm', '3634': 'l',
    #     '3834': 'xl', '4032': 'xl', '4034': 'xxl', '4232': 'xxxl', '80': 'xs', '85': 's',
    #     '90': 'm', '95': 'l', '100': 'xl', '105': 'xxl'
    # }
    df = convert_item_sizes(df)

    if truncate_item_price:
        print('truncate_price_size')
        # via outlier_truncation(df['item_price'])
        df = truncate_item_price_outliers(df)

    # via df['user_dob'].apply(calculate_age)
    # today = date.today()
    # return today.year - born.year - ((today.month, today.day) < (born.month, born.day))
    df = add_age(df)

    if truncate_age:
        print('truncate_age')
        # via outlier_truncation(df['age'])
        df = truncate_age_outliers(df)
    if cut_age:
        print('cut_age')
        # via df.loc[df['age'] > 95,'age'] = np.nan
        df = cut_age_outliers(df)
    
    # via df['user_dob'].apply(lambda x: False if pd.isnull(x) else True)
    df = add_dob_missing(df)

    # via df['been_member_for'] = (df['order_date']-df['user_reg_date'] ).dt.days
    df = add_been_member_for(df)

    # labels = ['fresh_member', 'new_member', 'member', 'old_member']
    # cut_bins = [-5, 150, 300, 450, 1000]
    # via df['member'] = pd.cut(df['been_member_for'], bins=cut_bins, labels=labels)
    df = add_member_category(df)

    print(df.info())
    return df   
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
def transform_columns(df_known, known_data:bool):
    # change object variables to datatype category
    df_known['item_size'] = df_known['item_size'].astype('category')
    df_known['item_color'] = df_known['item_color'].astype('category')
    df_known['user_title'] = df_known['user_title'].astype('category')
    df_known['user_state'] = df_known['user_state'].astype('category')
    # change all numeric variables from float64 to float32 to reduce memory consumption
    df_known['item_price'] = df_known['item_price'].astype(np.float32)
    df_known['item_price'] = df_known['item_price'].apply(lambda x:("%.2f" % round(x, 2)))
    df_known['item_price'] = df_known['item_price'].astype(np.float32)
    df_known['brand_id'] = df_known['brand_id'].astype(np.int32)
    df_known['user_id'] = df_known['user_id'].astype(np.int32)
    df_known['item_id'] = df_known['item_id'].astype(np.int32)
    if known_data:
        # since the feature return has only two values, we convert it to boolean
        df_known['return'] = df_known['return'].astype('bool')
    # transform all dates to the datetime datatype
    df_known['order_date'] = df_known['order_date'].astype('datetime64[ns]')
    df_known['delivery_date'] = df_known['delivery_date'].astype('datetime64[ns]')
    df_known['user_dob'] = df_known['user_dob'].astype('datetime64[ns]')
    df_known['user_reg_date'] = df_known['user_reg_date'].astype('datetime64[ns]')
    return df_known

df = transform_columns(df, known_data=True)
df.info()

# <class 'pandas.core.frame.DataFrame'>
# Int64Index: 100000 entries, 1 to 100000
# Data columns (total 13 columns):
#  #   Column         Non-Null Count   Dtype         
# ---  ------         --------------   -----         
#  0   order_date     100000 non-null  datetime64[ns]
#  1   delivery_date  90682 non-null   datetime64[ns]
#  2   item_id        100000 non-null  int32         
#  3   item_size      100000 non-null  category      
#  4   item_color     100000 non-null  category      
#  5   brand_id       100000 non-null  int32         
#  6   item_price     100000 non-null  float32       
#  7   user_id        100000 non-null  int32         
#  8   user_title     100000 non-null  category      
#  9   user_dob       91275 non-null   datetime64[ns]
#  10  user_state     100000 non-null  category      
#  11  user_reg_date  100000 non-null  datetime64[ns]
#  12  return         100000 non-null  bool          
# dtypes: bool(1), category(4), datetime64[ns](4), float32(1), int32(3)
# memory usage: 5.8 MB
```

### Some Data Description During Exploration


Unordered:

- Fusce non velit cursus ligula mattis convallis vel at metus[^2].
- Sed pharetra tellus massa, non elementum eros vulputate non.
- Suspendisse potenti.

Ordered:

1. Quisque arcu felis, laoreet vel accumsan sit amet, fermentum at nunc.
2. Sed massa quam, auctor in eros quis, porttitor tincidunt orci.
3. Nulla convallis id sapien ornare viverra.
4. Nam a est eget ligula pellentesque posuere.

## Blockquote

The following is a blockquote:

> Suspendisse tempus dolor nec risus sodales posuere. Proin dui dui, mollis a consectetur molestie, lobortis vitae tellus.

## Thematic breaks (<hr>)

Mauris viverra dictum ultricies[^3]. Vestibulum quis ipsum euismod, facilisis metus sed, varius ipsum. Donec scelerisque lacus libero, eu dignissim sem venenatis at. Etiam id nisl ut lorem gravida euismod. **You can put some text inside the horizontal rule like so.**

---
{: data-content="hr with text"}

Mauris viverra dictum ultricies. Vestibulum quis ipsum euismod, facilisis metus sed, varius ipsum. Donec scelerisque lacus libero, eu dignissim sem venenatis at. Etiam id nisl ut lorem gravida euismod. **Or you can just have an clean horizontal rule.**

---

Mauris viverra dictum ultricies. Vestibulum quis ipsum euismod, facilisis metus sed, varius ipsum. Donec scelerisque lacus libero, eu dignissim sem venenatis at. Etiam id nisl ut lorem gravida euismod. Or you can just have an clean horizontal rule.

## Code

Now some code:

```
const ultimateTruth = 'follow middlepath';
console.log(ultimateTruth);
```

And here is some `inline code`!

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