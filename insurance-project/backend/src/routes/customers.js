const express = require('express');
const router = express.Router();
const { body, query } = require('express-validator');
const auth = require('../middleware/authMiddleware');
const ctrl = require('../controllers/customersController');


router.get('/', auth, [query('q').optional()], ctrl.search);
router.get('/:id', auth, ctrl.getById);
router.post('/', auth, [
body('first_name').notEmpty(),
body('email').isEmail(),
], ctrl.create);
router.put('/:id', auth, ctrl.update);
router.delete('/:id', auth, ctrl.remove);


module.exports = router;