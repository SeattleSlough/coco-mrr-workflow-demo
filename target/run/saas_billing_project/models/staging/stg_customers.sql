
  create or replace   view SAAS_BILLING.ANALYTICS.stg_customers
  
  
  
  
  as (
    select
    customer_id,
    name,
    signup_date
from SAAS_BILLING.RAW.customers
  );

