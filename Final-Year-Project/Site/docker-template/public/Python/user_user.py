# C17378303 - Mariana Pirtac
# This program:
#               Generates the user * user matrix
#               Generates a list of subscriptions recomendations using collaborative filoetering

# Import libraries
import pandas as pd
import numpy as np
import csv
from sklearn.metrics.pairwise import cosine_similarity
from sklearn.feature_extraction.text import CountVectorizer

import os

os.chdir(r'C:\Users\lukeh\Documents\College\4th-Year\Final-Year-Project\Site\docker-template\public\csv')

cwd = os.getcwd()
print("Current working directory:", cwd)

# Store Data
data_frame = pd.read_csv('users.csv')
ratings = pd.read_csv('user_subs.csv')
subscriptions = pd.read_csv('subscriptions.csv', encoding = 'ISO-8859-1')

# Add a new column called "user_id" to the DataFrame
# and assign values from 1 to the number of rows in the DataFrame
data_frame.insert(0, "user_id", range(1, len(data_frame)+1))

# Print the updated DataFrame to verify the changes
print(data_frame)


# add a index column at the start of the data frame
step = 1
data_frame.index = pd.RangeIndex(start=0, stop=len(data_frame.index)*step, step=step)
loc = 0 
data_frame.insert(loc, column = 'index', value=data_frame.index)
#print(data_frame['index'])

# Show the first 5 rows of data
#print(data_frame.head(5))

#Get a count of the number of rows/subscriptions in the data set and the number of columns
#print(data_frame.shape)

# Create a list of important columns name user_features 
user_features  = ['gender', 'age', 'time_zone']

#Show the data
#print(data_frame[user_features].head(5))

#Check for missing values in the imported columns
#print("Missing Values in the dataframe = ", data_frame[user_features].isnull().values.any())

#A function that combines the values of the imported columns into a single string
def get_important_features(data):
    user_data = [] # initialize an empty list
    for i in range(0, data.shape[0]):
        # concatenate the strings from different columns
        user_data.append(str(data['gender'][i]) + ' ' + str(data['age'][i]) + ' ' + str(data['time_zone'][i]))
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

# Round all the values in the user_cs array to one decimal place
user_cs_rounded = np.round(user_cs, decimals=1)

# Write to a csv file
# Convert the user_cs_rounded array to a Pandas DataFrame
user_m_dataframe = pd.DataFrame(user_cs_rounded)
# Then convert pandas dataframe to csv file
user_m_dataframe.to_csv("user_matrix.csv")


# Helper Functions 
def get_userId_from_index(index):
    return data_frame[data_frame.index == index]['user_id'].values[0]

def get_index_from_userId(userId):
    return data_frame[data_frame.user_id == userId]['index'].values[0]

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

similar_users = list(enumerate(user_m_dataframe[user_index]))
#print("similar_users",similar_users)
sorted_similar_users = sorted(similar_users, key=lambda x:x[1], reverse=True)
#print("sorted_similar_users: ")
#print(sorted_similar_users[:50])


# Define the number of similar users to retrieve
num_similar_users = 5

# Open a CSV file to store the results
with open('userXuser.csv', mode='w', newline='') as file:
    writer = csv.writer(file)

    # Write the header row
    writer.writerow(['user_id', 'sub_id_1', 'sub_id_2', 'sub_id_3', 'sub_id_4', 'sub_id_5'])

    # Loop through each user
    for user_id in range(1, len(user_m_dataframe) + 1):

        # Get the index of the user using its user_id
        user_index = get_index_from_userId(user_id)

        # Get the list of similar users and sort them
        similar_users = list(enumerate(user_m_dataframe[user_index]))
        sorted_similar_users = sorted(similar_users, key=lambda x:x[1], reverse=True)

        # Get the user ids of the top num_similar_users similar users
        similar_user_ids = [get_userId_from_index(index) for index, score in sorted_similar_users[:num_similar_users]]

        # Get the list of subscriptions for the current user
        user_subs = ratings[ratings['user_id'] == user_id]['sub_id'].tolist()

        # Loop through the similar users and add their subscriptions that the current user doesn't have
        similar_subs = []
        for sim_user_id in similar_user_ids:
            sim_user_subs = ratings[ratings['user_id'] == sim_user_id]['sub_id'].tolist()
            for sub_id in sim_user_subs:
                if sub_id not in user_subs and sub_id not in similar_subs:
                    similar_subs.append(sub_id)
                    if len(similar_subs) == num_similar_users:
                        break
            if len(similar_subs) == num_similar_users:
                break

        # Write the results to the CSV file
        row = [user_id] + similar_subs
        writer.writerow(row)




similar_users_df = pd.DataFrame(columns = ['user_id', 'similarity_score'])
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
similar_users_df['user_id'] = IDs
similar_users_df["similarity_score"] = sim_score
#print("similar_users_df:")
#print(similar_users_df)

ratings = ratings[['user_id', 'sub_id', 'rating']]
# print(ratings)

subscriptions = subscriptions[['sub_id', 'name']]
#print(subscriptions)

new_subscription_df = pd.merge(ratings,subscriptions, on='sub_id')
#print(new_subscription_df.columns)

#new_subscription_df2 = pd.DataFrame(new_subscription_df.groupby('name')['rating'].count())


new_df = new_subscription_df.pivot_table(index='name',columns='user_id', values='rating').fillna(0)

# This function takes a user as an input, 
# then it finds all the subscriptions that were seen by the user,
# then it returns the list of seen subscriptions 
def user_seen_subscriptions(user):

    #print('User {} has seen the following subscriptions: \n'.format(user))
    n = 1
    for i in new_df[new_df[user] > 0][user].index.tolist():
        #print(n,i)
        n = n + 1

    return new_df[new_df[user] > 0][user].index.tolist()

#user_seen_subscriptions(3)  
#user_seen_subscriptions(similar_users_df.user_id[2])

# This function call the user_seen_subscriptions function which returns a list of seen subscriptions for the specified users
# every list of seen subscriptions that is returned by the user_seen_subscriptions is appended into a list of seen_subscriptions 
# Then the list of lists of seen subscriptions are compared to each other, to find subscriptions that reside in all the lists

def subscription_lists():
    
    seen_subscriptions = []
    subscriptions = []
    for i in range(15):
        seen_subscriptions.append(user_seen_subscriptions(similar_users_df.user_id[i]))

    #print("seen subscriptions list: ", seen_subscriptions)

    for i in range(len(seen_subscriptions)):
        #print("lists : ", i)
        for j in range(1,len(seen_subscriptions)):
            if i != j and j > i:
                #print("j: ",j)
                subscriptions.append(list(filter(lambda x:x in seen_subscriptions[i],  seen_subscriptions[j] )))

    one_subscription_lists = []
    for i in subscriptions:
        if type(i) is list:
            for subscription in i:
                one_subscription_lists.append(subscription)
                
    final_list = []
    for l in set(one_subscription_lists):
        counts = [l,one_subscription_lists.count(l)]
        #print(counts)
        
        #print(len(seen_subscriptions))
        if counts[1] > 3:
            final_list.append(counts[0])
        
    return final_list   
  
# This function returns a list of subscription reccomendations  
def recommend():

    subscriptions = subscription_lists()
    #print("\nsubscription Recomendations: \n", subscriptions)
    print("\nsubscription Recomendations:")
    print("\n".join(map(str,subscriptions)))
    #print(len(subscriptions))
    
    subscriptions_df_format = pd.DataFrame(subscriptions)
    # subscriptions_df_format.to_csv("list1.csv")

    
    
recommend()






