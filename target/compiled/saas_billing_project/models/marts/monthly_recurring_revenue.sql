with months as (
    select distinct date_trunc('month', invoice_date) as month
    from SAAS_BILLING.ANALYTICS.stg_invoices
),

subscription_months as (
    select
        s.subscription_id,
        s.customer_id,
        m.month
    from SAAS_BILLING.ANALYTICS.stg_subscriptions s
    cross join months m
    left join SAAS_BILLING.ANALYTICS.stg_cancellations c
        on s.subscription_id = c.subscription_id
    where m.month >= date_trunc('month', s.start_date)
      and (c.cancellation_date is null or m.month < date_trunc('month', c.cancellation_date))
),

plan_prices as (
    select
        sm.subscription_id,
        sm.customer_id,
        sm.month,
        pc.new_price,
        row_number() over (
            partition by sm.subscription_id, sm.month
            order by pc.change_date desc
        ) as rn
    from subscription_months sm
    left join SAAS_BILLING.ANALYTICS.stg_plan_changes pc
        on pc.subscription_id = sm.subscription_id
        and date_trunc('month', pc.change_date) <= sm.month
),

priced as (
    select
        pp.subscription_id,
        pp.customer_id,
        pp.month,
        coalesce(pp.new_price, s.monthly_price) as effective_price
    from plan_prices pp
    join SAAS_BILLING.ANALYTICS.stg_subscriptions s
        on pp.subscription_id = s.subscription_id
    where pp.rn = 1
)

select
    month,
    sum(effective_price) as mrr
from priced
group by month
order by month