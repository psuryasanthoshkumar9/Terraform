const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const dotenv = require('dotenv');
dotenv.config();


const authRoutes = require('./routes/auth');
const customersRoutes = require('./routes/customers');
const policiesRoutes = require('./routes/policies');
const claimsRoutes = require('./routes/claims');
const paymentsRoutes = require('./routes/payments');


const app = express();
app.use(cors());
app.use(bodyParser.json());


app.use('/api/auth', authRoutes);
app.use('/api/customers', customersRoutes);
app.use('/api/policies', policiesRoutes);
app.use('/api/claims', claimsRoutes);
app.use('/api/payments', paymentsRoutes);


app.get('/', (req, res) => res.json({ ok: true, message: 'Insurance backend running' }));


const port = process.env.PORT || 4000;
app.listen(port, () => console.log(`Server listening on port ${port}`));