
Table user {
  id int [pk, increment]
  first_name varchar
  last_name varchar
  email varchar
  phone_number int
  account_number int
  currency numeric
  time_zone datetime
  age numeric
  gender varchar
  user_address varchar
  country varchar
}

Table user_login{
  id int [pk]
  user_username varchar
  user_password varchar
}

Ref: user.id - user_login.id

Table subscriptions {
  id int [pk, increment]
  sub_name varchar
  company varchar
  website varchar
  category varchar
  sub_image varchar
  sub_description varchar
}

Table alarms {
  id int [pk]
  current datetime
  time_zone varchar
  alert_method varchar
  days_early int
}

Table user_subs{
  user_id int
  sub_id int
  cost numeric
  sub_start_date datetime
  recurring_length varchar
  alert_id int
  sort_group varchar
  user_notes varchar
  cancelled Boolean
}

Ref: user.id < user_subs.user_id
Ref: subscriptions.id < user_subs.sub_id
Ref: alarms.id - user_subs.alert_id

INSERT INTO subscriptions(id, sub_name, company, website, category, sub_image, sub_description) VALUES
 ('Netflix', 'Netflix', 'www.netflix.com', 'tv', 'https://photos.google.com/photo/AF1QipPaVHLd5e7TYCQILYlq5aDvWkUpqU4GnfS5PSnY' 'netflix'),
 ('Spotify', 'Spotify', 'www.Spotify.com', 'music', 'https://photos.google.com/photo/AF1QipMcP6tnPcgIsE-rOVfNwZtgkWb2Pb14xpV_jSl3', 'spotify'),
 ('Prime', 'Prime', 'www.amazon.com', 'tv', 'https://photos.google.com/photo/AF1QipPaVHLd5e7TYCQILYlq5aDvWkUpqU4GnfS5PSnY' 'prime'),
 ('Audable', 'Audable', 'www.audable.com', 'books', 'https://photos.google.com/photo/AF1QipOpXYg1r1v_9nHamK1JGKf21Ff7OZTTWD135d9W' 'audable'),
 ('Humble Bundle', 'Humble Bundle', 'www.HumbleBundle.com', 'games', 'https://photos.google.com/photo/AF1QipPhbDNih5NHBp6U9eJ7bpQ2fU1UTn3-68Y91KC4' 'humble bundle');
