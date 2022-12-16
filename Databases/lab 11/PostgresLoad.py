import psycopg2
import psycopg2.extras
import json
import collections
import cassandra
from cassandra.cluster import Cluster
import time



# Connection to advanceddb keyspace
casscluster = Cluster(['localhost'], port=9042)
casssession = casscluster.connect('advanceddb')

casssession.execute('USE advanceddb')

#Create a table in cassandra - drop it beforehand if it exists
casssession.execute('Drop table IF EXISTS factmarks;');
casssession.execute('Create table factmarks ( student_sk int,s_name text, c_name text, d_name text, pass text, primary key (student_sk, c_name, d_name));')

#In Cassandra if we are going to execute a query a number of times we can use a prepared statement
#We set up the statement and then when we execute it we can pass in different values
#This speeds up execution but also works well in this scenario
query = casssession.prepare("insert into factmarks (student_sk, s_name, c_name, d_name, pass) VALUES (?,?,?,?,?)")
print (query)        
text_id=1
with open("factmarks.json") as data_file:
    data = json.load(data_file)

    for v in data:
        print('Uploading to Cassandra - row ' + str(text_id)) 
        print (v['s_name'])
        r_student_sk = v['student_sk'] 
        r_s_name = v['s_name']
        r_c_name =  v['c_name'] 
        r_d_name = v['d_name'] 
        r_pass = v['pass'] 
        text_id += 1
#Execute the query passing in the required values from the r variables created
        casssession.execute(query, [r_student_sk, r_s_name, r_c_name, r_d_name, r_pass])
print("Waiting for 1 min to ensure data submitted....")
# Pause to ensure that the data is inserted
time.sleep(60)
