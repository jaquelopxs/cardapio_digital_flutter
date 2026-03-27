import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import crypto from 'crypto';
import { pool } from '../config/db.js';
import { transporter } from '../config/mailer.js';

// Utilitário para validar formato de e-mail
const isEmailValid = (email) => {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
};

/**
 * RF002: CADASTRO DE USUÁRIO
 * Inclui validação de campos obrigatórios e confirmação de senha.
 */
export const register = async (req, res) => {
  const { nome, email, telefone, senha, confirmacaoSenha } = req.body;

  // Verificação de campos obrigatórios (RF002)
  if (!nome || !email || !telefone || !senha || !confirmacaoSenha) {
    return res.status(400).json({ error: 'Todos os campos são obrigatórios.' });
  }

  // Validação de formato de e-mail (RF002)
  if (!isEmailValid(email)) {
    return res.status(400).json({ error: 'Formato de e-mail inválido.' });
  }

  // Verificação de igualdade de senhas (RF002)
  if (senha !== confirmacaoSenha) {
    return res.status(400).json({ error: 'A senha e a confirmação de senha devem ser iguais.' });
  }

  try {
    const existingUser = await pool.query('SELECT id FROM admin WHERE email = $1', [email]);
    if (existingUser.rows.length > 0) {
      return res.status(400).json({ error: 'E-mail já cadastrado no sistema.' });
    }

    const hashedSenha = await bcrypt.hash(senha, 10);
    const verificacaoToken = crypto.randomBytes(32).toString('hex');

    const result = await pool.query(
      'INSERT INTO admin (nome, email, telefone, senha, verificacao_token, is_verificado) VALUES ($1, $2, $3, $4, $5, $6) RETURNING id, nome, email, telefone',
      [nome, email, telefone, hashedSenha, verificacaoToken, false]
    );

    const urlVerificacao = `http://localhost:3000/auth/verify/${verificacaoToken}`;

    await transporter.sendMail({
      from: '"Cardápio Digital" <seu-email@gmail.com>',
      to: email,
      subject: 'Verifique sua conta de Administrador',
      html: `<h2>Olá, ${nome}!</h2>
             <p>Clique no link abaixo para ativar sua conta:</p>
             <a href="${urlVerificacao}" style="background-color: #4CAF50; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px;">Ativar Minha Conta</a>`
    });

    res.status(201).json({ 
      message: 'Usuário registrado! Verifique seu e-mail para ativar a conta.', 
      user: result.rows[0] 
    });
  } catch (error) {
    console.error('Erro no registro:', error);
    res.status(500).json({ error: 'Erro ao processar cadastro.' });
  }
};

/**
 * VERIFICAÇÃO DO TOKEN
 */
export const verifyEmail = async (req, res) => {
  const { token } = req.params;
  try {
    const result = await pool.query(
      'UPDATE admin SET is_verificado = true, verificacao_token = NULL WHERE verificacao_token = $1 RETURNING id',
      [token]
    );
    if (result.rowCount === 0) return res.status(400).send('<h1>Link inválido ou expirado.</h1>');
    res.send('<h1>E-mail verificado com sucesso!</h1>');
  } catch (error) {
    res.status(500).send('Erro interno ao verificar e-mail.');
  }
};

/**
 * RF001: LOGIN
 * Valida preenchimento, formato de e-mail e status de verificação.
 */
export const login = async (req, res) => {
  const { email, senha } = req.body;

  if (!email || !senha) {
    return res.status(400).json({ error: 'E-mail e senha são obrigatórios.' });
  }

  if (!isEmailValid(email)) {
    return res.status(400).json({ error: 'Formato de e-mail inválido.' });
  }

  try {
    const result = await pool.query('SELECT * FROM admin WHERE email = $1', [email]);
    const user = result.rows[0];

    if (!user) return res.status(401).json({ error: 'Credenciais inválidas.' });

    if (!user.is_verificado) {
      return res.status(401).json({ error: 'Conta não ativada. Verifique seu e-mail.' });
    }

    const senhaCorreta = await bcrypt.compare(senha, user.senha);
    if (!senhaCorreta) return res.status(401).json({ error: 'Credenciais inválidas.' });

    const token = jwt.sign(
      { id: user.id, email: user.email },
      process.env.JWT_SECRET,
      { expiresIn: '1d' }
    );

    res.json({ token, user: { id: user.id, email: user.email, nome: user.nome, telefone: user.telefone } });
  } catch (error) {
    res.status(500).json({ error: 'Erro interno no servidor.' });
  }
};

/**
 * RF003: ESQUECEU A SENHA
 * Gera um novo hash temporário ou link de recuperação (Exemplo funcional).
 */
export const forgotPassword = async (req, res) => {
  const { email } = req.body;

  if (!email || !isEmailValid(email)) {
    return res.status(400).json({ error: 'E-mail válido é obrigatório.' });
  }

  try {
    const result = await pool.query('SELECT nome FROM admin WHERE email = $1', [email]);
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'E-mail não localizado no sistema.' });
    }

    const nome = result.rows[0].nome;

    // Em um sistema real, você geraria um token de reset. 
    // Aqui simulamos o envio conforme o RF003.
    await transporter.sendMail({
      from: '"Cardápio Digital" <seu-email@gmail.com>',
      to: email,
      subject: 'Recuperação de Senha',
      html: `<h2>Olá, ${nome}</h2>
             <p>Recebemos uma solicitação de recuperação de senha para sua conta.</p>
             <p>Clique no link abaixo para definir uma nova senha:</p>
             <a href="http://localhost:3000/reset-password">Redefinir Senha</a>`
    });

    res.json({ message: 'Instruções de recuperação enviadas para o e-mail informado.' });
  } catch (error) {
    console.error('Erro na recuperação:', error);
    res.status(500).json({ error: 'Erro ao processar recuperação de senha.' });
  }
};