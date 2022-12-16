/* Relational db for two Golf DBs - for ETL task */
drop table if exists results1;
drop table if exists results2;
drop table if exists players1;
drop table if exists players2;
drop table if exists tournament1;
drop table if exists tournament2;


/* Golf DB 1 */
Create Table Players1(
p_id integer primary key,
p_name varchar(50),
p_sname varchar(50)
);

Create Table Tournament1(
T_id integer primary key,
t_descriprion varchar(100),
t_date date,
Total_prize float
);

Create Table Results1(
t_id integer,
p_id integer,
rank integer,
prize float,
CONSTRAINT  FK_player1 FOREIGN KEY (p_id) REFERENCES players1,
CONSTRAINT  FK_tournament1 FOREIGN KEY (t_id) REFERENCES tournament1,
CONSTRAINT PK_Results1 PRIMARY KEY (t_id,p_id)
);
/* Golf DB 2*/

Create Table Players2(
p_id integer primary key,
p_name varchar(50),
p_sname varchar(50)
);

Create Table Tournament2(
T_id integer primary key,
t_descriprion varchar(100),
t_date date,
Total_prize float
);

Create Table Results2(
t_id integer,
p_id integer,
rank integer,
prize float,
CONSTRAINT  FK_player2 FOREIGN KEY (p_id) REFERENCES players2,
CONSTRAINT  FK_tournament2 FOREIGN KEY (t_id) REFERENCES tournament2,
CONSTRAINT PK_Results2 PRIMARY KEY (t_id,p_id)
);

/* END ER DIAGRAM */


/* data */

INSERT INTO PLAYERS1 (P_ID, P_NAME, P_SNAME) VALUES (1, 'Tiger', 'Woods');
INSERT INTO PLAYERS1 (P_ID, P_NAME, P_SNAME) VALUES (2, 'Jane', 'Smith');
INSERT INTO PLAYERS1 (P_ID, P_NAME, P_SNAME) VALUES (3, 'Mike', 'Deegan');
INSERT INTO PLAYERS1 (P_ID, P_NAME, P_SNAME) VALUES (4, 'James', 'Bryan');
INSERT INTO PLAYERS1 (P_ID, P_NAME, P_SNAME) VALUES (5, 'John', 'McDonald');
INSERT INTO PLAYERS1 (P_ID, P_NAME, P_SNAME) VALUES (6, 'Mario', 'Baggio');

INSERT INTO PLAYERS2 (P_ID, P_NAME, P_SNAME) VALUES (2, 'Tiger', 'Woods');
INSERT INTO PLAYERS2 (P_ID, P_NAME, P_SNAME) VALUES (1, 'John', 'McDonald');
INSERT INTO PLAYERS2 (P_ID, P_NAME, P_SNAME) VALUES (3, 'Jim', 'Burke');
INSERT INTO PLAYERS2 (P_ID, P_NAME, P_SNAME) VALUES (4, 'Paul', 'Bin');
INSERT INTO PLAYERS2 (P_ID, P_NAME, P_SNAME) VALUES (5, 'Peter', 'Flynn');
INSERT INTO PLAYERS2 (P_ID, P_NAME, P_SNAME) VALUES (6, 'Martha', 'Ross');


INSERT INTO TOURNAMENT1 (T_ID, T_DESCRIPRION, TOTAL_prize,t_date) VALUES (1, 'US open', 1700000,'01-jan-2014');
INSERT INTO TOURNAMENT1 (T_ID, T_DESCRIPRION, TOTAL_prize,t_date) VALUES (2, 'British Open', 7000000,'01-apr-2014');
INSERT INTO TOURNAMENT1 (T_ID, T_DESCRIPRION, TOTAL_prize,t_date) VALUES (3, 'Italian Open', 2000000,'11-mar-2014');
INSERT INTO TOURNAMENT1 (T_ID, T_DESCRIPRION, TOTAL_prize,t_date) VALUES (4, 'Irish Open', 300000,'21-jul-2014');

INSERT INTO TOURNAMENT2 (T_ID, T_DESCRIPRION, TOTAL_prize,t_date) VALUES (1, 'Dutch open', 1700000,'22-nov-2014');
INSERT INTO TOURNAMENT2 (T_ID, T_DESCRIPRION, TOTAL_prize,t_date) VALUES (2, 'French Open', 7000000,'17-dec-2014');
INSERT INTO TOURNAMENT2 (T_ID, T_DESCRIPRION, TOTAL_prize,t_date) VALUES (3, 'Spanish Open', 2000000,'03-mar-2014');
INSERT INTO TOURNAMENT2 (T_ID, T_DESCRIPRION, TOTAL_prize,t_date) VALUES (4, 'Chiinese Open', 300000,'15-jul-2014');
INSERT INTO TOURNAMENT2 (T_ID, T_DESCRIPRION, TOTAL_prize,t_date) VALUES (5, 'Dubai Open', 600000,'10-aug-2014');
INSERT INTO TOURNAMENT2 (T_ID, T_DESCRIPRION, TOTAL_prize,t_date) VALUES (6, 'US Master', 1000000,'10-jul-2014');


INSERT INTO RESULTS1 (T_ID, P_ID, RANK, prize) VALUES (1, 1, 1, 10000);
INSERT INTO RESULTS1 (T_ID, P_ID, RANK, prize) VALUES (1, 2, 2, 20000);
INSERT INTO RESULTS1 (T_ID, P_ID, RANK, prize) VALUES (2, 2, 4, 1000);
INSERT INTO RESULTS1 (T_ID, P_ID, RANK, prize) VALUES (3, 2, 3, 10000);
INSERT INTO RESULTS1 (T_ID, P_ID, RANK, prize) VALUES (3, 1, 2, 1100);
INSERT INTO RESULTS1 (T_ID, P_ID, RANK, prize) VALUES (4, 6, 3, 6000);
INSERT INTO RESULTS1 (T_ID, P_ID, RANK, prize) VALUES (4, 2, 2, 9000);
INSERT INTO RESULTS1 (T_ID, P_ID, RANK, prize) VALUES (4, 1, 1, 10000);
INSERT INTO RESULTS1 (T_ID, P_ID, RANK, prize) VALUES (3, 5, 2, 9500);
INSERT INTO RESULTS1 (T_ID, P_ID, RANK, prize) VALUES (4, 5, 4, 10000);
INSERT INTO RESULTS1 (T_ID, P_ID, RANK, prize) VALUES (2, 5, 7, 100);

INSERT INTO RESULTS2 (T_ID, P_ID, RANK, prize) VALUES (1, 1, 1, 1000);
INSERT INTO RESULTS2 (T_ID, P_ID, RANK, prize) VALUES (1, 2, 3, 2000);
INSERT INTO RESULTS2 (T_ID, P_ID, RANK, prize) VALUES (2, 2, 1, 6000);
INSERT INTO RESULTS2 (T_ID, P_ID, RANK, prize) VALUES (3, 2, 3, 17000);
INSERT INTO RESULTS2 (T_ID, P_ID, RANK, prize) VALUES (3, 1, 12, 1100);
INSERT INTO RESULTS2 (T_ID, P_ID, RANK, prize) VALUES (4, 6, 10, 8000);
INSERT INTO RESULTS2 (T_ID, P_ID, RANK, prize) VALUES (4, 2, 2, 12000);
INSERT INTO RESULTS2 (T_ID, P_ID, RANK, prize) VALUES (4, 1, 3, 10000);
INSERT INTO RESULTS2 (T_ID, P_ID, RANK, prize) VALUES (3, 5, 1, 9000);
INSERT INTO RESULTS2 (T_ID, P_ID, RANK, prize) VALUES (4, 5, 5, 1000);
INSERT INTO RESULTS2 (T_ID, P_ID, RANK, prize) VALUES (2, 5, 3, 1000);
INSERT INTO RESULTS2 (T_ID, P_ID, RANK, prize) VALUES (5, 5, 3, 8000);
INSERT INTO RESULTS2 (T_ID, P_ID, RANK, prize) VALUES (5, 2, 2, 16000);
INSERT INTO RESULTS2 (T_ID, P_ID, RANK, prize) VALUES (5, 1, 1, 20000);
INSERT INTO RESULTS2 (T_ID, P_ID, RANK, prize) VALUES (6, 1, 3, 2000);
INSERT INTO RESULTS2 (T_ID, P_ID, RANK, prize) VALUES (6, 5, 2, 9400);
INSERT INTO RESULTS2 (T_ID, P_ID, RANK, prize) VALUES (6, 4, 1, 12000);