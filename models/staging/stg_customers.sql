select
    customer_id,
    name as customer_name,
    signup_date
from {{ source('raw', 'customers') }}
