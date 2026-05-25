import { pool } from '../config/db.js';

/**
 * RF005: VISUALIZAR CARDÁPIO
 * Permite filtrar por categoria se fornecido via query params (?categoria=bebidas)
 */
export const list = async (req, res) => {
  const { categoria } = req.query;
  try {
    let query = 'SELECT * FROM produtos';
    let values = [];

    if (categoria) {
      query += ' WHERE categoria = $1';
      values.push(categoria);
    }

    query += ' ORDER BY id ASC';
    
    const result = await pool.query(query, values);
    res.json(result.rows);
  } catch (error) {
    console.error('Erro ao buscar produtos:', error);
    res.status(500).json({ error: 'Erro ao buscar produtos' });
  }
};

/**
 * CADASTRO DE PRODUTO (Geralmente usado pelo Admin)
 */
export const store = async (req, res) => {
  const { nome, descricao, imagem, preco, categoria } = req.body;
  
  if (!nome || !preco || !categoria) {
    return res.status(400).json({ error: 'Nome, preço e categoria são obrigatórios.' });
  }

  try {
    const result = await pool.query(
      'INSERT INTO produtos (nome, descricao, imagem, preco, categoria) VALUES ($1, $2, $3, $4, $5) RETURNING *',
      [nome, descricao, imagem, preco, categoria]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error('Erro ao cadastrar produto:', error);
    res.status(500).json({ error: 'Erro ao cadastrar produto' });
  }
};

/**
 * ATUALIZAÇÃO DE PRODUTO
 */
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
    console.error('Erro ao atualizar produto:', error);
    res.status(500).json({ error: 'Erro ao atualizar produto' });
  }
};

/**
 * EXCLUSÃO DE PRODUTO
 */
export const destroy = async (req, res) => {
  const { id } = req.params;
  try {
    const result = await pool.query('DELETE FROM produtos WHERE id = $1', [id]);
    if (result.rowCount === 0) return res.status(404).json({ error: 'Produto não encontrado' });
    res.json({ message: 'Produto excluído com sucesso' });
  } catch (error) {
    console.error('Erro ao excluir produto:', error);
    res.status(500).json({ error: 'Erro ao excluir produto' });
  }
};
