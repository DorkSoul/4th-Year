--Q1
ALTER TABLE departments 
ADD num_of_employees Integer;

Update departments Set num_of_employees=
    (Select Count(department_id) FROM employees Where departments.department_id=employees.department_id );

Select department_name,num_of_employees from departments where num_of_employees > 5;

--alter the departments table to add num_of_employees which will be used to store the numbe of employees per department
--update this value from the fub query used to cound the occurances of each department id
-- get all departsments with more then 5 people


--Q2
ALTER TABLE employees
ADD location_id INTEGER;

Update employees 
Set location_id=departments.location_id
from departments
where employees.department_id = departments.department_id;

ALTER TABLE employees
ADD FOREIGN KEY (location_id) REFERENCES locations (location_id);

select department_id, location_id from employees where location_id = 1700;

--alter the table to add teh empty column
--update the table to fill this column using set where the two department ids match to match locations
--alter the table to make this value a forign key
--test by getting all employees at location 1700


--Q3
DROP VIEW IF EXISTS social_activities;

CREATE VIEW social_activities AS
SELECT dependents.dependent_id, dependents.first_name as "child first name", dependents.last_name as "child last name", 
        employees.employee_id, employees.first_name as "parent first name", employees.last_name as "parent last name"
FROM dependents
join employees
on dependents.employee_id = employees.employee_id;

select * from social_activities where social_activities.dependent_id < 5;

--drop view if it alread exists
--create a view called social_activities with the id and names of both adult and child andming them obviously
--select all with id less then 5 to test


--Q4
--drop tables
DROP VIEW IF EXISTS curr_job;
DROP VIEW IF EXISTS prev_job;

--create a view for current job of each employee id
--get the needed data joining the tables and join employees on the manager id to get the employees manager
CREATE VIEW curr_job AS
SELECT employees.employee_id, employees.first_name, employees.last_name, employees.salary, job_title, 
        department_name, employees.hire_date,
        managers.first_name as manager_first_name, managers.last_name as manager_last_name
FROM employees as employees
join jobs
on employees.job_id = jobs.job_id
join departments
on employees.department_id = departments.department_id
join employees as managers
on managers.employee_id=employees.manager_id;

--likewise create a view for previous job
--kept seperate as the employee may not have a previous job or may not be needed so no need to search it
--add the data needed by joining tables
--in the case an employee id has multiple previous jobs select the max end dat to get their most recent job
--add this end date to the select statment
CREATE VIEW prev_job AS
select jobhist.employee_id, salary, job_title, enddate, department_name
from jobhist
join jobs 
on jobhist.job_id=jobs.job_id
join departments
on jobhist.department_id=departments.department_id
join (select max(enddate) as max_end_date, employees.employee_id
      from jobhist
      join employees on employees.employee_id=jobhist.employee_id
    group by employees.employee_id) as sd
on sd.employee_id=jobhist.employee_id
where sd.max_end_date=jobhist.enddate;

--select everything from both views
select * 
from curr_job
join prev_job
on curr_job.employee_id=prev_job.employee_id;

--select all columns with an employee number between 200 and 300
--and alias some to make it easier to understand
--includes left join to display all emloyees that fit the criteria even if they dont have a previous job listed
select curr_job.employee_id, curr_job.first_name, curr_job.last_name, curr_job.salary, curr_job.job_title, 
        curr_job.department_name, curr_job.hire_date, curr_job.manager_first_name, curr_job.manager_last_name,
        prev_job.salary as prev_job_salary, prev_job.job_title as prev_job_job_title, 
        prev_job.enddate as prev_job_end_date, prev_job.department_name as prev_job_department_name
from curr_job
left join prev_job
on curr_job.employee_id=prev_job.employee_id
where curr_job.employee_id BETWEEN 200 AND 300;
