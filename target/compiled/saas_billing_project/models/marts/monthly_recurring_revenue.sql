with subscriptions as (
    select * from SAAS_BILLING.ANALYTICS.stg_subscriptions
),

plan_changes as (
    select * from SAAS_BILLING.ANALYTICS.stg_plan_changes
),

cancellations as (
    select * from SAAS_BILLING.ANALYTICS.stg_cancellations
),

-- Generate a spine of months from earliest subscription to current month
month_spine as (
    select
        dateadd(month, row_number() over (order by seq4()) - 1,
            (select min(date_trunc('month', start_date)) from subscriptions)
        ) as month_start
    from table(generator(rowcount => 120))
    qualify month_start <= date_trunc('month', current_date())
),

-- For each subscription, determine the last month it should contribute MRR
subscription_months as (
    select
        s.subscription_id,
        s.monthly_price as original_price,
        s.start_date,
        m.month_start,
        c.cancellation_date
    from subscriptions s
    cross join month_spine m
    left join cancellations c
        on s.subscription_id = c.subscription_id
    where m.month_start >= date_trunc('month', s.start_date)
      and (c.cancellation_date is null or m.month_start < date_trunc('month', c.cancellation_date))
),

-- Join plan changes that occurred on or before each month, rank to find most recent
ranked_changes as (
    select
        sm.subscription_id,
        sm.month_start,
        sm.original_price,
        pc.new_price,
        row_number() over (
            partition by sm.subscription_id, sm.month_start
            order by pc.change_date desc
        ) as rn
    from subscription_months sm
    inner join plan_changes pc
        on sm.subscription_id = pc.subscription_id
        and pc.change_date <= last_day(sm.month_start)
),

-- Determine effective price: most recent plan change price, or original if no changes
effective_price as (
    select
        sm.subscription_id,
        sm.month_start,
        coalesce(rc.new_price, sm.original_price) as monthly_price
    from subscription_months sm
    left join ranked_changes rc
        on sm.subscription_id = rc.subscription_id
        and sm.month_start = rc.month_start
        and rc.rn = 1
)

select
    month_start as month,
    sum(monthly_price) as mrr
from effective_price
group by month_start
order by month_start