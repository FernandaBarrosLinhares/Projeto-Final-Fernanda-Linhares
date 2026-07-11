import banco

# ==========================================================
# 1) Limpar tabelas SILVER
#
# A ordem importa por causa das chaves estrangeiras.
# Primeiro removemos tabelas filhas e depois a tabela principal.
#
# Relação:
# silver_pagamento  -> silver_viagem
# silver_passagem   -> silver_viagem
# silver_trecho     -> silver_viagem
# ==========================================================

LIMPAR_SILVER = [
    "DELETE FROM silver_trecho",
    "DELETE FROM silver_passagem",
    "DELETE FROM silver_pagamento",
    "DELETE FROM silver_viagem",
]


# ==========================================================
# 2) RAW -> SILVER
#
# Conversões realizadas:
#
# Datas:
# STR_TO_DATE()
#
# Valores:
# CAST(... AS DECIMAL)
#
# NULL:
# NULLIF + TRIM evitam problemas com campos vazios.
# ==========================================================


SQL_VIAGEM = """
INSERT INTO silver_viagem (
    id_viagem,
    num_proposta,
    situacao,
    viagem_urgente,
    cod_orgao_superior,
    nome_orgao_superior,
    nome_viajante,
    cargo,
    data_inicio,
    data_fim,
    destinos,
    motivo,
    valor_diarias,
    valor_passagens,
    valor_devolucao,
    valor_outros_gastos
)
SELECT
    identificadorProcessoViagem,
    numeroPropostaPcdp,
    situacao,
    viagemUrgente,
    codigoOrgaoSuperior,
    nomeOrgaoSuperior,
    nome,
    cargo,

    STR_TO_DATE(
        NULLIF(TRIM(periodoDataInicio), ''),
        '%d/%m/%Y'
    ),

    STR_TO_DATE(
        NULLIF(TRIM(periodoDataFim), ''),
        '%d/%m/%Y'
    ),

    destinos,
    motivo,

    CAST(
        REPLACE(
            REPLACE(NULLIF(TRIM(valorDiarias), ''), '.', ''),
            ',', '.'
        )
        AS DECIMAL(10,2)
    ),

    CAST(
        REPLACE(
            REPLACE(NULLIF(TRIM(valorPassagens), ''), '.', ''),
            ',', '.'
        )
        AS DECIMAL(10,2)
    ),

    CAST(
        REPLACE(
            REPLACE(NULLIF(TRIM(valorDevolucao), ''), '.', ''),
            ',', '.'
        )
        AS DECIMAL(10,2)
    ),

    CAST(
        REPLACE(
            REPLACE(NULLIF(TRIM(valorOutrosGastos), ''), '.', ''),
            ',', '.'
        )
        AS DECIMAL(10,2)
    )

FROM raw_viagem;
"""


SQL_PAGAMENTO = """
INSERT INTO silver_pagamento (
    id_viagem,
    num_proposta,
    nome_orgao_pagador,
    nome_ug_pagadora,
    tipo_pagamento,
    valor
)
SELECT
    identificadorProcessoViagem,
    numeroPropostaPcdp,
    nomeOrgaoPagador,
    nomeUnidadeGestoraPagadora,
    tipoPagamento,

    CAST(
        REPLACE(
            REPLACE(NULLIF(TRIM(valor), ''), '.', ''),
            ',', '.'
        )
        AS DECIMAL(10,2)
    )

FROM raw_pagamento;
"""


SQL_PASSAGEM = """
INSERT INTO silver_passagem (
    id_viagem,
    meio_transporte,
    pais_origem_ida,
    uf_origem_ida,
    cidade_origem_ida,
    pais_destino_ida,
    uf_destino_ida,
    cidade_destino_ida,
    valor_passagem,
    taxa_servico,
    data_emissao
)
SELECT
    identificadorProcessoViagem,
    meioTransporte,
    paisOrigemIda,
    ufOrigemIda,
    cidadeOrigemIda,
    paisDestinoIda,
    ufDestinoIda,
    cidadeDestinoIda,

    CAST(
        REPLACE(
            REPLACE(NULLIF(TRIM(valorPassagem), ''), '.', ''),
            ',', '.'
        )
        AS DECIMAL(10,2)
    ),

    CAST(
        REPLACE(
            REPLACE(NULLIF(TRIM(taxaServico), ''), '.', ''),
            ',', '.'
        )
        AS DECIMAL(10,2)
    ),

    STR_TO_DATE(
        NULLIF(TRIM(dataEmissaoCompra), ''),
        '%d/%m/%Y'
    )

FROM raw_passagem;
"""


SQL_TRECHO = """
INSERT INTO silver_trecho (
    id_viagem,
    sequencia_trecho,
    origem_data,
    origem_uf,
    origem_cidade,
    destino_data,
    destino_uf,
    destino_cidade,
    meio_transporte,
    numero_diarias
)
SELECT
    identificadorProcessoViagem,

    CAST(
        NULLIF(TRIM(sequenciaTrecho), '')
        AS UNSIGNED
    ),

    STR_TO_DATE(
        NULLIF(TRIM(origemData), ''),
        '%d/%m/%Y'
    ),

    origemUf,
    origemCidade,

    STR_TO_DATE(
        NULLIF(TRIM(destinoData), ''),
        '%d/%m/%Y'
    ),

    destinoUf,
    destinoCidade,
    meioTransporte,

    CAST(
        REPLACE(
            REPLACE(NULLIF(TRIM(numeroDiarias), ''), '.', ''),
            ',', '.'
        )
        AS DECIMAL(10,2)
    )

FROM raw_trecho;
"""


# ==========================================================
# 3) Cálculo das colunas derivadas
#
# valor_total:
#   valor líquido da viagem
#
# Fórmula:
#   diárias
# + passagens
# + outros gastos
# - devolução
#
# COALESCE:
#   substitui NULL por zero.
#
# duracao_dias:
#   diferença entre data final e inicial.
# ==========================================================


SQL_CALC_VIAGEM = """
UPDATE silver_viagem
SET

    valor_total =
          COALESCE(valor_diarias, 0)
        + COALESCE(valor_passagens, 0)
        + COALESCE(valor_outros_gastos, 0)
        - COALESCE(valor_devolucao, 0),

    duracao_dias =
        DATEDIFF(data_fim, data_inicio);
"""


# ==========================================================
# EXECUÇÃO PRINCIPAL
# ==========================================================


def main():

    print("=== FASE 2: TRANSFORMACAO + CAMADA SILVER ===")

    try:

        conexao = banco.conectar()


        print("[1/3] Esvaziando as tabelas SILVER...")

        for comando in LIMPAR_SILVER:
            banco.executar(conexao, comando)



        print("[2/3] Copiando e convertendo RAW -> SILVER...")


        banco.executar(conexao, SQL_VIAGEM)
        print("      silver_viagem    OK")


        banco.executar(conexao, SQL_PAGAMENTO)
        print("      silver_pagamento OK")


        banco.executar(conexao, SQL_PASSAGEM)
        print("      silver_passagem  OK")


        banco.executar(conexao, SQL_TRECHO)
        print("      silver_trecho    OK")



        print("[3/3] Calculando valor_total e duracao_dias...")


        banco.executar(conexao, SQL_CALC_VIAGEM)



        # Garante gravação das alterações
        conexao.commit()


        conexao.close()


        print("=== Camada SILVER concluída com sucesso! ===")



    except Exception as erro:

        print("[ERRO] Algo deu errado:", erro)

        raise



if __name__ == "__main__":
    main()