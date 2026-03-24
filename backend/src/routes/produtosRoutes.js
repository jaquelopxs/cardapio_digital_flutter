import express from "express";
import { pool } from "../config/db.js";

const router = express.Router();

// LISTAR TODOS OS PRODUTOS (Para o Flutter)
router.get("/", async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM produtos ORDER BY categoria, nome");
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: "Erro ao buscar produtos" });
  }
});

// ADICIONAR NOVO PRODUTO (Admin)
router.post("/", async (req, res) => {
  const { nome, descricao, preco, categoria, imagem } = req.body;
  try {
    const result = await pool.query(
      "INSERT INTO produtos (nome, descricao, preco, categoria, imagem) VALUES ($1, $2, $3, $4, $5) RETURNING *",
      [nome, descricao, preco, categoria, imagem]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: "Erro ao salvar produto" });
  }
});

// EDITAR PRODUTO (Admin)
router.put("/:id", async (req, res) => {
  const { id } = req.params;
  const { nome, descricao, preco, categoria, imagem } = req.body;
  try {
    const result = await pool.query(
      "UPDATE produtos SET nome=$1, descricao=$2, preco=$3, categoria=$4, imagem=$5 WHERE id=$6 RETURNING *",
      [nome, descricao, preco, categoria, imagem, id]
    );
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: "Erro ao editar produto" });
  }
});

// EXCLUIR PRODUTO (Admin)
router.delete("/:id", async (req, res) => {
  const { id } = req.params;
  try {
    await pool.query("DELETE FROM produtos WHERE id = $1", [id]);
    res.json({ message: "Produto removido com sucesso" });
  } catch (err) {
    res.status(500).json({ error: "Erro ao excluir produto" });
  }
});

export default router;
