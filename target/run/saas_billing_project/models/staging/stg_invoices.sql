
  create or replace   view SAAS_BILLING.ANALYTICS.stg_invoices
  
  
  
  
  as (
    select
    invoice_id,
    subscription_id,
    invoice_date,
    amount
from SAAS_BILLING.RAW.invoices
  );

