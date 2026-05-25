-- ============================================================
-- Task 3.2: Explore Orders Table
-- Phase 3: Data Exploration Log
-- Author: Yesenia Mora Acosta
-- Date: 2026-05-25
-- Description: Understand structure and content of orders table
-- ============================================================

-- Query 1: Table structure
DESCRIBE TABLE orders;

-- Query 2: Sample records
SELECT *
FROM orders
LIMIT 10;

-- Query 3: Status distribution
with status_counts as (
    select
        status,
        count(order_id) as status_count
    from orders
    group by status
)

select
    status,
    status_count,
    round(
        status_count * 100.0 / sum(status_count) over (),
        2
    ) as percentage
from status_counts
order by status_count desc;