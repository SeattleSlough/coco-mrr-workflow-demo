select
    invoice_id,
    subscription_id,
    invoice_date,
    amount
from {{ source('raw', 'invoices') }}