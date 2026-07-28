
  create or replace   view SAAS_BILLING.ANALYTICS.stg_subscriptions
  
  
  
  
  as (
    select
    subscription_id,
    customer_id,
    plan_name,
    monthly_price,
    start_date,
    status
from SAAS_BILLING.RAW.subscriptions
  );

