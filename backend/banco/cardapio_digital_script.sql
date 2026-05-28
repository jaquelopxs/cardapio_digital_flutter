-- Script de Criação do Banco de Dados - Cardápio Digital

-- Criação do banco (opcional, dependendo do ambiente)
-- CREATE DATABASE cardapio_digital;

-- ======== TABELA USUÁRIOS (RF001, RF002, RF003) ===============
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

-- ======== TABELA VERIFICAÇÕES PENDENTES (Para RF002) ===============
CREATE TABLE IF NOT EXISTS verificacoes_pendentes (
  email VARCHAR(255) PRIMARY KEY,
  nome VARCHAR(255) NOT NULL,
  telefone VARCHAR(20) NOT NULL,
  senha VARCHAR(255) NOT NULL,
  verificacao_codigo VARCHAR(10) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

-- ======== TABELA PRODUTOS (RF005) ===============
CREATE TABLE IF NOT EXISTS produtos (
  id SERIAL PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  descricao TEXT,
  imagem TEXT,
  preco NUMERIC(10,2) NOT NULL,
  categoria VARCHAR(50) NOT NULL -- bebidas, pratos principais, sobremesas, etc.
);

-- ======== TABELA PEDIDOS (RF009) ===============
CREATE TABLE IF NOT EXISTS pedidos (
  id SERIAL PRIMARY KEY,
  data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  status VARCHAR(20) DEFAULT 'pendente', -- pendente, em_preparo, entregue, cancelado
  total NUMERIC(10,2) DEFAULT 0,
  nome_cliente VARCHAR(100) NOT NULL,
  telefone VARCHAR(20),
  forma_pagamento VARCHAR(50) NOT NULL
);

-- ======== TABELA ITENS DO PEDIDO (RF006) ===============
CREATE TABLE IF NOT EXISTS itens_pedido (
  id SERIAL PRIMARY KEY,
  pedido_id INTEGER REFERENCES pedidos(id) ON DELETE CASCADE,
  produto_id INTEGER REFERENCES produtos(id),
  quantidade INTEGER NOT NULL,
  subtotal NUMERIC(10,2) NOT NULL
);

-- Inserção de Admin Inicial (Opcional)
-- Senha: administrador120 (Hashed)
-- INSERT INTO usuarios (nome, email, telefone, senha, is_verificado, is_admin) 
-- VALUES ('Admin', 'admin@admin.com', '00000000', '$2b$10$YourHashedPasswordHere', true, true);
