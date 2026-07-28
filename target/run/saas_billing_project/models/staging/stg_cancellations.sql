
  create or replace   view SAAS_BILLING.ANALYTICS.stg_cancellations
  
  
  
  
  as (
    select
    cancellation_id,
    subscription_id,
    cancellation_date,
    reason
from SAAS_BILLING.RAW.cancellations
  );

