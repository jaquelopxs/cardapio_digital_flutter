import express from "express";
import { pool } from "../config/db.js";

const router = express.Router();

// FINALIZAR PEDIDO (Cliente Flutter)
router.post("/", async (req, res) => {
  const { nome_cliente, telefone, forma_pagamento, total, itens } = req.body;
  const client = await pool.connect();

  try {
    await client.query("BEGIN");
    
    // Inserir pedido
    const pedidoResult = await client.query(
      "INSERT INTO pedidos (nome_cliente, telefone, forma_pagamento, total, status) VALUES ($1, $2, $3, $4, 'pendente') RETURNING id",
      [nome_cliente, telefone, forma_pagamento, total]
    );
    const pedidoId = pedidoResult.rows[0].id;

    // Inserir itens do pedido
    for (let item of itens) {
      const subtotal = item.preco_unitario * item.quantidade;
      await client.query(
        "INSERT INTO itens_pedido (pedido_id, produto_id, quantidade, subtotal) VALUES ($1, $2, $3, $4)",
        [pedidoId, item.produto_id, item.quantidade, subtotal]
      );
    }

    await client.query("COMMIT");
    res.status(201).json({ message: "Pedido realizado com sucesso", pedido_id: pedidoId });
  } catch (err) {
    await client.query("ROLLBACK");
    res.status(500).json({ error: "Erro ao processar pedido" });
  } finally {
    client.release();
  }
});

// LISTAR TODOS OS PEDIDOS (Painel Admin)
router.get("/", async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM pedidos ORDER BY data_pedido DESC");
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: "Erro ao buscar pedidos" });
  }
});

// BUSCAR PEDIDO POR ID (Acompanhamento)
router.get("/:id", async (req, res) => {
  const { id } = req.params;
  try {
    const pedido = await pool.query("SELECT * FROM pedidos WHERE id = $1", [id]);
    if (pedido.rows.length === 0) return res.status(404).json({ error: "Pedido não encontrado" });
    
    const itens = await pool.query(
      "SELECT i.*, p.nome FROM itens_pedido i JOIN produtos p ON i.produto_id = p.id WHERE i.pedido_id = $1",
      [id]
    );
    
    res.json({ ...pedido.rows[0], itens: itens.rows });
  } catch (err) {
    res.status(500).json({ error: "Erro ao buscar pedido" });
  }
});

// ATUALIZAR STATUS DO PEDIDO (Admin)
router.put("/:id/status", async (req, res) => {
  const { id } = req.params;
  const { status } = req.body;
  try {
    const result = await pool.query(
      "UPDATE pedidos SET status = $1 WHERE id = $2 RETURNING *",
      [status, id]
    );
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: "Erro ao atualizar status" });
  }
});

export default router;
