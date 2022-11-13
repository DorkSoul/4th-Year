--drop index
DROP INDEX if exists dbweek6.in_booking_system_btree;
DROP INDEX if exists dbweek6.in_booking_system_brin;
DROP INDEX if exists dbweek6.idx_user_name_btree;
DROP INDEX if exists dbweek6.in_booking_system_brin;

--extention for gin tree
CREATE EXTENSION pg_trgm;

--Q1
--no index very slow excecution time
EXPLAIN ANALYZE
SELECT date_trunc('hour', created_at), avg(count)
FROM dbweek6.booking_system t
WHERE created_at BETWEEN '2021-02-01 0:00' AND '2021-02-28
11:59:59'
GROUP BY 1 ORDER BY 1;

--Planning Time: 0.283 ms
--Execution Time: 26.648 ms

--btree
--add btree index
CREATE INDEX idx_booking_system_btree ON
dbweek6.booking_system(created_at);

--btree index greatly speeds up execution at the cost of 13MB extra space
EXPLAIN ANALYZE
SELECT date_trunc('hour', created_at), avg(count)
FROM dbweek6.booking_system t
WHERE created_at BETWEEN '2021-02-01 0:00' AND '2021-02-28
11:59:59'
GROUP BY 1 ORDER BY 1;

SELECT pg_size_pretty(pg_relation_size('dbweek6.idx_booking_system_btree'));

--Planning Time: 0.291 ms
--Execution Time: 15.629 ms
--13MB

--brin
--brin index also greatly increases the spped
--much lower cost of space at 24KB
--this method is preferred as the trade off is lower
--brin index are more efficent for numerical data such as dates
CREATE INDEX idx_booking_system_brin ON dbweek6.booking_system
USING brin();

EXPLAIN ANALYZE;
SELECT date_trunc('hour', created_at), avg(count)
FROM dbweek6.booking_system t
WHERE created_at BETWEEN '2021-02-01 0:00' AND '2021-02-28
11:59:59'
GROUP BY 1 ORDER BY 1;

SELECT pg_size_pretty(pg_relation_size('dbweek6.idx_booking_system_brin'));

--Planning Time: 0.449 ms
--Execution Time: 15.817 ms
--24KB


--drop index
DROP INDEX if exists dbweek6.in_booking_system_btree;
DROP INDEX if exists dbweek6.in_booking_system_brin;
DROP INDEX if exists dbweek6.idx_user_name_btree;
DROP INDEX if exists dbweek6.in_booking_system_brin;

DROP INDEX if exists dbweek6.idx_usermessages_ginsearch;
DROP INDEX if exists dbweek6.idx_usermessages_btree;
DROP INDEX if exists dbweek6.idx_usermessages_brin;

--extention for gin tree
CREATE EXTENSION pg_trgm;

--Q2
--no index
--select all messages that include the term "aeb"
explain analyze
SELECT * FROM dbweek6.usermessages
where message ilike '%aeb%';

--Planning Time: 0.290 ms
--Execution Time: 386.238 ms

--gin
--add gin index to message column in usermessages table
-- this speeds up the search greatly
-- gin is very good for text based searches
--down side is that it takes a long time to index a large database
--it also takes up a very large amount of space 115MB in this case
CREATE INDEX idx_usermessages_ginsearch ON dbweek6.usermessages 
USING gin(message gin_trgm_ops);

explain analyze
SELECT * FROM dbweek6.usermessages
where message ilike '%aeb%';

SELECT pg_size_pretty(pg_relation_size('dbweek6.idx_usermessages_ginsearch'));

--Planning Time: 0.178 ms
--Execution Time: 42.596 ms
--115MB

--btree
--add btree index to same column
-- doesnt take as long as gin
--however does not have an appreciable diffrence in  speed
--also takes up space 56MB
-- in this case gin would be the best indexing method
CREATE INDEX idx_usermessages_btree ON
dbweek6.usermessages(message);

explain analyze
SELECT * FROM dbweek6.usermessages
where message ilike '%aeb%';

SELECT pg_size_pretty(pg_relation_size('dbweek6.idx_usermessages_btree'));

--Planning Time: 0.867 ms
--Execution Time: 440.038 ms
--56MB