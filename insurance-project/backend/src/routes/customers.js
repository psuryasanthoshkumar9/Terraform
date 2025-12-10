const express = require('express');
const { body, query } = require('express-validator');
const router = express.Router();
const ctrl = require('../controllers/customersController');

// Search: /api/customers?q=krishna
router.get('/', ctrl.search);

// Get
router.get('/:id', ctrl.getById);

// Create
router.post('/',
  body('name').notEmpty().withMessage('name required'),
  body('age').optional().isInt({ min: 0 }),
  ctrl.create
);

// Update
router.put('/:id', ctrl.update);

// Delete
router.delete('/:id', ctrl.remove);

module.exports = router;
