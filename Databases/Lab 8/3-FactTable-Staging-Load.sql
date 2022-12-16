
/* LOAD FACTS */
/* merge all facts */
/* 1- merge all the data keeping a field for the source DB */
/* empty table */
drop table if exists stage_fact cascade;
create table stage_fact(
degree_id integer,
course_id integer,
student_id integer,
date_id date,
pass varchar(20)
);

alter table stage_fact add sourceDB integer;
/* insert data from college 1, set sourceDB to 1 for data from c1_st_courses, 2 for data from c2_st_courses*/
insert into stage_fact select  0,course_id,student_id,examdate,
cast(marks as varchar(20)),1 
from c1_st_courses;
/* insert data from college 1 */
insert into stage_fact select  0,course_id,student_id,examdate,
cast(marks as varchar(20)),2 
from c2_st_courses;

/* add in the degree_ids */
update stage_fact
set degree_id=
  (  
  select stage_student.degree_id from stage_student
  where   
  stage_student.s_id = stage_fact.student_id);
   
select * from stage_fact;
   

/* fix the transformation  - change grade letters and numeric marks to pass/fail */
update stage_fact set pass='Fail' where pass='F' or pass='E';
update stage_fact set pass='Pass' where pass='B' or pass='A' or pass='C' or pass='D';
update stage_fact set pass='Fail' where (pass!='Fail' and pass !='Pass') and cast(pass as integer)<40;
update stage_fact set pass='Pass' where (pass!='Fail' and pass !='Pass') and cast(pass as integer)>=40;


select * from stage_fact;


/* ADD SK Keys - i.e. foreign keys */
alter table stage_fact add student_sk integer;
alter table stage_fact add course_sk integer;
alter table stage_fact add date_sk integer;
alter table stage_fact add degree_sk integer;

/* assign values to Student_SK using stage_student as lookup*/
/* Join the dimension stage table */
update stage_fact
set student_sk=
  (select stage_student.student_sk from stage_student
where   
  stage_student.s_id = stage_fact.student_id);
select * from stage_fact;
  
  
select * from stage_student;
select * from stage_fact;
/* assign values to course_SK using stage_course as lookup*/
/* Join the dimension stage table */
update stage_fact
set course_sk=
  (select stage_course.course_sk from stage_course
   where stage_course.course_code = stage_fact.course_id
  and stage_course.sourceDB=stage_fact.sourceDB 
  );
  
 select * from stage_fact;

/* assign values to degree_SK using stage_STUDENT and stage_degree as lookup*/
/* Join the dimension stage table */
update stage_fact
set degree_sk=
  (select stage_degree.degree_sk from stage_degree
   where stage_degree.degree_id=stage_fact.degree_id
      );

select * from stage_fact;


/* assign values to date_SK using stage_date as lookup*/
/* Join the dimension stage table */
update stage_fact
set date_sk=
  (select stage_date.date_sk from
  stage_date  where 
  stage_date.examdate= stage_fact.date_id);
  
  select * from stage_fact;

/* LOAD into DW */
select * from factmarks;
insert into factmarks select degree_sk,course_sk,student_sk, date_sk,pass 
from stage_fact;

select * from factmarks;
