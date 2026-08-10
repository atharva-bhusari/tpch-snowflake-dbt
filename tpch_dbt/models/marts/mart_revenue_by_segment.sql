with fct as (
    select * from {{ ref('fct_line_items') }}
),

customers as (
    select * from {{ ref('dim_customers') }}
),

final as (
    select
        c.region_name,
        c.market_segment,
        count(distinct f.order_key)   as order_count,
        sum(f.quantity)               as total_quantity,
        round(sum(f.net_revenue), 2)  as net_revenue,
        round(avg(f.net_revenue), 2)  as avg_line_revenue
    from fct f
    inner join customers c on f.customer_key = c.customer_key
    group by 1, 2
)

select * from final
order by net_revenue desc