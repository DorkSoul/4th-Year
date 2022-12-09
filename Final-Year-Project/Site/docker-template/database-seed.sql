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
    "cancelled" Boolean
);

ALTER TABLE "user_login" ADD FOREIGN KEY ("id") REFERENCES "users" ("id");

ALTER TABLE "user_subs" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "user_subs" ADD FOREIGN KEY ("sub_id") REFERENCES "subscriptions" ("id");

ALTER TABLE "user_subs" ADD FOREIGN KEY ("alert_id") REFERENCES "alarms" ("id");


INSERT INTO subscriptions(name, company, website, category, image, description) VALUES
    ('Netflix', 'Netflix', 'www.netflix.com', 'tv', 'https://photos.google.com/photo/AF1QipPaVHLd5e7TYCQILYlq5aDvWkUpqU4GnfS5PSnY', 'netflix'),
    ('Spotify', 'Spotify', 'www.Spotify.com', 'music', 'https://photos.google.com/photo/AF1QipMcP6tnPcgIsE-rOVfNwZtgkWb2Pb14xpV_jSl3', 'spotify'),
    ('Prime', 'Prime', 'www.amazon.com', 'tv', 'https://photos.google.com/photo/AF1QipPaVHLd5e7TYCQILYlq5aDvWkUpqU4GnfS5PSnY', 'prime'),
    ('Audable', 'Audable', 'www.audable.com', 'books', 'https://photos.google.com/photo/AF1QipOpXYg1r1v_9nHamK1JGKf21Ff7OZTTWD135d9W', 'audable'),
    ('Humble Bundle', 'Humble Bundle', 'www.HumbleBundle.com', 'games', 'https://photos.google.com/photo/AF1QipPhbDNih5NHBp6U9eJ7bpQ2fU1UTn3-68Y91KC4', 'humble bundle');

INSERT INTO users (first_name, last_name, email, phone_number, account_number, currency, time_zone, age, gender, address, country) VALUES
    ('Luke', 'Hallinan', 'test@test.com', '0125456321', '12345', 'euro', '0', '27', 'male', '21 normal street', 'ireland');

INSERT INTO user_login (id, username, password) VALUES 
    ('1', 'luke', 'password');

INSERT INTO "alarms" (id, date, time, alert_method) VALUES
    ('1', '10-10-2022', '10:00:00', 'email');

INSERT INTO user_subs (user_id, sub_id, cost, start_date, recurring_length, alert_id, sort_group, user_notes, cancelled) VALUES
    ('1', '1', '10.00', '8-8-2020', 'monthly', '1', 'tv', 'none', 'false'),
    ('1', '2', '15.00', '6-6-2021', 'monthly', '1', 'music', 'none', 'false'),
    ('1', '5', '7.00', '1-1-2022', 'monthly', '1', 'games', 'none', 'false');