import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import { pool } from '../config/db.js';
import { transporter } from '../config/mailer.js';

// Utilitário para validar formato de e-mail
const isEmailValid = (email) => {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
};

// Gerar código de 6 dígitos
const generatePinCode = () => {
  return Math.floor(100000 + Math.random() * 900000).toString();
};

/**
 * RF002: CADASTRO DE USUÁRIO
 */
export const register = async (req, res) => {
  const { nome, email, telefone, senha, confirmacaoSenha } = req.body;

  if (!nome || !email || !telefone || !senha || !confirmacaoSenha) {
    return res.status(400).json({ error: 'Todos os campos são obrigatórios.' });
  }

  if (!isEmailValid(email)) {
    return res.status(400).json({ error: 'Formato de e-mail inválido.' });
  }

  if (senha !== confirmacaoSenha) {
    return res.status(400).json({ error: 'As senhas não coincidem.' });
  }

  try {
    const existingUser = await pool.query('SELECT id FROM usuarios WHERE email = $1', [email]);
    if (existingUser.rows.length > 0) {
      return res.status(400).json({ error: 'E-mail já cadastrado.' });
    }

    const hashedSenha = await bcrypt.hash(senha, 10);
    const verificacaoCodigo = generatePinCode();

    const result = await pool.query(
      'INSERT INTO usuarios (nome, email, telefone, senha, verificacao_codigo, is_verificado) VALUES ($1, $2, $3, $4, $5, $6) RETURNING id, nome, email',
      [nome, email, telefone, hashedSenha, verificacaoCodigo, false]
    );

    console.log(`\n>>> CÓDIGO PARA ${email}: ${verificacaoCodigo}\n`);

    try {
      await transporter.sendMail({
        from: `"Empório Sophia" <${process.env.MAIL_USER}>`,
        to: email,
        subject: 'Seu Código de Verificação',
        html: `<h2>Bem-vindo, ${nome}!</h2>
               <p>Seu código de verificação para o Empório Sophia é:</p>
               <h1 style="color: #FF5722; font-size: 32px; letter-spacing: 5px; background: #f4f4f4; padding: 10px; display: inline-block;">${verificacaoCodigo}</h1>
               <p>Digite este código no aplicativo para ativar sua conta.</p>`
      });
      
      res.status(201).json({ 
        message: 'Cadastro realizado! Digite o código enviado ao seu e-mail.', 
        email: email
      });
    } catch (mailError) {
      res.status(201).json({ 
        message: 'Cadastro realizado! (Verifique o código no console do servidor)', 
        email: email,
        dev_code: verificacaoCodigo
      });
    }
  } catch (error) {
    console.error('Erro no registro:', error);
    res.status(500).json({ error: 'Erro ao processar cadastro.' });
  }
};

/**
 * VERIFICAÇÃO DO CÓDIGO (PIN)
 */
export const verifyCode = async (req, res) => {
  const { email, codigo } = req.body;
  
  if (!email || !codigo) {
    return res.status(400).json({ error: 'E-mail e código são obrigatórios.' });
  }

  try {
    const result = await pool.query(
      'UPDATE usuarios SET is_verificado = true, verificacao_codigo = NULL WHERE email = $1 AND verificacao_codigo = $2 RETURNING id',
      [email, codigo]
    );
    
    if (result.rowCount === 0) {
      return res.status(400).json({ error: 'Código inválido ou e-mail incorreto.' });
    }
    
    res.json({ message: 'Conta verificada com sucesso! Faça seu login.' });
  } catch (error) {
    res.status(500).json({ error: 'Erro ao verificar código.' });
  }
};

/**
 * RF001: LOGIN
 */
export const login = async (req, res) => {
  const { email, senha } = req.body;

  try {
    const result = await pool.query('SELECT * FROM usuarios WHERE email = $1', [email]);
    const user = result.rows[0];

    if (!user) return res.status(401).json({ error: 'Usuário não encontrado.' });

    if (!user.is_verificado) {
      return res.status(401).json({ error: 'Conta não verificada. Verifique seu e-mail.' });
    }

    const senhaCorreta = await bcrypt.compare(senha, user.senha);
    if (!senhaCorreta) return res.status(401).json({ error: 'Senha incorreta.' });

    const token = jwt.sign(
      { id: user.id, is_admin: user.is_admin || false }, 
      process.env.JWT_SECRET, 
      { expiresIn: '1d' }
    );

    res.json({ 
      token, 
      user: { 
        id: user.id, 
        email: user.email, 
        nome: user.nome, 
        telefone: user.telefone,
        is_admin: user.is_admin || false 
      } 
    });
  } catch (error) {
    res.status(500).json({ error: 'Erro interno no servidor.' });
  }
};

/**
 * RF003: ESQUECEU A SENHA — envia código por e-mail
 */
export const forgotPassword = async (req, res) => {
  const { email } = req.body;

  if (!email || !isEmailValid(email)) {
    return res.status(400).json({ error: 'Informe um e-mail válido.' });
  }

  try {
    const result = await pool.query('SELECT nome FROM usuarios WHERE email = $1', [email]);
    if (result.rows.length === 0) return res.status(404).json({ error: 'E-mail não cadastrado.' });

    const resetCodigo = generatePinCode();
    await pool.query('UPDATE usuarios SET verificacao_codigo = $1 WHERE email = $2', [resetCodigo, email]);

    console.log(`\n>>> CÓDIGO DE RESET PARA ${email}: ${resetCodigo}\n`);

    try {
      await transporter.sendMail({
        from: `"Empório Sophia" <${process.env.MAIL_USER}>`,
        to: email,
        subject: 'Recuperação de Senha - Empório Sophia',
        html: `<h2>Redefinição de Senha</h2>
               <p>Olá, ${result.rows[0].nome}!</p>
               <p>Seu código para redefinir a senha é:</p>
               <h1 style="color: #5A0B1E; font-size: 32px; letter-spacing: 5px; background: #f4f4f4; padding: 10px; display: inline-block;">${resetCodigo}</h1>
               <p>Se você não solicitou a redefinição, ignore este e-mail.</p>`
      });
    } catch (mailError) {
      console.error('Erro ao enviar e-mail:', mailError);
    }

    res.json({ message: 'Código enviado ao seu e-mail.' });
  } catch (error) {
    res.status(500).json({ error: 'Erro ao processar solicitação.' });
  }
};

/**
 * RF003: REDEFINIR SENHA — verifica código e atualiza senha
 */
export const resetPassword = async (req, res) => {
  const { email, codigo, novaSenha } = req.body;

  if (!email || !codigo || !novaSenha) {
    return res.status(400).json({ error: 'E-mail, código e nova senha são obrigatórios.' });
  }

  if (novaSenha.length < 6) {
    return res.status(400).json({ error: 'A nova senha deve ter pelo menos 6 caracteres.' });
  }

  try {
    const result = await pool.query(
      'SELECT id FROM usuarios WHERE email = $1 AND verificacao_codigo = $2',
      [email, codigo]
    );

    if (result.rows.length === 0) {
      return res.status(400).json({ error: 'Código inválido ou expirado.' });
    }

    const hashedSenha = await bcrypt.hash(novaSenha, 10);

    await pool.query(
      'UPDATE usuarios SET senha = $1, verificacao_codigo = NULL WHERE email = $2',
      [hashedSenha, email]
    );

    res.json({ message: 'Senha redefinida com sucesso! Faça seu login.' });
  } catch (error) {
    console.error('Erro ao redefinir senha:', error);
    res.status(500).json({ error: 'Erro ao redefinir senha.' });
  }
};
