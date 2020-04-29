-- @author Nayara Souza - 118110390 - UFCG

-- Criando tipo para a restricao 19, onde a farmacia localiza-se em um dos 9 estados do nordeste(os estados foram abreviados)
CREATE TYPE estados_nordeste AS ENUM ('MA', 'PI', 'CE', 'RN', 'PE', 'PB', 'SE', 'AL', 'BA');
-- Criando data type com os tipos de funcionarios para simplificar
CREATE TYPE tipo_funcionario AS ENUM ('Farmaceutico', 'Vendedor', 'Entregador', 'Caixa', 'Administrador');
-- Criando data type com os tipos de endereços
CREATE TYPE tipo_endereco AS ENUM ('Residencia', 'Trabalho', 'Outro');

-- Criando a table Farmacias
CREATE TABLE Farmacias(
    id                  INTEGER,
    tipo                TEXT NOT NULL,
    bairro              TEXT NOT NULL,
    cidade              TEXT NOT NULL,
    -- Estado eh adicionado abreviado. EX: 'CE','PR','PB'...
    estado              estados_nordeste NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT verifica_tipo_farmacia CHECK (tipo = 'Filial' OR tipo = 'Sede'),
    CONSTRAINT verifica_sede_ja_existente EXCLUDE USING gist (tipo with =) WHERE (tipo = 'Sede'),
    CONSTRAINT unica_farmacia_por_bairro UNIQUE(bairro)
);

/* Alterando o tipo de data de estado
   ALTER TABLE Farmacias ALTER COLUMN estado SET DATA TYPE estados_nordeste USING estado::estados_nordeste; */

-- Considerando q exista uma tabela a parte de mais informacoes do funcionario(dependentes, idade, endereco, salario...)
CREATE TABLE Funcionarios(
    cpf                 CHAR(11),
    nome                TEXT NOT NULL,
    tipo                tipo_funcionario NOT NULL,
    id_farmacia         INTEGER,
    eh_gerente          BOOLEAN,
    CONSTRAINT cpf_n_char CHECK(LENGTH(cpf) = 11),
    --- Ao inves de usar o outro valor usasse null, para que eh_gerente possa usar unique sem conflitos
    CONSTRAINT true_or_null CHECK(eh_gerente),
    CONSTRAINT apenas_um_gerente UNIQUE(id_farmacia,eh_gerente),
    CONSTRAINT farmacia_null_n_pode_ser_gerente CHECK((id_farmacia IS NOT NULL OR eh_gerente IS NULL)),
    CONSTRAINT checa_tipo_gerente CHECK(eh_gerente IS NULL OR tipo = 'Farmaceutico' OR eh_gerente IS NULL OR tipo = 'Administrador'),
    CONSTRAINT FK_id_farmacia FOREIGN KEY (id_farmacia) REFERENCES Farmacias(id) ON DELETE RESTRICT,
    CONSTRAINT unique_func UNIQUE(cpf, tipo),
    PRIMARY KEY (cpf)
);

-- Criando tabela Medicamentos
CREATE TABLE Medicamentos(
    id                  INTEGER,
    nome                TEXT NOT NULL,
    venda_exclusiva     BOOLEAN NOT NULL,
    valor               NUMERIC,
    CONSTRAINT valor_invalido CHECK(valor >= 0),
    PRIMARY KEY (id, nome),
    UNIQUE (id, venda_exclusiva),
    UNIQUE (nome)
);

-- Criando tabela Clientes
CREATE TABLE Clientes(
    cpf                 CHAR(11),
    nome                TEXT NOT NULL,
    datanasc            DATE NOT NULL,
    PRIMARY KEY (cpf),
    CONSTRAINT checa_idade CHECK(date_part('years', age(datanasc)) >= 18),
    CONSTRAINT cpf_n_char CHECK(LENGTH(cpf) = 11)
);

-- Foi criada uma nova tabela com o endereco dos clientes para melhor administracao
CREATE TABLE Enderecos(
    cpf_cliente         CHAR(11),
    enderecos           TEXT NOT NULL,
    tipo_endereco       tipo_endereco NOT NULL,
    CONSTRAINT FK_cpf_cliente FOREIGN KEY (cpf_cliente) REFERENCES Clientes(cpf) ON DELETE CASCADE,
    UNIQUE(cpf_cliente, enderecos)
);

-- Criando tabelas Vendas
CREATE TABLE Vendas(
    id                  INTEGER,
    cpf_funcionario      CHAR(11) NOT NULL,
    tipo_funcionario    tipo_funcionario NOT NULL,
    cpf_cliente         CHAR(11),
    id_medicamento      INTEGER NOT NULL,
    venda_exclusiva_med BOOLEAN NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT FK_cliente_venda FOREIGN KEY (cpf_cliente) REFERENCES Clientes(cpf) ON DElETE CASCADE,
    CONSTRAINT FK_funcionario_venda FOREIGN KEY (cpf_funcionario, tipo_funcionario) REFERENCES Funcionarios(cpf, tipo) ON DELETE RESTRICT,
    CONSTRAINT verifica_funcionario CHECK((cpf_funcionario IS NULL AND tipo_funcionario IS NULL) OR (cpf_funcionario IS NOT NULL AND tipo_funcionario IS NOT NULL)),
    CONSTRAINT checa_tipo_funcionario CHECK (tipo_funcionario = 'Vendedor'),
    CONSTRAINT FK_med_venda FOREIGN KEY (id_medicamento, venda_exclusiva_med) REFERENCES Medicamentos(id, venda_exclusiva) ON DELETE RESTRICT,
    CONSTRAINT checa_venda_exclusiva CHECK(cpf_cliente IS NOT NULL OR venda_exclusiva_med = false) 
);

CREATE TABLE Entregas(
    id INTEGER,
    cpf_funcionario     CHAR(11) NOT NULL,
    tipo_funcionario    tipo_funcionario NOT NULL,
    cpf_cliente         CHAR(11) NOT NULL,
    endereco_cliente    TEXT NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT FK_funcionario_entrega FOREIGN KEY (cpf_funcionario, tipo_funcionario) REFERENCES Funcionarios(cpf, tipo),
    CONSTRAINT FK_cliente_entrega FOREIGN KEY (cpf_cliente, endereco_cliente) REFERENCES Enderecos(cpf_cliente, enderecos) ON DElETE CASCADE,
    CONSTRAINT checa_tipo_funcionario CHECK (tipo_funcionario = 'Entregador')
);

---- CASOS DE TESTES ----
    --- FARMACIAS ---
--- INSERINDO VALORES QUE FUNCIONAM
INSERT INTO farmacias VALUES(1, 'Sede', 'Salesianos', 'Juazeiro', 'CE');
INSERT INTO farmacias VALUES(2, 'Filial', 'Univesitario', 'Campina Grande', 'PB');
--- INSERINDO VALORES QUE NAO FUNCIONAM
INSERT INTO farmacias VALUES(3, 'Sede', 'Santo Antonio', 'Sobral', 'CE'); --Nao podem existir duas sedes
INSERT INTO farmacias VALUES(4, 'Filial', 'Salesianos', 'Juazeiro', 'CE'); --Nao podem existir duas farmacias no mesmo bairro
INSERT INTO farmacias VALUES(6, 'Parceira', 'Alto Branco', 'Campina Grande', 'PB'); -- So pode ser Filial ou Sede
INSERT INTO farmacias VALUES(7, 'Filial', 'Bela Vista', 'Sao Paulo', 'SP'); -- Estado invalido

    --- FUNCIONARIOS ---
--- INSERINDO VALORES QUE FUNCIONAM
INSERT INTO Funcionarios VALUES('12345678911', 'Ana', 'Farmaceutico', 1, true);
INSERT INTO Funcionarios VALUES('12345678912', 'Jose', 'Vendedor', 1, null);
INSERT INTO Funcionarios VALUES('12345678913', 'Carol', 'Caixa', 1, null);
INSERT INTO Funcionarios VALUES('12345678914', 'Gabriel', 'Administrador', 2, null);
INSERT INTO Funcionarios VALUES('12345678915', 'Marcos', 'Entregador', 2, null);
INSERT INTO Funcionarios VALUES('12345678919', 'Paulo', 'Caixa', null, null);
--- INSERINDO VALORES QUE NAO FUNCIONAM
INSERT INTO Funcionarios VALUES('1234567891', 'Claudia', 'Entregador', 1, null); -- cpf invalido
INSERT INTO Funcionarios VALUES('12345678916', 'Maria', 'Vendedor', 3, null); -- id de farmacia inexistente
INSERT INTO Funcionarios VALUES('12345678917', 'Lucas', 'Porteiro', 2, null); -- tipo de funcionario invalido
INSERT INTO Funcionarios VALUES('12345678918', 'Andressa', 'Administrador', null, true); -- Um funcionario sem farmacia n pode ser gerente
INSERT INTO Funcionarios VALUES('12345678920', 'Erica', 'Vendedor', 2, true); -- funcionario do tipo invalido para ser gerente

    --- CLIENTES ---
--- INSERINDO CLIENTES QUE FUNCIONAM
INSERT INTO Clientes VALUES('12345678011', 'Nayara','1998-01-13');
INSERT INTO Clientes VALUES('12345678012', 'Gabriel','2000-03-23');
--- INSERINDO CLIENTES QUE NAO FUNCIONAM
INSERT INTO Clientes VALUES('12345678011', 'Marcia', '2001-12-09'); --cpf ja cadastrado
INSERT INTO Clientes VALUES('1234567801', 'Andre', '2001-12-09'); --cpf invalido
INSERT INTO Clientes VALUES('12345678013', 'Kaua', '2010-02-24'); -- cliente menor de idade

    --- ENDERECOS ---
--- INSERINDO ENDERECOS QUE FUNCIONAM
INSERT INTO Enderecos VALUES('12345678011', 'Universitario', 'Residencia');
INSERT INTO Enderecos VALUES('12345678012', 'Universitario', 'Trabalho');
INSERT INTO Enderecos VALUES('12345678012', 'Alto Branco', 'Outro');-- um cliente pode ter mais de um endereco
--- INSERINDO ENDERECOS QUE NAO FUNCIONAM
INSERT INTO Enderecos VALUES('12345678013', 'Santo Antonio', 'Residencia');-- cliente nao esta cadastrado
INSERT INTO Enderecos VALUES('12345678011', 'Liberdade', 'Comercio');-- tipo de endereco invalido

    --- MEDICAMENTOS ---
--- INSERINDO MEDICAMENTOS QUE FUNCIONAM
INSERT INTO Medicamentos VALUES(1, 'Omeprazol', false, 20.00);
INSERT INTO Medicamentos VALUES(2, 'Dipirona', false, 5.20);
INSERT INTO Medicamentos VALUES(3, 'Ritalina', true, 30.0);
--- INSERINDO MEDICAMENTOS QUE NAO FUNCIONAM
INSERT INTO Medicamentos VALUES(2, 'Narix', false, 5.77);-- id ja cadastrado
INSERT INTO Medicamentos VALUES(4, 'Dipirona', false, 4.90);-- nome do remedio ja existe
INSERT INTO Medicamentos VALUES(5, 'Rivotril', true, -13.21);-- valor invalido

    --- VENDAS ---
--- INSERINDO VENDAS QUE FUNCIONAM
INSERT INTO Vendas VALUES(1,'12345678912', 'Vendedor', '12345678011', 2, false);
INSERT INTO Vendas VALUES(2,'12345678912', 'Vendedor', null, 2, false);-- venda de um remedio para um cliente n cadastrado
INSERT INTO Vendas VALUES(3,'12345678912', 'Vendedor', '12345678012', 3, true);-- cliente cadastrado compra remedio com receita
--- INSERINDO VENDAS QUE NAO FUNCIONAM
INSERT INTO Vendas VALUES(3, '12345678912', 'Vendedor', null, 1, false);-- id de venda ja cadastrado
INSERT INTO Vendas VALUES(4, '12345678911', 'Farmaceutico', null, 1, false);-- Somente vendedores podem vender
INSERT INTO Vendas VALUES(5, '12345678912', 'Vendedor', null, 3, true);-- cliente sem cadastro n pode comprar remedio com receita
--- EXCLUSOES PROIBIDAS
DELETE FROM Funcionarios WHERE cpf = '12345678912'; --nao eh possivel excluir funcionario com vendas vinculadas
DELETE FROM Medicamentos WHERE id = 2; --nao eh possivel excluir medicamento vinculado a uma venda

    --- ENTREGAS ---
--- INSERINDO VALORES QUE FUNCIONAM
INSERT INTO Entregas VALUES(1,'12345678915', 'Entregador', '12345678011', 'Universitario');
INSERT INTO Entregas VALUES(2,'12345678915', 'Entregador', '12345678012', 'Universitario');
INSERT INTO Entregas VALUES(3,'12345678915', 'Entregador', '12345678012', 'Alto Branco');
--- INSERINDO VALORES QUE NAO FUNCIONAM
INSERT INTO Entregas VALUES(3,'12345678915', 'Entregador', '12345678012', 'Alto Branco');--id de entrega ja cadastrado
INSERT INTO Entregas VALUES(4,'12345678915', 'Entregador', '12234456789', 'Liberdade');-- cliente n cadastrado
INSERT INTO Entregas VALUES(5,'12345678915', 'Entregador', '12345678012', 'Liberdade');-- endereco invalido p cliente cadastrado
INSERT INTO Entregas VALUES(6,'12345678912', 'Vendedor', '12345678012', 'Alto Branco');-- tipo de funcionario invalido
INSERT INTO Entregas VALUES(7,'12345678915', 'Entregador', null, 'Alto Branco');-- cpf do cliente n pode ser null
INSERT INTO Entregas VALUES(8,'12345678915', 'Entregador', '12345678012', null);-- endereco do cliente n pode ser null
INSERT INTO Entregas VALUES(9,'12345678915', 'Entregador', null, null);-- cliente sem cadastro

