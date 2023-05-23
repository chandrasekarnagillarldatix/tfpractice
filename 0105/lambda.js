import { MongoClient, ServerApiVersion } from 'mongodb';
/*
const AWS_ACCESS_KEY_ID = process.env.AWS_ACCESS_KEY_ID;
const AWS_SECRET_ACCESS_KEY = process.env.AWS_SECRET_ACCESS_KEY;
const AWS_SESSION_TOKEN = process.env.AWS_SESSION_TOKEN;

const uri = "mongodb+srv://<AWS access key>:<AWS secret key>@cluster0.jpelm7r.mongodb.net/?authSource=%24external&authMechanism=MONGODB-AWS&retryWrites=true&w=majority&authMechanismProperties=AWS_SESSION_TOKEN:<session token (for AWS IAM Roles)>"
    .replace("<AWS access key>", AWS_ACCESS_KEY_ID)
    .replace("<AWS secret key>", AWS_SECRET_ACCESS_KEY)
    .replace("<session token (for AWS IAM Roles)>",AWS_SESSION_TOKEN);
*/

const uri = "mongodb+srv://cluster0.jpelm7r.mongodb.net/DBNAME?authSource=$external&authMechanism=MONGODB-AWS&retryWrites=true&w=majority";

// Create a MongoClient with a MongoClientOptions object to set the Stable API version
const client = new MongoClient(uri, {
  serverApi: {
    version: ServerApiVersion.v1,
    strict: true,
    deprecationErrors: true,
  }
});

export async function run() {
  try {
    console.log("Inside TRY");
    // Connect the client to the server    (optional starting in v4.7)
    await client.connect();
    // Send a ping to confirm a successful connection
    await client.db("sample_analytics").command({ ping: 1 });
    console.log("Pinged your deployment. You successfully connected to MongoDB!");

    const db = client.db("sample_analytics");
    let collection = db.collection('customers');

    let query = { username: 'fmiller' }
    let res = await collection.findOne(query);

    console.log(res);


  } finally {
    // Ensures that the client will close when you finish/error
    await client.close();
  }
}
run().catch(console.dir);