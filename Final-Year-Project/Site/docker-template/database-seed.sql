drop table if exists employees;
drop table if exists subscriptions;

CREATE TABLE employees(
    id SERIAL,
    name text,
    title text,
    CONSTRAINT employees_pkey PRIMARY KEY (id)
);

CREATE TABLE subscriptions (
    id SERIAL,
    sub_name varchar,
    company varchar,
    website varchar,
    category varchar,
    sub_image varchar,
    sub_description varchar,
    CONSTRAINT subscriptions_pkey PRIMARY KEY (id)
);

INSERT INTO employees(name, title) VALUES
 ('Meadow Crystalfreak ', 'Head of Operations'),
 ('Buddy-Ray Perceptor', 'DevRel'),
 ('Prince Flitterbell', 'Marketing Guru');



INSERT INTO subscriptions(sub_name, company, website, category, sub_image, sub_description) VALUES
 ('Netflix', 'Netflix', 'www.netflix.com', 'tv', 'https://photos.google.com/photo/AF1QipPaVHLd5e7TYCQILYlq5aDvWkUpqU4GnfS5PSnY', 'netflix'),
 ('Spotify', 'Spotify', 'www.Spotify.com', 'music', 'https://photos.google.com/photo/AF1QipMcP6tnPcgIsE-rOVfNwZtgkWb2Pb14xpV_jSl3', 'spotify'),
 ('Prime', 'Prime', 'www.amazon.com', 'tv', 'https://photos.google.com/photo/AF1QipPaVHLd5e7TYCQILYlq5aDvWkUpqU4GnfS5PSnY', 'prime'),
 ('Audable', 'Audable', 'www.audable.com', 'books', 'https://photos.google.com/photo/AF1QipOpXYg1r1v_9nHamK1JGKf21Ff7OZTTWD135d9W', 'audable'),
 ('Humble Bundle', 'Humble Bundle', 'www.HumbleBundle.com', 'games', 'https://photos.google.com/photo/AF1QipPhbDNih5NHBp6U9eJ7bpQ2fU1UTn3-68Y91KC4', 'humble bundle');