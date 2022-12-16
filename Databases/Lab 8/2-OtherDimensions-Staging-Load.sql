/* DIMENSION Degree */


/* Merge degrees with the same name accross different Colleges */
DROP TABLE IF EXISTS stage_degree CASCADE;
/* create the staging  table - the where clause will ensure an empty table */
create table stage_degree as select * from c1_degrees where 1=0;
alter table stage_degree add sourceDB integer;

/* Both colleges use the same course code. 
College 1 is the master list - we want to ensure we don't get duplictes
However there might be a degree in college 2 that is not in the college 1 that we need to capture
*/
insert into stage_degree  select degree_id, degree_name, 1 from c1_degrees;
DROP TABLE IF EXISTS stage_degree_temp;
create table stage_degree_temp as select degree_id, degree_name, 2 from  c2_degrees t
where not EXISTS
(select t.degree_id from stage_degree s where t.degree_id =s.degree_id);

select * from STAGE_DEGREE;
alter table stage_degree add degree_sk integer;
select * from STAGE_DEGREE;


/* add sequence */
drop sequence if exists degree_seq;
create sequence degree_seq 
start with 1 
increment by 1 ; 

update stage_degree
set degree_sk = nextval('degree_seq');
select * from stage_degree;

/* LOAD into DW */
insert into DimDegree select degree_sk,degree_name from stage_degree;

select * from DimDegree;

/* End of dimension DEGREE */


/* DIMENSION DimCourse */
/* Merge courses accross different Colleges */

DROP TABLE IF EXISTS STAGE_COURSE CASCADE;

/* create the staging  table - the where clause will ensure an empty table */
create table stage_course as select * from c1_courses where 1=0;
alter table stage_course add sourceDB integer;

insert into  stage_course 
(select course_code,  c_name, start_date, end_date, 1 as sourceDB from  c1_courses as c1
union
select course_code, c_name, start_date, end_date, 2 as sourceDB from c2_courses as c2);

alter table stage_course add course_sk integer;
/* add sequence */
drop sequence if exists course_seq;
create sequence course_seq 
start with 1 
increment by 1 ; 
update stage_course
set course_sk = nextval ('course_seq');
select * from stage_course;

/* LOAD into DW */
insert into DimCourse select course_sk, c_name from stage_course;

select * from DimCourse;

/* End dimension COURSE*/

/* DIMENSION dimdate */
/* Merge exam dates accross different Colleges */

DROP TABLE IF EXISTS stage_date CASCADE;
/* create the staging  table - we only need a date as dates are different 
to the other dimensions  */
create table stage_date (
examdate date);


/* insert data into the staging table setting the value for the source db as appropriate */
insert into stage_date (select distinct examdate from (
select examdate from c1_st_courses as c1
union
select examdate from c2_st_courses as c2) as setupdate);

alter table stage_date add date_sk integer;

/* add sequence */
drop sequence if exists date_seq;
create sequence date_seq 
start with 1 
increment by 1 ; 

/* setup the surrogate key */
update stage_date
set date_sk = nextval ('date_seq');
select * from stage_date;

/* LOAD into DW */
insert into DimDate select date_sk, examdate from stage_date;

select * from DimDate;

/* END DIMENSION Date*/