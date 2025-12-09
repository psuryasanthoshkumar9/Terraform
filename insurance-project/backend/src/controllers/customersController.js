const db = require('../db');
const { validationResult } = require('express-validator');


exports.search = async (req, res) => {
const q = req.query.q || '';
const sql = `SELECT * FROM customers WHERE email ILIKE $1 OR first_name ILIKE $1 OR last_name ILIKE $1 ORDER BY created_at DESC LIMIT 50`;
const { rows } = await db.query(sql, [`%${q}%`]);
res.json(rows);
};


exports.getById = async (req, res) => {
const { id } = req.params;
const { rows } = await db.query('SELECT * FROM customers WHERE id = $1', [id]);
if (!rows.length) return res.status(404).json({ error: 'Not found' });
res.json(rows[0]);
};


exports.create = async (req, res) => {
const errors = validationResult(req);
if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });


const { first_name, last_name, email, phone, dob } = req.body;
try {
const insert = `INSERT INTO customers (first_name, last_name, email, phone, dob) VALUES ($1,$2,$3,$4,$5) RETURNING *`;
const { rows } = await db.query(insert, [first_name, last_name, email, phone, dob]);
res.status(201).json(rows[0]);
} catch (err) {
if (err.code === '23505') return res.status(400).json({ error: 'Email already exists' });
console.error(err);
res.status(500).json({ error: 'Server error' });
}
};


exports.update = async (req, res) => {
const { id } = req.params;
const fields = [];
const values = [];
let idx = 1;
for (const key of ['first_name','last_name','email','phone','dob']) {
if (req.body[key] !== undefined) {
fields.push(`${key} = $${idx}`);
values.push(req.body[key]);
idx++;
}
}
if (!fields.length) return res.status(400).json({ error: 'No fields to update' });
values.push(id);
const sql = `UPDATE customers SET ${fields.join(', ')} WHERE id = $${idx} RETURNING *`;
const { rows } = await db.query(sql, values);
if (!rows.length) return res.status(404).json({ error: 'Not found' });
res.json(rows[0]);
};


exports.remove = async (req, res) => {
const { id } = req.params;
const { rows } = await db.query('DELETE FROM customers WHERE id = $1 RETURNING id', [id]);
if (!rows.length) return res.status(404).json({ error: 'Not found' });
res.json({ deleted: true });
};