import json
from random import randint  
from cassandra.cluster import Cluster
import pymongo
import time

# Connection to advanceddb keyspace
casscluster = Cluster(['localhost'], port=9042)
casssession = casscluster.connect('advanceddb')
#use the correct database
casssession.execute('USE advanceddb')

#Connection to the Mongo databse running on localhost - forcing a direct connection
url="mongodb://localhost:27017"
client = pymongo.MongoClient(url, directConnection=True)

# Working with advanceddb and the factmarks collection
db = client.advanceddb
coll=db.factmarks


#Prepare the query for cassandra
query = casssession.prepare("select * from factmarks")

#We will create a set of insert statements for mongo in a file called cassjson.mongodb
#We will also insert the data directing into the factmarks collection in the MongoDB
filename = 'cassjson.mongodb'
file = open(filename,'w')
rec = 'use ("advanceddb);\n'
file.write(rec)

#iterate through rows retrieved and create the json equivalent
for i in casssession.execute(query):
    print("Setting up insert for Student_sk: ", i.student_sk, " for course ", i.c_name)
    marks=randint(20,80)
    insertentry = json.dumps({
    "student_sk": i.student_sk,
    "s_name": i.s_name,
    "c_name": i.c_name,
    "d_name": i.d_name,
    "marks": marks

    })
    doc={"student_sk": i.student_sk,"s_name": i.s_name,"c_name": i.c_name,"d_name": i.d_name,"marks": marks}

#insert into the mongo database
    res=coll.insert_one(doc)
    print(res)
#Write an insert for each row to the file   
    rec = 'db.factmarks.insertOne(' + insertentry + ')\n'
    file.write(rec)
file.close()
print ("Retrieving the data from Mongo to check - if you don't see anything use the inserts in cassjson.mongodb\n")
cursor = coll.find()
for record in cursor:
    print(record)
#You now have the data in Mongo AND
#You have a file of insert statements you can execute in mongo


time.sleep(120)#Wait for 2 minutes to give the mongo insert a chance to work
print ("If you didn't see the data on screen and when you check Mongo you can't see it - use the inserts in cassjson.mongodb\n")

#if the data doesn't appear use the inserts from the cassjson.mongo file