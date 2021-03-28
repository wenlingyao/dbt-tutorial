{{ config(
  materialized='incremental',
  unique_key="order_id"
) }}

select
    id as order_id,
    user_id as customer_id,
    order_date,
    status

from {{ source('jaffle_shop', 'orders')}}
{% if is_incremental() %}
where order_date > (select dateadd('day', -3,  max(order_date)) from {{ this }})
{% endif %}

-- How incremental works
-- 1. Create a temp table of new records
-- 2. merge, delete + insert ("upsert")
-- 3. insert overwrite("replace") entire partitions
-- Update existing rows: if the unique key of an existing row in your target table matches one of your incrementally transformed rows, the existing row will be updated. This ensures that you don't have multiple rows in your target table for a single row in your source data.
