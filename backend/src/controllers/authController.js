import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import { pool } from '../config/db.js';

// Função para validar formato de e-mail
const isEmailValid = (email) => {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
};

export const login = async (req, res) => {
  const { email, senha } = req.body;

  if (!email || !senha) {
    return res.status(400).json({ error: 'E-mail e senha são obrigatórios' });
  }

  if (!isEmailValid(email)) {
    return res.status(400).json({ error: 'E-mail em formato inválido' });
  }

  try {
    // Tenta buscar no admin primeiro, depois em usuarios (se houver)
    const result = await pool.query('SELECT * FROM admin WHERE email = $1', [email]);
    const user = result.rows[0];

    if (!user) {
      return res.status(401).json({ error: 'E-mail não encontrado' });
    }

    const senhaCorreta = await bcrypt.compare(senha, user.senha);
    if (!senhaCorreta) {
      return res.status(401).json({ error: 'Senha incorreta' });
    }

    const token = jwt.sign({ id: user.id, email: user.email }, process.env.JWT_SECRET, {
      expiresIn: '1d',
    });

    res.json({ token, user: { id: user.id, email: user.email, nome: user.nome } });
  } catch (error) {
    res.status(500).json({ error: 'Erro no servidor' });
  }
};

export const register = async (req, res) => {
  const { nome, email, telefone, senha } = req.body;

  if (!nome || !email || !senha) {
    return res.status(400).json({ error: 'Campos obrigatórios: nome, e-mail e senha' });
  }

  if (!isEmailValid(email)) {
    return res.status(400).json({ error: 'E-mail em formato inválido' });
  }

  try {
    const existingUser = await pool.query('SELECT * FROM admin WHERE email = $1', [email]);
    if (existingUser.rows.length > 0) {
      return res.status(400).json({ error: 'E-mail já cadastrado' });
    }

    const hashedSenha = await bcrypt.hash(senha, 10);
    const result = await pool.query(
      'INSERT INTO admin (nome, email, telefone, senha) VALUES ($1, $2, $3, $4) RETURNING id, email, nome',
      [nome, email, telefone, hashedSenha]
    );

    res.status(201).json({ message: 'Usuário cadastrado com sucesso!', user: result.rows[0] });
  } catch (error) {
    res.status(500).json({ error: 'Erro ao cadastrar usuário' });
  }
};

export const forgotPassword = async (req, res) => {
  const { email } = req.body;

  if (!email) {
    return res.status(400).json({ error: 'E-mail é obrigatório' });
  }

  if (!isEmailValid(email)) {
    return res.status(400).json({ error: 'E-mail em formato inválido' });
  }

  try {
    const result = await pool.query('SELECT * FROM admin WHERE email = $1', [email]);
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'E-mail não encontrado' });
    }

    // Simulação de envio de e-mail de recuperação
    // Em um sistema real, aqui você usaria o Nodemailer para enviar um link de redefinição
    res.json({ message: 'Instruções de recuperação enviadas para o seu e-mail!' });
  } catch (error) {
    res.status(500).json({ error: 'Erro no servidor' });
  }
};
