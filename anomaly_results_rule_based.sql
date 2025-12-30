CREATE OR REPLACE VIEW `bitcoin-anomaly-portfolio.dbt_bitcoin.anomaly_results_rule_based` AS

WITH stats AS (
  -- Calcula estatísticas globais (percentiles, médias) em dados recentes para thresholds dinâmicos
  SELECT
    APPROX_QUANTILES(transaction_value_btc, 100)[OFFSET(95)] AS p95_value,
    APPROX_QUANTILES(transaction_value_btc, 100)[OFFSET(99)] AS p99_value,
    APPROX_QUANTILES(input_count, 100)[OFFSET(95)] AS p95_input,
    APPROX_QUANTILES(output_count, 100)[OFFSET(95)] AS p95_output,
    APPROX_QUANTILES(fee_ratio, 100)[OFFSET(99)] AS p99_fee_ratio  -- Fee desproporcional
  FROM `bitcoin-anomaly-portfolio.dbt_bitcoin.fct_transaction_features`
  WHERE transaction_date >= '2024-01-01'  -- Foco em dados recentes (2024-2025)
),

features AS (
  SELECT
    transaction_hash,
    transaction_date,
    block_timestamp,
    transaction_value_btc,
    input_count,
    output_count,
    (input_count + output_count) AS total_io_count,
    fee_ratio,
    is_high_value,
    is_high_io,
    is_coinbase
  FROM `bitcoin-anomaly-portfolio.dbt_bitcoin.fct_transaction_features`
  WHERE transaction_date >= '2025-01-01'  -- Anomalias em 2025 (ou ajuste para período que quiser)
)

SELECT
  f.*,
  stats.*,

  -- Flags de anomalias (combina regras)
  CASE
    WHEN transaction_value_btc > stats.p99_value THEN TRUE
    WHEN total_io_count > GREATEST(stats.p95_input, stats.p95_output) * 2 THEN TRUE  -- Mixing forte
    WHEN fee_ratio > stats.p99_fee_ratio OR fee_ratio < 0.000001 THEN TRUE  -- Fee muito alta/baixa
    WHEN is_high_value = 1 OR is_high_io = 1 THEN TRUE
    ELSE FALSE
  END AS is_anomaly,

  -- Score simples de anomalia (quanto maior, mais suspeita)
  (CASE WHEN transaction_value_btc > stats.p99_value THEN 3 ELSE 0 END +
   CASE WHEN total_io_count > GREATEST(stats.p95_input, stats.p95_output) * 2 THEN 3 ELSE 0 END +
   CASE WHEN fee_ratio > stats.p99_fee_ratio THEN 2 ELSE 0 END +
   is_high_value + is_high_io) AS anomaly_score

FROM features f
CROSS JOIN stats

WHERE 
  -- Filtra só as anômalas para a view ser leve
  CASE
    WHEN transaction_value_btc > stats.p99_value THEN TRUE
    WHEN total_io_count > GREATEST(stats.p95_input, stats.p95_output) * 2 THEN TRUE
    WHEN fee_ratio > stats.p99_fee_ratio OR fee_ratio < 0.000001 THEN TRUE
    WHEN is_high_value = 1 OR is_high_io = 1 THEN TRUE
    ELSE FALSE
  END = TRUE

ORDER BY anomaly_score DESC;