-- Fails if any line item has negative net revenue.
-- A passing test returns zero rows.
select
    line_item_key,
    net_revenue
from {{ ref('fct_line_items') }}
where net_revenue < 0