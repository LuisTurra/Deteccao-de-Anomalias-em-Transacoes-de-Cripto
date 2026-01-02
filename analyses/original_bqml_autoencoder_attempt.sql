--  Autoencoder

CREATE OR REPLACE MODEL `bitcoin-anomaly-portfolio.dbt_bitcoin.anomaly_autoencoder`
OPTIONS(
  model_type = 'autoencoder',
  hidden_units = [64, 32, 16],
  activation_fn = 'relu',
  l1_reg_activation = 0.1,        -- Regularização suportada (l2_reg não funciona)
  max_iterations = 25,
  early_stop = TRUE
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
WHERE transaction_date BETWEEN '2023-01-01' AND '2024-12-31';