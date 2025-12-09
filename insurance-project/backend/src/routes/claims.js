const express = require('express');
exports.create = async (req, res) => {
const { claim_number, policy_id, claim_date, amount, status, description } = req.body;
try {
const sql = `INSERT INTO claims (claim_number, policy_id, claim_date, amount, status, description) VALUES ($1,$2,$3,$4,$5,$6) RETURNING *`;
const { rows } = await db.query(sql, [claim_number, policy_id, claim_date, amount, status || 'filed', description]);
res.status(201).json(rows[0]);
} catch (err) {
if (err.code === '23503') return res.status(400).json({ error: 'Invalid policy_id' });
if (err.code === '23505') return res.status(400).json({ error: 'Claim number already exists' });
console.error(err);
res.status(500).json({ error: 'Server error' });
}
};


exports.update = async (req, res) => {
const { id } = req.params;
const fields = [];
const values = [];
let idx = 1;
for (const key of ['claim_number','policy_id','claim_date','amount','status','description']) {
if (req.body[key] !== undefined) {
fields.push(`${key} = $${idx}`);
values.push(req.body[key]);
idx++;
}
}
if (!fields.length) return res.status(400).json({ error: 'No fields to update' });
values.push(id);
const sql = `UPDATE claims SET ${fields.join(', ')} WHERE id = $${idx} RETURNING *`;
const { rows } = await db.query(sql, values);
if (!rows.length) return res.status(404).json({ error: 'Not found' });
res.json(rows[0]);
};


exports.remove = async (req, res) => {
const { id } = req.params;
const { rows } = await db.query('DELETE FROM claims WHERE id = $1 RETURNING id', [id]);
if (!rows.length) return res.status(404).json({ error: 'Not found' });
res.json({ deleted: true });
};