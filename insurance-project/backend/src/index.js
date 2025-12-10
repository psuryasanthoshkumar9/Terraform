const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const dotenv = require('dotenv');
dotenv.config();

const customersRoutes = require('./routes/customers');
const policiesRoutes = require('./routes/policies');

const app = express();
app.use(cors());
app.use(bodyParser.json());

// Routes
app.use('/api/customers', customersRoutes);
app.use('/api/policies', policiesRoutes);

// Health
app.get('/', (req, res) => res.json({ ok: true, service: 'insurance-backend' }));

const port = process.env.PORT || 5000;
app.listen(port, () => console.log(`Backend listening on port ${port}`));
