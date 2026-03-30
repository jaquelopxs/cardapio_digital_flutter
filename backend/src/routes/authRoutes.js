import express from 'express';
import { login, register, forgotPassword, verifyCode } from '../controllers/authController.js';

const router = express.Router();

router.post('/register', register);
router.post('/login', login);
router.post('/verify-code', verifyCode);
router.post('/forgot-password', forgotPassword);

export default router;
