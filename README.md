# O Mercado de Dados no Brasil — Tech Challenge Fase 3 (FIAP)

Projeto de Engenharia de Dados & Analytics desenvolvido para a Fase 3 da pós-graduação em Data Analytics da FIAP. O desafio simula uma consultoria de dados contratada por uma **Instituição Financeira de grande porte** que planeja expandir sua área de Dados, Analytics e Inteligência Artificial e precisa, antes disso, entender o cenário atual do profissional de dados no Brasil.

A base utilizada é a pesquisa **State of Data Brasil 2021**, conduzida pela comunidade Data Hackers, com 2.645 respondentes.

## Sumário

1. [Objetivo do projeto](#objetivo-do-projeto)
2. [Arquitetura da solução](#arquitetura-da-solução)
3. [Pipeline de dados — passo a passo](#pipeline-de-dados--passo-a-passo)
4. [O desafio dos nomes de coluna](#o-desafio-dos-nomes-de-coluna)
5. [Camada Gold — a view analítica](#camada-gold--a-view-analítica)
6. [Perguntas de negócio respondidas](#perguntas-de-negócio-respondidas)
7. [Limitações e próximos passos](#limitações-e-próximos-passos)
8. [Estrutura do repositório](#estrutura-do-repositório)
9. [Como reproduzir](#como-reproduzir)

## Objetivo do projeto

Responder, com dados, às perguntas que orientariam a estratégia de contratação, capacitação e investimento em tecnologia da instituição financeira fictícia:

- Como está estruturado o mercado de profissionais de dados no Brasil?
- Quais perfis profissionais são mais valorizados?
- Qual o cenário de diversidade de gênero na área?
- Quais tecnologias são mais adotadas (linguagens, cloud, ferramentas de BI)?
- Como o modelo de trabalho (remoto/híbrido/presencial) se distribui?
- Como a senioridade varia por região do país?
- Qual o índice de adoção de Inteligência Artificial?

## Arquitetura da solução

O pipeline segue o padrão **medalhão (bronze → prata → gold)**, implementado inteiramente na AWS:

```
CSV (State of Data Brasil 2021)
        │
        ▼
   Amazon S3  ───────────────►  BRONZE (dado bruto, sem tratamento)
        │
        ▼
   AWS Glue (crawler + catalog)
        │  conversão para Parquet
        ▼
   Tabela tb-data-hacker  ────►  PRATA (dado convertido/catalogado, ainda com nomes de coluna sujos)
        │
        ▼
   Amazon Athena (SQL)
        │  view vw_data_hacker_2021
        ▼
   Gold (dado tratado, pronto para análise)  ────►  gold.csv (export final)
        │
        ▼
   Python (pandas) — validação cruzada dos números
        │
        ▼
   Apresentação executiva (PowerPoint com gráficos nativos)
```

O diagrama de arquitetura completo está em [`/diagrams`](./diagrams) (Draw.io).

**Por que essa analogia de cozinha?** Bronze são os ingredientes crus (o CSV original, do jeito que veio da pesquisa). Prata são os ingredientes já cortados e organizados (dado convertido para Parquet e catalogado pelo Glue, mas com nomes de coluna ainda ilegíveis). Gold é o prato pronto pra servir — a view SQL que renomeia, filtra e organiza tudo para responder às perguntas do negócio diretamente.

## Pipeline de dados — passo a passo

1. **Download da base**: arquivo CSV da pesquisa State of Data Brasil 2021 (Data Hackers).
2. **Ingestão no S3**: upload do CSV bruto para um bucket S3 (camada Bronze).
3. **Catalogação com Glue**: um crawler do AWS Glue varreu o CSV, inferiu o schema e converteu os dados para o formato colunar **Parquet**, criando a tabela `tb-data-hacker` no Glue Data Catalog (camada Prata).
4. **Consulta com Athena**: o Amazon Athena foi usado como motor de consulta SQL (engine Trino/Presto) sobre a tabela catalogada, sem necessidade de subir nenhum banco de dados.
5. **Diagnóstico dos nomes de coluna**: os cabeçalhos do CSV original vieram de uma exportação pandas com múltiplos níveis de cabeçalho não "achatados" (formato tipo `('P1_b ', 'Genero')`). O Glue sanitiza automaticamente esses nomes, trocando cada caractere inválido por `_` e acrescentando um sufixo numérico (`_0`, `_1`...) para garantir nomes únicos — o resultado são colunas como `_'p1_b_'_'genero'_0`.
6. **Criação da view analítica**: construímos, via `CREATE OR REPLACE VIEW`, a view `vw_data_hacker_2021`, que renomeia essas colunas para nomes legíveis (`genero`, `cargo`, `nivel`, `forma_trabalho`, etc.) e já aplica os filtros necessários.
7. **Exportação da camada Gold**: resultado de `SELECT * FROM vw_data_hacker_2021` exportado como CSV (`gold.csv`) diretamente pelo console do Athena.
8. **Validação cruzada**: todos os números foram recalculados de forma independente em Python (pandas) a partir do `gold.csv`, para conferir que os resultados do SQL batiam 100% com os do pandas.
9. **Apresentação executiva**: construção de um deck de 11 slides com gráficos nativos (pptxgenjs), cobrindo cada pergunta de negócio respondida.

## O desafio dos nomes de coluna

Um dos principais aprendizados técnicos do projeto foi lidar com nomes de coluna corrompidos pela sanitização automática do Glue. A regra descoberta (via consulta ao `information_schema.columns`, que expõe os nomes reais das colunas) foi:

- Cada caractere não permitido (espaço, vírgula, parênteses) vira um `_` **separado** (não são agrupados em um único `_`);
- Apóstrofos, letras e números são mantidos;
- Tudo é convertido para minúsculas;
- Um sufixo numérico **0-indexado** (`_0`, `_1`, `_2`...) é adicionado ao final para garantir nomes únicos — esse sufixo faz parte do nome físico da coluna, e **não é** o `ordinal_position` (que é 1-indexado e é apenas metadado).

Essa investigação foi feita rodando consultas de diagnóstico como:

```sql
SELECT column_name, ordinal_position
FROM information_schema.columns
WHERE table_schema = 'default'
  AND table_name = 'tb-data-hacker'
  AND column_name LIKE '%genero%';
```

## Camada Gold — a view analítica

A view `vw_data_hacker_2021` consolida em colunas legíveis os campos usados nas análises: gênero, cargo, nível de senioridade, forma de trabalho (atual e ideal), região, além dos blocos de múltipla escolha de linguagens de programação, provedores de cloud e ferramentas de BI (cada opção como uma coluna booleana `'1'`/`'0'`/vazio, onde vazio significa "pergunta não exibida para esse respondente", não "não usa").

As queries completas usadas para criar a view e para responder cada pergunta de negócio estão em [`/sql`](./sql) — veja a seção [Como reproduzir](#como-reproduzir) para o passo a passo de como exportá-las do histórico do Athena.

## Perguntas de negócio respondidas

Com base na camada Gold (n = 2.645 respondentes, edição 2021):

| Pergunta | Principal achado |
|---|---|
| Diversidade de gênero | 81,1% se identificam como homens, 18,6% como mulheres e 0,3% como outro gênero — gap relevante para metas de diversidade |
| Cargos mais comuns | Cientista de Dados (357), Analista de BI/Analytics Engineer (338), Analista de Dados (324), Engenheiro de Dados (300) lideram o mercado |
| Modelo de trabalho | 67,9% da área já trabalha 100% remoto ou em híbrido flexível — contratação sem restrição geográfica amplia o acesso a talentos |
| Senioridade x região | Nordeste concentra o maior percentual de juniores (42,6%); Centro-oeste tem a maior proporção de seniores (42,0%) |
| Linguagens de programação | SQL (1.487) e Python (1.346) dominam folgadamente; R (306) e Java (223) aparecem na sequência |
| Provedores de cloud | AWS lidera (786), seguido por Azure (498) e Google Cloud (448) |
| Ferramentas de BI | Power BI é hegemônico (974 menções), à frente de Tableau (335) e Google Data Studio (334) |
| Adoção de IA | Apenas 6% (159 pessoas) se declaram gestores de iniciativas de IA/ML — a edição 2021 não tinha uma seção dedicada ao tema (ver limitações) |
| Idade | Média de 31,2 anos, mediana de 30 anos |

A leitura executiva completa, com gráficos e recomendações estratégicas para a instituição financeira, está na apresentação [`/presentation/mercado_de_dados_brasil.pptx`](./presentation/mercado_de_dados_brasil.pptx).

## Limitações e próximos passos

A pesquisa State of Data Brasil 2021 não trouxe uma seção dedicada à adoção de Inteligência Artificial no dia a dia — reflexo do momento em que foi realizada: o boom de IA generativa só ganhou escala a partir de 2022/2023. O único dado disponível é o percentual de pessoas que se declaram gestoras de iniciativas de IA/ML (6%).

Para responder com profundidade ao índice de adoção de IA e seu impacto — e também para atender à exigência do desafio de comparar as três últimas edições disponíveis da pesquisa — o próximo passo é ingerir edições mais recentes (2023/2024) no mesmo pipeline.

## Estrutura do repositório

```
├── README.md                          # este documento
├── diagrams/                          # diagrama de arquitetura (Draw.io)
├── sql/                                # scripts SQL usados no Athena
│   ├── 01_view_data_hacker_2021.sql
│   ├── 02_genero.sql
│   ├── 03_cargos.sql
│   ├── 04_senioridade_regiao.sql
│   ├── 05_modelo_trabalho.sql
│   ├── 06_linguagens.sql
│   ├── 07_cloud.sql
│   ├── 08_bi_tools.sql
│   └── 09_ia.sql
├── screenshots/                        # evidências das execuções no console AWS
│   ├── s3/
│   ├── glue/
│   └── athena/
├── data/
│   └── gold.csv                        # export final da camada Gold
└── presentation/
    └── mercado_de_dados_brasil.pptx    # apresentação executiva
```

## Como reproduzir

1. Suba o CSV original da pesquisa State of Data Brasil 2021 em um bucket S3.
2. Rode um crawler do Glue apontando para esse bucket para gerar a tabela `tb-data-hacker` (formato Parquet) no Data Catalog.
3. No Athena, rode os scripts em `/sql`, na ordem numerada — o primeiro cria a view `vw_data_hacker_2021`; os demais respondem cada pergunta de negócio.
4. Exporte o resultado de `SELECT * FROM vw_data_hacker_2021` como CSV (botão "Baixar CSV dos resultados" no console do Athena) e salve como `data/gold.csv`.
5. Abra `presentation/mercado_de_dados_brasil.pptx` para ver a leitura executiva dos resultados.

---

*Fonte dos dados: [State of Data Brasil 2021 — Data Hackers](https://www.datahackers.com.br/). Pipeline: AWS S3 → Glue → Athena. Projeto acadêmico desenvolvido para o Tech Challenge Fase 3 da pós-graduação em Data Analytics, FIAP.*
