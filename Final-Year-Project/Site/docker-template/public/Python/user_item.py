# C17378303 - Mariana Pirtac
# Code to generate a user item matrix

# Import libraries
import pandas as pd
import numpy as np
import time as t
import warnings
from scipy.sparse.linalg import svds
from scipy.special import expit
import matplotlib.pyplot as plt

import os

os.chdir(r'C:\Users\lukeh\Documents\College\4th-Year\Final-Year-Project\Site\docker-template\public\csv')

cwd = os.getcwd()
# print("Current working directory:", cwd)

# Start timer
time_start = t.time()

# Load Data
#data_frame = pd.read_csv('MovieData1.csv')
#ratings_data_frame = data_frame[["user_id", "sub_id", "rating"]]
#ratings_data = data_frame[["user_id", "sub_id", "rating"]]
#ratings = np.array(ratings_data, dtype= np.float64)

ratings = pd.read_csv('user_subs.csv')
subscriptions = pd.read_csv('subscriptions.csv', encoding = 'ISO-8859-1')


new_subscription_df = pd.merge(ratings,subscriptions, on='sub_id')
# print(new_subscription_df.columns)

# print(ratings)

ratings_data_frame = pd.DataFrame(ratings, columns = ["user_id", "sub_id", "rating"], dtype = int)
# print("Data types:", ratings_data_frame.dtypes)
# print(ratings_data_frame)
#print(ratings_data_frame.head(10))
#print(ratings_data_frame.columns)

user_ratings = pd.pivot_table(ratings, index="user_id", columns="sub_id", values="rating")
user_ratings = user_ratings.fillna(0)
user_ratings.sort_index(axis=0, inplace=True)
user_ratings.sort_index(axis=1, inplace=True)
# print(user_ratings)

# Check if there are any missing values 
# print("Null values in the rating dataset = ",ratings_data_frame.isnull().sum().sum())

def encode_ids(data):
    # Takes a rating dataframe and return:
    # - a simplified rating dataframe with ids in range(nb unique id) for users and subscriptions
    # - 2 mapping dictionaries

    data_encoded = data.copy()
    # print("Data which will be encoded: ")
    # print(data_encoded)
     
    # data_frame of all unique users
    users = pd.DataFrame(data_encoded.user_id.unique(), columns = ['user_id'])
    dict_users = users.to_dict()
    individual_dict_users = {v: k for k, v in dict_users['user_id'].items()}

    # dataframe for all unique subscriptions 
    subscriptions = pd.DataFrame(data_encoded.sub_id.unique(), columns=['sub_id'])
    dict_subscriptions = subscriptions.to_dict()
    # print("1", dict_subscriptions)
    individual_dict_subscriptions = {v: k for k, v in dict_subscriptions['sub_id'].items()}
    # print("2", dict_subscriptions)

    data_encoded.user_id = data_encoded.user_id.map(individual_dict_users)
    data_encoded.sub_id = data_encoded.sub_id.map(individual_dict_subscriptions)

    #print(data_encoded)
    #print(dict_users)
    #print(dict_subscriptions)

    
    return data_encoded, dict_users, dict_subscriptions

# The steps to implement in the function SGD():
# 1. Ititialise P and Q to random values
# 2. For n epochs passes on the data:
#   -> for all known ratings rui
#       -compute the error between the predicted rating pu * qi and the known rating rui:
#           err = rui - pu * qi
#       -update pu and qi using the following rule:
#           pu <- pu + a * err * qi
#           qi <- qi + a * err * pu

# adapted from http://nicolas-hug.com/blog/matrix_facto_4
# data -> dataframe containing 1 user 1subscription 1rating per row
# alpha ->  number of factors/learning rate
# n_epochs -> number of iteration of the SGD procedure
def Stochastic_Gradient_Descent(data, n_factors = 10, alpha = .01, n_epochs = 5):
    #Learn the vectors P and Q(all the weighted p_u and q_i) with SGD
        
    # Encoding userId's and movieId's in data
    data, dict_users, dict_subscriptions = encode_ids(data)
    
    # Number of unique users
    n_unique_users = data.user_id.nunique()
    # Number of unique subscriptions
    n_unique_subscriptions = data.sub_id.nunique()
    print("Number of unique users: ")
    print(n_unique_users)
    print("Number of unique subscriptions: ")
    print(n_unique_subscriptions)

    #Number of epoch
    print("Epochs:")
    print(n_epochs)
   
    # Randomly initialize the user and item factors.
    p1 = np.random.normal(0, .1, (n_unique_users, n_factors))
    p = expit(p1)
    # print("p : \n", p)
    # print(type(p))
    q1 = np.random.normal(0, .1, (n_unique_subscriptions, n_factors))
    q = expit(q1)
    # print(type(q))
    # print("q : \n", q)

    # Optimization procedure
    for epoch in range(n_epochs):
        print('Epoch:', epoch)
        # Loop over the rows in data
        for index in range(data.shape[0]):
            row = data.iloc[[index]]
            
            # current userId = position in the p vector(due to encoding)
            u = int(row.user_id)
            
            
            # current movieId = position in the q vector 
            i = int(row.sub_id)
           
            # rating associated to  the couple(user u, item i)
            r_ui = int(row.rating)
            #print("r_ui",r_ui)

            err = r_ui - np.dot(p[u], q[i].transpose())
           

            # Update vectors p_u and q_i
            p_old = p[u]
            # Update the rule above 
            p[u] += alpha * err * q[i]
            #print("p[u] += alpha * err * q[i]: ", p[u])
            q[i] += alpha * err * p_old
            #print("q[i] += alpha * err * p_old: ", q[i])
           


    return p, q 

def estimate(u, i, p, q):
    '''Estimate rating of user u for subscription i.'''

    # scalar product of p[u]and q[i]
    return np.dot(p[u], q[i].transpose())

p, q = Stochastic_Gradient_Descent(ratings_data_frame)

#pd.DataFrame(p).to_csv("v3_p_matrix.csv")
#pd.DataFrame(q).to_csv("v3_q_matrix.csv")


time_end = t.time()
elapsed_time = time_end - time_start
hours, remainder = divmod(elapsed_time, 3600)
minutes, seconds = divmod(remainder, 60)
print("\nThe time to complete the Matrix factorisation is: {:02d}:{:02d}:{:02d} \n".format(int(hours), int(minutes), int(seconds)))

user_item_estimate_values = pd.DataFrame(np.dot(p, q.transpose()))
# print(user_item_estimate_values.head(10))

# To get the estimated values encoded ids were used
# Now we need to apply the associations of the encoded ids to its original ids
# GET THE MAPPING BACK
ratings_encoded, dict_users, dict_subscriptions = encode_ids(ratings_data_frame)

user_item_estimate_values.rename(columns=(dict_subscriptions['sub_id']), inplace=True)
user_item_estimate_values.rename(index=(dict_users['user_id']), inplace=True)

# Sort index/rows(users) and columns(subscriptions)
user_item_estimate_values.sort_index(axis=0, inplace=True)
user_item_estimate_values.sort_index(axis=1, inplace=True)

#Get user*item matrix
# print("user_item_estimate_values\n", user_item_estimate_values.head())

# Round each number to one decimal place
rounded_df = user_item_estimate_values.round(1)

# Save the sorted DataFrame to a new CSV file with the index label
rounded_df.to_csv('userXsub.csv', index_label='id')

# ratings given by user 1
# print("ratings given by user 1\n",user_ratings.loc[1][:10])
# Estimated ratings for user 1 after SVD
# print("Estimated ratings for user 1 after SVD\n", user_item_estimate_values.loc[1][:10])

# ratings given by user 2
# print("ratings given by user 2\n" , user_ratings.loc[2][:10])
# Estimated ratings for user 2 after SVD
# print("Estimated ratings for user 2 after SVD\n", user_item_estimate_values.loc[2][:10])

# ratings given by user 3
print("ratings given by user 962\n", user_ratings.loc[962][:10])
# Estimated ratings for user 3 after SVD
print("Estimated ratings for user 962 after SVD\n", user_item_estimate_values.loc[962][:10])


def get_subscription_names(sub_ids):
    # Get the names of the subscriptions corresponding to the given IDs
    subscription_names = []
    for sub_id in sub_ids:
        sub_name = subscriptions.loc[subscriptions['sub_id'] == sub_id, 'name'].iloc[0]
        subscription_names.append(sub_name)
    return subscription_names

# Get the recommendations for user 962
user_recommendations = list((user_item_estimate_values.loc[962]).sort_values(ascending=False)[:10].index)

# Get the names of the recommended subscriptions
recommended_subscription_names = get_subscription_names(user_recommendations)

# Print the recommendations with names
print("User recommendations: ", recommended_subscription_names)

recom_list = pd.DataFrame(user_recommendations)
# print("recom_list: " , recom_list)
# print("recom_list.columns: " , recom_list.columns)
recom_list.rename(columns={0: "sub_id"}, inplace=True)
# print("recom_list: " , recom_list)

def get_sub_name_from_movieid():
    movie_list = []
    for i in range(0,len(recom_list)):
        movie = subscriptions.loc[(subscriptions["sub_id"] == recom_list["sub_id"][i]), "name"].values[0]
        # print("movie" , movie)
        movie_list.append(movie)

    return movie_list

final_recom_list = get_sub_name_from_movieid()

# print(final_recom_list)

recom_list = pd.DataFrame(final_recom_list)
# recom_list.to_csv("recom_list.csv")
    

