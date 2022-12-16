

/*Find number of passes achieved for each course */
select count(factmarks.pass) as "Number of Passes", dimcourse.c_name
from factmarks
join dimcourse on
    factmarks.course_sk = dimcourse.course_sk
where factmarks.pass ='Pass'
group by dimcourse.c_name
order by c_name;

/*Find number of passes achieved for each student */
select count(factmarks.pass) as "Number of Passes", dimstudent.s_name, dimstudent.s_surname
from factmarks
join dimstudent on
    factmarks.course_sk = dimstudent.student_sk
where factmarks.pass ='Pass'
group by dimstudent.s_name, dimstudent.s_surname
order by dimstudent.s_surname;

