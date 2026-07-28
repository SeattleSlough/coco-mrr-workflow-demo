select
    subscription_id,
    customer_id,
    plan_name,
    monthly_price,
    start_date,
    status
from {{ source('raw', 'subscriptions') }}
