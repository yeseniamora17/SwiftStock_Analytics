# SwiftStock Logistics — Data Lineage Documentation

**Version:** 1.0  
**Last Updated:** December 2025

---

## Overview

This document describes where SwiftStock's data originates, how it flows through our systems, and important considerations for data quality and reliability.

---

## Table of Contents

1. [System Architecture](#1-system-architecture)
2. [Source Systems](#2-source-systems)
3. [Data Flow Diagrams](#3-data-flow-diagrams)
4. [Table-Level Lineage](#4-table-level-lineage)
5. [Data Freshness & SLAs](#5-data-freshness--slas)
6. [Known Data Quality Issues](#6-known-data-quality-issues)
7. [Data Owners & Contacts](#7-data-owners--contacts)

---

## 1. System Architecture

### High-Level Overview

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         SOURCE SYSTEMS                                   │
├─────────────────┬─────────────────┬─────────────────┬───────────────────┤
│  Manhattan WMS  │   NetSuite ERP  │  Carrier APIs   │  Client Portals   │
│  (Warehouse)    │   (Finance)     │  (Shipping)     │  (Orders)         │
└────────┬────────┴────────┬────────┴────────┬────────┴─────────┬─────────┘
         │                 │                 │                   │
         ▼                 ▼                 ▼                   ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                      INTEGRATION LAYER (Fivetran)                        │
│                      - Scheduled extracts                                │
│                      - Change data capture                               │
│                      - API polling                                       │
└─────────────────────────────────┬───────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                      DATA WAREHOUSE (PostgreSQL)                         │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐                  │
│  │   Raw       │───▶│  Staging    │───▶│  Analytics  │                  │
│  │   Schema    │    │  Schema     │    │  Schema     │                  │
│  │  (landing)  │    │  (cleaned)  │    │  (modeled)  │                  │
│  └─────────────┘    └─────────────┘    └─────────────┘                  │
└─────────────────────────────────┬───────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                      CONSUMPTION LAYER                                   │
├─────────────────┬─────────────────┬─────────────────────────────────────┤
│    Tableau      │   Ad-hoc SQL    │   Scheduled Reports                 │
│   Dashboards    │    Queries      │   (Email/Slack)                     │
└─────────────────┴─────────────────┴─────────────────────────────────────┘
```

---

## 2. Source Systems

### 2.1 Manhattan WMS (Warehouse Management System)

**Description:** Primary operational system for warehouse management. Handles inventory tracking, order processing, pick/pack operations.

**Vendor:** Manhattan Associates  
**Deployment:** Cloud-hosted (SaaS)  
**Data Owner:** Operations Team (Lisa Rodriguez)

**Data Provided:**
| Data Type | Tables Populated | Update Frequency |
|-----------|------------------|------------------|
| Warehouse master data | `warehouses` | On change |
| Product catalog | `products` | On change |
| Inventory levels | `inventory` | Real-time |
| Inventory movements | `inventory_logs` | Real-time |
| Orders | `orders`, `order_items` | Real-time |
| Employee records | `employees` | On change |

**Integration Method:** REST API with Change Data Capture (CDC)

**API Endpoints Used:**
- `/api/v2/warehouses` — Warehouse master
- `/api/v2/inventory` — Current inventory
- `/api/v2/inventory/movements` — Movement log
- `/api/v2/orders` — Order headers
- `/api/v2/orders/{id}/items` — Order line items
- `/api/v2/employees` — Employee master

**Technical Notes:**
- API rate limit: 1000 requests/minute
- Timestamps are in UTC
- Order IDs are globally unique across all warehouses
- Employee data excludes sensitive HR fields (SSN, bank info)

---

### 2.2 NetSuite ERP (Financial System)

**Description:** Enterprise resource planning system for finance and accounting. Source of truth for client contracts, invoicing, and payments.

**Vendor:** Oracle NetSuite  
**Deployment:** Cloud-hosted (SaaS)  
**Data Owner:** Finance Team (David Park)

**Data Provided:**
| Data Type | Tables Populated | Update Frequency |
|-----------|------------------|------------------|
| Client master data | `clients` | On change |
| Invoices | `invoices` | Daily batch |
| Invoice line items | `invoice_lines` | Daily batch |
| Payment records | `invoices.paid_date` | Daily batch |

**Integration Method:** SuiteScript scheduled export + SFTP

**Export Schedule:**
- Daily at 2:00 AM EST
- Full extract of modified records (last 7 days)
- Files landed in `/data/landing/netsuite/`

**Technical Notes:**
- Currency is always USD (multi-currency converted at booking)
- Client IDs synchronized with WMS via client_code
- Invoice numbers follow format: INV-YYYYMM-XXXX

---

### 2.3 Carrier APIs (Shipping Systems)

**Description:** Direct integrations with shipping carriers for tracking information.

**Carriers Integrated:**
| Carrier | Integration Type | Update Frequency |
|---------|------------------|------------------|
| FedEx | REST API | Every 2 hours |
| UPS | REST API | Every 2 hours |
| USPS | Web Services | Every 4 hours |
| DHL | REST API | Every 2 hours |
| Regional | Varies | Daily batch |

**Data Owner:** Operations Team

**Data Provided:**
| Data Type | Tables Populated |
|-----------|------------------|
| Shipment creation | `shipments` |
| Tracking updates | `shipments.delivery_status` |
| Delivery confirmation | `shipments.actual_delivery` |

**Technical Notes:**
- Tracking numbers may take 30-60 minutes to become active after label creation
- Delivery timestamps are in local time of delivery address
- Regional carriers have less reliable tracking data

---

### 2.4 Client Order Portals

**Description:** Client-specific integrations for receiving orders.

**Integration Types:**
| Method | Clients Using | Update Frequency |
|--------|---------------|------------------|
| EDI (X12 850) | Enterprise clients (~30) | Real-time |
| REST API push | Premium clients (~50) | Real-time |
| CSV upload | Standard clients (~70) | Batch (varies) |

**Data Owner:** Client Success Team

**Data Provided:**
| Data Type | Tables Populated |
|-----------|------------------|
| Customer master | `customers` |
| Orders | `orders`, `order_items` |

**Technical Notes:**
- Customer data quality varies by client
- Missing emails are common (~15% of records)
- Address standardization applied during ETL

---

## 3. Data Flow Diagrams

### 3.1 Order Lifecycle Data Flow

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│   Client     │     │   SwiftStock │     │   Carrier    │
│   System     │     │   WMS        │     │   System     │
└──────┬───────┘     └──────┬───────┘     └──────┬───────┘
       │                    │                    │
       │  1. Order placed   │                    │
       │───────────────────▶│                    │
       │                    │                    │
       │                    │  2. Order created  │
       │                    │  (status: pending) │
       │                    │                    │
       │                    │  3. Assigned to    │
       │                    │  warehouse         │
       │                    │  (status: processing)
       │                    │                    │
       │                    │  4. Items picked   │
       │                    │  (status: picked)  │
       │                    │                    │
       │                    │  5. Order packed   │
       │                    │  (status: packed)  │
       │                    │                    │
       │                    │  6. Ship label     │
       │                    │  created           │
       │                    │───────────────────▶│
       │                    │                    │
       │                    │  7. Carrier pickup │
       │                    │  (status: shipped) │
       │                    │◀───────────────────│
       │                    │                    │
       │                    │  8. Tracking       │
       │                    │  updates           │
       │                    │◀───────────────────│
       │                    │                    │
       │                    │  9. Delivery       │
       │                    │  confirmation      │
       │                    │  (status: delivered)
       │                    │◀───────────────────│
       │                    │                    │
       ▼                    ▼                    ▼

    ┌─────────────────────────────────────────────┐
    │           DATA WAREHOUSE                     │
    │                                              │
    │  orders (status changes tracked)            │
    │  order_items (pick timestamps)              │
    │  shipments (carrier + delivery data)        │
    │  inventory_logs (outbound movements)        │
    └─────────────────────────────────────────────┘
```

### 3.2 Inventory Data Flow

```
┌──────────────────────────────────────────────────────────────────┐
│                     INVENTORY MOVEMENTS                           │
└──────────────────────────────────────────────────────────────────┘

  INBOUND                                           OUTBOUND
  ═══════                                           ════════
     │                                                  │
     │  Client sends                                    │  Customer places
     │  product                                         │  order
     │                                                  │
     ▼                                                  ▼
┌──────────┐                                     ┌──────────┐
│ Receiving│                                     │  Order   │
│ Dock     │                                     │ Received │
└────┬─────┘                                     └────┬─────┘
     │                                                │
     │  Scan & verify                                 │  Allocate
     │                                                │  inventory
     ▼                                                ▼
┌──────────┐                                     ┌──────────┐
│inventory_│  type: 'inbound'                    │inventory │  qty_reserved
│logs      │  qty: +N                            │          │  increases
└────┬─────┘                                     └────┬─────┘
     │                                                │
     │  Put away                                      │  Pick items
     │                                                │
     ▼                                                ▼
┌──────────┐                                     ┌──────────┐
│inventory │  qty_on_hand                        │inventory_│  type: 'outbound'
│          │  increases                          │logs      │  qty: -N
└──────────┘                                     └────┬─────┘
                                                      │
                                                      │  Ship
                                                      │
                                                      ▼
                                                 ┌──────────┐
                                                 │inventory │  qty_on_hand
                                                 │          │  decreases
                                                 │          │  qty_reserved
                                                 │          │  decreases
                                                 └──────────┘
```

### 3.3 Billing Data Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                    MONTHLY BILLING CYCLE                         │
└─────────────────────────────────────────────────────────────────┘

  Day 1 of Month
        │
        ▼
┌───────────────────┐
│  Billing Job      │     Calculates:
│  Triggered        │     - Storage: pallet-days from inventory
│  (NetSuite)       │     - Fulfillment: order count from WMS
│                   │     - Shipping: carrier costs from shipments
└────────┬──────────┘
         │
         │  Query operational data
         │
         ▼
┌───────────────────┐     ┌───────────────────┐
│  inventory        │     │  orders           │
│  (avg pallets)    │     │  (count shipped)  │
└───────────────────┘     └───────────────────┘
         │                         │
         │                         │
         ▼                         ▼
┌─────────────────────────────────────────────┐
│              NetSuite                        │
│                                              │
│  Creates:                                    │
│  - invoices (header)                         │
│  - invoice_lines (storage, fulfillment,      │
│                   shipping, handling)        │
└───────────────────┬─────────────────────────┘
                    │
                    │  Daily sync to DW
                    │
                    ▼
┌─────────────────────────────────────────────┐
│           DATA WAREHOUSE                     │
│                                              │
│  invoices                                    │
│  invoice_lines                               │
│                                              │
│  Used for:                                   │
│  - Revenue reporting                         │
│  - AR aging                                  │
│  - Client profitability                      │
└─────────────────────────────────────────────┘
```

---

## 4. Table-Level Lineage

### Summary Matrix

| Table | Primary Source | Secondary Sources | Update Frequency | Latency |
|-------|---------------|-------------------|------------------|---------|
| `warehouses` | Manhattan WMS | — | On change | < 5 min |
| `clients` | NetSuite ERP | — | Daily | < 24 hrs |
| `categories` | Manhattan WMS | — | On change | < 5 min |
| `employees` | Manhattan WMS | — | On change | < 5 min |
| `products` | Manhattan WMS | — | On change | < 5 min |
| `inventory` | Manhattan WMS | — | Real-time | < 1 min |
| `inventory_logs` | Manhattan WMS | — | Real-time | < 1 min |
| `customers` | Client portals | Manhattan WMS | Real-time | < 5 min |
| `orders` | Client portals | Manhattan WMS | Real-time | < 5 min |
| `order_items` | Client portals | Manhattan WMS | Real-time | < 5 min |
| `shipments` | Carrier APIs | Manhattan WMS | Every 2 hrs | < 2 hrs |
| `invoices` | NetSuite ERP | — | Daily | < 24 hrs |
| `invoice_lines` | NetSuite ERP | — | Daily | < 24 hrs |

### Detailed Lineage by Table

#### `orders` Table

```
Source Systems                    Transformations              Target
══════════════                    ═══════════════              ══════

┌─────────────────┐
│ Client Portal   │──┐
│ (EDI/API/CSV)   │  │
└─────────────────┘  │
                     │   ┌──────────────────────┐
                     ├──▶│ Order normalization  │
                     │   │ - Standardize fields │
┌─────────────────┐  │   │ - Validate client_id │     ┌─────────┐
│ Manhattan WMS   │──┘   │ - Assign warehouse   │────▶│ orders  │
│ (status updates)│      │ - Generate order_num │     └─────────┘
└─────────────────┘      └──────────────────────┘

Field Mappings:
───────────────
client_portal.external_order_id  →  orders.order_number
client_portal.customer_ref       →  orders.customer_id (lookup)
wms.order_status                 →  orders.status
wms.pick_timestamp              →  orders.picked_by, orders.updated_at
wms.ship_timestamp              →  orders.shipped_date
carrier.delivery_timestamp       →  orders.delivered_date
```

#### `inventory` Table

```
Source Systems                    Transformations              Target
══════════════                    ═══════════════              ══════

┌─────────────────┐
│ Manhattan WMS   │
│                 │      ┌──────────────────────┐
│ /inventory      │─────▶│ Inventory snapshot   │
│ endpoint        │      │ - Sum by location    │     ┌───────────┐
│                 │      │ - Calculate reserved │────▶│ inventory │
│ /movements      │      │ - Compute available  │     └───────────┘
│ endpoint        │      └──────────────────────┘
└─────────────────┘

Computed Fields:
────────────────
quantity_available = quantity_on_hand - quantity_reserved
(Generated column in PostgreSQL)
```

---

## 5. Data Freshness & SLAs

### Refresh Schedule

| Data Category | Source | Refresh Time | SLA | Monitoring |
|--------------|--------|--------------|-----|------------|
| **Real-time operational** | WMS | Continuous | < 5 min | Fivetran alerts |
| **Inventory positions** | WMS | Continuous | < 1 min | Fivetran alerts |
| **Carrier tracking** | Carrier APIs | Every 2 hours | < 3 hrs | Custom job monitor |
| **Financial data** | NetSuite | Daily 2 AM EST | < 24 hrs | Airflow alerts |
| **Client master** | NetSuite | Daily 2 AM EST | < 24 hrs | Airflow alerts |

### Data Availability Windows

```
Timeline (EST)                    Data Available
════════════════                  ══════════════

12:00 AM ─────────────────────── Operational data: current
                                 Financial data: as of yesterday

 2:00 AM ─────────────────────── NetSuite sync starts

 3:30 AM ─────────────────────── NetSuite sync complete
                                 Financial data: current

 6:00 AM ─────────────────────── All dashboards refreshed
                                 Morning reports sent

 8:00 AM ─────────────────────── Business day starts
                                 All data current
```

### When to Trust the Data

| Question | Data Readiness | Notes |
|----------|---------------|-------|
| "How many orders shipped today?" | Real-time | Reliable anytime |
| "What's current inventory level?" | Real-time | Reliable anytime |
| "What's yesterday's revenue?" | After 3:30 AM | Wait for NetSuite sync |
| "Did this order deliver?" | 2-4 hour lag | Carrier API delay |
| "What's this month's invoice total?" | After 3:30 AM on 2nd of month | Billing runs overnight |

---

## 6. Known Data Quality Issues

### Active Issues

| ID | Table | Issue | Impact | Workaround | Status |
|----|-------|-------|--------|------------|--------|
| DQ-001 | `orders` | `shipped_date` sometimes NULL for delivered orders | 3% of delivered orders | Use `shipments.shipped_date` instead | Investigating |
| DQ-002 | `customers` | Missing email addresses | 15% of records | No workaround; client data quality | Accepted |
| DQ-003 | `shipments` | Regional carrier tracking unreliable | 5% of shipments | Manual status updates | Accepted |
| DQ-004 | `inventory_logs` | Duplicate entries during bulk uploads | < 0.1% of records | Dedupe in queries | Fix scheduled |
| DQ-005 | `clients` | `contract_end_date` not consistently updated | Unknown % | Verify with Sales | Under review |

### Historical Issues (Resolved)

| ID | Table | Issue | Resolution Date | Notes |
|----|-------|-------|-----------------|-------|
| DQ-R001 | `orders` | Timezone inconsistency (PST vs UTC) | 2024-06-15 | All timestamps now UTC |
| DQ-R002 | `products` | Missing `category_id` for 12% of products | 2024-08-01 | Backfilled with "Uncategorized" |

### Data Quality Queries

```sql
-- Check for orders with status 'delivered' but NULL shipped_date
SELECT COUNT(*) as problematic_orders
FROM orders
WHERE status = 'delivered'
  AND shipped_date IS NULL;

-- Check customer email completeness
SELECT 
    COUNT(*) as total_customers,
    COUNT(email) as with_email,
    ROUND(100.0 * COUNT(email) / COUNT(*), 1) as email_pct
FROM customers;

-- Check for duplicate inventory log entries
SELECT 
    warehouse_id, product_id, logged_at, movement_type,
    COUNT(*) as occurrences
FROM inventory_logs
GROUP BY warehouse_id, product_id, logged_at, movement_type
HAVING COUNT(*) > 1;
```

---

## 7. Data Owners & Contacts

### By Domain

| Domain | Data Owner | Backup | Contact |
|--------|-----------|--------|---------|
| **Warehouse Operations** | Lisa Rodriguez | Marcus Thompson | ops@swiftstock.com |
| **Inventory** | Jennifer Walsh | (reports to Lisa) | inventory@swiftstock.com |
| **Finance/Billing** | David Park | Controller | finance@swiftstock.com |
| **Client Data** | Robert Kim | Account Managers | clients@swiftstock.com |
| **Shipping/Carriers** | Lisa Rodriguez | Shipping Lead | shipping@swiftstock.com |

### By System

| System | Technical Owner | Business Owner | Support |
|--------|----------------|----------------|---------|
| Manhattan WMS | IT Infrastructure | Lisa Rodriguez | wms-support@swiftstock.com |
| NetSuite | IT Infrastructure | David Park | erp-support@swiftstock.com |
| Data Warehouse | BI Team (Maria Chen) | Maria Chen | bi-team@swiftstock.com |
| Carrier APIs | IT Infrastructure | Lisa Rodriguez | integrations@swiftstock.com |

### Escalation Path

```
Issue Type                    First Contact           Escalation
══════════                    ═════════════           ══════════

Data missing/delayed     →    bi-team@swiftstock.com  →  Maria Chen
Data incorrect           →    Data owner (above)      →  Maria Chen
System outage           →    IT Help Desk            →  CTO
Access request          →    bi-team@swiftstock.com  →  Maria Chen
New data request        →    bi-team@swiftstock.com  →  Maria Chen
```

---

## Appendix: Glossary

| Term | Definition |
|------|------------|
| **CDC** | Change Data Capture — technique to identify and capture changes in source data |
| **ETL** | Extract, Transform, Load — process of moving data from sources to warehouse |
| **SLA** | Service Level Agreement — promised data freshness/availability |
| **Latency** | Time delay between source change and warehouse availability |
| **Lineage** | Documentation of where data comes from and how it transforms |
| **WMS** | Warehouse Management System |
| **ERP** | Enterprise Resource Planning system |

---

## Document History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | Dec 2024 | BI Team | Initial creation |

---
