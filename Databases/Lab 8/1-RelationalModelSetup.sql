/* ETL : EXAMPLE ABOUT HOW TO CREATE DIMENSION STUDENT, DEGREE AND LOAD FACTS */
/* SCHEMA from COLLEGE 1 and COLLEGE 2 */
/* College One */
DROP TABLE IF EXISTS c1_St_Courses CASCADE;
DROP TABLE IF EXISTS c1_degrees CASCADE ;
DROP TABLE IF EXISTS c1_Courses CASCADE ;
DROP TABLE IF EXISTS c1_Students CASCADE ;
DROP TABLE IF EXISTS c2_St_Courses CASCADE;
DROP TABLE IF EXISTS c2_degrees CASCADE ;
DROP TABLE IF EXISTS c2_Courses CASCADE ;
DROP TABLE IF EXISTS c2_Students CASCADE ;

/* Degrees offered by College 1 */
Create Table c1_degrees(
degree_id integer primary key,
degree_name varchar(100)
);

/*Students attending College 1 */
Create Table c1_Students(
S_id integer primary key,
S_name varchar(100),
S_surname varchar(100),
s_email varchar(100),
modeofstudy integer, /* 0 fulltime , 1 partime */
degree_id integer,
CONSTRAINT  FK1_degree FOREIGN KEY (degree_id) REFERENCES c1_degrees
);

/*Courses offered by college 1 */
Create Table c1_Courses(
course_code integer primary key ,
c_name varchar(100),
start_date date,
end_Date date);

/*Student exam results per course in college 1 */
Create table c1_St_Courses(
student_id integer,
course_id integer,
marks integer,
examdate date,
CONSTRAINT  PK_st_courses PRIMARY KEY (student_id,course_id),  
CONSTRAINT  FK1_courses FOREIGN KEY (course_id) REFERENCES c1_courses,
CONSTRAINT  FK1_students FOREIGN KEY (student_id) REFERENCES c1_students
);

/* College TWO */
/* Degrees offered by College 2*/
Create Table c2_degrees(
degree_id integer primary key,
degree_name varchar(100)
);

/*Students attending College 2 */
Create Table c2_Students(
S_id integer primary key,
S_name varchar(100),
S_surname varchar(100),
S_email varchar(100),
modeofstudy Char, /* F-fulltime, P-part-time */
degree_id integer,
CONSTRAINT  FK1_degree2 FOREIGN KEY (degree_id) REFERENCES c2_degrees
);

/*Courses offered by college 2 */
Create Table c2_Courses(
course_code integer primary key ,
c_name varchar(100),
start_date date,
end_Date date);

/*Student exam results per course in college 2 */
Create table c2_St_Courses(
student_id integer,
course_id integer,
marks char, /* Grade Achieved A to F */
examdate date,
CONSTRAINT  PK_st_courses2 PRIMARY KEY (student_id,course_id),  
CONSTRAINT  FK1_courses2 FOREIGN KEY (course_id) REFERENCES c2_courses,
CONSTRAINT  FK1_students2 FOREIGN KEY (student_id) REFERENCES c2_students
)
