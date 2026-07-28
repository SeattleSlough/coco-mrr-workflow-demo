select
    change_id,
    subscription_id,
    change_date,
    old_plan,
    old_price,
    new_plan,
    new_price
from {{ source('raw', 'plan_changes') }}
