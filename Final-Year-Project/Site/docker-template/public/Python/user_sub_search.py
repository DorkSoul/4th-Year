import pandas as pd
import numpy as np
from sklearn.metrics.pairwise import cosine_similarity
from sklearn.feature_extraction.text import CountVectorizer
import os
import csv

os.chdir(r'C:\Users\lukeh\Documents\College\4th-Year\Final-Year-Project\Site\docker-template\public\csv')

cwd = os.getcwd()
print("Current working directory:", cwd)

# Store Data
data = pd.read_csv('user_subs.csv')

filename = os.path.join(cwd, 'user_subs.csv')

def find_users_with_matching_subs(filename, target_sub_ids):
    user_count = {}
    
    with open(filename, newline='') as csvfile:
        reader = csv.DictReader(csvfile)
        
        for row in reader:
            user_id = int(row['user_id'])
            sub_id = int(row['sub_id'])
            
            if sub_id in target_sub_ids:
                if user_id not in user_count:
                    user_count[user_id] = 0
                user_count[user_id] += 1
                
    return [user_id for user_id, count in user_count.items() if count == len(target_sub_ids)]

target_sub_ids = {21}  # Specify the sub_ids you are looking for

matching_users = find_users_with_matching_subs(filename, target_sub_ids)
# print("User_ids with specified matching sub_ids:", matching_users)


def get_user_subscriptions(user_id, user_subs_file, subscriptions_file):
    user_subs = {}
    with open(user_subs_file, newline='') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            if int(row['user_id']) == user_id:
                user_subs[int(row['sub_id'])] = None
    
    with open(subscriptions_file, newline='') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            sub_id = int(row['sub_id'])
            if sub_id in user_subs:
                user_subs[sub_id] = row['name']
    
    return user_subs

cwd = os.getcwd()
user_subs_file = os.path.join(cwd, 'user_subs.csv')
subscriptions_file = os.path.join(cwd, 'subscriptions.csv')

user_id = 4597  # Specify the user_id for which you want to list subscriptions
user_subscriptions = get_user_subscriptions(user_id, user_subs_file, subscriptions_file)
print(f"Subscriptions for user {user_id}:")
for sub_id, name in user_subscriptions.items():
    print(f"{sub_id}: {name}")