import psycopg2
import psycopg2.extras
import json
import collections
import cassandra
from cassandra.cluster import Cluster
import time

#Connect to postgres
#Change the details of conn_string to reflect your Postgres installation
conn_string = "host='localhost' port='54321' dbname='my_db' user='setyourusername' password='setyourpassword'"
pgcon = psycopg2.connect(conn_string)

#Create a cursor which will store the results from our query 
#The query is targeting the fact table and dimension tables created in the lab for week 8
#you need factmarks, dimstudent, dimcourse, dimdegree

#The query will retrieve for each student and each course they studied the student identifier, 
#the student name, degree name, course name and the result achieve
cursor = pgcon.cursor()
cursor.execute("select fm.student_sk, ds.s_name, dc.c_name, dd.degree_name as d_name, pass from factmarks fm join dimstudent ds on fm.student_sk=ds.student_sk join dimcourse dc on fm.course_sk = dc.course_sk join dimdegree dd on fm.degree_sk =dd.degree_sk;")
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
    d["student_sk"] = row[0]
    d["s_name"] = row[1]
    d["c_name"] = row[2]
    d["d_name"] = row[3]
    d["pass"] = row[4]
    objects_list.append(d)
j = json.dumps(objects_list)
with open("factmarks.json", "w") as f:
    f.write(j)

pgcon.close()

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
