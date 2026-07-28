select
    refund_id,
    invoice_id,
    refund_date,
    refund_amount,
    reason
from {{ source('raw', 'refunds') }}