# We are trying to predict the value of a customer to a business.
#
# The data structure training_data holds the information we have
# about other customers. The columns list:
# - column 1: customer ID
# - column 2: customer Average Weekly Shopping Frequency
# - column 3: customer Average Shop Spend
# - column 4: customer Customer Value (target variable)
#
# The data structure, query holds the information we have about the
# customer who we would like to predict the value of to the company.
# The data is listed in the same order as in the training_data 
# data structure. However, the final columns holds a zero as we do not
# no the value of this variable.
# 

training_data = [ 
    [100,	3.6,	85,	107],
    [102,	2.9,    99,	129],
    [107,	2.2,	75,	118],
    [141,	1.2,	150,	256],
    [154,	1.7,	177, 263],
    [165,	0.8,	183,	244],
    [211,	6,	    22,	308],
    [229,	5.7,	32,	333],
    [233,	4.8,	62,	316]
]

query = [244,	0.75,	0.285714286, 0]

# (1) Implement a k-nn classifer to compute the value of the query customer.
#
# (2) What is the predicted values of the query customer when:
# (2.1) - k = 1
# (2.2) - k = 3
#
# (3) The data in the explanatory variables 'Average Weekly Shopping Frequency'
# and the 'Average Shop Spend' have very different ranges of values. In such
# situations it is a good idea to normalise the values in the explanatory
# variables before computing the distance.
# (3.1) Write a function to normalise the values within a column.
# (3.2) What is the value of the customer using the normalised data when:
# (3.2.1) - k = 1
# (3.2.2) - k = 3
#
# (4) Implement a weighted k-nn classifer to compute the value of the query
# customer.
# (4.1) What is the predicted value of the query customer using the weighted
# k-nn classifer, using all the training set as neighbours, when we use:
# (4.1.1) an inverse function to convert distances to weights
# (4.1.2) an subtraction function to convert distances to weights
# (4.1.3) an gaussian function to convert distances to weights
#
