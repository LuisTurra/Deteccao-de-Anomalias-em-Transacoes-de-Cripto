-- models/staging/stg_transactions.sql
  -- View para não gastar storage no Sandbox

WITH base AS (
  SELECT
    -- Chave única da transação: use backticks porque 'hash' é keyword reservada!
    `hash` AS transaction_hash,

    -- Timestamp e data
    block_timestamp,
    DATE(block_timestamp) AS transaction_date,

    -- Valores em BTC (convertendo de satoshis)
    SAFE_DIVIDE(input_value, 100000000) AS input_btc,
    SAFE_DIVIDE(output_value, 100000000) AS output_btc,
    SAFE_DIVIDE(fee, 100000000) AS fee_btc,

    -- Contagens de inputs e outputs
    input_count,
    output_count,

    -- Se é transação de mineração (coinbase)
    is_coinbase

  FROM `bigquery-public-data`.`crypto_bitcoin`.`transactions`

  -- Filtra dados recentes para queries baratas e evitar limites do Sandbox
  -- Ajuste a data se quiser mais/menos histórico (ex: '2023-01-01' para mais recente)
  WHERE block_timestamp >= '2022-01-01'
)

SELECT *
FROM base

-- Comentários finais:
-- - Os backticks (`hash`) resolvem o erro de "Unexpected keyword HASH".
-- - Isso é comum em BigQuery com colunas que coincidem com funções reservadas.
-- - SAFE_DIVIDE protege contra divisão por zero.
-- - Filtro de data é crucial no Sandbox (mantém bytes processados baixos).