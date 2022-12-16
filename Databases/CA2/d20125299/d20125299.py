import psycopg2
import psycopg2.extras
import json
import collections
import cassandra
from cassandra.cluster import Cluster
import time

#Connect to postgres
conn_string = "host='localhost' port='54321' dbname='postgres' user='setyourusername' password='setyourpassword'"
pgcon = psycopg2.connect(conn_string)

#Create a cursor which will store the results from the query 

#The query will retrieve for each player, their sk number the prize they won and what year it was.
cursor = pgcon.cursor()
cursor.execute("select factresults.player_sk, dimplayer.p_name, dimplayer.p_sname, factresults.prize, dimdate.year from factresults join dimplayer on dimplayer.player_sk = factresults.player_sk join dimdate on dimdate.date_sk = factresults.date_sk;")
rows = cursor.fetchall()

rowarray_list = []
for row in rows:
    t = (row[0], row[1], row[2], row[3], row[4])
    rowarray_list.append(t)

j = json.dumps(rowarray_list)
with open("pgextractrows.js", "w") as f:
    f.write(j)

#Convert query to objects of key-value pairs
objects_list = []
for row in rows:
    d = collections.OrderedDict()
    d["player_sk"] = row[0]
    d["p_name"] = row[1]
    d["p_sname"] = row[2]
    d["prize"] = row[3]
    d["year"] = row[4]
    objects_list.append(d)
j = json.dumps(objects_list)
with open("factresults.json", "w") as f:
    f.write(j)

pgcon.close()

# Connection to advanceddb keyspace
casscluster = Cluster(['localhost'], port=9042)
casssession = casscluster.connect('advanceddb')

casssession.execute('USE advanceddb')

#Create a table in cassandra - drop it beforehand if it exists
casssession.execute('Drop table IF EXISTS factresults;');
casssession.execute('Create table factresults ( player_sk int, p_name text, p_sname text, prize float, year int, primary key (player_sk, p_name, p_sname));')

#In Cassandra if we are going to execute a query a number of times we can use a prepared statement
#We set up the statement and then when we execute it we can pass in different values
#This speeds up execution but also works well in this scenario
query = casssession.prepare("insert into factresults (player_sk, p_name, p_sname, prize, year) VALUES (?,?,?,?,?)")
print (query)        
text_id=1
with open("factresults.json") as data_file:
    data = json.load(data_file)

    for v in data:
        print('Uploading to Cassandra - row ' + str(text_id)) 
        print (v['p_name'])
        r_player_sk = v['player_sk'] 
        r_p_name = v['p_name']
        r_p_sname =  v['p_sname'] 
        r_prize= v['prize'] 
        r_year = v['year'] 
        text_id += 1
#Execute the query passing in the required values from the r variables created
        casssession.execute(query, [r_player_sk, r_p_name, r_p_sname, r_prize, r_year])
       
print("Waiting for 1 min to ensure data submitted....")
# Pause to ensure that the data is inserted
time.sleep(60)
