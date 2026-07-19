## Pergunta 1 – Quais são os 5 órgãos com maior custo total?

Para identificar os órgãos com maior impacto financeiro, foi realizada uma agregação dos valores totais das viagens por órgão superior. A análise considera a soma do campo valor_total da camada Silver, permitindo identificar quais órgãos concentraram os maiores gastos no período analisado.

### Análise dos resultados

A análise identificou os cinco órgãos superiores com maior custo total em viagens no período avaliado.

O Ministério da Justiça e Segurança Pública apresentou o maior volume de gastos, seguido pelo Ministério da Defesa e pelo Ministério da Educação. A concentração dos valores nesses órgãos indica uma maior demanda por deslocamentos relacionados
às suas atividades institucionais.

Essa análise permite identificar quais órgãos possuem maior participação nos gastos com viagens e pode auxiliar em avaliações futuras relacionadas à quantidade de viagens realizadas, duração dos deslocamentos e tipos de pagamento utilizados.

## Pergunta 2 – Quais são os 3 destinos com maior custo médio por viagem?

Para responder a esta pergunta, foram utilizados os dados das tabelas silver_trecho e silver_viagem, relacionadas pelo identificador da viagem (id_viagem).

Como uma mesma viagem pode possuir mais de um trecho registrado para o mesmo destino, foi utilizada uma subconsulta com SELECT DISTINCT, garantindo que cada combinação de viagem e destino fosse considerada apenas uma vez no cálculo da média.

Além disso, foram consideradas apenas viagens com valor_total maior que zero e destinos com pelo menos 30 viagens registradas, reduzindo a influência de registros com poucas ocorrências.

### Análise dos resultados

A análise identificou os três destinos com maior custo médio por viagem entre aqueles com pelo menos 30 viagens registradas. Após eliminar duplicidades de trechos de uma mesma viagem para o mesmo destino, Monte Negro (Rondônia) apresentou o maior custo médio, seguido por Sananduva e Nonoai, ambos no Rio Grande do Sul.

A utilização do SELECT DISTINCT garantiu que cada viagem fosse contabilizada apenas uma vez por destino, evitando que registros duplicados influenciassem o cálculo da média e tornando os resultados mais representativos.

### 3 Maior duração registrada

Inicialmente, foi identificada a viagem de maior duração presente na base de dados, sem aplicar filtros sobre o custo total. O objetivo é responder exatamente à pergunta proposta, identificando o maior período registrado entre as viagens.

Essa abordagem permite verificar se o registro de maior duração possui custo associado ou se representa um caso particular da base.

### Análise dos resultados

A maior duração registrada na base corresponde a **383 dias**, pertencente ao Ministério da Previdência Social.

Entretanto, essa viagem apresenta **custo total igual a R$ 0,00**, indicando um registro sem impacto financeiro. Embora responda à pergunta proposta, esse resultado deve ser interpretado com cautela, pois pode representar uma viagem ainda não finalizada, um registro incompleto ou outra situação administrativa.

## Pergunta 4 – Qual o tipo de pagamento com maior valor médio?

Para responder a esta pergunta, foi utilizada a tabela `silver_pagamento`, que contém os registros dos pagamentos realizados nas viagens a serviço.

Os pagamentos foram agrupados por `tipo_pagamento` e, para cada categoria, foi calculada a média dos valores pagos. Em seguida, os resultados foram ordenados em ordem decrescente, permitindo identificar o tipo de pagamento com maior valor médio.

Essa análise possibilita comparar o impacto financeiro médio entre as diferentes modalidades de pagamento registradas na base.

## Análise dos resultados

A análise dos valores médios por tipo de pagamento identificou que **DIÁRIAS** apresentou o maior valor médio registrado, com aproximadamente **R$ 2.078,28** por pagamento.

O tipo de pagamento **PASSAGEM** apresentou o segundo maior valor médio, com aproximadamente **R$ 1.878,34**, enquanto as categorias **Serviço correlato: seguro** e **RESTITUIÇÃO** apresentaram valores médios inferiores.

Os resultados indicam que as despesas relacionadas às diárias possuem maior impacto financeiro médio entre os tipos de pagamento analisados, sendo um dos principais componentes dos gastos associados às viagens a serviço.

## Pergunta 5 – Qual o meio de transporte mais usado nos trechos?

Para identificar o meio de transporte mais utilizado nos trechos das viagens, foi analisada a tabela `silver_trecho`, que contém os registros dos deslocamentos realizados.

A análise foi realizada contabilizando a quantidade de ocorrências para cada meio de transporte, permitindo identificar quais modalidades apresentam maior frequência nos trajetos registrados.

Essa informação auxilia na compreensão do perfil de deslocamento das viagens a serviço e na identificação dos meios de transporte mais utilizados na base analisada.
## Análise dos resultados

A análise dos trechos registrados identificou que o meio de transporte mais utilizado foi o **Veículo Oficial**, com **386.424 ocorrências**, seguido pelo transporte **Aéreo**, com **232.666 registros**.

Os demais meios de transporte apresentaram uma frequência menor, como o transporte **Rodoviário** e o uso de **Veículo Próprio**. Também foram identificados registros classificados como **Inválido**, que representam ocorrências sem uma categorização válida do meio de transporte.

Os resultados demonstram que os deslocamentos realizados com veículo oficial e transporte aéreo concentram a maior parte dos trechos analisados, indicando os principais padrões de mobilidade das viagens a serviço.

## Pergunta 6 – Qual UF de destino aparece em mais trechos?

Para identificar quais unidades federativas aparecem com maior frequência como destino das viagens, foi realizada uma análise dos registros da tabela `silver_trecho`.

A consulta contabilizou a quantidade de trechos agrupados por UF de destino, permitindo identificar os estados com maior ocorrência nos deslocamentos registrados.

Essa análise possibilita compreender a distribuição geográfica dos destinos das viagens a serviço e identificar as regiões com maior concentração de deslocamentos.

## Análise dos resultados

A análise dos trechos por unidade federativa de destino identificou que **São Paulo** foi o destino com maior quantidade de ocorrências, totalizando **82.722 trechos registrados**.

Em seguida, aparecem o **Distrito Federal**, com **79.962 trechos**, e **Minas Gerais**, com **50.965 registros**, demonstrando uma maior concentração dos deslocamentos para essas regiões.

Também foram encontrados registros sem UF de destino preenchida e ocorrências classificadas como inválidas. Esses registros não foram considerados na interpretação dos resultados, pois não representam uma unidade federativa válida.

Os dados indicam que os deslocamentos das viagens a serviço apresentam maior concentração nos principais centros administrativos e econômicos do país, com destaque para São Paulo e Distrito Federal.

### Criação da tabela Gold

A primeira etapa consiste na criação da tabela `gold_resumo_orgao`, construída a partir das tabelas `silver_viagem` e `silver_pagamento`, relacionadas pelo identificador da viagem (`id_viagem`).

A agregação é realizada por órgão superior, utilizando operações de JOIN e GROUP BY. Como resultado, a tabela consolida os seguintes indicadores:

- quantidade de viagens;
- quantidade de pagamentos;
- valor total pago;
- valor médio dos pagamentos.

Esses indicadores servem como base para consultas e análises da camada Gold.

## Pergunta 7 – Qual órgão pagou mais no total?

Para responder a esta pergunta, foi utilizada a VIEW `vw_gold_resumo_orgao`, criada na camada Gold.

A consulta ordena os órgãos pelo valor total pago, permitindo identificar quais concentraram os maiores gastos com viagens a serviço durante o período analisado.

### Análise dos resultados

A análise identificou que o órgão posicionado no topo do ranking concentrou o maior valor total pago em viagens a serviço durante o período analisado.

Os demais órgãos apresentaram valores inferiores, evidenciando diferenças na execução das despesas relacionadas às viagens. A utilização da camada Gold permitiu responder à pergunta de negócio por meio de indicadores previamente agregados, simplificando a consulta e demonstrando a aplicação da arquitetura Medallion na disponibilização de dados para análise.