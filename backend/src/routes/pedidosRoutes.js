import express from 'express';
import * as pedidosController from '../controllers/pedidosController.js';

const router = express.Router();

router.get('/', pedidosController.list);
router.post('/', pedidosController.store);
router.put('/:id/status', pedidosController.updateStatus);

export default router;
