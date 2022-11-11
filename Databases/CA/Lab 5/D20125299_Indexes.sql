set enable_seqscan = off;

set enable_seqscan = on;

drop index if exists idx_department_name;

--Q1a
EXPLAIN ANALYZE
Select department_name, Count(employee_id) as num_of_employees FROM departments
join employees
on departments.department_id=employees.department_id
group by department_name;

---Q1b
CREATE INDEX idx_department_name
ON departments (department_name);

EXPLAIN ANALYZE
Select department_name, Count(employee_id) as num_of_employees FROM departments
join employees
on departments.department_id=employees.department_id
group by department_name;


set enable_seqscan = off;

set enable_seqscan = on;

drop index if exists idx_city;

--Q2a
EXPLAIN ANALYZE
Select city, Count(department_id) as num_of_departments FROM locations
join departments
on locations.location_id=departments.location_id
group by city;

--Q2b
CREATE INDEX idx_city
ON locations (city);

EXPLAIN ANALYZE
Select city, Count(department_id) as num_of_departments FROM locations
join departments
on locations.location_id=departments.location_id
group by city;

set enable_seqscan = off;
set enable_seqscan = on;

drop index if exists idx_department_name;
drop index if exists idx_city;
drop index if exists idx_job_title;
drop index if exists idx_employees;

--Q3a
explain analyse
select employees.employee_id, employees.first_name, employees.last_name, employees.email, employees.phone_number, employees.salary, employees.hire_date,
        job_title, managers.employee_id, department_name
from employees as employees
join jobs
on employees.job_id=jobs.job_id
join departments
on employees.department_id=departments.department_id
join employees as managers
on managers.employee_id=employees.manager_id
order by job_title;

--Q3b-1
CREATE INDEX idx_job_title
ON jobs (job_title);

explain analyse
select employees.employee_id, employees.first_name, employees.last_name, employees.email, employees.phone_number, employees.salary, employees.hire_date,
        job_title, managers.employee_id, department_name
from employees as employees
join jobs
on employees.job_id=jobs.job_id
join departments
on employees.department_id=departments.department_id
join employees as managers
on managers.employee_id=employees.manager_id
order by job_title;

--Q3b-2
CREATE INDEX idx_department_name
ON departments (department_name);

explain analyse
select employees.employee_id, employees.first_name, employees.last_name, employees.email, employees.phone_number, employees.salary, employees.hire_date,
        job_title, managers.employee_id, department_name
from employees as employees
join jobs
on employees.job_id=jobs.job_id
join departments
on employees.department_id=departments.department_id
join employees as managers
on managers.employee_id=employees.manager_id
order by job_title;

--Q3b-3
CREATE INDEX idx_employees
ON employees (employee_id, first_name, last_name, email, phone_number, salary, hire_date);

explain analyse
select employees.employee_id, employees.first_name, employees.last_name, employees.email, employees.phone_number, employees.salary, employees.hire_date,
        job_title, managers.employee_id, department_name
from employees as employees
join jobs
on employees.job_id=jobs.job_id
join departments
on employees.department_id=departments.department_id
join employees as managers
on managers.employee_id=employees.manager_id
order by job_title;


