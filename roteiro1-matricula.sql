-- @author Nayara Souza - 118110390

-- Questão 1
-- Considerando 

CREATE TABLE Automovel (
Placa CHAR(7)
Chassi CHAR(17)
Modelo VARCHAR(50)
Marca VARCHAR(50)
Ano INTEGER
Segurado_cpf INTEGER
)

CREATE TABLE Segurado (
Cpf INTEGER
Cnh INTEGER

)

CREATE TABLE Perito (
Cpf
Automovel_Placa
)

CREATE TABLE Seguro (
Contrato
Segurado_Cpf
Automovel_Placa
Preço
Serviços 
)

CREATE TABLE Oficina (


