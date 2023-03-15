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

os.chdir(r'C:\Users\lukeh\Documents\College\4th-Year\Final-Year-Project\Ex_rec')

cwd = os.getcwd()
print("Current working directory:", cwd)

# Start timer
time_start = t.time()

# Load Data
#data_frame = pd.read_csv('MovieData1.csv')
#ratings_data_frame = data_frame[["User_id", "Movie_id", "Rating"]]
#ratings_data = data_frame[["User_id", "Movie_id", "Rating"]]
#ratings = np.array(ratings_data, dtype= np.float64)

ratings = pd.read_csv('ratings.csv')
movies = pd.read_csv('movies.csv', encoding = 'ISO-8859-1')


new_movie_df = pd.merge(ratings,movies, on='Movie_id')
print(new_movie_df.columns)

print(ratings)

ratings_data_frame = pd.DataFrame(ratings, columns = ["User_id", "Movie_id", "Rating"], dtype = int)
print("Data types:", ratings_data_frame.dtypes)
print(ratings_data_frame)
#print(ratings_data_frame.head(10))
#print(ratings_data_frame.columns)

user_ratings = pd.pivot_table(ratings, index="User_id", columns="Movie_id", values="Rating")
user_ratings = user_ratings.fillna(0)
user_ratings.sort_index(axis=0, inplace=True)
user_ratings.sort_index(axis=1, inplace=True)
print(user_ratings)

# Check if there are any missing values 
print("Null values in the rating dataset = ",ratings_data_frame.isnull().sum().sum())

def encode_ids(data):
    # Takes a rating dataframe and return:
    # - a simplified rating dataframe with ids in range(nb unique id) for users and movies
    # - 2 mapping dictionaries

    data_encoded = data.copy()
    print("Data which will be encoded: ")
    print(data_encoded)
     
    # data_frame of all unique users
    users = pd.DataFrame(data_encoded.User_id.unique(), columns = ['User_id'])
    dict_users = users.to_dict()
    individual_dict_users = {v: k for k, v in dict_users['User_id'].items()}

    # dataframe for all unique movies 
    movies = pd.DataFrame(data_encoded.Movie_id.unique(), columns=['Movie_id'])
    dict_movies = movies.to_dict()
    individual_dict_movies = {v: k for k, v in dict_movies['Movie_id'].items()}

    data_encoded.User_id = data_encoded.User_id.map(individual_dict_users)
    data_encoded.Movie_id = data_encoded.Movie_id.map(individual_dict_movies)

    #print(data_encoded)
    #print(dict_users)
    #print(dict_movies)

    
    return data_encoded, dict_users, dict_movies

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
# data -> dataframe containing 1 user 1movie 1rating per row
# alpha ->  number of factors/learning rate
# n_epochs -> number of iteration of the SGD procedure
def Stochastic_Gradient_Descent(data, n_factors = 10, alpha = .01, n_epochs = 1):
    #Learn the vectors P and Q(all the weighted p_u and q_i) with SGD
        
    # Encoding userId's and movieId's in data
    data, dict_users, dict_movies = encode_ids(data)
    
    # Number of unique users
    n_unique_users = data.User_id.nunique()
    # Number of unique movies
    n_unique_movies = data.Movie_id.nunique()
    print("Number of unique users: ")
    print(n_unique_users)
    print("Number of unique movies: ")
    print(n_unique_movies)

    #Number of epoch
    print("Epochs:")
    print(n_epochs)
   
    # Randomly initialize the user and item factors.
    p1 = np.random.normal(0, .1, (n_unique_users, n_factors))
    p = expit(p1)
    print("p : \n", p)
    print(type(p))
    q1 = np.random.normal(0, .1, (n_unique_movies, n_factors))
    q = expit(q1)
    print(type(q))
    print("q : \n", q)

    # Optimization procedure
    for epoch in range(n_epochs):
        print('Epoch:', epoch)
        # Loop over the rows in data
        for index in range(data.shape[0]):
            row = data.iloc[[index]]
            
            # current userId = position in the p vector(due to encoding)
            u = int(row.User_id)
            
            
            # current movieId = position in the q vector 
            i = int(row.Movie_id)
           
            # rating associated to  the couple(user u, item i)
            r_ui = int(row.Rating)
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
    '''Estimate rating of user u for movie i.'''

    # scalar product of p[u]and q[i]
    return np.dot(p[u], q[i].transpose())

p, q = Stochastic_Gradient_Descent(ratings_data_frame)

#pd.DataFrame(p).to_csv("v3_p_matrix.csv")
#pd.DataFrame(q).to_csv("v3_q_matrix.csv")


time_end = t.time()
print("\nThe time to complete the Matrix factorisation is: ", time_end - time_start)

user_item_estimate_values = pd.DataFrame(np.dot(p, q.transpose()))
print(user_item_estimate_values.head(10))

# To get the estimated values encoded ids were used
# Now we need to apply the associations of the encoded ids to its original ids
# GET THE MAPPING BACK
ratings_encoded, dict_users, dict_movies = encode_ids(ratings_data_frame)

user_item_estimate_values.rename(columns=(dict_movies['Movie_id']), inplace=True)
user_item_estimate_values.rename(index=(dict_users['User_id']), inplace=True)

# Sort index/rows(users) and columns(movies)
user_item_estimate_values.sort_index(axis=0, inplace=True)
user_item_estimate_values.sort_index(axis=1, inplace=True)

#Get user*item matrix
print(user_item_estimate_values.head())

# Ratings given by user 1
print("ratings_data_frame.loc[1][:10] :\n",user_ratings.loc[1][:10])
# Estimated ratings for user 1 after SVD
print("user_item_estimate_values.loc[1][:10] : \n",user_item_estimate_values.loc[1][:10])

# Ratings given by user 3
print(user_ratings.loc[3][:10])
# Estimated ratings for user 3 after SVD
print(user_item_estimate_values.loc[3][:10])

# Ratings given by user 2
print(user_ratings.loc[2][:10])
# Estimated ratings for user 7 after SVD
print(user_item_estimate_values.loc[2][:10])


# Give recommendations to a user(give the 10 highest recommendations: the recommendations with the highest rating)
user_recommendations = list((user_item_estimate_values.loc[2]).sort_values(ascending=False)[:20].index)
print("user_recommendation: ",user_recommendations)

recom_list = pd.DataFrame(user_recommendations)
# print("recom_list: " , recom_list)
# print("recom_list.columns: " , recom_list.columns)
recom_list.rename(columns={0: "Movie_id"}, inplace=True)
# print("recom_list: " , recom_list)

def get_movietitle_from_movieid():
    movie_list = []
    for i in range(0,len(recom_list)):
        movie = movies.loc[(movies["Movie_id"] == recom_list["Movie_id"][i]), "Title"].values[0]
        # print("movie" , movie)
        movie_list.append(movie)

    return movie_list

final_recom_list = get_movietitle_from_movieid()

print(final_recom_list)

recom_list = pd.DataFrame(final_recom_list)
recom_list.to_csv("list3.csv")
    

