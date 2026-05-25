import { pool } from '../config/db.js';
import { io } from '../../server.js';

export const store = async (req, res) => {
  const { nome_cliente, telefone, forma_pagamento, total, itens } = req.body;
  
  const client = await pool.connect();
  try {
    await client.query('BEGIN');
    
    // Inserir Pedido
    const pedidoResult = await client.query(
      'INSERT INTO pedidos (nome_cliente, telefone, forma_pagamento, total, status) VALUES ($1, $2, $3, $4, $5) RETURNING *',
      [nome_cliente, telefone, forma_pagamento, total, 'recebido']
    );
    const pedidoId = pedidoResult.rows[0].id;

    // Inserir Itens
    for (const item of itens) {
      await client.query(
        'INSERT INTO itens_pedido (pedido_id, produto_id, quantidade, subtotal) VALUES ($1, $2, $3, $4)',
        [pedidoId, item.produto_id, item.quantidade, item.subtotal]
      );
    }

    await client.query('COMMIT');

    // Notificar via Socket.io (Opcional, mas bom para o Admin)
    io.emit('novoPedido', pedidoResult.rows[0]);

    res.status(201).json(pedidoResult.rows[0]);
  } catch (error) {
    await client.query('ROLLBACK');
    console.error('Erro ao criar pedido:', error);
    res.status(500).json({ error: 'Erro ao processar pedido' });
  } finally {
    client.release();
  }
};

export const list = async (req, res) => {
  try {
    // Busca pedidos com itens agrupados (usando JSON_AGG para facilitar no Flutter)
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

export const updateStatus = async (req, res) => {
  const { id } = req.params;
  const { status } = req.body;
  try {
    const result = await pool.query(
      'UPDATE pedidos SET status = $1 WHERE id = $2 RETURNING *',
      [status, id]
    );
    if (result.rowCount === 0) return res.status(404).json({ error: 'Pedido não encontrado' });
    
    // Notificar mudança de status
    io.emit('statusAlterado', result.rows[0]);
    
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: 'Erro ao atualizar status' });
  }
};
