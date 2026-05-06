# SwiftStock Analytics — Project Charter

**Project Name:** SwiftStock Logistics Analytics  
**Analyst:** Yesenia Mora Acosta  
**Start Date:** March 2025  
**Status:** In Progress

---

## 1. Business Problem

SwiftStock Logistics leadership lacks visibility into key operational and financial metrics. Stakeholders currently rely on manual processes, spreadsheets, and tribal knowledge to answer critical business questions.

Specific pain points identified:

- **Finance (David Park):** Cannot determine client profitability; AR aging tracked manually
- **Operations (Lisa Rodriguez):** No SLA tracking; no consolidated view across warehouses
- **Inventory (Jennifer Walsh):** No automated aging reports; reactive stock-out management
- **Sales (Robert Kim):** Cannot assess capacity for new business; no churn early warning

---

## 2. Project Objectives

1. Assess data quality across all 13 tables in the SwiftStock database
2. Conduct exploratory analysis to understand operational patterns
3. Deliver 2-3 business deliverables that address stakeholder pain points
4. Document all work for repeatability and knowledge transfer

---

## 3. Scope

### In Scope

- Data quality assessment and documentation
- Exploratory SQL analysis in Databricks
- Business deliverables (reports/queries) for selected stakeholder needs
- All work version-controlled in GitHub
- Project tracked in Jira

### Out of Scope

- Dashboard development (Tableau — future phase)
- Data pipeline engineering / ETL modifications
- Real-time reporting infrastructure
- Changes to source systems

---

## 4. Stakeholders

| Name | Role | Primary Interest |
|------|------|------------------|
| David Park | VP of Finance | Client profitability, AR aging |
| Lisa Rodriguez | VP of Operations | SLA tracking, warehouse visibility |
| Marcus Thompson | Warehouse Ops Manager | Shift planning, productivity |
| Jennifer Walsh | Inventory Control Manager | Inventory aging, stock-outs |
| Robert Kim | Director of Sales | Capacity, client health |
| Maria Chen | Director of BI | Team support, data quality |

---

## 5. Deliverables

| # | Deliverable | Status |
|---|-------------|--------|
| 1 | Project documentation (charter, data dictionary, ERD) | In Progress |
| 2 | Data quality assessment report | Not Started |
| 3 | Exploratory analysis notebook | Not Started |
| 4 | Business deliverable #1 (TBD based on priority) | Not Started |
| 5 | Business deliverable #2 (TBD based on priority) | Not Started |
| 6 | Executive summary | Not Started |

---

## 6. Success Criteria

- All documentation complete and in GitHub
- Data quality issues identified and documented
- At least 2 business deliverables completed with findings and recommendations
- Work is reproducible — another analyst could run the queries and get the same results
- Portfolio-ready: clear README, clean commit history, professional presentation

---

## 7. Tools & Environment

| Tool | Purpose |
|------|---------|
| Databricks Community Edition | SQL queries, notebooks |
| GitHub | Version control, portfolio |
| Jira | Project tracking (Kanban) |
| VS Code | Local editing |
| Tableau | Dashboards (future phase) |

---

## 8. Risks & Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Data quality issues block analysis | High | Assess data quality first; document workarounds |
| Scope creep from stakeholder requests | Medium | Defined scope; defer to future phases |
| Databricks compute limits (free tier) | Low | Optimize queries; work in batches |

---

## 9. Timeline

| Phase | Focus | Target |
|-------|-------|--------|
| Phase 1 | Project Setup & Documentation | Week 1 |
| Phase 2 | Data Quality Assessment | Week 2 |
| Phase 3 | Exploratory Analysis | Week 3 |
| Phase 4 | Business Deliverables | Weeks 4-5 |
| Phase 5 | Portfolio Polish | Week 6 |

---

## Document History

| Date | Author | Change |
|------|--------|--------|
| 2025-05-06 | Yesenia Mora Acosta | Initial creation |