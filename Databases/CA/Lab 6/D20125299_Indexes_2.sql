DROP INDEX if exists dbweek6.in_booking_system_btree;
DROP INDEX if exists dbweek6.in_booking_system_brin;
DROP INDEX if exists dbweek6.idx_user_name_btree;
DROP INDEX if exists dbweek6.in_booking_system_brin;

CREATE EXTENSION pg_trgm;

--Q1a
EXPLAIN ANALYZE
SELECT date_trunc('hour', created_at), avg(count)
FROM dbweek6.booking_system t
WHERE created_at BETWEEN '2021-02-01 0:00' AND '2021-02-28
11:59:59'
GROUP BY 1 ORDER BY 1;

--Planning Time: 0.283 ms
--Execution Time: 26.648 ms

--Q1b
--btree
CREATE INDEX idx_booking_system_btree ON
dbweek6.booking_system(created_at);

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



DROP INDEX if exists dbweek6.in_booking_system_btree;
DROP INDEX if exists dbweek6.in_booking_system_brin;
DROP INDEX if exists dbweek6.idx_user_name_btree;
DROP INDEX if exists dbweek6.in_booking_system_brin;

DROP INDEX if exists dbweek6.idx_usermessages_ginsearch;
DROP INDEX if exists dbweek6.idx_usermessages_btree;
DROP INDEX if exists dbweek6.idx_usermessages_brin;


CREATE EXTENSION pg_trgm;

explain analyze
SELECT * FROM dbweek6.usermessages
where message ilike '%aeb%';

--Planning Time: 0.290 ms
--Execution Time: 386.238 ms

--gin
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
CREATE INDEX idx_usermessages_btree ON
dbweek6.usermessages(message);

explain analyze
SELECT * FROM dbweek6.usermessages
where message ilike '%aeb%';

SELECT pg_size_pretty(pg_relation_size('dbweek6.idx_usermessages_btree'));

--Planning Time: 0.867 ms
--Execution Time: 440.038 ms
--56MB