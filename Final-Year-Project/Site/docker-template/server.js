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
  await generateUserData(); // call the generateUserData function on initial startup
  app.listen(port, () => {
    console.log(`App listening at http://localhost:${port}`);
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
      const sessionId = req.sessionID;

      // Insert the session ID into the user_sessions table
      await client.query('INSERT INTO user_sessions (id) VALUES ($1)', [sessionId]);

      res.json({ success: true, sessionId: sessionId });
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



























//generate data for database
const generateUserData = async () => {
  const users = Array.from({ length: 100 }, (_, i) => {
    const phoneNumber = `086${Math.floor(Math.random() * 10000000).toString().padStart(7, '0')}`;
    const currency = ['euro', 'dollar', 'pound'][Math.floor(Math.random() * 3)];
    const timeZone = Math.floor(Math.random() * 24) - 12;
    const age = Math.floor(Math.random() * 80) + 18;
    const gender = ['male', 'female'][Math.floor(Math.random() * 2)];
    const country = ['Ireland', 'USA', 'UK'][Math.floor(Math.random() * 3)];
    const address = `${Math.floor(Math.random() * 100)} ${['Main', 'High', 'Park', 'Maple'][Math.floor(Math.random() * 4)]} St`;
    return [
      `user${i + 1}`,
      `last${i + 1}`,
      `user${i + 1}@example.com`,
      phoneNumber,
      Math.floor(Math.random() * 100000),
      currency,
      timeZone,
      age,
      gender,
      address,
      country,
    ];
  });

  const logins = Array.from({ length: 100 }, (_, i) => {
    return [
      i + 1,
      `user${i + 1}`,
      'password',
    ];
  });

  const subs = [];

  for (let i = 1; i <= 100; i++) {
    const subCount = Math.floor(Math.random() * 9) + 1;
    for (let j = 0; j < subCount; j++) {
      const subId = Math.floor(Math.random() * 40) + 1;
      const cost = Math.floor(Math.random() * 30) + 1;
      const startDate = `2021-${Math.floor(Math.random() * 12) + 1}-${Math.floor(Math.random() * 28) + 1}`;
      // const recurringLength = ['monthly', 'yearly'][Math.floor(Math.random() * 2)];
      const recurringLength = ['monthly', 'monthly'][Math.floor(Math.random() * 2)];
      const alertId = 1;
      const sortGroup = [
        ...Array(10).fill('tv and movies'),
        ...Array(10).fill('music'),
        ...Array(10).fill('games'),
        ...Array(5).fill('books'),
        ...Array(5).fill('food'),
      ][subId - 1];
      const userNotes = `This is a note for user ${i + 1} subscription ${j + 1}.`;
      // const cancelled = [true, false][Math.floor(Math.random() * 2)];
      const cancelled = [false, false][Math.floor(Math.random() * 2)];
      subs.push([i, subId, cost, startDate, recurringLength, alertId, sortGroup, userNotes, cancelled]);
    }
  }
  for (let i = 0; i < users.length; i++) {
    const [firstName, lastName, email, phoneNumber, accountNumber, currency, timeZone, age, gender, address, country] = users[i];
    try {
      await client.query(
        `INSERT INTO "users" ("first_name", "last_name", "email", "phone_number", "account_number", "currency", "time_zone", "age", "gender", "address", "country")
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)`,
        [firstName, lastName, email, phoneNumber, accountNumber, currency, timeZone, age, gender, address, country]
      );
      
      const [id, username, password] = logins[i];
      await client.query(
        `INSERT INTO "user_login" ("id", "username", "password")
         VALUES ($1, $2, $3)`,
        [id, username, password]
      );
  
      for (let j = 0; j < subs.length; j++) {
        const [userId, subId, cost, startDate, recurringLength, alertId, sortGroup, userNotes, cancelled] = subs[j];
        if (userId === i + 1) {
          await client.query(
            `INSERT INTO "user_subs" ("user_id", "sub_id", "cost", "start_date", "recurring_length", "alert_id", "sort_group", "user_notes", "cancelled")
             VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)`,
            [userId, subId, cost, startDate, recurringLength, alertId, sortGroup, userNotes, cancelled]
          );
        }
      }
    } catch (error) {
      console.error(error.stack);
    }
  }  
};