# C17378303 - Mariana Pirtac
# This program:
#               Generates the user movie * movie matrix
#               Generates a list of movie reccoemndations using content based filtering

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
movie_data_frame = pd.read_csv('movies.csv', encoding = 'ISO-8859-1')
ratings = pd.read_csv('ratings.csv')

# add a index column at the start of the dataframe
step = 1
movie_data_frame.index = pd.RangeIndex(start=0, stop=len(movie_data_frame.index)*step, step=step)

#movie_data_frame['index'] = movie_data_frame.index
loc = 0 
movie_data_frame.insert(loc, column = 'index', value=movie_data_frame.index)
#print(movie_data_frame['index'])


# Show the first 5 rows of data
#print(movie_data_frame.head(5))

#Get a count of the number of rows/movies in the data set and the number of columns
#print(movie_data_frame.shape)

# Create a list of important columns name 
#movie_features  = ['Genre', 'Title']
movie_features  = ['Genre']

#Show the data
#print(movie_data_frame[movie_features].head(5))

# Check for missing values in the imported columns
#print(movie_data_frame[movie_features].isnull().values.any())

# A function to combine the values of the imported columns into a single string
def get_important_features_movie(data):
    movie_data = [] #initialises this variable as a empty list
    for i in range(0, data.shape[0]):
        #append all the strings from different columns together
        #movie_data.append(data['Genre'][i]+' '+data['Title'][i])
        movie_data.append(data['Genre'][i])

    return movie_data

# Create a column to hold the combined strings
movie_data_frame['movie_data'] = get_important_features_movie(movie_data_frame)
#print("Movie Data:")
#print(movie_data_frame['movie_data'].head(20))

# Show 5 rows of data
#print(movie_data_frame.head(5))

#print(movie_data_frame['movie_data'])

# Convert text to a matrix of tokens counts
movie_count_matrix = CountVectorizer().fit_transform(movie_data_frame['movie_data'])
#print("CountVector:")
#print(movie_count_matrix)
#print(movie_count_matrix.shape)

# Get the movie*movie cosine similarity matrix from the count matrix
# Each row represents a movie and each column represents a movie
movie_cs = cosine_similarity(movie_count_matrix)
print("Movie*Movie Matrix:")
print(movie_cs)
#print(movie_cs.shape)

# Write the matrix to a csv file
#movie_m_dataframe = pd.DataFrame(movie_cs)
#movie_m_dataframe.to_csv("movie_matrix.csv")
#movie_m_dataframe.to_csv("movie_without_title_matrix.csv")


#/**************************************Next Part*************************/
# Content Based Reccomendation 
# Helper Functions 
def get_title_from_index(index):
    return movie_data_frame[movie_data_frame.index == index]['Title'].values[0]

def get_index_from_title(title):
    return movie_data_frame[movie_data_frame.Title == title]['index'].values[0]

# Get into the movie matrix:
# Step1:Get the index of the wanted movie then get its similarity scores to other movies, into a list 
# Step2: Enumerate the similarity scores list 
# Step3: Sort in order of similarity(decreasing order)

#print(movie_data_frame.columns)
#print(movie_data_frame.index)

m_r_df = pd.merge(ratings,movie_data_frame, on='Movie_id')
#print(m_r_df.columns)

new_m_r_df = m_r_df.pivot_table(index='Title',columns='User_id',values='Rating').fillna(0)

data_frame = new_m_r_df.copy()

# A function which takes the userid as an input
# Then finds all the movies seen by that user
# Then Returns the seen_movies list 
def seen_movies(user_id):

    #print('User {} has seen the following movies: \n'.format(user_id))
    n = 1
    for i in new_m_r_df[new_m_r_df[user_id] > 0][user_id].index.tolist():
        #print(n,i)
        n = n + 1
        
    return new_m_r_df[new_m_r_df[user_id] > 0][user_id].index.tolist()

# Call the seen_movies function which will print the seen movies for the chosen user
seen = seen_movies(2)

#print(seen[1])

# Finds the similar movies using the movie*movie matrix for a specific movie
# Returns a list of top 10 most similar movies for the specified movies  
def similar_movies(movies):
    #Find the movie index
    movie_index = get_index_from_title(movies)
    #print("movie_index: ", movie_index)

    similar_movies = list(enumerate(movie_cs[movie_index]))

    sorted_similar_movies = sorted(similar_movies, key=lambda x:x[1], reverse=True)[1:] #[1:] --> disregards the first element, the first element is always the movie itselfsince it has the highest similarity

    similarity_scores = sorted_similar_movies[1:21]
    #similarity_scores = sorted_similar_movies
    similar_movies_list = []

    for i in similarity_scores:
        
        similar_movies_list.append(get_title_from_index(i[0]))

    #print("movies_to_r: \n",similar_movies_list)
    return similar_movies_list

# This function calls the similar_movies function for 20 most similar movies, each list of similar movies is appended into a list
# Each list is compared to eachother and the elements which are present in every list are then appended into the final list 
def movie_lists():

    movie_lists = []
    movies_in_all = []
    
    for i in range(20):
        movie_lists.append(similar_movies(seen[i]))
        #print("movie_lists0: \n", movie_lists)

    for i in range(len(movie_lists)):
        for j in range(1,len(movie_lists)):
            if i != j and j > i:
                movies_in_all.append(list(filter(lambda x:x in movie_lists[i],  movie_lists[j] )))


    #print("movie_lists: \n", movie_lists)
    #print(len(movie_lists[0]))

    #print("1:\n",movie_lists[0])
    #print("2:\n",movie_lists[4])
    
    #print(list(filter(lambda x:x in movie_lists[0],  movie_lists[1] or movie_lists[2] or movie_lists[3] or movie_lists[4])))
    #print(list(filter(lambda x:x in movie_lists[0],  movie_lists[4] )))
    #for i in range(20):
        #movies_in_all.append(list(filter(lambda x:x in movie_lists[0],  movie_lists[i])))
        
    one_movie_lists = []
    for i in movies_in_all:
        if type(i) is list:
            for movies_in_all in i:
                one_movie_lists.append(movies_in_all)

    final_list = []
    for l in set(one_movie_lists):
        counts = [l,one_movie_lists.count(l)]

        if counts[1] > 3:
            final_list.append(counts[0])
            
    return final_list  

def recommend():

    movies = movie_lists()
    print("\nMovie Recomendations:")
    print("\n".join(map(str,movies)))
    movies_df_format = pd.DataFrame(movies)
    movies_df_format.to_csv("list2.csv")
    
recommend()



