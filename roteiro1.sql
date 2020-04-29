-- @author Nayara Souza - 118110390 - UFCG


-- CRIACAO DA TABELA
-- Criada uma situação em que esse banco de dados pertence a uma seguradora

-- Automovel que sera registrado no cpf de um segurado.
CREATE TABLE Automovel (
    Automovel_Placa CHAR(7),
    Automovel_Chassi CHAR(17),
    Automovel_Modelo VARCHAR(50),
    Automovel_Marca VARCHAR(50),
    Automovel_Ano INTEGER,
    -- CPF do responsavel pelo automovel.
    Segurado_cpf INTEGER
);

-- Cliente cadastrado que podera realizar contratos para realizar o seguro do automovel.
-- Um cliente pode ter mais de um automovel com contrato com a seguradora.
CREATE TABLE Segurado (
    Segurado_Cpf INTEGER,
    Segurado_Cnh INTEGER
);

-- O perito cadastrado que verifica o sinistro ocorrido
CREATE TABLE Perito (
    Perito_Cpf INTEGER
);

-- Oficina responsavel pelo conserto do automovel.
CREATE TABLE Oficina (
    Oficina_Cnpq INTEGER
);

/*  Seguro representa o contrato que o segurado faz para seu automovel de forma
    que contem informações do seu segurado e do automovel, alem dos serviços prestados.*/
-- Considerando que o seguro cobre qualquer tipo de ocorrencia.
-- Se o automovel já pertence a alguma pessoa cadastrada entao nao e necessario cita-la no seguro
CREATE TABLE Seguro (
    Contrato SERIAL,
    Automovel_Chassi CHAR(17),
    Preço NUMERIC
);

-- Sinistro representa evento em que o bem segurado sofre um acidente ou prejuízo material.
CREATE TABLE Sinistro (
    -- Ocorrencia representada por um codigo criado pelo sistema para representar a situacao.
    Ocorrencia_Codigo SERIAL,
    -- Especificação em texto do que cada ocorrencia significa.
    Ocorrencia_Especificacao TEXT
);

-- Pericia realizada pelo perito de forma que ele consiga cadastrar o codigo da ocorrencia 
CREATE TABLE Pericia (
    -- Numero do processo da pericia
    N_Pericia SERIAL,
    Perito_Cpf INTEGER,
    Automovel_Chassi CHAR(17),
    Ocorrencia SERIAL
);

CREATE TABLE Reparo (
    -- Oficina que em que sera reparado o automovel
    Oficina_Cnpq INTEGER,
    Automovel_Chassi CHAR(17),
    -- O resultado da pericia para que a oficina saiba que problema o automovel possivel
    N_Pericia SERIAL,
    -- Se o automovel esta reparado ou nao
    Situacao_De_Reparo BOOLEAN
);

-- DEFININDO CHAVES PRIMARIAS
ALTER TABLE Automovel ADD PRIMARY KEY(Automovel_Chassi);
ALTER TABLE Segurado ADD PRIMARY KEY(Segurado_Cpf);
ALTER TABLE Perito ADD PRIMARY KEY(Perito_Cpf);
ALTER TABLE Oficina ADD PRIMARY KEY(Oficina_Cnpq);
ALTER TABLE Seguro ADD PRIMARY KEY(Contrato);
ALTER TABLE Sinistro ADD PRIMARY KEY(Ocorrencia_Codigo);
ALTER TABLE Pericia ADD PRIMARY KEY(N_Pericia);
ALTER TABLE Reparo ADD PRIMARY KEY(Oficina_Cnpq, Automovel_Placa);

-- DEFININDO CHAVES ESTRANGEIRAS
ALTER TABLE Automovel ADD CONSTRAINT automovel_do_segurado FOREIGN KEY (Segurado_Cpf) REFERENCES Segurado(Segurado_Cpf);
ALTER TABLE Seguro ADD CONSTRAINT automovel_no_seguro FOREIGN KEY (Automovel_Chassi) REFERENCES Automovel(Automovel_Chassi);
ALTER TABLE Pericia ADD CONSTRAINT responsavel_perito FOREIGN KEY (Perito_Cpf) REFERENCES Perito(Perito_Cpf);
ALTER TABLE Pericia ADD CONSTRAINT automovel_pericia FOREIGN KEY (Automovel_Chassi) REFERENCES Automovel(Automovel_Chassi);
ALTER TABLE Reparo ADD CONSTRAINT oficina FOREIGN KEY (Oficina_Cnpq) REFERENCES Oficina(Oficina_Cnpq);
ALTER TABLE Reparo ADD CONSTRAINT automovel_na_oficina FOREIGN KEY (Automovel_Chassi) REFERENCES Automovel(Automovel_Chassi);
ALTER TABLE Reparo ADD CONSTRAINT numero_pericia FOREIGN KEY (N_Pericia) REFERENCES Pericia(N_Pericia);

-- REMOVENDO TODAS AS TABELAS
DROP TABLE Automavel;
DROP TABLE Segurado;
DROP TABLE Perito;
DROP TABLE Oficina;
DROP TABLE Seguro;
DROP TABLE Sinistro;
DROP TABLE Pericia;
DROP TABLE Reparo;

-- RECRIANDO TABELAS COM ALTER
CREATE TABLE Automovel (
    Automovel_Placa CHAR(7) NOT NULL,
    Automovel_Chassi CHAR(17) NOT NULL,
    Automovel_Modelo VARCHAR(50),
    Automovel_Marca VARCHAR(50),
    Automovel_Ano INTEGER,
    Segurado_cpf INTEGER NOT NULL,
    PRIMARY KEY (Automovel_Chassi),
    FOREIGN KEY (Segurado_Cpf) REFERENCES Segurado(Segurado_Cpf)
);

CREATE TABLE Segurado (
    Segurado_Cpf INTEGER NOT NULL,
    Segurado_Cnh INTEGER NOT NULL,
    PRIMARY KEY (Segurado_Cpf)
);

CREATE TABLE Perito (
    Perito_Cpf INTEGER NOT NULL,
    PRIMARY KEY(Perito_Cpf)
);

CREATE TABLE Oficina (
    Oficina_Cnpq INTEGER NOT NULL,
    PRIMARY KEY(Oficina_Cnpq)
);

CREATE TABLE Seguro (
    Contrato SERIAL NOT NULL,
    Automovel_Chassi CHAR(17) NOT NULL,
    Preço NUMERIC,
    PRIMARY KEY(Contrato),
    FOREIGN KEY (Automovel_Chassi) REFERENCES Automovel(Automovel_Chassi)
);

CREATE TABLE Sinistro (
    Ocorrencia_Codigo SERIAL NOT NULL,
    Ocorrencia_Especificacao TEXT NOT NULL,
    PRIMARY KEY(Ocorrencia_Codigo)
);

CREATE TABLE Pericia (
    N_Pericia SERIAL NOT NULL,
    Perito_Cpf INTEGER NOT NULL,
    Automovel_Chassi CHAR(17),
    Ocorrencia SERIAL NOT NULL,
    PRIMARY KEY(N_Pericia),
    FOREIGN KEY (Automovel_Chassi) REFERENCES Automovel(Automovel_Chassi),
    FOREIGN KEY (Perito_Cpf) REFERENCES Perito(Perito_Cpf)
);

CREATE TABLE Reparo (
    Oficina_Cnpq INTEGER NOT NULL,
    Automovel_Chassi CHAR(17),
    N_Pericia SERIAL NOT NULL,
    Situacao_De_Reparo BOOLEAN NOT NULL,
    PRIMARY KEY(Oficina_Cnpq, Automovel_Placa),
    FOREIGN KEY (N_Pericia) REFERENCES Pericia(N_Pericia),
    FOREIGN KEY (Automovel_Chassi) REFERENCES Automovel(Automovel_Chassi),
    FOREIGN KEY (Oficina_Cnpq) REFERENCES Oficina(Oficina_Cnpq)
);

-- REMOVENDO TABELAS (AGORA COM CONSTRAINTS DEVEM TER ORDEM PARA SUA REMOCAO)
DROP TABLE Reparo;
DROP TABLE Pericia;
DROP TABLE Seguro;
DROP TABLE Sinistro;
DROP TABLE Oficina;
DROP TABLE Perito;
DROP TABLE Automavel;
DROP TABLE Segurado;

