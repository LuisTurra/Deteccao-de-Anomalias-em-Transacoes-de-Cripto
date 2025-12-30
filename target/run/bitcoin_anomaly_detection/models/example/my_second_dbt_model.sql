

  create or replace view `bitcoin-anomaly-portfolio`.`dbt_bitcoin`.`my_second_dbt_model`
  OPTIONS()
  as -- Use the `ref` function to select from other models

select *
from `bitcoin-anomaly-portfolio`.`dbt_bitcoin`.`my_first_dbt_model`
where id = 1;

