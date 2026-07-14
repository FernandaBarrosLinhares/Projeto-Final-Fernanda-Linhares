# Pipeline de Dados – Viagens a Serviço do Governo Federal

##  Sobre o projeto

Este projeto tem como objetivo construir um pipeline de dados completo utilizando **Python, SQL e Arquitetura Medallion (Raw, Silver e Gold)**, transformando dados públicos brutos do Portal da Transparência em informações confiáveis para análise e tomada de decisão.

A solução realiza a extração automatizada dos dados de viagens a serviço, preserva os dados originais, realiza tratamentos e modelagem relacional, e disponibiliza análises de negócio por meio de consultas SQL, tabelas agregadas e visualizações gráficas.

---

#  Qual problema resolve?

Os dados públicos disponibilizados pelo Portal da Transparência possuem grande volume e são apresentados em formato bruto, dificultando análises rápidas e confiáveis.

Este projeto resolve esse problema através da criação de um pipeline de dados capaz de:

- Automatizar a extração dos dados;
- Preservar o histórico original para auditoria;
- Transformar dados inconsistentes em informações estruturadas;
- Aplicar regras de qualidade e integridade;
- Gerar indicadores para análise dos gastos públicos com viagens.

---

#  Para quem é essa solução?

A solução pode apoiar:

- Gestores públicos;
- Equipes de transparência e controle;
- Analistas de dados;
- Profissionais responsáveis pelo acompanhamento de gastos públicos;
- Cidadãos interessados em compreender a utilização dos recursos públicos.

---

#  Arquitetura do projeto

O projeto utiliza a **Arquitetura Medallion**, organizada em três camadas:

```
Dados Brutos
      |
      ↓
    RAW
      |
      ↓
   SILVER
      |
      ↓
    GOLD
      |
      ↓
Análises e Indicadores
```

##  Camada Raw

Responsável por armazenar os dados exatamente como foram disponibilizados na fonte original.

Características:

- Dados preservados sem alteração;
- Todas as colunas armazenadas como texto (`VARCHAR`);
- Permite rastreabilidade e auditoria.

Tabelas:

- `raw_viagem`
- `raw_pagamento`
- `raw_passagem`
- `raw_trecho`

---

##  Camada Silver

Responsável pela limpeza, transformação e organização dos dados.

Foram aplicados:

- Conversão de tipos;
- Tratamento de valores monetários;
- Conversão de datas;
- Criação de chaves primárias e estrangeiras;
- Aplicação de constraints;
- Criação de campos calculados.

Campos calculados:

- `valor_total`
- `duracao_dias`

Tabelas:

- `silver_viagem`
- `silver_pagamento`
- `silver_passagem`
- `silver_trecho`

---

##  Camada Gold

Camada preparada para consumo analítico.

Foram criadas:

- Tabelas agregadas;
- Views analíticas;
- Consultas utilizando `JOIN` e `GROUP BY`;
- Indicadores para apoio à tomada de decisão.

---

#  Tecnologias utilizadas

- Python
- SQL
- MySQL
- Pandas
- Matplotlib
- SQLAlchemy
- Jupyter Notebook
- Git/GitHub

---

#  Estrutura do projeto

```
Projeto_Final_Fernanda_Linhares/

│
├── 0_criar_banco.sql
├── 1_extrair.py
├── 2_transformar.py
├── 3_analise.ipynb
│
├── banco.py
├── config.py
│
├── requirements.txt
├── README.md
├── .env.example
└── .gitignore
```

---

# ▶️ Como executar o projeto

## 1. Clonar o repositório

```bash
git clone URL_DO_REPOSITORIO
```

## 2. Criar ambiente virtual

```bash
python -m venv venv
```

Ativar no Windows:

```bash
venv\Scripts\activate
```

---

## 3. Instalar dependências

```bash
python -m pip install -r requirements.txt
```

---

## 4. Configurar variáveis de ambiente

Criar um arquivo `.env` baseado no `.env.example`:

```
MYSQL_HOST=localhost
MYSQL_PORT=3306
MYSQL_USER=root
MYSQL_PASSWORD= "digite aqui sua senha"
MYSQL_DATABASE=transparencia
```

---

## 5. Executar o pipeline

### Criar banco e tabelas

Executar:

```
0_criar_banco.sql
```

### Executar extração dos dados

```bash
python 1_extrair.py
```

Processo realizado:

- Download automático do arquivo;
- Leitura dos arquivos CSV;
- Carga na camada Raw.

### Executar transformação

```bash
python 2_transformar.py
```

Processo realizado:

- Limpeza dos dados;
- Conversão dos tipos;
- Criação da camada Silver.

### Executar análises

Abrir:

```
3_analise.ipynb
```

---

#  Resultados e impacto

O pipeline possibilitou transformar dados públicos brutos em informações estruturadas para análise.

Foram respondidas perguntas de negócio relacionadas a:

- Órgãos com maior custo total;
- Destinos com maior custo médio por viagem;
- Viagem de maior duração;
- Tipos de pagamento com maior valor médio;
- Meios de transporte mais utilizados;
- Estados de destino com maior ocorrência;
- Órgãos com maior volume financeiro pago.

Os resultados permitem uma visão mais clara sobre a distribuição dos gastos públicos com viagens a serviço.

---

#  O que aprendi?

Durante o desenvolvimento do projeto foram aplicados conhecimentos de:

- Construção de pipelines ETL;
- Arquitetura Medallion;
- Tratamento e qualidade de dados;
- Modelagem relacional;
- Integração entre Python e banco de dados;
- Consultas SQL analíticas;
- Visualização de dados;
- Organização e versionamento com GitHub.

---

# Melhorias futuras

Como evolução do projeto, podem ser aplicadas:

- Automatização do pipeline com ferramentas de orquestração;
- Criação de dashboards interativos;
- Implantação em ambiente de nuvem;
- Aplicação de modelos preditivos para análise de gastos;
- Criação de alertas para identificação de padrões de despesas.

---

# Autora

Fernanda Linhares

Projeto desenvolvido como parte da formação em **Análise de Dados com Python**.