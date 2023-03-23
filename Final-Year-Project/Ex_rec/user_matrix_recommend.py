# C17378303 - Mariana Pirtac
# This program:
#               Generates the user * user matrix
#               Generates a list of movies recomendations using collaborative filoetering

# Import libraries
import pandas as pd
import numpy as np
from sklearn.metrics.pairwise import cosine_similarity
from sklearn.feature_extraction.text import CountVectorizer

import os

os.chdir(r'C:\Users\lukeh\Documents\College\4th-Year\Final-Year-Project\Ex_rec')

cwd = os.getcwd()
print("Current working directory:", cwd)

# Store Data
data_frame = pd.read_csv('users.csv')
ratings = pd.read_csv('ratings.csv')
movies = pd.read_csv('movies.csv', encoding = 'ISO-8859-1')

# add a index column at the start of the data frame
step = 1
data_frame.index = pd.RangeIndex(start=0, stop=len(data_frame.index)*step, step=step)
loc = 0 
data_frame.insert(loc, column = 'index', value=data_frame.index)
#print(data_frame['index'])

# Show the first 5 rows of data
#print(data_frame.head(5))

#Get a count of the number of rows/movies in the data set and the number of columns
#print(data_frame.shape)

# Create a list of important columns name user_features 
user_features  = ['Gender', 'Age', 'Occupation']

#Show the data
#print(data_frame[user_features].head(5))

#Check for missing values in the imported columns
#print("Missing Values in the dataframe = ", data_frame[user_features].isnull().values.any())

#A function that combines the values of the imported columns into a single string
def get_important_features(data):
    user_data = [] #initialises this variable as a empty list
    for i in range(0, data.shape[0]):
        #append all the strings from different columns together
        user_data.append(data['Gender'][i]+' '+data['Age'][i]+' '+data['Occupation'][i])

    return user_data 

#Create a column to hold the combined strings
data_frame['user_data'] = get_important_features(data_frame) #imports the frame

#Show 3 rows of the data
#print("Data Array")
#print(data_frame['user_data'].head(11))

#Convert the text to a matrix of token counts
count_matrix = CountVectorizer().fit_transform(data_frame['user_data'])

#print("Vector of Tokens: ")
#print(count_matrix)
#print("Shape:")
#print(count_matrix.shape)
# Get the user*user cosine similarity matrix from the count matrix
#each row represents a user and each column represents a user
user_cs = cosine_similarity(count_matrix)

#print the user*user cosine similarity matrix
#should display a matrix
print("User*User Matrix:")
print(user_cs) 

# Get the shape of the cosine similarity matrix
#print(user_cs.shape)

# Write to a csv file
# First convert ndarray(user_cs) to pandas dataframe  
user_m_dataframe = pd.DataFrame(user_cs)
# Then convert pandas dataframe to csv file
user_m_dataframe.to_csv("user_matrix.csv")


# Helper Functions 
def get_userId_from_index(index):
    return data_frame[data_frame.index == index]['User_id'].values[0]

def get_index_from_userId(userId):
    return data_frame[data_frame.User_id == userId]['index'].values[0]

# Get into the user similarity matrix
# Get the index of the user we want to find similar users to
# Enumerate the similarity scores list
# Sort in order of similarity score (decreasing order)

# print(data_frame.columns)
# print(data_frame.index)

# Choose the user using its user_id 
wanted_user = 2

# Get the index of the user using its user_id
user_index = get_index_from_userId(wanted_user)
print("User index: ",user_index)
print("User ID: ", get_userId_from_index(user_index))

similar_users = list(enumerate(user_cs[user_index]))
#print("similar_users",similar_users)
sorted_similar_users = sorted(similar_users, key=lambda x:x[1], reverse=True)
#print("sorted_similar_users: ")
#print(sorted_similar_users[:50])

similar_users_df = pd.DataFrame(columns = ['User_id', 'similarity_score'])
#print("similar_users_df: ", similar_users_df.columns)
#print("sorted_similar_users", len(sorted_similar_users))

i = 0
# a list for the IDs
IDs = []
# a list to hold the similarity scores 
sim_score = []

for similar in sorted_similar_users:
    
    if(similar[1] >=0.7):
        x = get_userId_from_index(similar[0])
        #print(x)
        IDs.append(x)
        y = sorted_similar_users[i]
        #print(y)
        # append only the similarity score to the list
        sim_score.append(y[1])
        
    
    i = i + 1 

    if(i > len(sorted_similar_users)):
        print("Reached the end of the list")
        break 


#print("IDs:",IDs)
#print("sim_score", sim_score)
similar_users_df['User_id'] = IDs
similar_users_df["similarity_score"] = sim_score
#print("similar_users_df:")
#print(similar_users_df)

ratings = ratings.drop(['Timestamp'], axis = 1)
# print(ratings)

movies = movies.drop(['Genre', 'Year'], axis = 1)
print(movies)

new_movie_df = pd.merge(ratings,movies, on='Movie_id')
print(new_movie_df.columns)

#new_movie_df2 = pd.DataFrame(new_movie_df.groupby('Title')['Rating'].count())


new_df = new_movie_df.pivot_table(index='Title',columns='User_id', values='Rating').fillna(0)

# This function takes a user as an input, 
# then it finds all the movies that were seen by the user,
# then it returns the list of seen movies 
def user_seen_movies(user):

    #print('User {} has seen the following movies: \n'.format(user))
    n = 1
    for i in new_df[new_df[user] > 0][user].index.tolist():
        #print(n,i)
        n = n + 1

    return new_df[new_df[user] > 0][user].index.tolist()

#user_seen_movies(3)  
#user_seen_movies(similar_users_df.User_id[2])

# This function call the user_seen_movies function which returns a list of seen movies for the specified users
# every list of seen movies that is returned by the user_seen_movies is appended into a list of seen_movies 
# Then the list of lists of seen movies are compared to each other, to find movies that reside in all the lists

def movie_lists():
    
    seen_movies = []
    movies = []
    for i in range(10):
        seen_movies.append(user_seen_movies(similar_users_df.User_id[i]))

    #print("seen movies list: ", seen_movies)
    

    for i in range(len(seen_movies)):
        #print("lists : ", i)
        for j in range(1,len(seen_movies)):
            if i != j and j > i:
                #print("j: ",j)
                movies.append(list(filter(lambda x:x in seen_movies[i],  seen_movies[j] )))

    one_movie_lists = []
    for i in movies:
        if type(i) is list:
            for movie in i:
                one_movie_lists.append(movie)
                
    final_list = []
    for l in set(one_movie_lists):
        counts = [l,one_movie_lists.count(l)]
        #print(counts)
        
        #print(len(seen_movies))
        if counts[1] > 3:
            final_list.append(counts[0])
        
    return final_list    
  
# This function returns a list of movie reccomendations  
def recommend():

    movies = movie_lists()
    #print("\nMovie Recomendations: \n", movies)
    print("\nMovie Recomendations:")
    print("\n".join(map(str,movies)))
    #print(len(movies))
    
    movies_df_format = pd.DataFrame(movies)
    movies_df_format.to_csv("list1.csv")

    
    
recommend()






