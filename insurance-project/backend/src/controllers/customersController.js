const pool = require('../db');
const { validationResult } = require('express-validator');

const toInt = v => (v === undefined || v === null) ? null : Number(v);

exports.search = async (req, res) => {
  try {
    const q = (req.query.q || '').trim();
    if (!q) {
      const [rows] = await pool.query('SELECT * FROM customers ORDER BY id DESC LIMIT 100');
      return res.json(rows);
    }
    const like = `%${q}%`;
    const [rows] = await pool.query(
      'SELECT * FROM customers WHERE name LIKE ? OR phone LIKE ? ORDER BY id DESC LIMIT 100',
      [like, like]
    );
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Server error' });
  }
};

exports.getById = async (req, res) => {
  try {
    const id = req.params.id;
    const [rows] = await pool.query('SELECT * FROM customers WHERE id = ?', [id]);
    if (!rows.length) return res.status(404).json({ error: 'Not found' });
    res.json(rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Server error' });
  }
};

exports.create = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });

    const { name, age, phone } = req.body;
    const [result] = await pool.query(
      'INSERT INTO customers (name, age, phone) VALUES (?, ?, ?)',
      [name, toInt(age), phone]
    );
    const insertId = result.insertId;
    const [rows] = await pool.query('SELECT * FROM customers WHERE id = ?', [insertId]);
    res.status(201).json(rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Server error' });
  }
};

exports.update = async (req, res) => {
  try {
    const id = req.params.id;
    const allowed = ['name','age','phone'];
    const parts = [];
    const values = [];
    for (const k of allowed) {
      if (req.body[k] !== undefined) {
        parts.push(`${k} = ?`);
        values.push(k === 'age' ? toInt(req.body[k]) : req.body[k]);
      }
    }
    if (!parts.length) return res.status(400).json({ error: 'No fields to update' });
    values.push(id);
    const sql = `UPDATE customers SET ${parts.join(', ')} WHERE id = ?`;
    const [result] = await pool.query(sql, values);
    if (result.affectedRows === 0) return res.status(404).json({ error: 'Not found' });
    const [rows] = await pool.query('SELECT * FROM customers WHERE id = ?', [id]);
    res.json(rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Server error' });
  }
};

exports.remove = async (req, res) => {
  try {
    const id = req.params.id;
    const [result] = await pool.query('DELETE FROM customers WHERE id = ?', [id]);
    if (result.affectedRows === 0) return res.status(404).json({ error: 'Not found' });
    res.json({ deleted: true });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Server error' });
  }
};
