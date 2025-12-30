# Detecção de Anomalias em Transações Bitcoin

![BigQuery + dbt + Looker Studio](https://via.placeholder.com/800x400?text=Bitcoin+Anomaly+Detection+Pipeline)  
*(Substitua por screenshot do seu dashboard)*

## Descrição do Projeto

Projeto de portfólio para detecção de **transações suspeitas** (possíveis mixing, alto valor, fees anormais) no blockchain Bitcoin, usando **dados públicos do BigQuery** (`bigquery-public-data.crypto_bitcoin.transactions`).

Stack 100% Google Cloud gratuito (Sandbox):
- **dbt Core**: Transformação e feature engineering
- **BigQuery**: Queries SQL + detecção rule-based 
- **Looker Studio**: Dashboard interativo com alertas visuais

**Objetivo**: Identificar padrões de fraude/privacidade como mixing services (ex: CoinJoin, peeling chains) em transações de 2025.

**Live Dashboard**: [Link do seu Looker Studio aqui]

**dbt Documentation**: (https://luisturra.github.io/Deteccao-de-Anomalias-em-Transacoes-de-Cripto/#!/overview)

## Arquitetura

- `stg_transactions.sql`: Limpeza e conversão satoshis → BTC
- `fct_transaction_features.sql`: Features suspeitas (high value, high I/O count, fee ratio)
- `anomaly_results_rule_based` (view): Thresholds dinâmicos com APPROX_QUANTILES + flags + anomaly_score

## Como Reproduzir (100% gratuito)

1. Crie projeto BigQuery Sandbox
2. `dbt init` + configure BigQuery
3. Rode `dbt run`
4. Crie a view `anomaly_results_rule_based` (código no models/marts/)
5. Conecte no Looker Studio

## Resultados Exemplo

- Detecta transações com >95th percentile de inputs/outputs (mixing)
- Alto valor (>99th percentile)
- Fees desproporcionais


## Tecnologias Usadas

- Google BigQuery (Sandbox)
- dbt Core
- Looker Studio
- GitHub + GitHub Pages (docs)

## Autor

Luis Herique Turra Ramos  
LinkedIn | GitHub

Projeto construído em dezembro 2025 para portfólio Cientista de Dados.