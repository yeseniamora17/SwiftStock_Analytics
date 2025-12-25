# SwiftStock Logistics — Business Glossary

**Version:** 1.0  
**Last Updated:** December 2024  
**Owner:** Business Intelligence Team

---

## Purpose

This glossary provides standardized definitions for business terms used across SwiftStock. Consistent terminology ensures everyone speaks the same language when discussing metrics, processes, and data.

---

## A

### Active Client
A client with `is_active = TRUE` in the database. Indicates an ongoing contractual relationship.

### Aging Inventory
Products stored beyond a threshold (90, 180, or 365 days) without outbound movement.

### Available Quantity
`quantity_on_hand - quantity_reserved`. Units that can be allocated to new orders.

---

## B

### B2B (Business-to-Business)
Our relationship with **clients**. SwiftStock provides services to other businesses.

### B2C (Business-to-Consumer)
Our clients' relationship with **customers**. End consumers buy from client websites; we fulfill orders.

### Backlog
Orders in `pending` or `processing` status not yet picked.

---

## C

### Capacity (Warehouse)
Maximum pallet positions available. Found in `warehouses.capacity_pallets`.

### Carrier
Shipping company (FedEx, UPS, USPS, DHL) that delivers packages to customers.

### Charge Type
Category of billable service: storage, fulfillment, shipping, handling, special_services.

### Client
A business that contracts with SwiftStock for services. Clients **pay us**.

### Client Tier
Service level affecting pricing: Standard, Premium, Enterprise.

### Customer
End consumer who receives shipments. Customers are **our clients' customers**.

---

## D

### Days Sales Outstanding (DSO)
Average days to collect payment after invoicing.

### Delivered
Final order status indicating customer received their package.

---

## F

### Fulfillment
Complete process: receive order → pick items → pack → ship.

### Fulfillment Fee
Per-order charge for pick/pack services. Found in `clients.fulfillment_rate`.

---

## I

### Inbound
Inventory received from a client. Increases `quantity_on_hand`.

### Inventory Accuracy
Percentage match between system quantities and physical counts. Target: 99%+.

### Inventory Turnover
How quickly inventory sells: Cost of Goods Shipped / Average Inventory Value.

---

## O

### On-Time Shipping Rate
Percentage of orders shipped within SLA.

### Order
Request to pick, pack, and ship products to a customer.

### Order Status
Lifecycle stages: pending → processing → picked → packed → shipped → delivered (or cancelled).

### Outbound
Inventory shipped to a customer. Decreases `quantity_on_hand`.

---

## P

### Pallet
Standard unit for warehouse storage capacity (40" × 48" platform).

### Pick / Picking
Retrieving items from storage to fulfill an order.

### Priority (Order)
Urgency level: Standard (48 hrs), Express (24 hrs), Overnight (same day).

---

## Q

### Quantity Available
Units available to sell: `on_hand - reserved`.

### Quantity on Hand
Total physical units in the warehouse.

### Quantity Reserved
Units allocated to pending orders.

---

## R

### Reorder Point
Threshold triggering low-stock alert. Found in `inventory.reorder_point`.

---

## S

### Shipment
Package handed to carrier with tracking information.

### Shipping Zone
Distance-based classification (1-8) affecting cost.

### Shrinkage
Unexplained inventory loss (theft, damage, miscounts).

### SKU (Stock Keeping Unit)
Unique product identifier assigned by the client.

### SLA (Service Level Agreement)
Contractual promise for service quality (e.g., "ship within 48 hours").

### Stock-Out
When `quantity_available = 0`. Orders cannot be fulfilled.

### Storage Fee
Monthly charge per pallet. Found in `clients.storage_rate_pallet`.

---

## T

### 3PL (Third-Party Logistics)
Company providing outsourced logistics services. SwiftStock is a 3PL.

### Tracking Number
Carrier-assigned identifier to track shipment delivery.

---

## U

### Utilization (Warehouse)
Percentage of capacity in use: `Pallets Used / Capacity × 100`. Target: 70-85%.

---

## W

### Warehouse
Physical distribution center for storage and fulfillment.

### WMS (Warehouse Management System)
Software managing warehouse operations (Manhattan Associates).

---

*Maintained by the Business Intelligence team. Contact: bi-team@swiftstock.com*
