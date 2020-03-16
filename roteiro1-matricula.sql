-- @author Nayara Souza - 118110390

-- Questão 1
-- Criada uma situação em que esse banco de dados pertence a uma seguradora

-- 
CREATE TABLE Seguro (
Contrato SERIAL,
Segurado_Cpf CHAR(7),
Automovel_Placa CHAR(7),
Preço NUMERIC,
Serviços TEXT
);

CREATE TABLE Automovel (
Placa CHAR(7),
Chassi CHAR(17),
Modelo VARCHAR(50),
Marca VARCHAR(50),
Ano INTEGER,
Segurado_cpf INTEGER
);

CREATE TABLE Segurado (
Cpf INTEGER,
Cnh INTEGER,
);

CREATE TABLE Perito (
Cpf INTEGER,
Automovel_Placa CHAR(7)
);

CREATE TABLE Oficina (
);

