/* DIMENSIONAL MODEL SCHEMA */
DROP TABLE IF EXISTS DimDate CASCADE;
DROP TABLE IF EXISTS DimStudent CASCADE;
DROP TABLE IF EXISTS DimDegree CASCADE;
DROP TABLE IF EXISTS DimCourse CASCADE;
DROP TABLE IF EXISTS FactMarks CASCADE;

Create table DimDate(
date_sk integer primary key,
examdate date
);

Create table DimStudent(
student_sk integer primary key,
S_name varchar(100),
S_surname varchar(100),
S_email varchar(100),
modeofstudy char, /* F-fulltime, P-parttime */
degree_id integer
);

Create table DimCourse(
course_sk integer primary key,
c_name varchar(100)
);

Create table DimDegree(
degree_sk integer primary key,
degree_name varchar(200));

/* In the fact table we want to store whether the student has passed/failed */
Create Table FactMarks(
degree_sk integer,
course_sk integer,
student_sk integer,
date_sk integer,
pass varchar(20),
CONSTRAINT  PK_fact PRIMARY KEY (degree_sk,course_sk,student_sk,date_sk),  
CONSTRAINT  SK_course FOREIGN KEY (course_sk) REFERENCES DimCourse,
CONSTRAINT  SK_degree FOREIGN KEY (degree_sk) REFERENCES DimDegree,
CONSTRAINT  SK_student FOREIGN KEY (student_sk) REFERENCES DimStudent,
CONSTRAINT  SK_date FOREIGN KEY (date_sk) REFERENCES DimDate
);