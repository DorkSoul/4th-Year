// Import the postgres client
const { Client } = require("pg");
const express = require("express");
const app = express();
const port = 8070;

// Connect to our postgres database
// These values like `root` and `postgres` will be
// defined in our `docker-compose-yml` file
const client = new Client({
  password: "root",
  user: "root",
  host: "postgres",
});


// Serves a folder called `public` that we will create
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

// app.get("/add_subscriptions", async (req, res) => {
//   try{
//     query("INSERT INTO subscriptions(name, company, website, category, image, description) VALUES ('Test', 'Test', 'www.test.com', 'test', 'https://photos.google.com/photo/AF1QipPaVHLd5e7TYCQILYlq5aDvWkUpqU4GnfS5PSnY', 'test')");
//     return true;
//   }catch(error) {
//       throw new Error("Query failed");
//   };
// });

// Our app must connect to the database before it starts, so
// we wrap this in an IIFE (Google it) so that we can wait
// asynchronously for the database connection to establish before listening
(async () => {
  await client.connect();

  app.listen(port, () => {
    console.log(`Example app listening at http://localhost:${port}`);
  });
})();


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

app.get("/add_subscriptions", async () => 
{insertSub('Test', 'Test', 'www.test.com', 'test', 'https://photos.google.com/photo/AF1QipPaVHLd5e7TYCQILYlq5aDvWkUpqU4GnfS5PSnY', 'test')
.then(result => {
  if (result) {
      console.log('Subscription inserted');
  }
})});