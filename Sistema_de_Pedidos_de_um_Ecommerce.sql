show databases;
use BD180225130;
show tables;
select * FROM clientes;
select * FROM pedidos;

CREATE TABLE clientes (
id INT AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(100) NOT NULL,
email VARCHAR(100) UNIQUE NOT NULL,
cpf CHAR(11) UNIQUE,
telefone VARCHAR(20),
endereco TEXT,
cidade VARCHAR(50),
estado CHAR(2),
ativo BOOLEAN DEFAULT TRUE,
data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE pedidos (
id INT AUTO_INCREMENT PRIMARY KEY,
cliente_id INT NOT NULL,
valor_total DECIMAL(10,2) NOT NULL,
status_pedido VARCHAR(30) DEFAULT 'Em aberto',
forma_pagamento VARCHAR(30),
endereco_entrega TEXT,
data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
observacao TEXT,
cupom_aplicado VARCHAR(20),
confirmado BOOLEAN DEFAULT FALSE,
FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

-- Dados fictícios
INSERT INTO clientes (nome, email, cpf, telefone, endereco, cidade, estado)
VALUES
('Mariana Dias Piazzi', 'mariana@gmail.com', '12345678901', '(11)91234-5678', 'Rua A, 100', 'Campinas', 'SP'),
('Roberto Rezende de Paula', 'roberto@hotmail.com', '23456789012', '(19)98765-4321', 'Av B, 200', 'São Paulo', 'SP');

INSERT INTO pedidos (cliente_id, valor_total, forma_pagamento, endereco_entrega, cupom_aplicado)
VALUES
(1, 299.90, 'Cartão de Crédito', 'Rua A, 100', 'PROMO10'),
(2, 99.99, 'Pix', 'Av B, 200', NULL);

INSERT INTO clientes (nome, email, cpf, cidade, estado)
VALUES
('Alexandre Magno', 'ale_magninho@gmail.com', '17697378901', 'Campinas', 'SP');

-- Tentar inserir cliente com email duplicado e observar o erro
-- Perceba que, se uma pessoa entra com os dados de outra pessoa, o banco de dados dá erro: Teste este a baixo ->
-- INSERT INTO clientes (nome, email, cpf, cidade, estado)
-- VALUES
-- ('Alexandre Magno', 'ale_magninho@gmail.com', '17697378901', 'Campinas', 'SP');

INSERT INTO clientes (nome, email, cpf, cidade, estado, ativo)
VALUES
('Agostinho de Pataxo', 'agost_pataxo@gmail.com', '36547678901', 'Campinas', 'SP', FALSE);

-- Aqui inserimos um pedido de boleto
INSERT INTO pedidos (cliente_id, valor_total, forma_pagamento, endereco_entrega, cupom_aplicado)
VALUES
(1, 299.90, 'Boleto', 'Rua A, 100', 'PROMO10');

-- Aqui outra pessoa fez cadastro de compra, mas não conseguiu a promoção
INSERT INTO pedidos (cliente_id, valor_total, forma_pagamento, endereco_entrega)
VALUES
(2, 299.90, 'Boleto', 'Av B, 200');

 -- Inserir pedido com valor negativo (testar erro, se houver validação futura).
 -- Foi aceito um valor negativo, pois 
INSERT INTO pedidos (cliente_id, valor_total, forma_pagamento, endereco_entrega)
VALUES
(2, -299.90, 'Boleto', 'Av B, 200');

DELETE FROM pedidos WHERE id=7;

-- Aqui ele vai impedir dar qualquer tipo de erro de valores negativos na compra
ALTER TABLE pedidos ADD CONSTRAINT cnk_valor_total_positivo CHECK (valor_total >= 0);

select * FROM pedidos;

-- Agora, se tentarmos fazer novamente o mesmo comando acima, vai dar erro
INSERT INTO pedidos (cliente_id, valor_total, forma_pagamento, endereco_entrega)
VALUES
(2, -299.90, 'Boleto', 'Av B, 200');

INSERT INTO pedidos (cliente_id, valor_total, forma_pagamento, endereco_entrega)
VALUES
(2, 299.90, 'Boleto', 'Av B, 200'),
(2, 299.90, 'Boleto', 'Av B, 200'),
(2, 299.90, 'Boleto', 'Av B, 200');

-- Inserir pedido com cliente_id = 9999 e observar erro de integridade referencial
INSERT INTO pedidos (cliente_id, valor_total, forma_pagamento, endereco_entrega)
VALUES
(9999, 79.90, 'Pix', 'Rua H, 3');
-- Observe que, deu erro pois na tabela clientes, não tem nenhum referencial do id=999, ele não encontra, por isso incrementar
-- E cliente_id é um chave estrangeira que referencia a chave id da tabela primária