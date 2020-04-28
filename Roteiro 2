-- @author Nayara Souza - 118110390

                -- QUESTAO 1 --

CREATE TABLE Tarefas (
    id                  INTEGER,
    descricao_tarefa    TEXT,
    func_resp_cpf       CHAR(11),
    prioridade_tarefa   INTEGER,
    status_tarefa       CHAR(1)
);

                -- QUESTAO 2 --
ALTER TABLE Tarefas ALTER COLUMN id TYPE BIGINT;

                -- QUESTAO 3 --
ALTER TABLE Tarefas ALTER COLUMN prioridade_tarefa TYPE SMALLINT;

                -- QUESTAO 4 --
-- Alterar nome dos atributos
ALTER TABLE Tarefas RENAME COLUMN descricao_tarefa TO descricao;
ALTER TABLE Tarefas RENAME COLUMN prioridade_tarefa TO prioridade;
ALTER TABLE Tarefas RENAME COLUMN status_tarefa TO status;

-- Primeiro apagar valores null visto que eles nao serao permitidos
DELETE FROM Tarefas WHERE id IS NULL;

-- Nao permitindo valores NULL
ALTER TABLE Tarefas ALTER COLUMN id SET NOT NULL;
ALTER TABLE Tarefas ALTER COLUMN descricao SET NOT NULL;
ALTER TABLE Tarefas ALTER COLUMN func_resp_cpf SET NOT NULL;
ALTER TABLE Tarefas ALTER COLUMN prioridade SET NOT NULL;
ALTER TABLE Tarefas ALTER COLUMN status SET NOT NULL;

                -- QUESTAO 5 --
-- Adicionando Constraint para tornar o valor de id unico
ALTER TABLE Tarefas ADD CONSTRAINT id_unico UNIQUE(id);

                -- QUESTAO 6 --
    -- ITEM A
ALTER TABLE Tarefas ADD CONSTRAINT func_resp_cpf_n_char CHECK(LENGTH(func_resp_cpf) = 11);
    -- ITEM B
-- Atualizando os valores dos status já existentes
UPDATE Tarefas SET status = 'P' WHERE status = 'A';
UPDATE Tarefas SET status = 'E' WHERE status = 'R';
UPDATE Tarefas SET status = 'C' WHERE status = 'F';
-- Adicionando as constrants
ALTER TABLE Tarefas ADD CONSTRAINT status_check_char CHECK(status = 'P' OR status = 'E' OR status = 'C');

                -- QUESTAO 7 --
-- Atualizando os valores de prioridade que nao existem no range(5)
UPDATE Tarefas SET prioridade = 5 WHERE prioridade > 5;
UPDATE Tarefas SET prioridade = 0 WHERE prioridade < 0;
-- Inserindo a Constraint
ALTER TABLE Tarefas ADD CONSTRAINT prioridade_check_value CHECK(prioridade >= 0 AND prioridade <= 5);

                -- QUESTAO 8 --
CREATE TABLE Funcionario (
    cpf                 CHAR(11)    NOT NULL       PRIMARY KEY,
    data_nasc           DATE        NOT NULL,
    nome                TEXT        NOT NULL,
    funcao              TEXT        NOT NULL,
    nivel               CHAR(1)     NOT NULL,
    superior_cpf        CHAR(11),
    FOREIGN KEY(superior_cpf) REFERENCES Funcionario(cpf),
    CONSTRAINT cpf_n_char CHECK (LENGTH(cpf) = 11),
    -- Onde Limpeza precisa de um superior, porem sup_limpeza nao precisa
    CONSTRAINT limpeza_check CHECK (funcao = 'SUP_LIMPEZA' OR funcao = 'LIMPEZA'),
    CONSTRAINT funcao_limpeza_check CHECK (funcao = 'SUP_LIMPEZA' OR superior_cpf IS NOT NULL),
    CONSTRAINT nivel_valido CHECK(nivel = 'J' OR nivel = 'P' OR nivel = 'S')
);

            -- QUESTAO 9 --
-- Insercoes que funcionam em funcionario
INSERT INTO Funcionario VALUES ('12345678914', '1980-05-10', 'Carlos Souza', 'SUP_LIMPEZA','S', null);
INSERT INTO Funcionario VALUES ('12345678915', '1980-06-11', 'Ana Oliveira', 'SUP_LIMPEZA','S', null);
INSERT INTO Funcionario VALUES ('12345678916', '1980-07-12', 'Andre Lucas', 'SUP_LIMPEZA','S', null);
INSERT INTO Funcionario VALUES ('12345678917', '1980-08-13', 'Lia Andrade', 'LIMPEZA','P', '12345678914');
INSERT INTO Funcionario VALUES ('12345678918', '1980-09-14', 'Pedro Marcos', 'LIMPEZA','P', '12345678915');
INSERT INTO Funcionario VALUES ('12345678919', '1980-10-15', 'Gabriel Gomes', 'LIMPEZA','P', '12345678916');
INSERT INTO Funcionario VALUES ('12345678920', '1980-11-16', 'Jessica Ribeiro', 'LIMPEZA','J','12345678914');
INSERT INTO Funcionario VALUES ('12345678921', '1980-12-17', 'Bianca Soares', 'LIMPEZA','J', '12345678915');
INSERT INTO Funcionario VALUES ('12345678922', '1981-01-18', 'Brenda Almeida', 'LIMPEZA','J', '12345678917');
INSERT INTO Funcionario VALUES ('12345678923', '1981-02-19', 'Paulo Freire', 'LIMPEZA','J', '12345678919');
-- Insercoes que nao funcionam em funcionario
INSERT INTO Funcionario VALUES ('123456789145', '1980-05-10', 'Carlos Souza', 'SUP_LIMPEZA','S', null);
INSERT INTO Funcionario VALUES ('12345678915', '1980-06-11', 'Ana Oliveira', 'SUP_LIMPEZA','S', '12345678914');
INSERT INTO Funcionario VALUES ('12345678916', '1980-31-12', 'Andre Lucas', 'SUP_LIMPEZA','S', null);
INSERT INTO Funcionario VALUES ('1234567891', '1980-08-13', 'Lia Andrade', 'LIMPEZA','P', '12345678914');
INSERT INTO Funcionario VALUES ('12345678918', '1980-09-14', null, 'LIMPEZA','P', '12345678915');
INSERT INTO Funcionario VALUES ('12345678919', '1980-10-15', 'Gabriel Gomes', null,'P', '12345678916');
INSERT INTO Funcionario VALUES ('12345678920', '1980-11-16', 'Jessica Ribeiro', 'LIMPEZA',null,'12345678914');
INSERT INTO Funcionario VALUES ('12345678921', '1980-12-17', 'Bianca Soares', 'LIMPEZA','J', null);
INSERT INTO Funcionario VALUES ('12345678922', '1981-01-18', 'Brenda Almeida', 'LIMPEZA','K', '12345678917');
INSERT INTO Funcionario VALUES (null, '1981-02-19', 'Paulo Freire', 'LIMPEZA','J', '12345678919');

            -- QUESTAO 10 --
-- Primeiramente adicionar funcionarios com os cpfs existentes em tarefas
INSERT INTO Funcionario VALUES ('32323232955', '1980-05-10', 'Erica di Paulo', 'SUP_LIMPEZA','S', null);
INSERT INTO Funcionario VALUES ('32323232911', '1980-06-11', 'Amanda Lima', 'SUP_LIMPEZA','S', null);
INSERT INTO Funcionario VALUES ('98765432111', '1980-07-12', 'Augusto Santos', 'SUP_LIMPEZA','S', null);
INSERT INTO Funcionario VALUES ('98765432122', '1980-08-13', 'Lucas Costa', 'LIMPEZA','P', '12345678914');
    -- Opcao 1
-- Adicionar a constraint para a foreign key
ALTER TABLE Tarefas ADD CONSTRAINT FK_func_resp_cpf FOREIGN KEY (func_resp_cpf) REFERENCES Funcionario(cpf) ON DELETE CASCADE;
-- Delete ocorreu sem erros :)
DELETE FROM Funcionario WHERE cpf = '32323232911';
    -- Opcao 2
ALTER TABLE Tarefas DROP CONSTRAINT FK_func_resp_cpf;
ALTER TABLE Tarefas ADD CONSTRAINT FK_func_resp_cpf FOREIGN KEY (func_resp_cpf) REFERENCES Funcionario(cpf) ON DELETE RESTRICT;
-- ON DELETE RESTRIC nao permite que um elemento na tabela filha com uma chave existente na tabela pai seja deletada
DELETE FROM Funcionario WHERE cpf = '32323232911';

                -- QUESTAO 11 --
-- NULL em func_resp_cpf 
ALTER TABLE Tarefas ALTER COLUMN func_resp_cpf DROP NOT NULL ;
-- Adicionar constraint para o caso de null
ALTER TABLE Tarefas ADD CONSTRAINT null_in_func_resp_cpf CHECK ((status = 'E' AND func_resp_cpf IS NOT NULL) OR
                                                                (status = 'C' AND func_resp_cpf IS NOT NULL) OR
                                                                (status = 'P' AND func_resp_cpf IS NOT NULL) OR
                                                                (status = 'P' AND func_resp_cpf IS NULL));
-- Alterar constraint da questao 10
ALTER TABLE Tarefas DROP CONSTRAINT FK_func_resp_cpf;
ALTER TABLE Tarefas ADD CONSTRAINT FK_func_resp_cpf FOREIGN KEY (func_resp_cpf) REFERENCES Funcionario(cpf) ON DELETE SET NULL;
 -- Quando o funcionario a ser deletado contem tarefas com status 'E' e/ou 'C', ele nao pode ser deletado pois esses status n podem conter NULL, segundo a constraint
