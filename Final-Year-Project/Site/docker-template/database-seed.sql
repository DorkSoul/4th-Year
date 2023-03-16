drop table if exists users;
drop table if exists user_login;
drop table if exists subscriptions;
drop table if exists alarms;
drop table if exists user_subs;

CREATE TABLE "users" (
    "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    "first_name" varchar,
    "last_name" varchar,
    "email" varchar,
    "phone_number" int,
    "account_number" int,
    "currency" varchar,
    "time_zone" numeric,
    "age" numeric,
    "gender" varchar,
    "address" varchar,
    "country" varchar
);

CREATE TABLE "user_login" (
    "id" int PRIMARY KEY,
    "username" varchar,
    "password" varchar
);

CREATE TABLE "subscriptions" (
    "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    "name" varchar,
    "company" varchar,
    "website" varchar,
    "category" varchar,
    "image" varchar,
    "description" varchar
);

CREATE TABLE "alarms" (
  "id" int PRIMARY KEY,
  "date" date,
  "time" time,
  "alert_method" varchar
);

CREATE TABLE "user_subs" (
    "user_id" int,
    "sub_id" int,
    "cost" numeric,
    "start_date" date,
    "recurring_length" varchar,
    "alert_id" int,
    "sort_group" varchar,
    "user_notes" varchar,
    "cancelled" Boolean,
    "rating" int
);

CREATE TABLE "user_sessions" (
    "id" varchar PRIMARY KEY
);

CREATE TABLE "recommendations" (
    "user_id" INTEGER PRIMARY KEY,
    "sub_1" DECIMAL(3, 1),
    "sub_2" DECIMAL(3, 1),
    "sub_3" DECIMAL(3, 1),
    "sub_4" DECIMAL(3, 1),
    "sub_5" DECIMAL(3, 1),
    "sub_6" DECIMAL(3, 1),
    "sub_7" DECIMAL(3, 1),
    "sub_8" DECIMAL(3, 1),
    "sub_9" DECIMAL(3, 1),
    "sub_10" DECIMAL(3, 1),
    "sub_11" DECIMAL(3, 1),
    "sub_12" DECIMAL(3, 1),
    "sub_13" DECIMAL(3, 1),
    "sub_14" DECIMAL(3, 1),
    "sub_15" DECIMAL(3, 1),
    "sub_16" DECIMAL(3, 1),
    "sub_17" DECIMAL(3, 1),
    "sub_18" DECIMAL(3, 1),
    "sub_19" DECIMAL(3, 1),
    "sub_20" DECIMAL(3, 1),
    "sub_21" DECIMAL(3, 1),
    "sub_22" DECIMAL(3, 1),
    "sub_23" DECIMAL(3, 1),
    "sub_24" DECIMAL(3, 1),
    "sub_25" DECIMAL(3, 1),
    "sub_26" DECIMAL(3, 1),
    "sub_27" DECIMAL(3, 1),
    "sub_28" DECIMAL(3, 1),
    "sub_29" DECIMAL(3, 1),
    "sub_30" DECIMAL(3, 1),
    "sub_31" DECIMAL(3, 1),
    "sub_32" DECIMAL(3, 1),
    "sub_33" DECIMAL(3, 1),
    "sub_34" DECIMAL(3, 1),
    "sub_35" DECIMAL(3, 1),
    "sub_36" DECIMAL(3, 1),
    "sub_37" DECIMAL(3, 1),
    "sub_38" DECIMAL(3, 1),
    "sub_39" DECIMAL(3, 1),
    "sub_40" DECIMAL(3, 1)
);

ALTER TABLE "user_login" ADD FOREIGN KEY ("id") REFERENCES "users" ("id");

ALTER TABLE "user_subs" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "user_subs" ADD FOREIGN KEY ("sub_id") REFERENCES "subscriptions" ("id");

ALTER TABLE "user_subs" ADD FOREIGN KEY ("alert_id") REFERENCES "alarms" ("id");


INSERT INTO subscriptions(name, company, website, category, image, description) VALUES
    ('Netflix', 'Netflix', 'www.netflix.com', 'tv and movies', 'https://i.imgur.com/ubhckib.png', 'netflix'),
    ('HBO Max', 'HBO', 'www.hbomax.com/', 'tv and movies', 'https://i.imgur.com/Dy1KrCQ.png', 'HBO Max'),
    ('Prime Video', 'amazon', 'www.amazon.com', 'tv and movies', 'https://i.imgur.com/MaJrIIp.png', 'Prime Video'),
    ('Hulu', 'Hulu', 'www.Hulu.com', 'tv and movies', 'https://i.imgur.com/A2m3gf4.png', 'Hulu'),
    ('Disney Plus', 'Disney Plus', 'www.disneyplus.com', 'tv and movies', 'https://i.imgur.com/r1euyrZ.png', 'Disney Plus'),
    ('Apple Tv Plus', 'Apple Tv Plus', 'tv.apple.com', 'tv and movies', 'https://i.imgur.com/wLK82ny.png', 'Apple Tv Plus'),
    ('Youtube TV', 'Youtube TV', 'tv.youtube.com', 'tv and movies', 'https://i.imgur.com/F3bblfI.png', 'Youtube TV'),
    ('ESPN', 'ESPN', 'www.espn.com/espnplus/', 'tv and movies', 'https://i.imgur.com/NW9CzFf.png', 'ESPN'),
    ('Paramount Plus', 'Paramount Plus', 'www.paramountplus.com', 'tv and movies', 'https://i.imgur.com/wdbMELX.png', 'Paramount Plus'),
    ('NBC Peacock', 'NBC Peacock', 'www.peacocktv.com', 'tv and movies', 'https://i.imgur.com/DFjk48K.png', 'NBC Peacock'),

    ('Sound Cloud', 'Sound Cloud', 'www.soundcloud.com', 'music', 'https://i.imgur.com/DvURaiJ.png', 'Sound Cloud'),
    ('Spotify', 'Spotify', 'www.Spotify.com', 'music', 'https://i.imgur.com/VD6WGhp.png', 'spotify'),
    ('Napster', 'Napster', 'www.napster.com', 'music', 'https://i.imgur.com/jdU5Qgb.png', 'Napster'),
    ('Youtube Music', 'Youtube Music', 'music.youtube.com', 'music', 'https://i.imgur.com/AKd0TOd.png', 'Youtube Music'),
    ('Apple Music', 'Apple Music', 'music.apple.com', 'music', 'https://i.imgur.com/gdwSKJj.png', 'Apple Music'),
    ('Amazon Music', 'Amazon Music', 'music.amazon.com', 'music', 'https://i.imgur.com/gWDEpc2.png', 'Amazon Music'),
    ('Qobuz', 'Qobuz', 'https://www.qobuz.com/', 'music', 'https://i.imgur.com/AIUob3Z.png', 'Qobuz'),
    ('Deezer', 'Deezer', 'www.deezer.com', 'music', 'https://i.imgur.com/6bwLW77.png', 'Deezer'),
    ('KKBOX', 'KKBOX', 'www.kkbox.com', 'music', 'https://i.imgur.com/q5wcZSj.png', 'KKBOX'),
    ('Tidal', 'Tidal', 'www.tidal.com', 'music', 'https://i.imgur.com/Nfshk2h.png', 'Tidal'),

    ('Xbox Game Pass', 'Xbox Game Pass', 'www.xbox.com/en-IE/xbox-game-pass', 'games', 'https://i.imgur.com/amcRd83.png', 'Xbox Game Pass'),
    ('Playstation Plus', 'Playstation Plus', 'www.playstation.com/en-ie/ps-plus/', 'games', 'https://i.imgur.com/q0kDFgn.png', 'Playstation Plus'),
    ('EA Play', 'EA Play', 'www.ea.com/ea-play', 'games', 'https://i.imgur.com/5kWbNHo.png', 'EA Play'),
    ('Apple Arcade', 'Apple Arcade', 'www.apple.com/ie/apple-arcade/', 'games', 'https://i.imgur.com/ErEhUXk.png', 'Apple Arcade'),
    ('Humble Bundle', 'Humble Bundle', 'www.HumbleBundle.com', 'games', 'https://i.imgur.com/OhHnvoR.png', 'humble bundle'),
    ('Google Play Pass', 'Google Play Pass', 'play.google.com/about/play-pass/', 'games', 'https://i.imgur.com/jX1Vy5g.png', 'Google Play Pass'),
    ('Nintendo Switch Online', 'Nintendo Switch Online', 'www.nintendo.com/switch/online/', 'games', 'https://i.imgur.com/DFBjIBI.png', 'Nintendo Switch Online'),
    ('Prime Gaming', 'amazon', 'gaming.amazon.com/', 'games', 'https://i.imgur.com/QjbEYNm.png', 'Prime Gaming'),
    ('Nvidia Geforce Now', 'Nvidia Geforce Now', 'www.nvidia.com/en-us/geforce-now/', 'games', 'https://i.imgur.com/8Tu83aS.png', 'Nvidia Geforce Now'),
    ('Ubisoft Plus', 'Ubisoft Plus', 'store.ubi.com/ubisoftplus', 'games', 'https://i.imgur.com/QLr2Hw5.png', 'Ubisoft Plus'),

    ('Kindle Unlimited', 'Kindle Unlimited', 'www.amazon.co.uk/Kindle-Unlimited-Books/b?ie=UTF8&node=4764713031', 'books', 'https://i.imgur.com/cmtfsc8.png', 'Kindle Unlimited'),
    ('Barnes & Noble Member', 'Barnes & Noble Member', 'www.barnesandnoble.com/membership/', 'books', 'https://i.imgur.com/rdKDC2E.png', 'Barnes & Noble Member'),
    ('Owlcrate', 'Owlcrate', 'www.owlcrate.com', 'books', 'https://i.imgur.com/BYUOfC1.png', 'Owlcrate'),
    ('Audable', 'Audable', 'www.audable.com', 'books', 'https://i.imgur.com/UJLDMGH.png', 'audable'),
    ('Book Of The Month', 'Book Of The Month', 'www.bookofthemonth.com', 'books', 'https://i.imgur.com/F5wsaBb.png', 'Book Of The Month'),

    ('Gousto', 'Gousto', 'www.gousto.co.uk', 'food', 'https://i.imgur.com/JDfQ7mY.png', 'Gousto'),
    ('Riverford', 'Riverford', 'www.riverford.co.uk', 'food', 'https://i.imgur.com/zcgkN5J.png', 'Riverford'),
    ('The Cook Away', 'The Cook Away', 'www.thecookaway.com', 'food', 'https://i.imgur.com/3bpnndu.png', 'The Cook Away'),
    ('Wild And Game', 'Wild And Game', 'www.wildandgame.co.uk', 'food', 'https://i.imgur.com/aSUoCse.png', 'Wild And Game'),
    ('Hello Fresh', 'Hello Fresh', 'www.hellofresh.ie', 'food', 'https://i.imgur.com/MRBrKyH.png', 'Hello Fresh');

-- INSERT INTO users (first_name, last_name, email, phone_number, account_number, currency, time_zone, age, gender, address, country) VALUES
--     ('Luke', 'Hallinan', 'test@test.com', '0125456321', '12345', 'euro', '0', '27', 'male', '21 normal street', 'Ireland');

-- INSERT INTO user_login (id, username, password) VALUES 
--     ('1', 'luke', 'password');

INSERT INTO "alarms" (id, date, time, alert_method) VALUES
    ('1', '10-10-2022', '10:00:00', 'email');

-- INSERT INTO user_subs (user_id, sub_id, cost, start_date, recurring_length, alert_id, sort_group, user_notes, cancelled) VALUES
--     ('1', '1', '10.00', '8-8-2020', 'monthly', '1', 'tv', 'none', 'false'),
--     ('1', '2', '15.00', '6-6-2021', 'monthly', '1', 'music', 'none', 'false'),
--     ('1', '5', '7.00', '1-1-2022', 'monthly', '1', 'games', 'none', 'false');

