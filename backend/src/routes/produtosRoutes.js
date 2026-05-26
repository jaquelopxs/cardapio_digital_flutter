import express from 'express';
import * as produtosController from '../controllers/produtosController.js';
import { authMiddleware } from '../middlewares/authMiddleware.js';

const router = express.Router();

router.get('/', produtosController.list);
router.post('/', authMiddleware, produtosController.store);
router.put('/:id', authMiddleware, produtosController.update);
router.delete('/:id', authMiddleware, produtosController.destroy);

export default router;
