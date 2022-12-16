/* ETL : EXAMPLE ABOUT HOW TO CREATE DIMENSION STUDENT, DEGREE AND LOAD FACTS */
/* Insert data into the relational database 
Two colleges:
Each has 3 degrees, the same students attend each college (college 1 in semester 1, college 2 in semester 2)

*/

/* Insert some data into College 1 */
INSERT INTO c1_degrees(degree_id, degree_name)
VALUES (1, 'BSc in Computer Science');
INSERT INTO c1_degrees(degree_id, degree_name)
VALUES (2, 'BSc in Computer Science(International)');
INSERT INTO c1_degrees(degree_id, degree_name)
VALUES (3, 'BSc in Computer Science(Infrastructure)');


INSERT INTO c1_courses(course_code, c_name, start_date, end_date)
VALUES (1, 'Advanced Databases', '2021-9-19', '2022-1-20');
INSERT INTO c1_courses(course_code, c_name, start_date, end_date)
VALUES (2, 'Machine Learning', '2021-9-19', '2022-1-20');
INSERT INTO c1_courses(course_code, c_name, start_date, end_date)
VALUES (3, 'Forensics', '2021-9-19', '2022-1-20');

INSERT INTO c1_students(s_id, s_name, s_surname, s_email, modeofstudy, degree_id) 
VALUES (100,'Steven','King','steven.king@sqltutorial.org',0, 1);
INSERT INTO c1_students(s_id, s_name, s_surname, s_email, modeofstudy, degree_id) 
VALUES (101,'Neena','Kochhar','neena.kochhar@sqltutorial.org',1, 1);
INSERT INTO c1_students(s_id, s_name, s_surname, s_email, modeofstudy, degree_id) 
VALUES (102,'Lex','De Haan','lex.de haan@sqltutorial.org',0, 2);
INSERT INTO c1_students(s_id, s_name, s_surname, s_email, modeofstudy, degree_id) 
VALUES (103,'Alexander','Hunold','alexander.hunold@sqltutorial.org',0, 3);

INSERT INTO c1_st_courses(student_id, course_id,marks, examdate)
VALUES (100, 1, 60, '2022-1-16');
INSERT INTO c1_st_courses(student_id, course_id,marks, examdate)
VALUES (100, 2, 65, '2022-1-12');
INSERT INTO c1_st_courses(student_id, course_id,marks, examdate)
VALUES (102, 2, 30, '2022-1-12');
INSERT INTO c1_st_courses(student_id, course_id,marks, examdate)
VALUES (103, 3, 72, '2022-1-13');
INSERT INTO c1_st_courses(student_id, course_id,marks, examdate)
VALUES (103, 1, 72, '2022-1-13');


/* Insert some data into College 2 */
INSERT INTO c2_degrees(degree_id, degree_name)
VALUES (1, 'BSc in Computer Science');
INSERT INTO c2_degrees(degree_id, degree_name)
VALUES (2, 'BSc in Computer Science(International)');
INSERT INTO c2_degrees(degree_id, degree_name)
VALUES (3, 'BSc in Computer Science(Infrastructure)');


INSERT INTO c2_courses(course_code, c_name, start_date, end_date)
VALUES (1, 'Big Data Analytics', '2022-1-20', '2022-6-20');
INSERT INTO c2_courses(course_code, c_name, start_date, end_date)
VALUES (2, 'IT Security', '2022-1-20', '2022-6-20');
INSERT INTO c2_courses(course_code, c_name, start_date, end_date)
VALUES (3, 'Programming Paradigms', '2022-1-20', '2022-6-20');

INSERT INTO c2_students(s_id, s_name, s_surname, s_email, modeofstudy, degree_id) 
VALUES (100,'Steven','King','steven.king@sqltutorial.org','F', 1);
INSERT INTO c2_students(s_id, s_name, s_surname, s_email, modeofstudy, degree_id) 
VALUES (101,'Neena','Kochhar','neena.kochhar@sqltutorial.org','P', 1);
INSERT INTO c2_students(s_id, s_name, s_surname, s_email, modeofstudy, degree_id) 
VALUES (102,'Lex','De Haan','lex.de haan@sqltutorial.org','F', 2);
INSERT INTO c2_students(s_id, s_name, s_surname, s_email, modeofstudy, degree_id) 
VALUES (103,'Alexander','Hunold','alexander.hunold@sqltutorial.org','F', 3);
INSERT INTO c2_students(s_id, s_name, s_surname, s_email, modeofstudy, degree_id) 
VALUES (109,'Daniel','Faviet','daniel.faviet@sqltutorial.org',0, 3);


INSERT INTO c2_st_courses(student_id, course_id,marks, examdate)
VALUES (100, 1, 'A', '2022-6-16');
INSERT INTO c2_st_courses(student_id, course_id,marks, examdate)
VALUES (100, 2, 'B', '2022-6-15');
INSERT INTO c2_st_courses(student_id, course_id,marks, examdate)
VALUES (102, 2, 'F', '2022-6-15');
INSERT INTO c2_st_courses(student_id, course_id,marks, examdate)
VALUES (103, 3, 'E', '2022-6-13');
INSERT INTO c2_st_courses(student_id, course_id,marks, examdate)
VALUES (103, 1, 'D', '2022-6-16');
INSERT INTO c2_st_courses(student_id, course_id,marks, examdate)
VALUES (109, 2, 'A', '2022-1-15');