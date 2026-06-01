import pg from 'pg';
import dotenv from 'dotenv';

dotenv.config();

const { Pool } = pg;

// Se tiver DATABASE_URL (Supabase/Render), usa ela.
// Caso contrário, usa as variáveis separadas (ambiente local).
export const pool = process.env.DATABASE_URL
  ? new Pool({
      connectionString: process.env.DATABASE_URL,
      ssl: { rejectUnauthorized: false }, // necessário para Supabase
    })
  : new Pool({
      user: process.env.DB_USER,
      host: process.env.DB_HOST,
      database: process.env.DB_NAME,
      password: process.env.DB_PASSWORD,
      port: process.env.DB_PORT,
    });

pool.on('connect', () => {
  console.log('Base de dados conectada com sucesso!');
});

export const initDb = async () => {
  const sql = `
    CREATE TABLE IF NOT EXISTS usuarios (
      id SERIAL PRIMARY KEY,
      nome VARCHAR(255) NOT NULL,
      email VARCHAR(255) UNIQUE NOT NULL,
      telefone VARCHAR(20),
      senha VARCHAR(255) NOT NULL,
      verificacao_codigo VARCHAR(10),
      is_verificado BOOLEAN DEFAULT FALSE,
      is_admin BOOLEAN DEFAULT FALSE,
      created_at TIMESTAMP DEFAULT NOW()
    );

    CREATE TABLE IF NOT EXISTS verificacoes_pendentes (
      email VARCHAR(255) PRIMARY KEY,
      nome VARCHAR(255) NOT NULL,
      telefone VARCHAR(20) NOT NULL,
      senha VARCHAR(255) NOT NULL,
      verificacao_codigo VARCHAR(10) NOT NULL,
      created_at TIMESTAMP DEFAULT NOW()
    );

    CREATE TABLE IF NOT EXISTS produtos (
      id SERIAL PRIMARY KEY,
      nome VARCHAR(100) NOT NULL,
      descricao TEXT,
      imagem TEXT,
      preco NUMERIC(10,2) NOT NULL,
      categoria VARCHAR(50) NOT NULL
    );

    CREATE TABLE IF NOT EXISTS pedidos (
      id SERIAL PRIMARY KEY,
      data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      status VARCHAR(20) DEFAULT 'pendente',
      total NUMERIC(10,2) DEFAULT 0,
      nome_cliente VARCHAR(100) NOT NULL,
      telefone VARCHAR(20),
      forma_pagamento VARCHAR(50) NOT NULL
    );

    CREATE TABLE IF NOT EXISTS itens_pedido (
      id SERIAL PRIMARY KEY,
      pedido_id INTEGER REFERENCES pedidos(id) ON DELETE CASCADE,
      produto_id INTEGER REFERENCES produtos(id),
      quantidade INTEGER NOT NULL,
      subtotal NUMERIC(10,2) NOT NULL
    );
  `;
  try {
    await pool.query(sql);
    console.log('Tabelas verificadas/criadas com sucesso!');
  } catch (err) {
    console.error('Erro ao inicializar o banco de dados:', err);
  }
};
