-- =======================================================
-- 1. ESTRUTURA DE TABELAS (VENDAS DE DOMINGO / FIADO)
-- =======================================================

-- Tabela de Clientes (Amigos)
CREATE TABLE IF NOT EXISTS clientes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  nome TEXT NOT NULL UNIQUE,
  emoji TEXT DEFAULT '👤',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Tabela de Produtos (Bebidas/Comidas)
CREATE TABLE IF NOT EXISTS produtos (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  nome TEXT NOT NULL,
  preco NUMERIC(10, 2) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Tabela de Pagamentos / Acertos Recebidos (Vendas Concluídas)
CREATE TABLE IF NOT EXISTS vendas (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  cliente_nome TEXT NOT NULL,
  total NUMERIC(10, 2) NOT NULL,
  forma_pagamento TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Tabela de Itens Consumidos por Data (Histórico do Fiado)
CREATE TABLE IF NOT EXISTS itens_venda (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  venda_id UUID REFERENCES vendas(id) ON DELETE CASCADE,
  cliente_nome TEXT NOT NULL,
  produto_nome TEXT NOT NULL,
  quantidade INT NOT NULL,
  preco_unitario NUMERIC(10, 2) NOT NULL,
  subtotal NUMERIC(10, 2) NOT NULL,
  data_consumo DATE DEFAULT CURRENT_DATE NOT NULL
);

-- =======================================================
-- 2. SEGURANÇA E PERMISSÕES (ROW LEVEL SECURITY - RLS)
-- =======================================================

-- Habilitar RLS em todas as tabelas
ALTER TABLE clientes ENABLE ROW LEVEL SECURITY;
ALTER TABLE produtos ENABLE ROW LEVEL SECURITY;
ALTER TABLE vendas ENABLE ROW LEVEL SECURITY;
ALTER TABLE itens_venda ENABLE ROW LEVEL SECURITY;

-- Limpar políticas antigas se existirem
DROP POLICY IF EXISTS "Acesso publico clientes" ON clientes;
DROP POLICY IF EXISTS "Acesso publico produtos" ON produtos;
DROP POLICY IF EXISTS "Acesso publico vendas" ON vendas;
DROP POLICY IF EXISTS "Acesso publico itens_venda" ON itens_venda;

-- Criar permissões totais (Inserir, Ler, Editar, Excluir)
CREATE POLICY "Acesso publico clientes" ON clientes FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Acesso publico produtos" ON produtos FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Acesso publico vendas" ON vendas FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Acesso publico itens_venda" ON itens_venda FOR ALL USING (true) WITH CHECK (true);




-- 1. Adicionar custo na tabela de produtos
ALTER TABLE produtos ADD COLUMN IF NOT EXISTS custo NUMERIC(10, 2) DEFAULT 0.00;

-- 2. Tabela de Compras / Gastos do Evento
CREATE TABLE IF NOT EXISTS compras (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  descricao TEXT NOT NULL,
  categoria TEXT DEFAULT 'Bebidas',
  valor NUMERIC(10, 2) NOT NULL,
  data_compra DATE DEFAULT CURRENT_DATE NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Habilitar RLS
ALTER TABLE compras ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Acesso publico compras" ON compras;
CREATE POLICY "Acesso publico compras" ON compras FOR ALL USING (true) WITH CHECK (true);