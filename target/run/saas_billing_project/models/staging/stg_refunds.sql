
  create or replace   view SAAS_BILLING.ANALYTICS.stg_refunds
  
  
  
  
  as (
    select
    refund_id,
    invoice_id,
    refund_date,
    refund_amount,
    reason
from SAAS_BILLING.RAW.refunds
  );

