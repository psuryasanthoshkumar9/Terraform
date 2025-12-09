const express = require("express");
const mysql = require("mysql2");
const app = express();


const db = mysql.createConnection({
host: process.env.DB_HOST,
user: process.env.DB_USER,
password: process.env.DB_PASS,
database: process.env.DB_NAME
});


db.connect(err => {
if (err) console.log("DB Error", err);
else console.log("MySQL Connected");
});


app.get("/api", (req, res) => {
res.json({ message: "Backend working!" });
});


app.listen(5000, () => console.log("Backend running on port 5000"));