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

app.get("/subscriptions", async (req, res) => {
  const results = await client
    .query("SELECT * FROM subscriptions")
    .then((payload) => {
      return payload.rows;
    })
    .catch(() => {
      throw new Error("Query failed");
    });
  res.setHeader("Content-Type", "application/json");
  res.status(200);
  res.send(JSON.stringify(results));
});


  (async () => {
  await client.connect();

  app.listen(port, () => {
    console.log(`App listening at http://localhost:${port}`);
  });
})();


// app.post('/login', function(req, res) {
//   var username = req.body.username;
//   var password = req.body.password;

//   // check if the username and password are valid
//   if (username === 'test' && password === 'test') {
//     // set session ID and send success response
//     var sessionId = req.sessionID;
//     res.json({ success: true, sessionId: sessionId });
//   } else {
//     // send error response
//     res.status(401).json({ error: 'Invalid username or password' });
//   }
// });






// Handle the login form submission
app.post('/login', (req, res) => {
  const { username, password } = req.body;

  // Validate the user's credentials
  if (username === 'test' && password === 'test') {
    // If the credentials are valid, set a cookie to indicate that the user is authenticated
    var sessionId = req.sessionID;
    res.json({ success: true, sessionId: sessionId });
      } else {
        // send error response
        res.status(401).json({ error: 'Invalid username or password' });
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