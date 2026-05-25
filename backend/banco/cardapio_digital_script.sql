CREATE DATABASE cardapio_digital;
-- ======== TABELA PRODUTOS ===============
CREATE TABLE produtos (
  id SERIAL PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  descricao TEXT,
  imagem TEXT,
  preco NUMERIC(10,2) NOT NULL,
  categoria VARCHAR(50)
);

-- ======== TABELA PEDIDOS ===============
CREATE TABLE pedidos (
  id SERIAL PRIMARY KEY,
  data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  status VARCHAR(20) DEFAULT 'pendente',   -- pendente, em_preparo, entregue, cancelado
  total NUMERIC(10,2) DEFAULT 0,
  nome_cliente VARCHAR(100) NOT NULL,
  telefone VARCHAR(20),
  forma_pagamento VARCHAR(50) NOT NULL
);

-- ======== TABELA ITENS DO PEDIDO ===============
CREATE TABLE itens_pedido (
  id SERIAL PRIMARY KEY,
  pedido_id INTEGER REFERENCES pedidos(id) ON DELETE CASCADE,
  produto_id INTEGER REFERENCES produtos(id),
  quantidade INTEGER NOT NULL,
  subtotal NUMERIC(10,2) NOT NULL
);

CREATE TABLE admin (
  id SERIAL PRIMARY KEY,
  nome VARCHAR(100),
  email VARCHAR(150) UNIQUE NOT NULL,
  telefone VARCHAR(20),
  senha VARCHAR(255) NOT NULL
);
-- Tabela de usuários clientes (RF001, RF002, RF003)
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
