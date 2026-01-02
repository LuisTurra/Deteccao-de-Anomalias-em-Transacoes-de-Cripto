{{ config(materialized='view') }}  -- View para não gastar storage no Sandbox

WITH base AS (
  SELECT
    -- Chave única da transação: use backticks porque 'hash' é keyword reservada!
    `hash` AS transaction_hash,

    -- Timestamp e data
    block_timestamp,
    DATE(block_timestamp) AS transaction_date,

    -- Valores em BTC
    SAFE_DIVIDE(input_value, 100000000) AS input_btc,
    SAFE_DIVIDE(output_value, 100000000) AS output_btc,
    SAFE_DIVIDE(fee, 100000000) AS fee_btc,

    -- Contagens de inputs e outputs
    input_count,
    output_count,

    -- Se é transação de mineração (coinbase)
    is_coinbase

  FROM {{ source('crypto_bitcoin', 'transactions') }}

  -- Filtra dados recentes para queries baratas e evitar limites do Sandbox

  WHERE block_timestamp >= '2022-01-01'
)

SELECT *
FROM base

-- Comentários finais:
-- - SAFE_DIVIDE protege contra divisão por zero.
-- - Filtro de data é crucial no Sandbox (mantém bytes processados baixos).