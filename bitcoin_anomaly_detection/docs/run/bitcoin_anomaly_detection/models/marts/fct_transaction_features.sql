

  create or replace view `bitcoin-anomaly-portfolio`.`dbt_bitcoin`.`fct_transaction_features`
  OPTIONS()
  as 

SELECT
  transaction_hash,
  transaction_date,
  block_timestamp,

  output_btc AS transaction_value_btc,

  input_count,
  output_count,
  (input_count + output_count) AS total_io_count,
  SAFE_DIVIDE(fee_btc, output_btc) AS fee_ratio,
  CASE WHEN output_btc > 100 THEN 1 ELSE 0 END AS is_high_value,
  CASE WHEN input_count > 50 OR output_count > 50 THEN 1 ELSE 0 END AS is_high_io,
  is_coinbase

FROM `bitcoin-anomaly-portfolio`.`dbt_bitcoin`.`stg_transactions`;

