const pool = require('../db');

exports.search = async (req, res) => {
  try {
    const q = (req.query.q || '').trim();
    if (!q) {
      const [rows] = await pool.query(
        `SELECT p.*, c.name as customer_name, c.phone as customer_phone
         FROM policies p
         LEFT JOIN customers c ON p.customer_id = c.id
         ORDER BY p.id DESC LIMIT 100`
      );
      return res.json(rows);
    }
    const like = `%${q}%`;
    const [rows] = await pool.query(
      `SELECT p.*, c.name as customer_name, c.phone as customer_phone
       FROM policies p
       LEFT JOIN customers c ON p.customer_id = c.id
       WHERE p.policy_type LIKE ? OR p.id = ? OR c.name LIKE ?
       ORDER BY p.id DESC LIMIT 100`,
      [like, isNaN(Number(q)) ? -1 : Number(q), like]
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
    const [rows] = await pool.query(
      `SELECT p.*, c.name as customer_name, c.phone as customer_phone
       FROM policies p LEFT JOIN customers c ON p.customer_id = c.id WHERE p.id = ?`,
      [id]
    );
    if (!rows.length) return res.status(404).json({ error: 'Not found' });
    res.json(rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Server error' });
  }
};

exports.create = async (req, res) => {
  try {
    const { customer_id, policy_type, premium } = req.body;
    // basic validation
    if (!customer_id || !policy_type || premium === undefined) {
      return res.status(400).json({ error: 'customer_id, policy_type and premium are required' });
    }
    const [result] = await pool.query(
      'INSERT INTO policies (customer_id, policy_type, premium) VALUES (?, ?, ?)',
      [customer_id, policy_type, premium]
    );
    const insertId = result.insertId;
    const [rows] = await pool.query('SELECT * FROM policies WHERE id = ?', [insertId]);
    res.status(201).json(rows[0]);
  } catch (err) {
    // foreign key error code for mysql is ER_NO_REFERENCED_ROW_2 (1452)
    if (err && err.code === 'ER_NO_REFERENCED_ROW_2') {
      return res.status(400).json({ error: 'Invalid customer_id' });
    }
    console.error(err);
    res.status(500).json({ error: 'Server error' });
  }
};

exports.update = async (req, res) => {
  try {
    const id = req.params.id;
    const allowed = ['customer_id','policy_type','premium'];
    const parts = [];
    const values = [];
    for (const k of allowed) {
      if (req.body[k] !== undefined) {
        parts.push(`${k} = ?`);
        values.push(req.body[k]);
      }
    }
    if (!parts.length) return res.status(400).json({ error: 'No fields to update' });
    values.push(id);
    const sql = `UPDATE policies SET ${parts.join(', ')} WHERE id = ?`;
    const [result] = await pool.query(sql, values);
    if (result.affectedRows === 0) return res.status(404).json({ error: 'Not found' });
    const [rows] = await pool.query('SELECT * FROM policies WHERE id = ?', [id]);
    res.json(rows[0]);
  } catch (err) {
    if (err && err.code === 'ER_NO_REFERENCED_ROW_2') {
      return res.status(400).json({ error: 'Invalid customer_id' });
    }
    console.error(err);
    res.status(500).json({ error: 'Server error' });
  }
};

exports.remove = async (req, res) => {
  try {
    const id = req.params.id;
    const [result] = await pool.query('DELETE FROM policies WHERE id = ?', [id]);
    if (result.affectedRows === 0) return res.status(404).json({ error: 'Not found' });
    res.json({ deleted: true });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Server error' });
  }
};
