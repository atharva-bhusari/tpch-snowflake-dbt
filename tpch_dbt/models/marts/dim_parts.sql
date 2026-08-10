with parts as (
    select * from {{ ref('stg_tpch__parts') }}
),

final as (
    select
        part_key,
        part_name,
        manufacturer,
        brand,
        part_type,
        part_size,
        container,
        retail_price
    from parts
)

select * from final