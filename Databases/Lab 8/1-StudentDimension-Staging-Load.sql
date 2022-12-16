
/* DIMENSION STUDENT *******************************************/
/* 1- merge all the data keeping a field for the source DB */
/*College 1 is considered the master list - if a student with the same student id exists in both college 1 and college 2
the details of name and email are taken from college 1
However it is possible for the student to be studying a degree in college 1 in semester 1 and 
another degree in college 2 in semester 2 and have a different mode of study in each college.
Therefore we need on the staging table to have columns for the degree in college 1 and mode of study in college 1
AND columns for the degree in college 2 and mode of study in college 2 and make sure we populate those columns correctly */

DROP TABLE IF EXISTS stage_student CASCADE;
DROP TABLE IF EXISTS stage_student_temp CASCADE;
DROP TABLE IF EXISTS stage_student_temp2 CASCADE;

/* create the staging  table - the where clause will ensure an empty table */
create table stage_student as select * from c1_students where 1=0;

/* add a field for a source DB*/
alter table stage_student add sourceDB integer;
/* insert data from college 1 */
Insert into stage_student 
select s_id,s_name,s_surname,s_email, modeofstudy,degree_id,1 from c1_students;


/* insert data from college 2 */

/* fix the transformation of mode of study - from integer to character */
create table  stage_student_temp as
select s_id,s_name,s_surname,s_email,modeofstudy,degree_id from c2_students;
update stage_student_temp set modeofstudy=0 where modeofstudy='F';
update stage_student_temp set modeofstudy=1 where modeofstudy='P';



/* If there are any additional students in college 2 which were not in college 1 we need to insert them 
In our schema college 2 has an additonal student*/
create table stage_student_temp2 as select s_id, s_name, s_surname,s_email, degree_id , modeofstudy 
 from stage_student_temp t
where not EXISTS
(select t.s_id from stage_student s where t.s_id =s.s_id);
/* there are other ways to do this */

/* Insert the additional students from college 2 into the staging table */
Insert into stage_student (s_id, s_name, s_surname, s_email, modeofstudy, degree_id, sourceDB)
(select s_id,s_name,s_surname,s_email,cast(modeofstudy as integer), degree_id,2 from stage_student_temp2);



/* ADD SK Key */
alter table stage_student add student_sk integer;

/* create a sequence to generate the surrogate keys */
DROP SEQUENCE IF EXISTS student_seq;
create sequence student_seq 
start with 1 
increment by 1 ; 
/* update the values of the student_sk column, make the sequence choose the next in sequence */
update stage_student set student_sk = nextval('student_seq');

select * from stage_student;


/* LOAD into DW */
/* We should have FIVE students */
insert into DimStudent (student_sk, s_name, s_surname, s_email, modeofstudy, degree_id)
select student_sk,S_name,S_surname,s_email,modeofstudy, degree_id from stage_student;

select * from DimStudent;

/* END OF DIMENSION STUDENT ************************************************/
