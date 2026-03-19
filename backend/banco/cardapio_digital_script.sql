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
  email VARCHAR(150) UNIQUE NOT NULL,
  senha VARCHAR(255) NOT NULL
);