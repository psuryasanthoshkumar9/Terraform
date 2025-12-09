const db = require('../db');


exports.search = async (req, res) => {
const q = req.query.q || '';
const sql = `SELECT p.*, c.first_name, c.last_name FROM policies p JOIN customers c ON p.customer_id = c.id WHERE p.policy_number ILIKE $1 OR c.first_name ILIKE $1 OR c.email ILIKE $1 ORDER BY p.created_at DESC LIMIT 50`;
const { rows } = await db.query(sql, [`%${q}%`]);
res.json(rows);
};


exports.getById = async (req, res) => {
const { id } = req.params;
const sql = `SELECT p.*, c.* FROM policies p JOIN customers c ON p.customer_id = c.id WHERE p.id = $1`;
const { rows } = await db.query(sql, [id]);
if (!rows.length) return res.status(404).json({ error: 'Not found' });
res.json(rows[0]);
};


exports.create = async (req, res) => {
const { policy_number, customer_id, policy_type, start_date, end_date, premium_amount, status } = req.body;
try {
const sql = `INSERT INTO policies (policy_number, customer_id, policy_type, start_date, end_date, premium_amount, status) VALUES ($1,$2,$3,$4,$5,$6,$7) RETURNING *`;
const { rows } = await db.query(sql, [policy_number, customer_id, policy_type, start_date, end_date, premium_amount, status || 'active']);
res.status(201).json(rows[0]);
} catch (err) {
if (err.code === '23503') return res.status(400).json({ error: 'Invalid customer_id' });
if (err.code === '23505') return res.status(400).json({ error: 'Policy number already exists' });
console.error(err);
res.status(500).json({ error: 'Server error' });
}
};


exports.update = async (req, res) => {
const { id } = req.params;
const fields = [];
const values = [];
let idx = 1;
for (const key of ['policy_number','policy_type','start_date','end_date','premium_amount','status','customer_id']) {
if (req.body[key] !== undefined) {
fields.push(`${key} = $${idx}`);
values.push(req.body[key]);
idx++;
}
}
if (!fields.length) return res.status(400).json({ error: 'No fields to update' });
values.push(id);
const sql = `UPDATE policies SET ${fields.join(', ')} WHERE id = $${idx} RETURNING *`;
const { rows } = await db.query(sql, values);
if (!rows.length) return res.status(404).json({ error: 'Not found' });
res.json(rows[0]);
};


exports.remove = async (req, res) => {
const { id } = req.params;
const { rows } = await db.query('DELETE FROM policies WHERE id = $1 RETURNING id', [id]);
if (!rows.length) return res.status(404).json({ error: 'Not found' });
res.json({ deleted: true });
};