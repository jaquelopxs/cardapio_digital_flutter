import express from 'express';
import * as pedidosController from '../controllers/pedidosController.js';
import { authMiddleware } from '../middlewares/authMiddleware.js';

const router = express.Router();

// RF009: Finalizar Pedido (Protegido por login)
router.post('/', authMiddleware, pedidosController.store);

// RF007: Visualizar Carrinho (Geralmente listagem de pedidos feitos pelo usuário)
router.get('/', authMiddleware, pedidosController.list);

// Atualizar status (Geralmente por Admin)
router.put('/:id/status', authMiddleware, pedidosController.updateStatus);

export default router;
