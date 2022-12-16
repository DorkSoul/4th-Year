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
t_description varchar(100),
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
t_description varchar(100),
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


INSERT INTO TOURNAMENT1 (T_ID, t_description, TOTAL_prize,t_date) VALUES (1, 'US open', 1700000,'01-jan-2014');
INSERT INTO TOURNAMENT1 (T_ID, t_description, TOTAL_prize,t_date) VALUES (2, 'British Open', 7000000,'01-apr-2014');
INSERT INTO TOURNAMENT1 (T_ID, t_description, TOTAL_prize,t_date) VALUES (3, 'Italian Open', 2000000,'11-mar-2014');
INSERT INTO TOURNAMENT1 (T_ID, t_description, TOTAL_prize,t_date) VALUES (4, 'Irish Open', 300000,'21-jul-2014');

INSERT INTO TOURNAMENT2 (T_ID, t_description, TOTAL_prize,t_date) VALUES (1, 'Dutch open', 1700000,'22-nov-2014');
INSERT INTO TOURNAMENT2 (T_ID, t_description, TOTAL_prize,t_date) VALUES (2, 'French Open', 7000000,'17-dec-2014');
INSERT INTO TOURNAMENT2 (T_ID, t_description, TOTAL_prize,t_date) VALUES (3, 'Spanish Open', 2000000,'03-mar-2014');
INSERT INTO TOURNAMENT2 (T_ID, t_description, TOTAL_prize,t_date) VALUES (4, 'Chiinese Open', 300000,'15-jul-2014');
INSERT INTO TOURNAMENT2 (T_ID, t_description, TOTAL_prize,t_date) VALUES (5, 'Dubai Open', 600000,'10-aug-2014');
INSERT INTO TOURNAMENT2 (T_ID, t_description, TOTAL_prize,t_date) VALUES (6, 'US Master', 1000000,'10-jul-2014');


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


/* Golf Dimensions */



drop table if exists dimdate CASCADE;
drop table if exists dimplayer CASCADE;
drop table if exists dimtournament CASCADE;
drop table if exists FactResults CASCADE;


create table dimdate
(
    date_sk   integer not null
        primary key,
    day       integer,
    month     integer,
    week      integer,
    dayofweek integer,
    quarter   integer,
    year      integer
);



INSERT INTO dimdate (date_sk, day, month, week, dayofweek, quarter, year) VALUES (1, 1, 1, 1, 3, 1, 2014);
INSERT INTO dimdate (date_sk, day, month, week, dayofweek, quarter, year) VALUES (2, 1, 4, 14, 2, 2, 2014);
INSERT INTO dimdate (date_sk, day, month, week, dayofweek, quarter, year) VALUES (3, 11, 3, 11, 2, 1, 2014);
INSERT INTO dimdate (date_sk, day, month, week, dayofweek, quarter, year) VALUES (4, 21, 7, 30, 1, 3, 2014);
INSERT INTO dimdate (date_sk, day, month, week, dayofweek, quarter, year) VALUES (5, 22, 11, 47, 6, 4, 2014);
INSERT INTO dimdate (date_sk, day, month, week, dayofweek, quarter, year) VALUES (6, 17, 12, 51, 3, 4, 2014);
INSERT INTO dimdate (date_sk, day, month, week, dayofweek, quarter, year) VALUES (7, 3, 3, 10, 1, 1, 2014);
INSERT INTO dimdate (date_sk, day, month, week, dayofweek, quarter, year) VALUES (8, 15, 7, 29, 2, 3, 2014);
INSERT INTO dimdate (date_sk, day, month, week, dayofweek, quarter, year) VALUES (9, 10, 8, 32, 0, 3, 2014);
INSERT INTO dimdate (date_sk, day, month, week, dayofweek, quarter, year) VALUES (10, 10, 7, 28, 4, 3, 2014);

create table dimtournament
(
    tournament_sk integer not null
        primary key,
    t_descriprion varchar(100),
    t_date        date,
    total_prize   double precision
);


INSERT INTO dimtournament (tournament_sk, t_descriprion, t_date, total_prize) VALUES (1, 'Irish Open', '2014-07-21', 300000);
INSERT INTO dimtournament (tournament_sk, t_descriprion, t_date, total_prize) VALUES (2, 'Italian Open', '2014-03-11', 2000000);
INSERT INTO dimtournament (tournament_sk, t_descriprion, t_date, total_prize) VALUES (3, 'British Open', '2014-04-01', 7000000);
INSERT INTO dimtournament (tournament_sk, t_descriprion, t_date, total_prize) VALUES (4, 'US open', '2014-01-01', 1700000);
INSERT INTO dimtournament (tournament_sk, t_descriprion, t_date, total_prize) VALUES (5, 'Dutch open', '2014-11-22', 2210000);
INSERT INTO dimtournament (tournament_sk, t_descriprion, t_date, total_prize) VALUES (6, 'Dubai Open', '2014-08-10', 780000);
INSERT INTO dimtournament (tournament_sk, t_descriprion, t_date, total_prize) VALUES (7, 'Chiinese Open', '2014-07-15', 390000);
INSERT INTO dimtournament (tournament_sk, t_descriprion, t_date, total_prize) VALUES (8, 'Spanish Open', '2014-03-03', 2600000);
INSERT INTO dimtournament (tournament_sk, t_descriprion, t_date, total_prize) VALUES (9, 'French Open', '2014-12-17', 9100000);
INSERT INTO dimtournament (tournament_sk, t_descriprion, t_date, total_prize) VALUES (10, 'US Master', '2014-07-10', 1300000);



create table dimplayer
(
    player_sk integer not null
        primary key,
    p_name    varchar(50),
    p_sname   varchar(50)
);



INSERT INTO dimplayer (player_sk, p_name, p_sname) VALUES (1, 'Tiger', 'Woods');
INSERT INTO dimplayer (player_sk, p_name, p_sname) VALUES (2, 'Jane', 'Smith');
INSERT INTO dimplayer (player_sk, p_name, p_sname) VALUES (3, 'Mike', 'Deegan');
INSERT INTO dimplayer (player_sk, p_name, p_sname) VALUES (4, 'James', 'Bryan');
INSERT INTO dimplayer (player_sk, p_name, p_sname) VALUES (5, 'John', 'McDonald');
INSERT INTO dimplayer (player_sk, p_name, p_sname) VALUES (6, 'Mario', 'Baggio');
INSERT INTO dimplayer (player_sk, p_name, p_sname) VALUES (7, 'Jim', 'Burke');
INSERT INTO dimplayer (player_sk, p_name, p_sname) VALUES (8, 'Paul', 'Bin');
INSERT INTO dimplayer (player_sk, p_name, p_sname) VALUES (9, 'Peter', 'Flynn');
INSERT INTO dimplayer (player_sk, p_name, p_sname) VALUES (10, 'Martha', 'Ross');




Create Table FactResults(
player_sk integer,
tournament_sk integer,
date_sk integer,
rank integer,
prize float,
CONSTRAINT  FK_player_sk FOREIGN KEY (player_sk) REFERENCES DimPlayer,
CONSTRAINT  FK_tournament_sk FOREIGN KEY (tournament_sk) REFERENCES DimTournament,
CONSTRAINT FK_date_sk FOREIGN KEY (date_sk) REFERENCES DimDate,
CONSTRAINT PK_DimResults PRIMARY KEY (player_sk,tournament_sk, date_sk)
);






/* Golf Staging */


drop table if exists stage_date;
drop table if exists stage_player;
drop table if exists stage_tournament;

create table stage_date
(
    t_date  date not null
        primary key,
    date_sk integer
);


INSERT INTO stage_date (t_date, date_sk) VALUES ('2014-01-01', 1);
INSERT INTO stage_date (t_date, date_sk) VALUES ('2014-04-01', 2);
INSERT INTO stage_date (t_date, date_sk) VALUES ('2014-03-11', 3);
INSERT INTO stage_date (t_date, date_sk) VALUES ('2014-07-21', 4);
INSERT INTO stage_date (t_date, date_sk) VALUES ('2014-11-22', 5);
INSERT INTO stage_date (t_date, date_sk) VALUES ('2014-12-17', 6);
INSERT INTO stage_date (t_date, date_sk) VALUES ('2014-03-03', 7);
INSERT INTO stage_date (t_date, date_sk) VALUES ('2014-07-15', 8);
INSERT INTO stage_date (t_date, date_sk) VALUES ('2014-08-10', 9);
INSERT INTO stage_date (t_date, date_sk) VALUES ('2014-07-10', 10);

create table stage_tournament
(
    t_id          integer,
    t_descriprion varchar(100),
    t_date        date,
    total_prize   double precision,
    sourcedb      integer,
    tournament_sk integer
);


INSERT INTO stage_tournament (t_id, t_descriprion, t_date, total_prize, sourcedb, tournament_sk) VALUES (4, 'Irish Open', '2014-07-21', 300000, 1, 1);
INSERT INTO stage_tournament (t_id, t_descriprion, t_date, total_prize, sourcedb, tournament_sk) VALUES (3, 'Italian Open', '2014-03-11', 2000000, 1, 2);
INSERT INTO stage_tournament (t_id, t_descriprion, t_date, total_prize, sourcedb, tournament_sk) VALUES (2, 'British Open', '2014-04-01', 7000000, 1, 3);
INSERT INTO stage_tournament (t_id, t_descriprion, t_date, total_prize, sourcedb, tournament_sk) VALUES (1, 'US open', '2014-01-01', 1700000, 1, 4);
INSERT INTO stage_tournament (t_id, t_descriprion, t_date, total_prize, sourcedb, tournament_sk) VALUES (1, 'Dutch open', '2014-11-22', 2210000, 2, 5);
INSERT INTO stage_tournament (t_id, t_descriprion, t_date, total_prize, sourcedb, tournament_sk) VALUES (5, 'Dubai Open', '2014-08-10', 780000, 2, 6);
INSERT INTO stage_tournament (t_id, t_descriprion, t_date, total_prize, sourcedb, tournament_sk) VALUES (4, 'Chiinese Open', '2014-07-15', 390000, 2, 7);
INSERT INTO stage_tournament (t_id, t_descriprion, t_date, total_prize, sourcedb, tournament_sk) VALUES (3, 'Spanish Open', '2014-03-03', 2600000, 2, 8);
INSERT INTO stage_tournament (t_id, t_descriprion, t_date, total_prize, sourcedb, tournament_sk) VALUES (2, 'French Open', '2014-12-17', 9100000, 2, 9);
INSERT INTO stage_tournament (t_id, t_descriprion, t_date, total_prize, sourcedb, tournament_sk) VALUES (6, 'US Master', '2014-07-10', 1300000, 2, 10);


create table stage_player
(
    p_id      integer,
    p_name    varchar(50),
    p_sname   varchar(50),
    sourcedb  integer,
    player_sk integer
);


INSERT INTO stage_player (p_id, p_name, p_sname, sourcedb, player_sk) VALUES (1, 'Tiger', 'Woods', 1, 1);
INSERT INTO stage_player (p_id, p_name, p_sname, sourcedb, player_sk) VALUES (2, 'Jane', 'Smith', 1, 2);
INSERT INTO stage_player (p_id, p_name, p_sname, sourcedb, player_sk) VALUES (3, 'Mike', 'Deegan', 1, 3);
INSERT INTO stage_player (p_id, p_name, p_sname, sourcedb, player_sk) VALUES (4, 'James', 'Bryan', 1, 4);
INSERT INTO stage_player (p_id, p_name, p_sname, sourcedb, player_sk) VALUES (5, 'John', 'McDonald', 1, 5);
INSERT INTO stage_player (p_id, p_name, p_sname, sourcedb, player_sk) VALUES (6, 'Mario', 'Baggio', 1, 6);
INSERT INTO stage_player (p_id, p_name, p_sname, sourcedb, player_sk) VALUES (3, 'Jim', 'Burke', 2, 7);
INSERT INTO stage_player (p_id, p_name, p_sname, sourcedb, player_sk) VALUES (4, 'Paul', 'Bin', 2, 8);
INSERT INTO stage_player (p_id, p_name, p_sname, sourcedb, player_sk) VALUES (5, 'Peter', 'Flynn', 2, 9);
INSERT INTO stage_player (p_id, p_name, p_sname, sourcedb, player_sk) VALUES (6, 'Martha', 'Ross', 2, 10);



/* Golf FactResults */



/* LOAD FACTS */
/* merge all facts */
/* 1- merge all the data keeping a field for the source DB */
/* empty table */
drop table if exists stage_fact cascade;
drop table if exists stage_fact_temp cascade;
drop table if exists stage_fact_temp2 cascade;

create table stage_fact(
p_id integer,
p_name varchar(50),
p_sname varchar(50),
T_id integer,
t_date date,
rank integer,
prize int,
sourceDB integer
);


insert into stage_fact select  Results1.p_id, p_name, p_sname, Results1.T_id, t_date, rank, prize, 1 
from Results1
join Players1
on Results1.p_id = Players1.p_id
join Tournament1
on Results1.T_id = Tournament1.T_id;

/* insert data from college 1 */
-- insert into stage_fact select p_id, T_id, 0, prize, rank, 2 
-- from Results2;
insert into stage_fact select  Results2.p_id, p_name, p_sname, Results2.T_id, t_date, rank, prize, 2 
from Results2
join Players2
on Results2.p_id = Players2.p_id
join Tournament2
on Results2.T_id = Tournament2.T_id;

select * from stage_fact;


/* ADD SK Keys - i.e. foreign keys */
alter table stage_fact add player_sk integer;
alter table stage_fact add tournament_sk integer;
alter table stage_fact add date_sk integer;


/* assign values to Student_SK using stage_student as lookup*/
/* Join the dimension stage table */
update stage_fact
set player_sk=
  (select stage_player.player_sk from stage_player
where   
  stage_fact.p_name=stage_player.p_name AND stage_fact.p_sname=stage_player.p_sname);
select * from stage_fact;
  
/* assign values to course_SK using stage_course as lookup*/
/* Join the dimension stage table */
update stage_fact
set tournament_sk=
  (select stage_tournament.tournament_sk from stage_tournament
   where stage_tournament.T_id = stage_fact.T_id
  and stage_tournament.sourceDB=stage_fact.sourceDB 
  );
  
 select * from stage_fact;

/* assign values to date_SK using stage_date as lookup*/
/* Join the dimension stage table */
update stage_fact
set date_sk=
  (select stage_date.date_sk from stage_date  
  where stage_date.t_date= stage_fact.t_date);
  
  select * from stage_fact;

/* LOAD into DW */
select * from FactResults;
insert into FactResults select player_sk, tournament_sk, date_sk, rank, prize
from stage_fact;

select * from FactResults;




/* Golf Query to get the player sk numbers and names their prize and they year they won */
/* this will be used in the python file */



select factresults.player_sk, dimplayer.p_name, dimplayer.p_sname, factresults.prize, dimdate.year
from factresults
join dimplayer
on dimplayer.player_sk = factresults.player_sk
join dimdate
on dimdate.date_sk = factresults.date_sk;

