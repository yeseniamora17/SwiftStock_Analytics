# SwiftStock Logistics — Data Dictionary

**Version:** 1.0  
**Last Updated:** December 2025

---

## Overview

This document provides detailed documentation for all tables and columns in the SwiftStock operational database. It serves as the authoritative reference for analysts, engineers, and business stakeholders.

---

## Table of Contents

1. [Core Reference Tables](#1-core-reference-tables)
   - [warehouses](#11-warehouses)
   - [clients](#12-clients)
   - [categories](#13-categories)
   - [employees](#14-employees)
2. [Product & Inventory Tables](#2-product--inventory-tables)
   - [products](#21-products)
   - [inventory](#22-inventory)
   - [inventory_logs](#23-inventory_logs)
3. [Customer & Order Tables](#3-customer--order-tables)
   - [customers](#31-customers)
   - [orders](#32-orders)
   - [order_items](#33-order_items)
   - [shipments](#34-shipments)
4. [Billing Tables](#4-billing-tables)
   - [invoices](#41-invoices)
   - [invoice_lines](#42-invoice_lines)
5. [Appendix: Enumerated Values](#5-appendix-enumerated-values)

---

## 1. Core Reference Tables

These tables contain foundational data that other tables reference.

### 1.1 warehouses

**Description:** Physical distribution centers operated by SwiftStock. Each warehouse has defined capacity and geographic location.

**Business Context:** Warehouses are the core operational units. All inventory, orders, and employees are associated with specific warehouses. Capacity planning and utilization tracking depend on this table.

**Row Count:** 12  
**Primary Key:** `warehouse_id`  
**Foreign Keys:** None (reference table)

| Column | Data Type | Nullable | Default | Description | Business Rules | Example |
|--------|-----------|----------|---------|-------------|----------------|---------|
| `warehouse_id` | serial | NO | auto | Unique identifier for the warehouse | System-generated, never reused | `1` |
| `warehouse_code` | varchar(10) | NO | — | Short code for the warehouse | Unique; format: WH-XXX | `'WH-LAX'` |
| `warehouse_name` | varchar(100) | NO | — | Full descriptive name | Human-readable name for reports | `'Los Angeles West Coast Hub'` |
| `city` | varchar(100) | NO | — | City where warehouse is located | Must be valid city name | `'Los Angeles'` |
| `state_province` | varchar(100) | YES | NULL | State or province | NULL for countries without states | `'California'` |
| `country` | varchar(50) | NO | — | Country where warehouse is located | ISO country name | `'USA'` |
| `capacity_pallets` | integer | NO | — | Maximum pallet positions available | Must be > 0; reviewed annually | `28000` |
| `opened_date` | date | NO | — | Date warehouse began operations | Historical record; immutable | `'2014-09-01'` |
| `is_active` | boolean | YES | TRUE | Whether warehouse is operational | FALSE = closed/decommissioned | `TRUE` |
| `created_at` | timestamp | YES | CURRENT_TIMESTAMP | Record creation timestamp | System-managed | `'2024-01-15 09:30:00'` |

**Common Queries:**
- Warehouse utilization reports
- Geographic distribution analysis
- Capacity planning

---

### 1.2 clients

**Description:** Business customers who contract with SwiftStock for warehousing and fulfillment services.

**Business Context:** Clients are our B2B customers — the companies that pay us. Each client has negotiated rates based on their tier. All products, orders, and invoices are associated with clients.

**Row Count:** 150  
**Primary Key:** `client_id`  
**Foreign Keys:** None (reference table)

| Column | Data Type | Nullable | Default | Description | Business Rules | Example |
|--------|-----------|----------|---------|-------------|----------------|---------|
| `client_id` | serial | NO | auto | Unique identifier for the client | System-generated | `42` |
| `client_code` | varchar(20) | NO | — | External-facing client identifier | Unique; format: CLXXXX | `'CL0042'` |
| `company_name` | varchar(150) | NO | — | Legal business name | As per contract | `'TechGear Direct'` |
| `contact_name` | varchar(100) | YES | NULL | Primary contact person | Updated by Account Management | `'Sarah Johnson'` |
| `contact_email` | varchar(150) | YES | NULL | Primary contact email | Must be valid email format | `'sarah@techgear.com'` |
| `contact_phone` | varchar(30) | YES | NULL | Primary contact phone | International format | `'+1-555-123-4567'` |
| `industry` | varchar(50) | NO | — | Industry classification | From predefined list (see Appendix) | `'Electronics & Technology'` |
| `client_tier` | varchar(20) | YES | 'standard' | Service tier level | Determines pricing; see Appendix | `'premium'` |
| `contract_start_date` | date | NO | — | Date client relationship began | Immutable after creation | `'2020-03-15'` |
| `contract_end_date` | date | YES | NULL | Date contract ends | NULL = ongoing/auto-renew | `NULL` |
| `storage_rate_pallet` | decimal(10,2) | NO | — | Monthly rate per pallet (USD) | Set by Sales; reviewed annually | `32.50` |
| `fulfillment_rate` | decimal(10,2) | NO | — | Rate per order fulfilled (USD) | Set by Sales; reviewed annually | `3.75` |
| `is_active` | boolean | YES | TRUE | Whether client is active | FALSE = churned/terminated | `TRUE` |
| `created_at` | timestamp | YES | CURRENT_TIMESTAMP | Record creation timestamp | System-managed | `'2020-03-15 14:22:00'` |

**Common Queries:**
- Client profitability analysis
- Churn risk identification
- Revenue forecasting by tier

---

### 1.3 categories

**Description:** Hierarchical product classification system.

**Business Context:** Categories help organize products for reporting, warehouse organization, and identifying handling requirements (e.g., fragile electronics vs. sturdy tools).

**Row Count:** 25  
**Primary Key:** `category_id`  
**Foreign Keys:** `parent_category_id` → `categories.category_id` (self-referential)

| Column | Data Type | Nullable | Default | Description | Business Rules | Example |
|--------|-----------|----------|---------|-------------|----------------|---------|
| `category_id` | serial | NO | auto | Unique identifier | System-generated | `5` |
| `category_name` | varchar(100) | NO | — | Display name for category | Must be unique | `'Wearable Technology'` |
| `parent_category_id` | integer | YES | NULL | Parent category for hierarchy | NULL = top-level category | `1` (Electronics) |
| `description` | text | YES | NULL | Detailed description | Optional documentation | `'Smart watches, fitness trackers...'` |
| `created_at` | timestamp | YES | CURRENT_TIMESTAMP | Record creation timestamp | System-managed | `'2024-01-01 00:00:00'` |

**Common Queries:**
- Product mix analysis
- Category performance reports

---

### 1.4 employees

**Description:** Warehouse staff who perform operational tasks.

**Business Context:** Employees are tracked for productivity analysis, labor cost allocation, and quality control. Each order records who picked and packed it.

**Row Count:** 180  
**Primary Key:** `employee_id`  
**Foreign Keys:** `warehouse_id` → `warehouses.warehouse_id`

| Column | Data Type | Nullable | Default | Description | Business Rules | Example |
|--------|-----------|----------|---------|-------------|----------------|---------|
| `employee_id` | serial | NO | auto | Unique identifier | System-generated | `127` |
| `warehouse_id` | integer | NO | — | Assigned warehouse | Must exist in warehouses | `6` |
| `employee_code` | varchar(20) | NO | — | Badge/ID number | Unique across company | `'EMP0127'` |
| `first_name` | varchar(50) | NO | — | Legal first name | As per HR records | `'Marcus'` |
| `last_name` | varchar(50) | NO | — | Legal last name | As per HR records | `'Thompson'` |
| `email` | varchar(150) | YES | NULL | Work email | @swiftstock.com domain | `'marcus.thompson@swiftstock.com'` |
| `role` | varchar(50) | NO | — | Job function | From predefined list (see Appendix) | `'picker'` |
| `hire_date` | date | NO | — | Employment start date | Immutable | `'2022-06-15'` |
| `termination_date` | date | YES | NULL | Employment end date | NULL = currently employed | `NULL` |
| `hourly_rate` | decimal(8,2) | YES | NULL | Current pay rate (USD) | Confidential; restricted access | `18.50` |
| `is_active` | boolean | YES | TRUE | Currently employed | FALSE = terminated | `TRUE` |
| `created_at` | timestamp | YES | CURRENT_TIMESTAMP | Record creation timestamp | System-managed | `'2022-06-15 09:00:00'` |

**Common Queries:**
- Productivity analysis by employee
- Labor cost by warehouse
- Staffing level reports

---

## 2. Product & Inventory Tables

### 2.1 products

**Description:** SKUs (Stock Keeping Units) stored by clients in SwiftStock warehouses.

**Business Context:** Every physical item we store is a product. Products belong to clients and are categorized for organization. Product attributes affect storage requirements and handling.

**Row Count:** 2,500  
**Primary Key:** `product_id`  
**Foreign Keys:** 
- `client_id` → `clients.client_id`
- `category_id` → `categories.category_id`

| Column | Data Type | Nullable | Default | Description | Business Rules | Example |
|--------|-----------|----------|---------|-------------|----------------|---------|
| `product_id` | serial | NO | auto | Unique identifier | System-generated | `1547` |
| `client_id` | integer | NO | — | Owning client | Must exist in clients | `42` |
| `sku` | varchar(50) | NO | — | Stock keeping unit code | Unique per client | `'CL0042-00015'` |
| `product_name` | varchar(200) | NO | — | Product description | Client-provided | `'Premium Wireless Earbuds Pro'` |
| `category_id` | integer | YES | NULL | Product category | Should be assigned | `3` |
| `weight_kg` | decimal(10,3) | YES | NULL | Unit weight in kilograms | Used for shipping calc | `0.250` |
| `length_cm` | decimal(10,2) | YES | NULL | Length in centimeters | Used for space planning | `15.00` |
| `width_cm` | decimal(10,2) | YES | NULL | Width in centimeters | Used for space planning | `10.00` |
| `height_cm` | decimal(10,2) | YES | NULL | Height in centimeters | Used for space planning | `5.00` |
| `unit_cost` | decimal(12,2) | YES | NULL | Client's cost per unit | For inventory valuation | `45.00` |
| `unit_price` | decimal(12,2) | YES | NULL | Client's selling price | For order value calc | `89.99` |
| `units_per_pallet` | integer | YES | 48 | How many units fit on pallet | Used for storage calc | `120` |
| `is_fragile` | boolean | YES | FALSE | Requires careful handling | Affects packing process | `TRUE` |
| `is_hazardous` | boolean | YES | FALSE | Contains hazardous materials | Special storage required | `FALSE` |
| `requires_cold` | boolean | YES | FALSE | Needs refrigeration | Limited warehouse support | `FALSE` |
| `min_stock_level` | integer | YES | 10 | Reorder alert threshold | Client-defined | `50` |
| `is_active` | boolean | YES | TRUE | Currently stocked | FALSE = discontinued | `TRUE` |
| `created_at` | timestamp | YES | CURRENT_TIMESTAMP | Record creation timestamp | System-managed | `'2023-05-20 11:30:00'` |

**Common Queries:**
- Product catalog by client
- Inventory valuation
- Storage requirement analysis

---

### 2.2 inventory

**Description:** Current stock levels by product and warehouse location.

**Business Context:** This is the "source of truth" for what's physically in each warehouse. The `quantity_available` field is computed to show what can actually be sold (on_hand minus reserved).

**Row Count:** 4,765  
**Primary Key:** `inventory_id`  
**Foreign Keys:**
- `warehouse_id` → `warehouses.warehouse_id`
- `product_id` → `products.product_id`
**Unique Constraint:** (`warehouse_id`, `product_id`)

| Column | Data Type | Nullable | Default | Description | Business Rules | Example |
|--------|-----------|----------|---------|-------------|----------------|---------|
| `inventory_id` | serial | NO | auto | Unique identifier | System-generated | `3892` |
| `warehouse_id` | integer | NO | — | Storage location | Must exist in warehouses | `6` |
| `product_id` | integer | NO | — | Product being stored | Must exist in products | `1547` |
| `quantity_on_hand` | integer | NO | 0 | Total physical units | Must be >= 0 | `500` |
| `quantity_reserved` | integer | NO | 0 | Units allocated to orders | Must be <= on_hand | `75` |
| `quantity_available` | integer | — | COMPUTED | Available for new orders | on_hand - reserved | `425` |
| `reorder_point` | integer | YES | 20 | Alert threshold | Client notification trigger | `100` |
| `last_count_date` | date | YES | NULL | Last physical count | Cycle count tracking | `'2025-06-15'` |
| `last_movement_date` | timestamp | YES | NULL | Last stock change | Activity tracking | `'2025-06-20 14:30:00'` |
| `created_at` | timestamp | YES | CURRENT_TIMESTAMP | Record creation | System-managed | `'2023-05-20 11:30:00'` |
| `updated_at` | timestamp | YES | CURRENT_TIMESTAMP | Last update | System-managed | `'2025-06-20 14:30:00'` |

**Common Queries:**
- Stock level reports
- Low inventory alerts
- Warehouse utilization

---

### 2.3 inventory_logs

**Description:** Audit trail of all inventory movements (inbound, outbound, adjustments, etc.).

**Business Context:** Every change to inventory is logged for traceability, reconciliation, and analysis. This table grows continuously and is critical for investigating discrepancies.

**Row Count:** 207,228  
**Primary Key:** `log_id`  
**Foreign Keys:**
- `warehouse_id` → `warehouses.warehouse_id`
- `product_id` → `products.product_id`
- `employee_id` → `employees.employee_id`

| Column | Data Type | Nullable | Default | Description | Business Rules | Example |
|--------|-----------|----------|---------|-------------|----------------|---------|
| `log_id` | serial | NO | auto | Unique identifier | System-generated | `185432` |
| `warehouse_id` | integer | NO | — | Where movement occurred | Must exist in warehouses | `6` |
| `product_id` | integer | NO | — | Product affected | Must exist in products | `1547` |
| `movement_type` | varchar(30) | NO | — | Type of movement | See Appendix for values | `'outbound'` |
| `quantity` | integer | NO | — | Units moved | Positive=in, Negative=out | `-5` |
| `quantity_before` | integer | YES | NULL | Stock before movement | For audit trail | `500` |
| `quantity_after` | integer | YES | NULL | Stock after movement | For audit trail | `495` |
| `reference_type` | varchar(30) | YES | NULL | Source document type | Links to other tables | `'order'` |
| `reference_id` | integer | YES | NULL | Source document ID | Foreign key varies by type | `67890` |
| `employee_id` | integer | YES | NULL | Who performed action | NULL for system actions | `127` |
| `notes` | text | YES | NULL | Additional context | Free text for exceptions | `'Customer return - damaged'` |
| `logged_at` | timestamp | NO | CURRENT_TIMESTAMP | When movement occurred | Immutable timestamp | `'2025-06-20 14:30:00'` |

**Common Queries:**
- Inventory reconciliation
- Movement history by product
- Employee productivity tracking

---

## 3. Customer & Order Tables

### 3.1 customers

**Description:** End consumers who receive shipments (the customers of our clients).

**Business Context:** These are NOT our customers — they're our clients' customers. We store their shipping information to fulfill orders. Each customer belongs to a specific client.

**Row Count:** 15,000  
**Primary Key:** `customer_id`  
**Foreign Keys:** `client_id` → `clients.client_id`

| Column | Data Type | Nullable | Default | Description | Business Rules | Example |
|--------|-----------|----------|---------|-------------|----------------|---------|
| `customer_id` | serial | NO | auto | Unique identifier | System-generated | `8472` |
| `client_id` | integer | NO | — | Which client's customer | Must exist in clients | `42` |
| `customer_code` | varchar(50) | YES | NULL | Client's customer ID | Client's reference | `'CUST008472'` |
| `customer_name` | varchar(150) | NO | — | Recipient name | For shipping label | `'John Smith'` |
| `email` | varchar(150) | YES | NULL | Contact email | For delivery notifications | `'john.smith@email.com'` |
| `phone` | varchar(30) | YES | NULL | Contact phone | For delivery issues | `'+1-555-987-6543'` |
| `address_line1` | varchar(200) | YES | NULL | Street address | Primary address line | `'123 Main Street'` |
| `address_line2` | varchar(200) | YES | NULL | Additional address | Apt/Suite/Unit | `'Apt 4B'` |
| `city` | varchar(100) | YES | NULL | City | For shipping | `'Seattle'` |
| `state_province` | varchar(100) | YES | NULL | State or province | For shipping | `'Washington'` |
| `postal_code` | varchar(20) | YES | NULL | ZIP/Postal code | For shipping | `'98101'` |
| `country` | varchar(50) | NO | — | Country | For shipping/customs | `'USA'` |
| `is_business` | boolean | YES | FALSE | B2B customer flag | Affects delivery options | `FALSE` |
| `created_at` | timestamp | YES | CURRENT_TIMESTAMP | Record creation | System-managed | `'2024-03-10 16:45:00'` |

**Common Queries:**
- Customer geographic distribution
- Repeat customer analysis
- Shipping zone analysis

---

### 3.2 orders

**Description:** Fulfillment orders — requests to pick, pack, and ship products.

**Business Context:** Orders are the core transactional unit. When a client's customer buys something, an order comes to us. We track its journey through our fulfillment process via the status field.

**Row Count:** 67,343  
**Primary Key:** `order_id`  
**Foreign Keys:**
- `client_id` → `clients.client_id`
- `warehouse_id` → `warehouses.warehouse_id`
- `customer_id` → `customers.customer_id`
- `picked_by` → `employees.employee_id`
- `packed_by` → `employees.employee_id`

| Column | Data Type | Nullable | Default | Description | Business Rules | Example |
|--------|-----------|----------|---------|-------------|----------------|---------|
| `order_id` | serial | NO | auto | Unique identifier | System-generated | `67890` |
| `client_id` | integer | NO | — | Which client's order | Must exist in clients | `42` |
| `warehouse_id` | integer | NO | — | Fulfilling warehouse | Must exist in warehouses | `6` |
| `customer_id` | integer | NO | — | Ship-to customer | Must exist in customers | `8472` |
| `order_number` | varchar(30) | NO | — | External order reference | Unique; client-facing | `'ORD-202506-067890'` |
| `order_date` | timestamp | NO | — | When order was placed | Immutable | `'2025-06-18 09:15:00'` |
| `required_date` | date | YES | NULL | Requested delivery date | Client's expectation | `'2025-06-22'` |
| `shipped_date` | timestamp | YES | NULL | When shipped | NULL until shipped | `'2025-06-19 16:30:00'` |
| `delivered_date` | timestamp | YES | NULL | When delivered | NULL until delivered | `'2025-06-21 11:45:00'` |
| `status` | varchar(30) | NO | 'pending' | Current order state | See Appendix for values | `'delivered'` |
| `priority` | varchar(20) | YES | 'standard' | Fulfillment priority | See Appendix for values | `'express'` |
| `shipping_method` | varchar(50) | YES | NULL | Delivery speed | See Appendix for values | `'ground'` |
| `shipping_cost` | decimal(10,2) | YES | NULL | Carrier charge | For billing pass-through | `12.50` |
| `subtotal` | decimal(12,2) | YES | NULL | Product value | Sum of line items | `156.75` |
| `tax_amount` | decimal(10,2) | YES | 0 | Sales tax | Client-dependent | `12.54` |
| `total_amount` | decimal(12,2) | YES | NULL | Order total | Subtotal + tax + shipping | `181.79` |
| `notes` | text | YES | NULL | Special instructions | Client or customer notes | `'Leave at back door'` |
| `picked_by` | integer | YES | NULL | Employee who picked | NULL until picked | `127` |
| `packed_by` | integer | YES | NULL | Employee who packed | NULL until packed | `134` |
| `created_at` | timestamp | YES | CURRENT_TIMESTAMP | Record creation | System-managed | `'2025-06-18 09:15:00'` |
| `updated_at` | timestamp | YES | CURRENT_TIMESTAMP | Last update | System-managed | `'2025-06-21 11:45:00'` |

**Common Queries:**
- Order volume by status
- Fulfillment time analysis
- On-time delivery rates

---

### 3.3 order_items

**Description:** Line items within each order — the specific products and quantities.

**Business Context:** An order can contain multiple products. This table stores what was ordered vs. what was actually picked (for accuracy tracking).

**Row Count:** 130,150  
**Primary Key:** `order_item_id`  
**Foreign Keys:**
- `order_id` → `orders.order_id`
- `product_id` → `products.product_id`

| Column | Data Type | Nullable | Default | Description | Business Rules | Example |
|--------|-----------|----------|---------|-------------|----------------|---------|
| `order_item_id` | serial | NO | auto | Unique identifier | System-generated | `234567` |
| `order_id` | integer | NO | — | Parent order | Must exist in orders | `67890` |
| `product_id` | integer | NO | — | Product ordered | Must exist in products | `1547` |
| `quantity_ordered` | integer | NO | — | Units requested | Must be > 0 | `2` |
| `quantity_picked` | integer | YES | 0 | Units actually picked | For accuracy tracking | `2` |
| `unit_price` | decimal(12,2) | NO | — | Price per unit | At time of order | `89.99` |
| `discount_percent` | decimal(5,2) | YES | 0 | Discount applied | 0-100 | `10.00` |
| `line_total` | decimal(12,2) | YES | NULL | Extended amount | qty × price × (1-discount) | `161.98` |
| `picked_at` | timestamp | YES | NULL | When picked | NULL until picked | `'2025-06-19 14:20:00'` |
| `created_at` | timestamp | YES | CURRENT_TIMESTAMP | Record creation | System-managed | `'2025-06-18 09:15:00'` |

**Common Queries:**
- Pick accuracy analysis
- Product velocity (units sold)
- Average order size

---

### 3.4 shipments

**Description:** Carrier tracking information for shipped orders.

**Business Context:** Once an order is handed to a carrier, we create a shipment record to track its journey to the customer.

**Row Count:** 61,935  
**Primary Key:** `shipment_id`  
**Foreign Keys:** `order_id` → `orders.order_id`

| Column | Data Type | Nullable | Default | Description | Business Rules | Example |
|--------|-----------|----------|---------|-------------|----------------|---------|
| `shipment_id` | serial | NO | auto | Unique identifier | System-generated | `58742` |
| `order_id` | integer | NO | — | Associated order | Must exist in orders | `67890` |
| `carrier` | varchar(50) | NO | — | Shipping carrier | See Appendix for values | `'FedEx'` |
| `service_type` | varchar(50) | YES | NULL | Carrier service level | Carrier-specific | `'Ground'` |
| `tracking_number` | varchar(100) | YES | NULL | Carrier tracking ID | For customer tracking | `'794644790132'` |
| `shipping_zone` | integer | YES | NULL | Distance-based zone | Affects cost; 1-8 | `3` |
| `weight_kg` | decimal(10,3) | YES | NULL | Package weight | For carrier billing | `0.750` |
| `package_count` | integer | YES | 1 | Number of packages | Multi-box shipments | `1` |
| `shipping_cost` | decimal(10,2) | YES | NULL | Actual carrier cost | For billing reconciliation | `8.75` |
| `shipped_date` | timestamp | YES | NULL | Carrier pickup time | When scanned by carrier | `'2025-06-19 16:30:00'` |
| `estimated_delivery` | date | YES | NULL | Expected delivery | Carrier estimate | `'2025-06-22'` |
| `actual_delivery` | timestamp | YES | NULL | Actual delivery time | From carrier tracking | `'2025-06-21 11:45:00'` |
| `delivery_status` | varchar(30) | YES | 'pending' | Current status | See Appendix for values | `'delivered'` |
| `signature_required` | boolean | YES | FALSE | Signature needed | High-value items | `FALSE` |
| `created_at` | timestamp | YES | CURRENT_TIMESTAMP | Record creation | System-managed | `'2025-06-19 16:30:00'` |

**Common Queries:**
- Carrier performance comparison
- On-time delivery analysis
- Shipping cost analysis

---

## 4. Billing Tables

### 4.1 invoices

**Description:** Monthly invoices sent to clients for services rendered.

**Business Context:** We bill clients monthly for storage, fulfillment, and other services. This table tracks invoice status and payment.

**Row Count:** 2,550  
**Primary Key:** `invoice_id`  
**Foreign Keys:** `client_id` → `clients.client_id`

| Column | Data Type | Nullable | Default | Description | Business Rules | Example |
|--------|-----------|----------|---------|-------------|----------------|---------|
| `invoice_id` | serial | NO | auto | Unique identifier | System-generated | `1847` |
| `client_id` | integer | NO | — | Billed client | Must exist in clients | `42` |
| `invoice_number` | varchar(30) | NO | — | External invoice ID | Unique; client-facing | `'INV-202506-0042'` |
| `invoice_date` | date | NO | — | Date issued | First of month typically | `'2025-06-01'` |
| `due_date` | date | NO | — | Payment due | Net 30 standard | `'2025-07-01'` |
| `billing_period_start` | date | NO | — | Service period start | First of prior month | `'2025-05-01'` |
| `billing_period_end` | date | NO | — | Service period end | Last of prior month | `'2025-05-31'` |
| `subtotal` | decimal(12,2) | NO | — | Pre-tax total | Sum of line items | `18,540.00` |
| `tax_amount` | decimal(10,2) | YES | 0 | Sales tax | Usually 0 for B2B | `0.00` |
| `total_amount` | decimal(12,2) | NO | — | Amount due | Subtotal + tax | `18,540.00` |
| `status` | varchar(20) | YES | 'pending' | Invoice status | See Appendix for values | `'paid'` |
| `paid_date` | date | YES | NULL | When paid | NULL until paid | `'2025-06-15'` |
| `payment_method` | varchar(50) | YES | NULL | How paid | ACH, Wire, Check, etc. | `'ACH'` |
| `notes` | text | YES | NULL | Additional notes | Adjustments, disputes | `NULL` |
| `created_at` | timestamp | YES | CURRENT_TIMESTAMP | Record creation | System-managed | `'2025-06-01 06:00:00'` |

**Common Queries:**
- Accounts receivable aging
- Revenue by month
- Payment trends

---

### 4.2 invoice_lines

**Description:** Itemized charges on each invoice.

**Business Context:** Each invoice contains multiple charge types (storage, fulfillment, shipping, etc.). This detail is needed for client transparency and revenue analysis.

**Row Count:** 8,415  
**Primary Key:** `line_id`  
**Foreign Keys:** `invoice_id` → `invoices.invoice_id`

| Column | Data Type | Nullable | Default | Description | Business Rules | Example |
|--------|-----------|----------|---------|-------------|----------------|---------|
| `line_id` | serial | NO | auto | Unique identifier | System-generated | `12847` |
| `invoice_id` | integer | NO | — | Parent invoice | Must exist in invoices | `1847` |
| `charge_type` | varchar(50) | NO | — | Type of charge | See Appendix for values | `'fulfillment'` |
| `description` | varchar(200) | YES | NULL | Charge description | Human-readable detail | `'Order fulfillment services'` |
| `quantity` | decimal(12,2) | NO | — | Units billed | Pallets, orders, etc. | `847.00` |
| `unit_rate` | decimal(10,2) | NO | — | Rate per unit | Per contract | `3.75` |
| `line_total` | decimal(12,2) | NO | — | Extended amount | qty × rate | `3,176.25` |
| `reference_ids` | text | YES | NULL | Related record IDs | For audit trail | `'Orders 67001-67847'` |
| `created_at` | timestamp | YES | CURRENT_TIMESTAMP | Record creation | System-managed | `'2025-06-01 06:00:00'` |

**Common Queries:**
- Revenue by charge type
- Client billing detail
- Rate analysis

---

## 5. Appendix: Enumerated Values

### Order Status Values

| Value | Description | Next States |
|-------|-------------|-------------|
| `pending` | Order received, awaiting processing | processing, cancelled |
| `processing` | Assigned to warehouse, in queue | picked, cancelled |
| `picked` | Items retrieved from shelves | packed, cancelled |
| `packed` | Items boxed and labeled | shipped, cancelled |
| `shipped` | Handed to carrier | delivered |
| `delivered` | Customer received package | (final) |
| `cancelled` | Order cancelled | (final) |

### Order Priority Values

| Value | SLA | Use Case |
|-------|-----|----------|
| `standard` | Ship within 2-3 days | Default for most orders |
| `express` | Ship within 1 day | Faster delivery requested |
| `overnight` | Ship same day (before noon) | Urgent orders |

### Shipping Method Values

| Value | Typical Delivery | Cost Level |
|-------|-----------------|------------|
| `ground` | 5-7 days | $ |
| `express` | 2-3 days | $$ |
| `overnight` | 1 day | $$$ |
| `economy` | 7-12 days | $ (cheapest) |
| `freight` | 1-3 weeks | Bulk/heavy |

### Carrier Values

| Value | Primary Use |
|-------|-------------|
| `FedEx` | Domestic US, reliable tracking |
| `UPS` | Strong ground network |
| `USPS` | Light packages, residential |
| `DHL` | International shipments |
| `OnTrac` | US West Coast regional |
| `Canada Post` | Canadian shipments |
| `Estafeta` | Mexican shipments |
| `PostNL` | European shipments |

### Shipment Delivery Status Values

| Value | Description |
|-------|-------------|
| `pending` | Shipment created, not yet picked up |
| `in_transit` | With carrier, en route |
| `out_for_delivery` | On delivery vehicle |
| `delivered` | Confirmed delivered |
| `exception` | Delivery issue (address problem, etc.) |

### Invoice Status Values

| Value | Description |
|-------|-------------|
| `pending` | Invoice created, not yet sent |
| `sent` | Sent to client |
| `paid` | Payment received |
| `overdue` | Past due date, unpaid |
| `cancelled` | Invoice voided |

### Charge Type Values

| Value | Description | Unit |
|-------|-------------|------|
| `storage` | Pallet storage fees | Per pallet |
| `fulfillment` | Pick/pack/ship service | Per order |
| `shipping` | Carrier charges (pass-through) | Per order |
| `handling` | Special handling fees | Per item/order |
| `special_services` | Custom services | Varies |

### Employee Role Values

| Value | Description |
|-------|-------------|
| `picker` | Retrieves items from shelves |
| `packer` | Boxes and labels orders |
| `receiving` | Processes inbound shipments |
| `shipping` | Prepares outbound shipments |
| `supervisor` | Team lead |
| `manager` | Warehouse management |

### Industry Values

| Value |
|-------|
| `Electronics & Technology` |
| `Apparel & Fashion` |
| `Health & Beauty` |
| `Food & Beverage` |
| `Home & Garden` |
| `Industrial & Tools` |
| `Sports & Outdoors` |
| `Pharmaceuticals` |

### Client Tier Values

| Value | Description |
|-------|-------------|
| `standard` | Default tier, standard rates |
| `premium` | High volume, ~10% discount |
| `enterprise` | Largest clients, ~25% discount |

### Inventory Movement Type Values

| Value | Description | Quantity Sign |
|-------|-------------|---------------|
| `inbound` | Product received from client | Positive (+) |
| `outbound` | Product shipped to customer | Negative (-) |
| `adjustment` | Count correction | +/- |
| `transfer` | Moved between warehouses | +/- |
| `return` | Customer return | Positive (+) |
| `damaged` | Product damaged/disposed | Negative (-) |

---

## Document History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | Dec 2025 | BI Team | Initial creation |

---