import express from 'express';
import * as produtosController from '../controllers/produtosController.js';

const router = express.Router();

router.get('/', produtosController.list);
router.post('/', produtosController.store);
router.put('/:id', produtosController.update);
router.delete('/:id', produtosController.destroy);

export default router;
