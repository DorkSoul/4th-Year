import csv
import random
import os

os.chdir(r'C:\Users\lukeh\Documents\College\4th-Year\Final-Year-Project\Site\docker-template\public\csv')

cwd = os.getcwd()
print("Current working directory:", cwd)

def generate_user_data():
    users = []
    logins = []
    subs = []

    # Create a list of all possible subscription ids
    sub_ids = list(range(1, 41))

    for i in range(10000):
        phone_number = f"086{str(random.randint(0, 9999999)).zfill(7)}"
        currency = random.choice(['euro', 'dollar', 'pound'])
        time_zone = random.randint(-12, 11)
        age = random.randint(18, 97)
        gender = random.choice(['male', 'female'])
        country = random.choice(['Ireland', 'USA', 'UK'])
        address = f"{random.randint(0, 99)} {random.choice(['Main', 'High', 'Park', 'Maple'])} St"

        users.append([
            f"user{i + 1}",
            f"last{i + 1}",
            f"user{i + 1}@example.com",
            phone_number,
            currency,
            time_zone,
            age,
            gender,
            address,
            country,
        ])

        logins.append([i + 1, f"user{i + 1}", 'password'])

        # Shuffle the list of possible subscription ids
        random.shuffle(sub_ids)

        # Select a random number of subscriptions between 1 and 9
        sub_count = random.randint(1, min(len(sub_ids), 8))
        assigned_subs = sub_ids[:sub_count]

        # Choose a majority group for the user
        majority_group = random.choice([
            range(1, 11),
            range(11, 21),
            range(21, 31),
            range(31, 36),
            range(36, 41)
        ])

        # Assign the majority of subscriptions to the user from the chosen group
        majority_subs = random.sample(majority_group, sub_count // 2)
        remaining_subs = [sub for sub in assigned_subs if sub not in majority_subs]
        assigned_subs = majority_subs + remaining_subs[:sub_count - len(majority_subs)]
        assigned_subs = list(set(assigned_subs)) # Remove duplicates

        for j, sub_id in enumerate(assigned_subs):
            cost = random.randint(1, 20)
            start_date = f"2021-{random.randint(1, 12)}-{random.randint(1,28)}"
            recurring_length = random.choice(['monthly', 'monthly'])
            alert_id = 1
            # Assign sort_group based on sub_id
            if sub_id in range(1, 11):
                sort_group = 'tv and movies'
            elif sub_id in range(11, 21):
                sort_group = 'music'
            elif sub_id in range(21, 31):
                sort_group = 'games'
            elif sub_id in range(31, 36):
                sort_group = 'books'
            else:
                sort_group = 'food'
            user_notes = f"This is a note for user {i + 1} subscription {j + 1}."
            cancelled = random.choice([False, False])
                    # Adjust the rating distribution
            rating = random.choices(
                [1, 2, 3, 4, 5],
                [5, 10, 25, 30, 30]
            )[0]

            subs.append([
                i + 1,
                sub_id,
                cost,
                start_date,
                recurring_length,
                alert_id,
                sort_group,
                user_notes,
                cancelled,
                rating,
            ])
    return users, logins, subs




def write_csv(filename, data, header=None):
    with open(filename, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)
        if header:
            writer.writerow(header)
        writer.writerows(data)

users, logins, subs = generate_user_data()

user_header = ["first_name", "last_name", "email", "phone_number", "currency", "time_zone", "age", "gender", "address", "country"]
write_csv("users.csv", users, user_header)

login_header = ["user_id", "username", "password"]
write_csv("user_login.csv", logins, login_header)

subs_header = ["user_id", "sub_id", "cost", "start_date", "recurring_length", "alert_id", "sort_group", "user_notes", "cancelled", "rating"]
write_csv("user_subs.csv", subs, subs_header)
