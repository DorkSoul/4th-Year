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
