with payments as (
  select * from {{ ref('stg_payments') }}
)

final as (
  select
  created_at,
  sum(amount) as total_amount
  from payments
  where status = 'success'
  group by 1
)

select * from final
