-- analysis/original_bqml_kmeans_attempt.sql
-- Tentativa de anomaly detection com K-Means (leve e bom para clustering)

CREATE OR REPLACE MODEL `bitcoin-anomaly-portfolio.dbt_bitcoin.anomaly_kmeans`
OPTIONS(
  model_type = 'kmeans',
  num_clusters = 8,
  standardize_features = TRUE,
  distance_type = 'EUCLIDEAN'
) AS

SELECT
  transaction_value_btc,
  input_count,
  output_count,
  fee_ratio,
  is_high_value,
  is_high_io,
  is_coinbase
FROM `bitcoin-anomaly-portfolio.dbt_bitcoin.fct_transaction_features`
WHERE transaction_date BETWEEN '2024-01-01' AND '2024-12-31';