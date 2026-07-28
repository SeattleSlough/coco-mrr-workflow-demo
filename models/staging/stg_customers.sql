select
    customer_id,
    name,
    signup_date
from {{ source('raw', 'customers') }}