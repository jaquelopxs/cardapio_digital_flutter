import { pool } from '../config/db.js';
import { io } from '../../server.js';

/**
 * RF009: FINALIZAR PEDIDO
 */
export const store = async (req, res) => {
  const { nome_cliente, telefone, forma_pagamento, total, itens } = req.body;
  
  if (!nome_cliente || !forma_pagamento || !itens || itens.length === 0) {
    return res.status(400).json({ error: 'Dados do pedido incompletos.' });
  }

  const client = await pool.connect();
  try {
    await client.query('BEGIN');
    
    // Inserir Pedido
    const pedidoResult = await client.query(
      'INSERT INTO pedidos (nome_cliente, telefone, forma_pagamento, total, status) VALUES ($1, $2, $3, $4, $5) RETURNING *',
      [nome_cliente, telefone, forma_pagamento, total, 'pendente']
    );
    const pedidoId = pedidoResult.rows[0].id;

    // Inserir Itens (RF006)
    for (const item of itens) {
      if (!item.produto_id || !item.quantidade || !item.subtotal) {
        throw new Error('Item do pedido malformatado.');
      }
      await client.query(
        'INSERT INTO itens_pedido (pedido_id, produto_id, quantidade, subtotal) VALUES ($1, $2, $3, $4)',
        [pedidoId, item.produto_id, item.quantidade, item.subtotal]
      );
    }

    await client.query('COMMIT');

    // Notificar via Socket.io para o painel administrativo
    io.emit('novoPedido', pedidoResult.rows[0]);

    res.status(201).json({
      message: 'Pedido realizado com sucesso!',
      pedido: pedidoResult.rows[0]
    });
  } catch (error) {
    await client.query('ROLLBACK');
    console.error('Erro ao criar pedido:', error);
    res.status(500).json({ error: error.message || 'Erro ao processar pedido' });
  } finally {
    client.release();
  }
};

/**
 * RF007: VISUALIZAR CARRINHO / LISTAR PEDIDOS
 */
export const list = async (req, res) => {
  try {
    const query = `
      SELECT p.*, 
             JSON_AGG(JSON_BUILD_OBJECT(
               'id', ip.id,
               'produto_id', ip.produto_id,
               'quantidade', ip.quantidade,
               'subtotal', ip.subtotal,
               'nome_produto', pr.nome
             )) as itens
      FROM pedidos p
      LEFT JOIN itens_pedido ip ON p.id = ip.pedido_id
      LEFT JOIN produtos pr ON ip.produto_id = pr.id
      GROUP BY p.id
      ORDER BY p.data_pedido DESC
    `;
    const result = await pool.query(query);
    res.json(result.rows);
  } catch (error) {
    console.error('Erro ao listar pedidos:', error);
    res.status(500).json({ error: 'Erro ao buscar pedidos' });
  }
};

/**
 * ATUALIZAR STATUS (Admin)
 */
export const updateStatus = async (req, res) => {
  const { id } = req.params;
  const { status } = req.body;

  if (!status) return res.status(400).json({ error: 'Status é obrigatório.' });

  try {
    const result = await pool.query(
      'UPDATE pedidos SET status = $1 WHERE id = $2 RETURNING *',
      [status, id]
    );
    if (result.rowCount === 0) return res.status(404).json({ error: 'Pedido não encontrado' });
    
    // Notificar mudança de status via Socket.io
    io.emit('statusAlterado', result.rows[0]);
    
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Erro ao atualizar status:', error);
    res.status(500).json({ error: 'Erro ao atualizar status' });
  }
};
