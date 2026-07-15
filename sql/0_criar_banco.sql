CREATE DATABASE IF NOT EXISTS transparencia
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_general_ci;

USE transparencia;


-- CRIAÇÃO DA TABELA VIAGENS

DROP TABLE IF EXISTS raw_viagem;

CREATE TABLE raw_viagem (
    identificadorProcessoViagem   VARCHAR(50),
    numeroPropostaPcdp            VARCHAR(20),
    situacao                      VARCHAR(100),
    viagemUrgente                 VARCHAR(100),
    justificativaUrgenciaViagem   VARCHAR(4000),
    codigoOrgaoSuperior           VARCHAR(20),
    nomeOrgaoSuperior             VARCHAR(255),
    codigoOrgaoSolicitante        VARCHAR(20),
    nomeOrgaoSolicitante          VARCHAR(255),
    cpfViajante                   VARCHAR(20),
    nome                          VARCHAR(255),
    cargo                         VARCHAR(255),
    funcao                        VARCHAR(255),
    descricaoFuncao               VARCHAR(255),
    periodoDataInicio             VARCHAR(20),
    periodoDataFim                VARCHAR(20),
    destinos                      VARCHAR(4000),
    motivo                        VARCHAR(4000),
    valorDiarias                  VARCHAR(30),
    valorPassagens                VARCHAR(30),
    valorDevolucao                VARCHAR(30),
    valorOutrosGastos             VARCHAR(30)
) ENGINE=InnoDB;


-- Criação da tabela Trecho

DROP TABLE IF EXISTS raw_trecho;

CREATE TABLE raw_trecho (
    identificadorProcessoViagem   VARCHAR(50),
    numeroPropostaPcdp            VARCHAR(20),
    sequenciaTrecho               VARCHAR(10),
    origemData                    VARCHAR(20),
    origemPais                    VARCHAR(100),
    origemUf                      VARCHAR(100),
    origemCidade                  VARCHAR(100),
    destinoData                   VARCHAR(20),
    destinoPais                   VARCHAR(100),
    destinoUf                     VARCHAR(100),
    destinoCidade                 VARCHAR(100),
    meioTransporte                VARCHAR(100),
    numeroDiarias                 VARCHAR(31),
    missao                        VARCHAR(100)
) ENGINE=InnoDB;


-- Criacao da tabela passagem

DROP TABLE IF EXISTS raw_passagem;

CREATE TABLE raw_passagem (
    identificadorProcessoViagem   VARCHAR(50),
    numeroPropostaPcdp            VARCHAR(20),
    meioTransporte                VARCHAR(100),
    paisOrigemIda                 VARCHAR(100),
    ufOrigemIda                   VARCHAR(40),
    cidadeOrigemIda               VARCHAR(100),
    paisDestinoIda                VARCHAR(100),
    ufDestinoIda                  VARCHAR(100),
    cidadeDestinoIda              VARCHAR(100),
    paisOrigemVolta               VARCHAR(100),
    ufOrigemVolta                 VARCHAR(40),
    cidadeOrigemVolta             VARCHAR(100),
    paisDestinoVolta              VARCHAR(100),
    ufDestinoVolta                VARCHAR(40),
    cidadeDestinoVolta            VARCHAR(100),
    valorPassagem                 VARCHAR(30),
    taxaServico                   VARCHAR(30),
    dataEmissaoCompra             VARCHAR(20),
    horaEmissaoCompra             VARCHAR(20)
) ENGINE=InnoDB;


-- Criacao da tabela pagamento

DROP TABLE IF EXISTS raw_pagamento;

CREATE TABLE raw_pagamento (
    identificadorProcessoViagem    VARCHAR(50),
    numeroPropostaPcdp             VARCHAR(20),
    codigoOrgaoSuperior            VARCHAR(20),
    nomeOrgaoSuperior              VARCHAR(255),
    codigoOrgaoPagador             VARCHAR(20),
    nomeOrgaoPagador               VARCHAR(255),
    codigoUnidadeGestoraPagadora   VARCHAR(20),
    nomeUnidadeGestoraPagadora     VARCHAR(255),
    tipoPagamento                  VARCHAR(100),
    valor                          VARCHAR(30)
) ENGINE=InnoDB;

-- Criacao tabela silver_viagem

DROP TABLE IF EXISTS silver_viagem;

CREATE TABLE silver_viagem (
    id_viagem              VARCHAR(20) PRIMARY KEY NOT NULL,
    num_proposta           VARCHAR(20),
    situacao               VARCHAR(50),
    viagem_urgente         VARCHAR(5),
    cod_orgao_superior     VARCHAR(20),
    nome_orgao_superior    VARCHAR(255) NOT NULL,
    nome_viajante          VARCHAR(255),
    cargo                  VARCHAR(255),
    data_inicio            DATE,
    data_fim               DATE,
    destinos               VARCHAR(4000),
    motivo                 VARCHAR(4000),
    valor_diarias          DECIMAL(10,2),
    valor_passagens        DECIMAL(10,2),
    valor_devolucao        DECIMAL(10,2),
    valor_outros_gastos    DECIMAL(10,2),
    valor_total            DECIMAL(12,2),
    duracao_dias           INT,

    CONSTRAINT chk_valor_diarias
        CHECK (valor_diarias >= 0)
) ENGINE=InnoDB;

-- Criacao da tabela pagamento silver

DROP TABLE IF EXISTS silver_pagamento;

CREATE TABLE silver_pagamento (
    id_pagamento          INT AUTO_INCREMENT,
    id_viagem             VARCHAR(20) NOT NULL,
    num_proposta          VARCHAR(20),
    nome_orgao_pagador    VARCHAR(255),
    nome_ug_pagadora      VARCHAR(255),
    tipo_pagamento        VARCHAR(50) NOT NULL,
    valor                 DECIMAL(10,2),

    PRIMARY KEY (id_pagamento),

    CONSTRAINT fk_pagamento_viagem
        FOREIGN KEY (id_viagem)
        REFERENCES silver_viagem(id_viagem),

    CONSTRAINT chk_pagamento_valor
        CHECK (valor >= 0)
) ENGINE=InnoDB;

-- Criacao da tabela silver trecho

DROP TABLE IF EXISTS silver_passagem;

CREATE TABLE silver_passagem (
    id_passagem         INT AUTO_INCREMENT,
    id_viagem           VARCHAR(20) NOT NULL,
    meio_transporte     VARCHAR(50),
    pais_origem_ida     VARCHAR(60),
    uf_origem_ida       VARCHAR(40),
    cidade_origem_ida   VARCHAR(80),
    pais_destino_ida    VARCHAR(60),
    uf_destino_ida      VARCHAR(40),
    cidade_destino_ida  VARCHAR(80),
    valor_passagem      DECIMAL(10,2),
    taxa_servico        DECIMAL(10,2),
    data_emissao        DATE,

    PRIMARY KEY (id_passagem),

    CONSTRAINT fk_passagem_viagem
        FOREIGN KEY (id_viagem)
        REFERENCES silver_viagem(id_viagem),

    CONSTRAINT chk_valor_passagem
        CHECK (valor_passagem >= 0),

    CONSTRAINT chk_taxa_servico
        CHECK (taxa_servico >= 0)
) ENGINE=InnoDB;

-- Criacao das tabels silver trecho

DROP TABLE IF EXISTS silver_trecho;

CREATE TABLE silver_trecho (
    id_trecho          INT AUTO_INCREMENT,
    id_viagem          VARCHAR(20) NOT NULL,
    sequencia_trecho   INT,
    origem_data        DATE,
    origem_uf          VARCHAR(40),
    origem_cidade      VARCHAR(80),
    destino_data       DATE,
    destino_uf         VARCHAR(40),
    destino_cidade     VARCHAR(80),
    meio_transporte    VARCHAR(50),
    numero_diarias     DECIMAL(10,2),

    PRIMARY KEY (id_trecho),

    CONSTRAINT fk_trecho_viagem
        FOREIGN KEY (id_viagem)
        REFERENCES silver_viagem(id_viagem),

    CONSTRAINT chk_numero_diarias
        CHECK (numero_diarias >= 0),

    CONSTRAINT uq_trecho
        UNIQUE (id_viagem, sequencia_trecho)
) ENGINE=InnoDB;