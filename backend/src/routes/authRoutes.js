import express from 'express';
<<<<<<< HEAD
import { login, register, forgotPassword, verifyCode, resetPassword } from '../controllers/authController.js';
=======
import { login, register, forgotPassword, verifyCode } from '../controllers/authController.js';
>>>>>>> 72bbee81325504357f9041a0baafdc846eaa2c26

const router = express.Router();

router.post('/register', register);
router.post('/login', login);
router.post('/verify-code', verifyCode);
router.post('/forgot-password', forgotPassword);
<<<<<<< HEAD
router.post('/reset-password', resetPassword);
=======
>>>>>>> 72bbee81325504357f9041a0baafdc846eaa2c26

export default router;
