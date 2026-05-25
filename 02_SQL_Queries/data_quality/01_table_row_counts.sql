-- ============================================================
-- Task 3.1: Table Row Counts
-- Phase 3: Data Exploration Log
-- Author: Yesenia Mora Acosta
-- Date: 2026-05-25
-- Description: Verify data loaded correctly across all 13 tables
-- ============================================================

select
    'categories' as table_name,
    count(*) as total_rows
from categories

union all

select 
    'clients' as table_name,
    count(*) as total_rows
from clients

union all

select 
    'customers' as table_name,
    count(*) as total_rows
from customers

union all

select 
    'employees' as table_name,
    count(*) as total_rows
from employees

union all

select 
    'inventory' as table_name,
    count(*) as total_rows
from inventory

union all

select 
    'inventory_logs' as table_name,
    count(*) as total_rows
from inventory_logs

union all

select 
    'invoice_lines' as table_name,
    count(*) as total_rows
from invoice_lines

union all

select 
    'invoices' as table_name,
    count(*) as total_rows
from invoices

union all

select 
    'order_items' as table_name,
    count(*) as total_rows
from order_items

union all

select 
    'orders' as table_name,
    count(*) as total_rows
from orders

union all

select 
    'products' as table_name,
    count(*) as total_rows
from products

union all

select 
    'shipments' as table_name,
    count(*) as total_rows
from shipments

union all

select 
    'warehouses' as table_name,
    count(*) as total_rows
from warehouses;