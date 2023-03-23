// some code refcrenced from https://dev.to/alexeagleson/docker-for-javascript-developers-41me
// Import the postgres client
const { Client } = require("pg");
const express = require("express");
const session = require('express-session'); // express-sessions
const { v4: uuidv4 } = require('uuid'); // uuid, To call: uuidv4();
// const bodyParser = require('body-parser');
const app = express();
const port = 8070;

// app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.json());

app.use(session({
  genid: function (req) {
    return uuidv4();
  },
  secret: '=fgHV*U@FL`N]]~/zFgyCch.pBHuEU',
  resave: false,
  saveUninitialized: true,
  cookie: { maxAge: 60 * 60 * 1000 }, // 1 hour cookie life
}));


// Connect to our postgres database
const client = new Client({
  password: "root",
  user: "root",
  host: "postgres",
});

app.use(express.static("public"));

(async () => {
  await client.connect();
  app.listen(port, () => {
    console.log(`App listening at http://localhost:${port}`);
    importUserData(client); // call the importUserData function on initial startup
    importRecommendationsData(client); // call the importRecommendationsData function on initial startup
    importUserXUserData(client); // call the importUserXUserData function on initial startup
    importSubXSubData(client); // call the importSubXSubData function on initial startup
  });
})();




app.post("/subscriptions", async (req, res) => {
  const { username, password } = req.body;

  const query = `
    SELECT s.id, s.name, s.category, s.image, us.cost, us.start_date, us.recurring_length, us.sort_group 
    FROM user_login ul 
    INNER JOIN users u ON ul.id = u.id 
    INNER JOIN user_subs us ON u.id = us.user_id 
    INNER JOIN subscriptions s ON us.sub_id = s.id 
    WHERE ul.username = $1 AND ul.password = $2;
  `;

  const params = [username, password];

  try {
    const results = await client.query(query, params);
    res.setHeader("Content-Type", "application/json");
    res.status(200);
    res.send(JSON.stringify(results.rows));
  } catch (error) {
    console.error(error);
    res.status(500).send("Query failed");
  }
});

app.post("/subscriptions/:id", async (req, res) => {
  const { id } = req.params;
  const { username } = req.body;

  const query = `
    SELECT s.name, s.category, s.image, us.cost, us.start_date, us.recurring_length, us.sort_group 
    FROM user_subs us
    INNER JOIN subscriptions s ON us.sub_id = s.id 
    INNER JOIN user_login ul ON ul.id = us.user_id 
    WHERE s.id = $1 AND ul.username = $2;
  `;

  const params = [id, username];

  try {
    const results = await client.query(query, params);
    res.setHeader("Content-Type", "application/json");
    res.status(200);
    res.send(JSON.stringify(results.rows));
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Query failed" });
  }
});




// Handle the login form submission
app.post('/login', async (req, res) => {
  const { username, password } = req.body;

  try {
    // Query the user_login table for a user with the given username and password
    const result = await client.query('SELECT id FROM user_login WHERE username = $1 AND password = $2', [username, password]);

    // Check if a user was found
    if (result.rows.length > 0) {
      const userId = result.rows[0].id;
      const sessionId = req.sessionID;

      // Insert the session ID into the user_sessions table
      await client.query('INSERT INTO user_sessions (id) VALUES ($1)', [sessionId]);

      res.json({ success: true, sessionId: sessionId, userId: userId });
    } else {
      // Send an error response if no user was found
      res.status(401).json({ error: 'Invalid username or password' });
    }
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'An error occurred' });
  }
});

app.post('/user_session', async (req, res) => {
  const { sessionId } = req.body;
  try {
    // Query the user_sessions table for a session with the given ID
    const result = await client.query('SELECT id FROM user_sessions WHERE id = $1', [sessionId]);

    // Check if a session was found
    if (result.rows.length > 0) {
      res.json({ success: true });
    } else {
      // Send an error response if no session was found
      res.status(401).json({ error: 'Invalid session' });
    }
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'An error occurred' });
  }
});










// format from https://dirask.com/posts/Node-js-PostgreSQL-Insert-query-DZXq2j

const insertSub = async (name, company, website, category, image, description) => {
  try {           // gets connection
      await client.query(
          `INSERT INTO "subscriptions" ("name", "company", "website", "category", "image", "description")  
           VALUES ($1, $2, $3, $4, $5, $6)`, [name, company, website, category, image, description]); // sends queries
      return true;
  } catch (error) {
      console.error(error.stack);
      return false;
  }
};

app.get("/add_subscriptions", async (req, res) => 
{insertSub('Added Subscription', 'Generic Company', 'www.test.com', 'Testing', 'Image url here', 'This is an added subscription for testing purposes')
.then(result => {
  if (result) {
      console.log('Subscription inserted');
      res.setHeader("Content-Type", "application/json");
      res.status(200);
      res.send(JSON.stringify(result));
  }
})});

app.post("/recommendations", async (req, res) => {
  const { userId } = req.body;

  const query = `
    SELECT sub_1, sub_2, sub_3, sub_4, sub_5, sub_6, sub_7, sub_8, sub_9, sub_10,
           sub_11, sub_12, sub_13, sub_14, sub_15, sub_16, sub_17, sub_18, sub_19, sub_20,
           sub_21, sub_22, sub_23, sub_24, sub_25, sub_26, sub_27, sub_28, sub_29, sub_30,
           sub_31, sub_32, sub_33, sub_34, sub_35, sub_36, sub_37, sub_38, sub_39, sub_40
    FROM recommendations
    WHERE user_id = $1;
  `;

  try {
    const result = await client.query(query, [userId]);
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'An error occurred' });
  }
});

app.get("/all-subscriptions", async (req, res) => {
  const query = `
    SELECT *
    FROM subscriptions;
  `;

  try {
    const results = await client.query(query);
    res.setHeader("Content-Type", "application/json");
    res.status(200);
    res.send(JSON.stringify(results.rows));
  } catch (error) {
    console.error(error);
    res.status(500).send("Query failed");
  }
});






























const fs = require('fs');
const csv = require('csv-parser');
const readline = require('readline');
const path = require('path');
const usersCsvPath = path.join('/app', 'public', 'csv', 'users.csv');
const userLoginCsvPath = path.join('/app', 'public', 'csv', 'user_login.csv');
const userSubsCsvPath = path.join('/app', 'public', 'csv', 'user_subs.csv');
const recommendationsCsvPath = path.join('/app', 'public', 'csv', 'userXsub.csv');
const userXuserCsvPath = path.join('/app', 'public', 'csv', 'userXuser.csv');
const subXsubCsvPath = path.join('/app', 'public', 'csv', 'subXsub.csv');

const importUserData = async (client) => {
  try {
    // Read users.csv file
    const usersData = [];
    fs.createReadStream(usersCsvPath)
      .pipe(csv())
      .on('data', (row) => {
        const { id, first_name, last_name, email, phone_number, account_number, currency, time_zone, age, gender, address, country } = row;
        usersData.push([id, first_name, last_name, email, phone_number, account_number, currency, time_zone, age, gender, address, country]);
      })
      .on('end', async () => {
        // Insert data into "users" table and store the generated IDs
        const userIds = [];
        for (let i = 0; i < usersData.length; i++) {
          const [id, firstName, lastName, email, phoneNumber, accountNumber, currency, timeZone, age, gender, address, country] = usersData[i];
          try {
            const result = await client.query(
              `INSERT INTO "users" ("first_name", "last_name", "email", "phone_number", "account_number", "currency", "time_zone", "age", "gender", "address", "country")
               VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
               RETURNING "id"`,
              [firstName, lastName, email, phoneNumber, accountNumber, currency, timeZone, age, gender, address, country]
            );
            userIds.push(result.rows[0].id);
          } catch (error) {
            console.error(error.stack);
          }          
        }

        // Read user_login.csv file
        const loginsData = [];
        fs.createReadStream(userLoginCsvPath)
          .pipe(csv())
          .on('data', (row) => {
            const { user_id, username, password } = row;
            loginsData.push([user_id, username, password]);
          })
          .on('end', async () => {
            // Insert data into "user_login" table using the generated user IDs
            for (let i = 0; i < loginsData.length; i++) {
              const [userIndex, username, password] = loginsData[i];
              const userId = userIds[userIndex - 1]; // Assuming user_id in user_login.csv is 1-indexed
              try {
                await client.query(
                  `INSERT INTO "user_login" ("id", "username", "password")
                   VALUES ($1, $2, $3)`,
                  [userId, username, password]
                );
              } catch (error) {
                console.error(error.stack);
              }
            }
          }) // Add a closing bracket here
          .on('error', (error) => {
            console.error(error.stack);
          });

        // Read user_subs.csv file
        const userSubsData = [];
        fs.createReadStream(userSubsCsvPath)
          .pipe(csv())
          .on('data', (row) => {
            userSubsData.push(row);
          })
          .on('end', async () => {
            // Insert data into "user_subs" table using the generated user IDs
            for (let i = 0; i < userSubsData.length; i++){
            const { user_id, sub_id, cost, start_date, recurring_length, alert_id, sort_group, user_notes, cancelled, rating } = userSubsData[i];
            const userId = userIds[user_id - 1]; // Assuming user_id in user_subs.csv is 1-indexed
            try {
              await client.query(
                `INSERT INTO "user_subs" ("user_id", "sub_id", "cost", "start_date", "recurring_length", "alert_id", "sort_group", "user_notes", "cancelled", "rating")
                 VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)`,
                [userId, sub_id, cost, start_date, recurring_length, alert_id, sort_group, user_notes, cancelled, rating]
              );
            } catch (error) {
              console.error(error.stack);
            }
          }
        })
        .on('error', (error) => {
          console.error(error.stack);
        });
    })
    .on('error', (error) => {
      console.error(error.stack);
    });
} catch (error) {
  console.error(error.stack);
}
};

const importRecommendationsData = async (client) => {
  try {
    fs.createReadStream(recommendationsCsvPath)
      .pipe(csv())
      .on('data', async (row) => {
        const { id, ...subscriptions } = row;
        const subscriptionValues = Object.values(subscriptions).map(Number);
        const queryParams = [id, ...subscriptionValues];

        try {
          await client.query(
            `
            INSERT INTO "recommendations" (
              "user_id", "sub_1", "sub_2", "sub_3", "sub_4", "sub_5", "sub_6", "sub_7", "sub_8", "sub_9", "sub_10",
              "sub_11", "sub_12", "sub_13", "sub_14", "sub_15", "sub_16", "sub_17", "sub_18", "sub_19", "sub_20",
              "sub_21", "sub_22", "sub_23", "sub_24", "sub_25", "sub_26", "sub_27", "sub_28", "sub_29", "sub_30",
              "sub_31", "sub_32", "sub_33", "sub_34", "sub_35", "sub_36", "sub_37", "sub_38", "sub_39", "sub_40"
            ) VALUES (
              $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21,
              $22, $23, $24, $25, $26, $27, $28, $29, $30, $31, $32, $33, $34, $35, $36, $37, $38, $39, $40, $41
            )
            `,
            queryParams
          );
        } catch (error) {
          console.error(error.stack);
        }
      })
      .on('end', () => {
        console.log('CSV file successfully processed.');
      })
      .on('error', (error) => {
        console.error(error.stack);
      });
  } catch (error) {
    console.error(error.stack);
  }
};

const importUserXUserData = async (client) => {
  try {
    fs.createReadStream(userXuserCsvPath)
      .pipe(csv())
      .on('data', async (row) => {
        const { user_id, sub_id_1, sub_id_2, sub_id_3, sub_id_4, sub_id_5 } = row;

        try {
          await client.query(
            `
            INSERT INTO "user_user" (
              "user_id", "sub_id_1", "sub_id_2", "sub_id_3", "sub_id_4", "sub_id_5"
            ) VALUES ($1, $2, $3, $4, $5, $6)
            `,
            [user_id, sub_id_1, sub_id_2, sub_id_3, sub_id_4, sub_id_5]
          );
        } catch (error) {
          console.error(error.stack);
        }
      })
      .on('end', () => {
        console.log('CSV file successfully processed.');
      })
      .on('error', (error) => {
        console.error(error.stack);
      });
  } catch (error) {
    console.error(error.stack);
  }
};


const importSubXSubData = async (client) => {
  try {
    fs.createReadStream(subXsubCsvPath)
      .pipe(csv())
      .on('data', async (row) => {
        const { sub_id, similar_sub_id_1, similar_sub_id_2, similar_sub_id_3, similar_sub_id_4, similar_sub_id_5 } = row;

        try {
          await client.query(
            `
            INSERT INTO "sub_sub" (
              "sub_id", "similar_sub_id_1", "similar_sub_id_2", "similar_sub_id_3", "similar_sub_id_4", "similar_sub_id_5"
            ) VALUES ($1, $2, $3, $4, $5, $6)
            `,
            [sub_id, similar_sub_id_1, similar_sub_id_2, similar_sub_id_3, similar_sub_id_4, similar_sub_id_5]
          );
        } catch (error) {
          console.error(error.stack);
        }
      })
      .on('end', () => {
        console.log('CSV file successfully processed.');
      })
      .on('error', (error) => {
        console.error(error.stack);
      });
  } catch (error) {
    console.error(error.stack);
  }
};

const calculateAverageRatings = async () => {
  const userSubsData = [];

  // Read user_subs.csv file
  await new Promise((resolve, reject) => {
    fs.createReadStream(userSubsCsvPath)
      .pipe(csv())
      .on('data', (row) => {
        userSubsData.push(row);
      })
      .on('end', resolve)
      .on('error', reject);
  });

  // Calculate the average rating for each unique sub_id
  const ratingsMap = new Map();

  for (const row of userSubsData) {
    const { sub_id, rating } = row;

    if (ratingsMap.has(sub_id)) {
      const { totalRating, count } = ratingsMap.get(sub_id);
      ratingsMap.set(sub_id, { totalRating: totalRating + Number(rating), count: count + 1 });
    } else {
      ratingsMap.set(sub_id, { totalRating: Number(rating), count: 1 });
    }
  }

  const averageRatings = new Map();
  for (const [sub_id, { totalRating, count }] of ratingsMap.entries()) {
    averageRatings.set(sub_id, totalRating / count);
  }

  return averageRatings;
};

const updateSubscriptionsRatings = async (client, averageRatings) => {
  try {
    // Update the 'rating' column in the "subscriptions" table
    for (const [sub_id, rating] of averageRatings.entries()) {
      const roundedRating = parseFloat(rating.toFixed(1));
      try {
        await client.query(
          `UPDATE "subscriptions" SET "rating" = $1 WHERE "id" = $2`,
          [roundedRating, sub_id]
        );
      } catch (error) {
        console.error(error.stack);
      }
    }
  } catch (error) {
    console.error(error.stack);
  }
};

// Execute the functions
(async () => {
  const averageRatings = await calculateAverageRatings();
  await updateSubscriptionsRatings(client, averageRatings);
})();


