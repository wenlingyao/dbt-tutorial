{{ config(
  materialized="table"
)}}


-- This referes to the table created from data/employees.csv
-- Run `dbt seed` first to make sure the seeds data is loaded before `dbt run`
with employees as (
  select * from {{ ref('employees') }}
),

customers as (
  select
      id as customer_id,
      first_name,
      last_name

  from {{ source('jaffle_shop', 'customers')}}
),

final as (
  select
      *
  from customers
  left join employees using (customer_id)
)

select * from final
