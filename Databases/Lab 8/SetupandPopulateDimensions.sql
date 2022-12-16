drop table if exists dimdate;
drop table if exists dimplayer;
drop table if exists dimtournament;

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
