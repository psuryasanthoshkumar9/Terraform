const db = require('../db');
const jwt = require('jsonwebtoken');
const { validationResult } = require('express-validator');


const JWT_SECRET = process.env.JWT_SECRET || 'secret';


exports.register = async (req, res) => {
try {
const errors = validationResult(req);
if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });


const { email, password, role } = req.body;
const pwHash = await bcrypt.hash(password, 10);


const insert = `INSERT INTO app_users (email, password_hash, role) VALUES ($1,$2,$3) RETURNING id, email, role`;
const { rows } = await db.query(insert, [email, pwHash, role || 'agent']);
const user = rows[0];


const token = jwt.sign({ id: user.id, email: user.email, role: user.role }, JWT_SECRET, { expiresIn: process.env.JWT_EXPIRES_IN || '7d' });
res.json({ user, token });
} catch (err) {
if (err.code === '23505') return res.status(400).json({ error: 'Email already registered' });
console.error(err);
res.status(500).json({ error: 'Server error' });
}
};


exports.login = async (req, res) => {
try {
const errors = validationResult(req);
if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });


const { email, password } = req.body;
const q = `SELECT id, email, password_hash, role FROM app_users WHERE email = $1`;
const { rows } = await db.query(q, [email]);
if (rows.length === 0) return res.status(401).json({ error: 'Invalid credentials' });


const user = rows[0];
const match = await bcrypt.compare(password, user.password_hash);
if (!match) return res.status(401).json({ error: 'Invalid credentials' });


const token = jwt.sign({ id: user.id, email: user.email, role: user.role }, JWT_SECRET, { expiresIn: process.env.JWT_EXPIRES_IN || '7d' });
res.json({ user: { id: user.id, email: user.email, role: user.role }, token });
} catch (err) {
console.error(err);
res.status(500).json({ error: 'Server error' });
}
};