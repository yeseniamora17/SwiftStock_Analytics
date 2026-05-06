# SwiftStock Logistics — Data Analytics Project

End-to-end analytics project for a third-party logistics (3PL) company that provides warehousing, inventory management, and fulfillment services for multiple clients.

---

##  Project Overview

**Analyst:** Yesenia Mora Acosta  
**Status:** In Progress  
**Tools:** Databricks SQL, GitHub, Jira, VS Code

### Business Context

SwiftStock Logistics operates 12 warehouses across North America and Europe, serving 150+ B2B clients. Leadership lacks visibility into key operational and financial metrics, relying on manual processes and tribal knowledge.

### Project Objectives

1. Assess data quality across 13 tables (~500K rows)
2. Conduct exploratory analysis to understand operational patterns
3. Deliver business insights that address stakeholder pain points
4. Document all work for repeatability and portfolio demonstration

---

##  Repository Structure

SwiftStock_Analytics/
├── 01_Documentation/
│   ├── project_charter.md      # Scope, objectives, success criteria
│   ├── data_dictionary.md      # Complete schema documentation
│   ├── stakeholder_interviews.md # Business requirements
│   ├── data_lineage.md         # Data flow and source systems
│   ├── business_glossary.md    # Key terms and definitions
│   ├── decision_log.md         # Project decisions and rationale
│   └── erd_diagram.png         # Entity relationship diagram
├── 02_SQL_Queries/
│   ├── data_quality/           # Data validation queries
│   ├── exploratory/            # EDA queries
│   └── business_deliverables/  # Final analysis queries
├── 03_Analysis/
│   ├── findings/               # Analysis results
│   └── recommendations/        # Business recommendations
├── 04_Deliverables/
│   └── reports/                # Final reports
└── README.md

---

## Database Overview

| Table | Rows | Description |
|-------|------|-------------|
| warehouses | 12 | Distribution centers |
| clients | 200 | B2B customers |
| employees | 180 | Warehouse staff |
| categories | 25 | Product categories |
| products | 2,500 | SKUs stored |
| customers | 15,000 | End consumers |
| inventory | 4,192 | Current stock levels |
| orders | 60,103 | Fulfillment orders |
| order_items | 116,122 | Order line items |
| shipments | 57,864 | Carrier tracking |
| invoices | 2,550 | Client billing |
| invoice_lines | 8,401 | Charge details |
| inventory_logs | 207,000 | Stock movements |
| **Total** | **~474,000** | |

---

## Key Stakeholders

| Stakeholder | Role | Primary Interest |
|-------------|------|------------------|
| David Park | VP of Finance | Client profitability, AR aging |
| Lisa Rodriguez | VP of Operations | SLA tracking, warehouse visibility |
| Jennifer Walsh | Inventory Control Manager | Inventory aging, stock-outs |
| Robert Kim | Director of Sales | Capacity, client health |

---

## Tools & Environment

| Tool | Purpose |
|------|---------|
| **Databricks Community Edition** | SQL queries, notebooks |
| **GitHub** | Version control, portfolio |
| **Jira** | Project tracking (Kanban) |
| **VS Code** | Local development |
| **dbdiagram.io** | ERD visualization |
| **Tableau** | Dashboards (future phase) |

---

## Project Phases

| Phase | Focus | Status |
|-------|-------|--------|
| 1 | Project Setup & Documentation | ✅ Complete |
| 2 | Data Quality Assessment | 🔲 Not Started |
| 3 | Exploratory Analysis | 🔲 Not Started |
| 4 | Business Deliverables | 🔲 Not Started |
| 5 | Portfolio Polish | 🔲 Not Started |

---

## Documentation

- [Project Charter](01_Documentation/project_charter.md)
- [Data Dictionary](01_Documentation/data_dictionary.md)
- [Stakeholder Interviews](01_Documentation/stakeholder_interviews.md)
- [Data Lineage](01_Documentation/data_lineage.md)
- [Business Glossary](01_Documentation/business_glossary.md)
- [Decision Log](01_Documentation/decision_log.md)

---

## Skills Demonstrated

### Technical
- SQL (CTEs, window functions, aggregations, joins)
- Databricks / Spark SQL
- Git version control
- Data quality assessment

### Analytical
- Stakeholder requirements gathering
- Data quality assessment
- Business insight generation
- Metric definition

### Project Management
- Kanban workflow (Jira)
- Documentation discipline
- Structured approach to analysis
- Decision logging

---


## License

This project uses simulated data for portfolio demonstration purposes. All company names, employee names, and figures are fictional.