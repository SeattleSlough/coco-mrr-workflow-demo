select
    cancellation_id,
    subscription_id,
    cancellation_date,
    reason
from {{ source('raw', 'cancellations') }}
