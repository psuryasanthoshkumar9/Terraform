const express = require('express');
const router = express.Router();
const ctrl = require('../controllers/policiesController');

// Search: /api/policies?q=POL-100
router.get('/', ctrl.search);
router.get('/:id', ctrl.getById);
router.post('/', ctrl.create);
router.put('/:id', ctrl.update);
router.delete('/:id', ctrl.remove);

module.exports = router;
