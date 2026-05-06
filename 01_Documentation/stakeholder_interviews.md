# SwiftStock Logistics — Stakeholder Interview Notes

**Analyst:** Yesenia Mora Acosta  
**Date Range:** December 16-20, 2024  
**Purpose:** Understand business needs, pain points, and data requirements

---

## Interview Summary

| Stakeholder | Role | Date | Duration |
|-------------|------|------|----------|
| David Park | VP of Finance | Dec 16 | 45 min |
| Lisa Rodriguez | VP of Operations | Dec 17 | 60 min |
| Marcus Thompson | Warehouse Operations Manager | Dec 17 | 30 min |
| Jennifer Walsh | Inventory Control Manager | Dec 18 | 45 min |
| Robert Kim | Director of Sales | Dec 18 | 30 min |
| Maria Chen | Director of BI | Dec 20 | 60 min |

---

## Interview 1: David Park, VP of Finance

### Current State

> "We have decent visibility into revenue, but understanding profitability at the client level is painful. I spend two days every month manually pulling data from three different systems to build our client P&L."

**Current tools:** Excel, QuickBooks exports, manual data pulls from WMS  
**Reporting frequency:** Monthly close takes 5-7 business days

### Key Pain Points

1. **Client Profitability Analysis**
   - Cannot determine which clients are profitable after labor and space costs
   - Currently allocates warehouse costs by square footage (knows this is inaccurate)
   - Wants activity-based costing but lacks data infrastructure

2. **Accounts Receivable Aging**
   - $2.3M in receivables; needs to know who's 30, 60, 90 days overdue at a glance
   - Currently tracked in spreadsheet, updated weekly

3. **Revenue Forecasting**
   - Seasonality is unpredictable; November orders spike 40%
   - Needs historical patterns by client and industry

### Priority Requests

| Priority | Request |
|----------|---------|
| HIGH | Client profitability dashboard |
| HIGH | AR aging report |
| MEDIUM | Revenue by charge type |
| MEDIUM | Forecast model |

---

## Interview 2: Lisa Rodriguez, VP of Operations

### Current State

> "Operations runs on gut feel and tribal knowledge. Our best warehouse managers know instinctively when something's wrong. But we're growing too fast for that to scale."

**Current tools:** Manhattan WMS, Excel exports, whiteboard dashboards  
**Team size:** 180 employees across 12 warehouses

### Key Pain Points

1. **Fulfillment SLA Tracking**
   - Promises same-day ship for orders before noon
   - No systematic tracking of order-to-ship time
   - Customer complaints are reactive, not proactive

2. **Warehouse Capacity Planning**
   - LA is at ~90% capacity (uncertain)
   - No forward-looking view of capacity needs

3. **Labor Productivity**
   - Some pickers process 50 orders per shift, others do 25
   - WMS has pick timestamps but no one analyzes them

4. **Cross-Warehouse Visibility**
   - Each warehouse is a black box
   - Managers send daily email updates (inconsistent format)

### Priority Requests

| Priority | Request |
|----------|---------|
| CRITICAL | Order fulfillment SLA dashboard |
| HIGH | Warehouse utilization by location |
| HIGH | Employee productivity metrics |
| MEDIUM | Order volume forecasting |

### Operational SLAs

| Priority | SLA Target | Estimated Performance |
|----------|------------|----------------------|
| Overnight | Ship same day (orders before 12pm) | ~92% |
| Express | Ship within 24 hours | ~88% |
| Standard | Ship within 48 hours | ~95% |

---

## Interview 3: Marcus Thompson, Warehouse Operations Manager (Chicago)

### Current State

> "I've been doing this for 15 years. I know when we're behind just by the energy in the building. But I can't explain that to corporate."

**Direct reports:** 22 employees (pickers, packers, receiving, shipping)

### Key Pain Points

1. **Shift Planning** — Needs advance warning of volume spikes
2. **Pick Path Optimization** — High-frequency products poorly located
3. **Employee Performance** — Informal tracking via paper logs

### What Would Help Most

> "A simple report Monday morning: here's how many orders we expect this week, by day. Here's who's scheduled. Here's the gap."

---

## Interview 4: Jennifer Walsh, Inventory Control Manager

### Current State

> "Inventory accuracy is my whole job. We're at 97.2% accuracy right now. Good, but not great. Amazon is at 99.9%."

**Focus areas:** Cycle counts, shrinkage, aging inventory, stock-outs

### Key Pain Points

1. **Inventory Aging** — Products sitting 18 months; no automated aging report
2. **Stock-Out Prevention** — Reorder points exist but aren't monitored proactively
3. **Shrinkage Investigation** — Movement logs hard to query
4. **Multi-Warehouse Visibility** — No single view of inventory across warehouses

### Priority Requests

| Priority | Request |
|----------|---------|
| HIGH | Inventory aging report |
| HIGH | Low stock alert dashboard |
| MEDIUM | Inventory accuracy trending |
| MEDIUM | Dead stock identification |

### Key Metrics

- Inventory accuracy %
- Shrinkage rate
- Stock-out incidents per month
- Inventory turns by category
- Average days on hand

---

## Interview 5: Robert Kim, Director of Sales

### Current State

> "I'm trying to grow this business 30% next year. But I can't sell capacity I don't have, and I can't promise SLAs we don't track."

**Focus:** New client acquisition, upselling existing clients

### Key Pain Points

1. **Capacity for New Business** — Cannot self-serve capacity checks
2. **Client Health Scoring** — No churn prediction or early warning
3. **Industry Benchmarking** — No performance data by industry for pitches

### Priority Requests

| Priority | Request |
|----------|---------|
| HIGH | Capacity availability by warehouse |
| HIGH | Client health indicators |
| MEDIUM | Industry benchmarks |

---

## Interview 6: Maria Chen, Director of BI

### Current State

> "You're the third analyst on my team. We're small but growing. Right now we're drowning in ad-hoc requests."

**Team:** Director + 2 analysts (including this role)  
**Tools:** PostgreSQL, Tableau, dbt (just starting)  
**Maturity:** "Maybe a 3 out of 10"

### BI Team Pain Points

1. **No Single Source of Truth** — Five people calculate 'revenue' five different ways
2. **Ad-Hoc Request Overload** — 15 "quick questions" per week
3. **Technical Debt** — 200 Tableau workbooks, half broken, no documentation



---

## Synthesis: Common Themes

### Cross-Functional Needs

| Theme | Mentioned By | Priority |
|-------|--------------|----------|
| Real-time operational visibility | Lisa, Marcus, Jennifer | CRITICAL |
| Client profitability | David, Robert | HIGH |
| SLA tracking and alerting | Lisa, Marcus, Robert | HIGH |
| Inventory aging and health | Jennifer, David | HIGH |
| Predictive analytics | David, Lisa, Marcus | MEDIUM |
| Self-service reporting | Maria, all | MEDIUM |

### Quick Wins Identified

1. **AR Aging Report** — Data exists, needs query + visualization
2. **Order Status Dashboard** — orders table has what we need
3. **Warehouse Utilization** — inventory + warehouse capacity
4. **Low Stock Alerts** — inventory vs reorder_point

---

## Document History

| Date | Author | Change |
|------|--------|--------|
| 2026-04-10 | Yesenia Mora Acosta | Initial interviews |
| 2026-05-06 | Yesenia Mora Acosta | Added to GitHub |