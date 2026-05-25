import { pool } from '../config/db.js';

export const list = async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM produtos ORDER BY id ASC');
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: 'Erro ao buscar produtos' });
  }
};

export const store = async (req, res) => {
  const { nome, descricao, imagem, preco, categoria } = req.body;
  try {
    const result = await pool.query(
      'INSERT INTO produtos (nome, descricao, imagem, preco, categoria) VALUES ($1, $2, $3, $4, $5) RETURNING *',
      [nome, descricao, imagem, preco, categoria]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: 'Erro ao cadastrar produto' });
  }
};

export const update = async (req, res) => {
  const { id } = req.params;
  const { nome, descricao, imagem, preco, categoria } = req.body;
  try {
    const result = await pool.query(
      'UPDATE produtos SET nome = $1, descricao = $2, imagem = $3, preco = $4, categoria = $5 WHERE id = $6 RETURNING *',
      [nome, descricao, imagem, preco, categoria, id]
    );
    if (result.rowCount === 0) return res.status(404).json({ error: 'Produto não encontrado' });
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: 'Erro ao atualizar produto' });
  }
};

export const destroy = async (req, res) => {
  const { id } = req.params;
  try {
    const result = await pool.query('DELETE FROM produtos WHERE id = $1', [id]);
    if (result.rowCount === 0) return res.status(404).json({ error: 'Produto não encontrado' });
    res.json({ message: 'Produto excluído com sucesso' });
  } catch (error) {
    res.status(500).json({ error: 'Erro ao excluir produto' });
  }
};
