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