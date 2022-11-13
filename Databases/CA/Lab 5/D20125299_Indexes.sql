--just in case it needs to be turned on or off
set enable_seqscan = off;
set enable_seqscan = on;

--drop index
drop index if exists idx_department_name;

--Q1a
--select department name and count employees in each
--alias to make it easier to read
--no index to get normal time
--uses nested loop to join
EXPLAIN ANALYZE
Select department_name, Count(employee_id) as num_of_employees FROM departments
join employees
on departments.department_id=employees.department_id
group by department_name;
-- Planning Time: 0.121 ms
-- Execution Time: 0.738 ms

-- HashAggregate  (cost=36.14..37.84 rows=170 width=86) (actual time=0.694..0.713 rows=11 loops=1)
--   Group Key: departments.department_name
--   Batches: 1  Memory Usage: 40kB
--   ->  Hash Join  (cost=13.82..35.29 rows=170 width=82) (actual time=0.352..0.492 rows=741 loops=1)
--         Hash Cond: (departments.department_id = employees.department_id)
--         ->  Seq Scan on departments  (cost=0.00..17.10 rows=710 width=82) (actual time=0.004..0.005 rows=11 loops=1)
--         ->  Hash  (cost=11.70..11.70 rows=170 width=8) (actual time=0.342..0.343 rows=741 loops=1)
--               Buckets: 1024  Batches: 1  Memory Usage: 37kB
--               ->  Seq Scan on employees  (cost=0.00..11.70 rows=170 width=8) (actual time=0.006..0.153 rows=741 loops=1)
-- Planning Time: 0.121 ms

---Q1b
--add index to try increase speed
CREATE INDEX idx_department_name
ON departments (department_name);

--same as above but using the index
--statment is faster now
--uses hash index instead of nested loop to join table increasing speed
EXPLAIN ANALYZE
Select department_name, Count(employee_id) as num_of_employees FROM departments
join employees
on departments.department_id=employees.department_id
group by department_name;
-- Planning Time: 0.090 ms
-- Execution Time: 0.649 ms

-- HashAggregate  (cost=25.05..25.16 rows=11 width=86) (actual time=0.607..0.609 rows=11 loops=1)
--   Group Key: departments.department_name
--   Batches: 1  Memory Usage: 24kB
--   ->  Hash Join  (cost=1.25..21.35 rows=741 width=82) (actual time=0.045..0.331 rows=741 loops=1)
--         Hash Cond: (employees.department_id = departments.department_id)
--         ->  Seq Scan on employees  (cost=0.00..17.41 rows=741 width=8) (actual time=0.007..0.076 rows=741 loops=1)
--         ->  Hash  (cost=1.11..1.11 rows=11 width=82) (actual time=0.031..0.031 rows=11 loops=1)
--               Buckets: 1024  Batches: 1  Memory Usage: 9kB
--               ->  Seq Scan on departments  (cost=0.00..1.11 rows=11 width=82) (actual time=0.019..0.021 rows=11 loops=1)
-- Planning Time: 0.090 ms


--just in case it needs to be turned on or off
set enable_seqscan = off;
set enable_seqscan = on;

--drop index
drop index if exists idx_city;

--Q2a
--select city and count departments in each
--alias to make it easier to read
--no index to get base speed
EXPLAIN ANALYZE
Select city, Count(department_id) as num_of_departments FROM locations
join departments
on locations.location_id=departments.location_id
group by city;
-- Planning Time: 0.493 ms
-- Execution Time: 0.092 ms

-- HashAggregate  (cost=14.71..14.82 rows=11 width=86) (actual time=0.032..0.034 rows=7 loops=1)
--   Group Key: locations.city
--   Batches: 1  Memory Usage: 24kB
--   ->  Hash Join  (cost=1.25..14.66 rows=11 width=82) (actual time=0.021..0.026 rows=11 loops=1)
--         Hash Cond: (locations.location_id = departments.location_id)
--         ->  Seq Scan on locations  (cost=0.00..12.40 rows=240 width=82) (actual time=0.003..0.004 rows=7 loops=1)
--         ->  Hash  (cost=1.11..1.11 rows=11 width=8) (actual time=0.009..0.009 rows=11 loops=1)
--               Buckets: 1024  Batches: 1  Memory Usage: 9kB
--               ->  Seq Scan on departments  (cost=0.00..1.11 rows=11 width=8) (actual time=0.004..0.005 rows=11 loops=1)
-- Planning Time: 0.493 ms

--Q2b
--add index to speed up statment
CREATE INDEX idx_city
ON locations (city);

--same as abouve but using index
-- index speeds up the statment
--not a huge increase as most rows only have 1 in them
EXPLAIN ANALYZE
Select city, Count(department_id) as num_of_departments FROM locations
join departments
on locations.location_id=departments.location_id
group by city;
-- Planning Time: 0.089 ms
-- Execution Time: 0.052 ms

-- HashAggregate  (cost=2.36..2.43 rows=7 width=86) (actual time=0.028..0.030 rows=7 loops=1)
--   Group Key: locations.city
--   Batches: 1  Memory Usage: 24kB
--   ->  Hash Join  (cost=1.16..2.31 rows=11 width=82) (actual time=0.018..0.022 rows=11 loops=1)
--         Hash Cond: (departments.location_id = locations.location_id)
--         ->  Seq Scan on departments  (cost=0.00..1.11 rows=11 width=8) (actual time=0.005..0.006 rows=11 loops=1)
--         ->  Hash  (cost=1.07..1.07 rows=7 width=82) (actual time=0.007..0.008 rows=7 loops=1)
--               Buckets: 1024  Batches: 1  Memory Usage: 9kB
--               ->  Seq Scan on locations  (cost=0.00..1.07 rows=7 width=82) (actual time=0.004..0.005 rows=7 loops=1)
-- Planning Time: 0.089 ms


--just in case it needs to be turned on or off
set enable_seqscan = off;
set enable_seqscan = on;

--drop index
drop index if exists idx_department_name;
drop index if exists idx_city;
drop index if exists idx_job_title;
drop index if exists idx_employees;

--Q3a
--no index
--select needed data and join tables much like last lab Q4
--order outbut by job title
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
-- Planning Time: 0.608 ms
-- Execution Time: 1.786 ms

-- Sort  (cost=104.20..106.05 rows=741 width=230) (actual time=1.638..1.672 rows=740 loops=1)
--   Sort Key: jobs.job_title
--   Sort Method: quicksort  Memory: 133kB
--   ->  Nested Loop  (cost=1.69..68.88 rows=741 width=230) (actual time=0.046..1.103 rows=740 loops=1)
--         ->  Hash Join  (cost=1.41..44.49 rows=741 width=230) (actual time=0.032..0.727 rows=741 loops=1)
--               Hash Cond: (employees.department_id = departments.department_id)
--               ->  Nested Loop  (cost=0.16..40.55 rows=741 width=156) (actual time=0.014..0.502 rows=741 loops=1)
--                     ->  Seq Scan on employees  (cost=0.00..17.41 rows=741 width=72) (actual time=0.004..0.082 rows=741 loops=1)
--                     ->  Memoize  (cost=0.16..0.24 rows=1 width=92) (actual time=0.000..0.000 rows=1 loops=741)
--                           Cache Key: employees.job_id

--Q3b-1
--add index to job title
CREATE INDEX idx_job_title
ON jobs (job_title);

--reduces executoon time slightly
-- changes from a nested loop to a hash join using the index
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
-- Planning Time: 0.716 ms
-- Execution Time: 1.603 ms

-- Sort  (cost=84.86..86.71 rows=741 width=230) (actual time=1.468..1.503 rows=740 loops=1)
--   Sort Key: jobs.job_title
--   Sort Method: quicksort  Memory: 133kB
--   ->  Nested Loop  (cost=2.96..49.54 rows=741 width=230) (actual time=0.060..1.014 rows=740 loops=1)
--         ->  Hash Join  (cost=2.68..25.15 rows=741 width=230) (actual time=0.045..0.588 rows=741 loops=1)
--               Hash Cond: (employees.department_id = departments.department_id)
--               ->  Hash Join  (cost=1.43..21.22 rows=741 width=156) (actual time=0.021..0.350 rows=741 loops=1)
--                     Hash Cond: (employees.job_id = jobs.job_id)
--                     ->  Seq Scan on employees  (cost=0.00..17.41 rows=741 width=72) (actual time=0.002..0.072 rows=741 loops=1)
--                     ->  Hash  (cost=1.19..1.19 rows=19 width=92) (actual time=0.009..0.009 rows=19 loops=1)

--Q3b-2
--create index on department name
CREATE INDEX idx_department_name
ON departments (department_name);

-- no apreciable diffrence as has join already used using the indexed primary key
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
-- Planning Time: 0.875 ms
-- Execution Time: 1.682 ms

-- Sort  (cost=84.86..86.71 rows=741 width=230) (actual time=1.537..1.575 rows=740 loops=1)
--   Sort Key: jobs.job_title
--   Sort Method: quicksort  Memory: 133kB
--   ->  Nested Loop  (cost=2.96..49.54 rows=741 width=230) (actual time=0.096..1.054 rows=740 loops=1)
--         ->  Hash Join  (cost=2.68..25.15 rows=741 width=230) (actual time=0.045..0.625 rows=741 loops=1)
--               Hash Cond: (employees.department_id = departments.department_id)
--               ->  Hash Join  (cost=1.43..21.22 rows=741 width=156) (actual time=0.021..0.394 rows=741 loops=1)
--                     Hash Cond: (employees.job_id = jobs.job_id)
--                     ->  Seq Scan on employees  (cost=0.00..17.41 rows=741 width=72) (actual time=0.002..0.087 rows=741 loops=1)
--                     ->  Hash  (cost=1.19..1.19 rows=19 width=92) (actual time=0.009..0.009 rows=19 loops=1)

--Q3b-3
--create index to the commonly requestion rows
CREATE INDEX idx_employees
ON employees (employee_id, first_name, last_name, email, phone_number, salary, hire_date);

--bas use of indexes
--sh=lows down execution slightly with un-needed / unsuded index as table must be re joined to get the manager information
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
-- Planning Time: 0.838 ms
-- Execution Time: 2.012 ms

-- Sort  (cost=84.86..86.71 rows=741 width=230) (actual time=1.856..1.889 rows=740 loops=1)
--   Sort Key: jobs.job_title
--   Sort Method: quicksort  Memory: 133kB
--   ->  Nested Loop  (cost=2.96..49.54 rows=741 width=230) (actual time=0.063..1.331 rows=740 loops=1)
--         ->  Hash Join  (cost=2.68..25.15 rows=741 width=230) (actual time=0.045..0.779 rows=741 loops=1)
--               Hash Cond: (employees.department_id = departments.department_id)
--               ->  Hash Join  (cost=1.43..21.22 rows=741 width=156) (actual time=0.024..0.536 rows=741 loops=1)
--                     Hash Cond: (employees.job_id = jobs.job_id)
--                     ->  Seq Scan on employees  (cost=0.00..17.41 rows=741 width=72) (actual time=0.003..0.106 rows=741 loops=1)
--                     ->  Hash  (cost=1.19..1.19 rows=19 width=92) (actual time=0.008..0.008 rows=19 loops=1)