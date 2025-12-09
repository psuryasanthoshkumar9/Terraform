const { Pool } = require('pg');
const dotenv = require('dotenv');
dotenv.config();


const pool = new Pool({
host: process.env.DATABASE_HOST || 'localhost',
port: process.env.DATABASE_PORT ? Number(process.env.DATABASE_PORT) : 5432,
database: process.env.DATABASE_NAME,
user: process.env.DATABASE_USER,
password: process.env.DATABASE_PASSWORD,
});


module.exports = {
query: (text, params) => pool.query(text, params),
pool,
};