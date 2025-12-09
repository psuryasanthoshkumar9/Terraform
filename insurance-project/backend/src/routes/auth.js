const express = require('express');
const router = express.Router();
const { body } = require('express-validator');
const controller = require('../controllers/authController');


router.post('/register', [
body('email').isEmail(),
body('password').isLength({ min: 6 }),
], controller.register);


router.post('/login', [
body('email').isEmail(),
body('password').notEmpty(),
], controller.login);


module.exports = router;