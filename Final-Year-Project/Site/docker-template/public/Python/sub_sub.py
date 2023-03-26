# C17378303 - Mariana Pirtac
# This program:
#               Generates the user subscription * subscription matrix
#               Generates a list of subscription reccoemndations using content based filtering

# Import libraries
import pandas as pd
import numpy as np
from sklearn.metrics.pairwise import cosine_similarity
from sklearn.feature_extraction.text import CountVectorizer

import os

os.chdir(r'C:\Users\lukeh\Documents\College\4th-Year\Final-Year-Project\Site\docker-template\public\csv')

cwd = os.getcwd()
print("Current working directory:", cwd)

# Store Data
subscription_data_frame = pd.read_csv('subscriptions.csv', encoding = 'ISO-8859-1')
ratings = pd.read_csv('user_subs.csv')

# add a index column at the start of the dataframe
step = 1
subscription_data_frame.index = pd.RangeIndex(start=0, stop=len(subscription_data_frame.index)*step, step=step)

#subscription_data_frame['index'] = subscription_data_frame.index
loc = 0 
subscription_data_frame.insert(loc, column = 'index', value=subscription_data_frame.index)
#print(subscription_data_frame['index'])


# Show the first 5 rows of data
#print(subscription_data_frame.head(5))

#Get a count of the number of rows/subscriptions in the data set and the number of columns
#print(subscription_data_frame.shape)

# Create a list of important columns name 
#subscription_features  = ['category', 'name']
subscription_features  = ['category']

#Show the data
#print(subscription_data_frame[subscription_features].head(5))

# Check for missing values in the imported columns
#print(subscription_data_frame[subscription_features].isnull().values.any())

# A function to combine the values of the imported columns into a single string
def get_important_features_subscription(data):
    subscription_data = [] #initialises this variable as a empty list
    for i in range(0, data.shape[0]):
        #append all the strings from different columns together
        #subscription_data.append(data['category'][i]+' '+data['name'][i])
        subscription_data.append(data['category'][i])

    return subscription_data

# Create a column to hold the combined strings
subscription_data_frame['subscription_data'] = get_important_features_subscription(subscription_data_frame)
#print("subscription Data:")
#print(subscription_data_frame['subscription_data'].head(20))

# Show 5 rows of data
#print(subscription_data_frame.head(5))

#print(subscription_data_frame['subscription_data'])

# Convert text to a matrix of tokens counts
subscription_count_matrix = CountVectorizer().fit_transform(subscription_data_frame['subscription_data'])
#print("CountVector:")
#print(subscription_count_matrix)
#print(subscription_count_matrix.shape)

# Get the subscription*subscription cosine similarity matrix from the count matrix
# Each row represents a subscription and each column represents a subscription
subscription_cs = cosine_similarity(subscription_count_matrix)

# create a dictionary to store the most similar subscriptions for each subscription
similar_subs_dict = {}
for i in range(len(subscription_cs)):
    # sort the cosine similarity scores for this subscription and get the indices of the top 5
    sorted_indices = subscription_cs[i].argsort()[::-1][:6]
    # add the indices to the dictionary
    similar_subs_dict[i] = sorted_indices[1:]

# create a pandas dataframe to hold the results and save it to a csv file
sub_ids = list(range(len(subscription_cs)))
sub_x_sub_df = pd.DataFrame({'sub_id': [i+1 for i in sub_ids]})
for i in range(1, 6):
    similar_subs = [similar_subs_dict[j][i-1]+1 for j in range(len(subscription_cs))]
    col_name = f'similar_sub_id_{i}'
    sub_x_sub_df[col_name] = similar_subs
sub_x_sub_df.to_csv('subXsub.csv', index=False)

# Write the matrix to a csv file
#subscription_m_dataframe = pd.DataFrame(subscription_cs)
#subscription_m_dataframe.to_csv("subscription_matrix.csv")
#subscription_m_dataframe.to_csv("subscription_without_name_matrix.csv")


#/**************************************Next Part*************************/
# Content Based Reccomendation 
# Helper Functions 
def get_name_from_index(index):
    return subscription_data_frame[subscription_data_frame.index == index]['name'].values[0]

def get_index_from_name(name):
    return subscription_data_frame[subscription_data_frame.name == name]['index'].values[0]

# Get into the subscription matrix:
# Step1:Get the index of the wanted subscription then get its similarity scores to other subscriptions, into a list 
# Step2: Enumerate the similarity scores list 
# Step3: Sort in order of similarity(decreasing order)

#print(subscription_data_frame.columns)
#print(subscription_data_frame.index)

m_r_df = pd.merge(ratings,subscription_data_frame, on='sub_id')
#print(m_r_df.columns)

new_m_r_df = m_r_df.pivot_table(index='name',columns='user_id',values='rating').fillna(0)

data_frame = new_m_r_df.copy()

# A function which takes the userid as an input
# Then finds all the subscriptions subscribed by that user
# Then Returns the user_subscriptions list 
def user_subscriptions(user_id):

    #print('User {} has subscribed the following subscriptions: \n'.format(user_id))
    n = 1
    for i in new_m_r_df[new_m_r_df[user_id] > 0][user_id].index.tolist():
        #print(n,i)
        n = n + 1
        
    return new_m_r_df[new_m_r_df[user_id] > 0][user_id].index.tolist()

# Call the user_subscriptions function which will print the subscribed subscriptions for the chosen user
subscribed = user_subscriptions(1)

#print(subscribed[1])

# Finds the similar subscriptions using the subscription*subscription matrix for a specific subscription
# Returns a list of top 10 most similar subscriptions for the specified subscriptions  
def similar_subscriptions(subscriptions):
    #Find the subscription index
    subscription_index = get_index_from_name(subscriptions)
    #print("subscription_index: ", subscription_index)

    similar_subscriptions = list(enumerate(subscription_cs[subscription_index]))

    sorted_similar_subscriptions = sorted(similar_subscriptions, key=lambda x:x[1], reverse=True)[1:] #[1:] --> disregards the first element, the first element is always the subscription itselfsince it has the highest similarity

    similarity_scores = sorted_similar_subscriptions[1:21]
    #similarity_scores = sorted_similar_subscriptions
    similar_subscriptions_list = []

    for i in similarity_scores:
        
        similar_subscriptions_list.append(get_name_from_index(i[0]))

    #print("subscriptions_to_r: \n",similar_subscriptions_list)
    return similar_subscriptions_list

# This function calls the similar_subscriptions function for 20 most similar subscriptions, each list of similar subscriptions is appended into a list
# Each list is compared to eachother and the elements which are present in every list are then appended into the final list 
def subscription_lists():

    subscription_lists = []
    subscriptions_in_all = []
    
    for i in range(4):
        subscription_lists.append(similar_subscriptions(subscribed[i]))
        #print("subscription_lists0: \n", subscription_lists)

    for i in range(len(subscription_lists)):
        for j in range(1,len(subscription_lists)):
            if i != j and j > i:
                subscriptions_in_all.append(list(filter(lambda x:x in subscription_lists[i],  subscription_lists[j] )))


    #print("subscription_lists: \n", subscription_lists)
    #print(len(subscription_lists[0]))

    #print("1:\n",subscription_lists[0])
    #print("2:\n",subscription_lists[4])
    
    #print(list(filter(lambda x:x in subscription_lists[0],  subscription_lists[1] or subscription_lists[2] or subscription_lists[3] or subscription_lists[4])))
    #print(list(filter(lambda x:x in subscription_lists[0],  subscription_lists[4] )))
    #for i in range(20):
        #subscriptions_in_all.append(list(filter(lambda x:x in subscription_lists[0],  subscription_lists[i])))
        
    one_subscription_lists = []
    for i in subscriptions_in_all:
        if type(i) is list:
            for subscriptions_in_all in i:
                one_subscription_lists.append(subscriptions_in_all)

    final_list = []
    for l in set(one_subscription_lists):
        counts = [l,one_subscription_lists.count(l)]

        if counts[1] > 3:
            final_list.append(counts[0])
            
    return final_list  

def recommend():

    subscriptions = subscription_lists()
    print("\nsubscription Recomendations:")
    print("\n".join(map(str,subscriptions)))
    subscriptions_df_format = pd.DataFrame(subscriptions)
    subscriptions_df_format.to_csv("list2.csv")
    
recommend()



