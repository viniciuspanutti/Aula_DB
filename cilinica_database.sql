-- atividade avaliativa Clínica veterinária
-- Vinícius Panutti Salgado// RA 25007329
 
SHOW DATABASES;
CREATE DATABASE clinica_db_v;
USE clinica_db_v;

-- 1ª Etapa: Criação de Tabelas (adaptar ao seu nome)
CREATE TABLE tutores_v (
id_tutor_v INT PRIMARY KEY,
nome_v VARCHAR(100),
telefone_v VARCHAR(15),
email_v VARCHAR(100),
endereco_v VARCHAR(150)
);

CREATE TABLE animais_v (
id_animal_v INT PRIMARY KEY,
nome_v VARCHAR(50),
especie_v VARCHAR(30),
raca_v VARCHAR(50),
idade_v INT,
peso_v DECIMAL(5,2),
sexo_v CHAR(1),
id_tutor_v INT,
FOREIGN KEY (id_tutor_v) REFERENCES tutores_v(id_tutor_v)
);

CREATE TABLE consultas_v (
id_consulta_v INT PRIMARY KEY,
id_animal_v INT,
data_consulta_v DATE,
procedimento_v VARCHAR(100),
valor_v DECIMAL(10,2),
retorno_v BOOLEAN,
FOREIGN KEY (id_animal_v) REFERENCES animais_v(id_animal_v)
);

-- 2ª Etapa: Inserção de Dados
INSERT INTO tutores_v (id_tutor_v, nome_v, telefone_v, email_v, endereco_v) VALUES
(1, 'Carlos Mendes', '11999887766', 'carlos@email.com', 'Rua das Flores, 123'),
(2, 'Ana Lúcia', '11988776655', 'ana@email.com', 'Av. Central, 456'),
(3, 'Juliana Silva', '11977665544', 'juliana@email.com', 'Rua Verde, 789'),
(4, 'Roberto Nunes', '11966554433', 'roberto@email.com', 'Travessa Sol, 321'),
(5, 'Fernanda Dias', '11955443322', 'fernanda@email.com', 'Alameda Azul, 852');

INSERT INTO animais_v (id_animal_v, nome_v, especie_v, raca_v, idade_v, peso_v, sexo_v, id_tutor_v) VALUES
(1, 'Toby', 'Cão', 'Labrador', 5, 28.5, 'M', 1),
(2, 'Mimi', 'Gato', 'Persa', 3, 4.2, 'F', 2),
(3, 'Rex', 'Cão', 'Vira-lata', 2, 12.7, 'M', 1),
(4, 'Luna', 'Gato', 'Siamês', 4, 5.1, 'F', 3),
(5, 'Bolinha', 'Cão', 'Poodle', 10, 7.8, 'F', 4),
(6, 'Thor', 'Cão', 'Husky', 6, 32.0, 'M', 5),
(7, 'Nina', 'Gato', 'Maine Coon', 2, 6.9, 'F', 3),
(8, 'Max', 'Cão', 'Bulldog', 4, 24.0, 'M', 4),
(9, 'Mel', 'Gato', 'SRD', 1, 3.5, 'F', 5),
(10, 'Bob', 'Cão', 'Beagle', 3, 10.2, 'M', 2);

INSERT INTO consultas_v (id_consulta_v, id_animal_v, data_consulta_v, procedimento_v, valor_v, retorno_v) VALUES
(1, 1, '2024-12-10', 'Vacinação Antirrábica', 80.0, False),
(2, 2, '2024-12-15', 'Consulta Rotina', 120.0, True),
(3, 3, '2025-01-10', 'Tratamento de pele', 200.0, False),
(4, 1, '2025-02-05', 'Retorno Vacinação', 0.0, False),
(5, 4, '2025-02-20', 'Exame de sangue', 150.0, True),
(6, 5, '2025-03-01', 'Consulta geriátrica', 160.0, True),
(7, 6, '2025-03-15', 'Cirurgia ortopédica', 800.0, False),
(8, 7, '2025-04-02', 'Tratamento vermífugo', 95.0, False),
(9, 8, '2025-04-10', 'Check-up', 180.0, True),
(10, 9, '2025-04-20', 'Consulta Rotina', 110.0, False),
(11, 10, '2025-04-25', 'Vacinação múltipla', 90.0, True),
(12, 2, '2025-05-05', 'Retorno Consulta', 0.0, False);

-- 3ª Etapa: Exercícios SQL
-- 1. Altere o peso do animal chamado 'Thor' para 33.5 kg.
UPDATE animais_v
SET peso_v = 33.5
WHERE nome_v = 'Thor';

-- 2. Remova a consulta com id_consulta = 6.
DELETE FROM consultas_v
WHERE id_consulta_v = 6;

-- 3. Exiba o nome dos animais e o nome dos tutores responsáveis.
SELECT
    a.nome_v AS nome_animal,
    t.nome_v AS nome_tutor
FROM
    animais_v AS a
JOIN
    tutores_v AS t ON a.id_tutor_v = t.id_tutor_v;

-- 4. Quais animais têm peso maior que 25 kg? Mostre nome, espécie e peso.
SELECT
    nome_v,
    especie_v,
    peso_v
FROM
    animais_v
WHERE
    peso_v > 25;

-- 5. Marque todas as consultas de 'Mimi' como realizadas (retorno = TRUE).
UPDATE consultas_v
SET retorno_v = TRUE
WHERE id_animal_v = (SELECT id_animal_v FROM animais_v WHERE nome_v = 'Mimi');

-- 6. Delete todos os animais do tutor 'Juliana Silva'.
DELETE FROM consultas_v
WHERE id_animal_v IN (SELECT id_animal_v FROM animais_v WHERE id_tutor_v = (SELECT id_tutor_v FROM tutores_v WHERE nome_v = 'Juliana Silva'));

DELETE FROM animais_v
WHERE id_tutor_v = (SELECT id_tutor_v FROM tutores_v WHERE nome_v = 'Juliana Silva');


-- 7. Liste o nome de cada animal e o total que ele gastou em consultas.
SELECT
    a.nome_v AS nome_animal,
    SUM(c.valor_v) AS total_gasto
FROM
    animais_v AS a
JOIN
    consultas_v AS c ON a.id_animal_v = c.id_animal_v
GROUP BY
    a.nome_v;

-- 8. Mostre o nome de cada tutor e a quantidade de animais sob seus cuidados.
SELECT
    t.nome_v AS nome_tutor,
    COUNT(a.id_animal_v) AS quantidade_animais
FROM
    tutores_v AS t
LEFT JOIN
    animais_v AS a ON t.id_tutor_v = a.id_tutor_v
GROUP BY
    t.nome_v;

-- 9. Acrescente 1 ano à idade de todos os animais da espécie 'Cão'.
UPDATE animais_v
SET idade_v = idade_v + 1
WHERE especie_v = 'Cão';

-- 10. Liste o nome e a data das consultas realizadas para animais da espécie 'Gato'.
SELECT
    a.nome_v AS nome_animal,
    c.data_consulta_v
FROM
    animais_v AS a
JOIN
    consultas_v AS c ON a.id_animal_v = c.id_animal_v
WHERE
    a.especie_v = 'Gato';
    

SELECT * FROM tutores_v;
SELECT * FROM animais_v;
SELECT * FROM consultas_v;
DROP DATABASE clinica_db_v;