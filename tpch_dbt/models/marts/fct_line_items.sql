with lineitems as (
    select * from {{ ref('stg_tpch__lineitems') }}
),

orders as (
    select * from {{ ref('stg_tpch__orders') }}
),

final as (
    select
        -- surrogate key: uniquely identifies the fact grain (order + line)
        {{ dbt_utils.generate_surrogate_key(['l.order_key', 'l.line_number']) }} as line_item_key,

        -- foreign keys to dimensions
        l.order_key,
        l.part_key,
        l.supplier_key,
        o.customer_key,

        -- degenerate dimensions / context
        l.line_number,
        o.order_date,
        o.order_status,
        l.ship_date,
        l.ship_mode,
        l.return_flag,

        -- measures
        l.quantity,
        l.extended_price                                              as gross_item_revenue,
        l.discount,
        round(l.extended_price * l.discount, 2)                       as discount_amount,
        round(l.extended_price * (1 - l.discount), 2)                 as net_revenue,
        l.tax,
        round(l.extended_price * (1 - l.discount) * (1 + l.tax), 2)   as net_revenue_with_tax
    from lineitems l
    inner join orders o on l.order_key = o.order_key
)

select * from final