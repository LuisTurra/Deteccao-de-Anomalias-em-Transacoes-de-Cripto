-- Use the `ref` function to select from other models

select *
from `bitcoin-anomaly-portfolio`.`dbt_bitcoin`.`my_first_dbt_model`
where id = 1