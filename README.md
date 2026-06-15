# Lab 10 — Azure Database for PostgreSQL: Deployment & Configuration

## Overview
This project documents the deployment and configuration of an Azure Database for PostgreSQL Flexible Server. It covers provisioning, security, networking, database schema design, CRUD operations, monitoring, and backup verification.

---

## 1. Configuration Choices

### Server Details
| Setting | Value |
|---|---|
| Server Name | lab10-pg-ade |
| Resource Group | rg-lab10-postgres |
| Region | South Africa North |
| PostgreSQL Version | 18.4 |
| Compute Tier | Burstable — B1ms (1 vCore, 2 GiB RAM) |
| Storage | 32 GiB (P4 — 120 IOPS) |
| Administrator Login | pgadmin10 |
| Availability Zone | 1 |
| High Availability | Not enabled |

### Why Burstable B1ms?
This tier is ideal for development and test workloads. It handles low-to-moderate traffic efficiently, using CPU credits to burst when needed — perfect for a lab environment without the cost of General Purpose tiers.

---

## 2. Networking & Security Settings

| Setting | Value |
|---|---|
| Connectivity Method | Public access (allowed IP addresses) |
| Firewall Rule | ClientIPAddress_2026-6-15 (personal IP only) |
| Allow all Azure services | No |
| Private Endpoints | None configured |
| Data Encryption | Service-managed key (Azure-managed) |
| Authentication Method | PostgreSQL authentication only |
| TLS | Enforced by default on Azure Flexible Server |

### Security Notes
- Only the developer's IP address is whitelisted in the firewall, restricting all other public access.
- TLS is enforced by default on all Azure PostgreSQL Flexible Server connections, ensuring data in transit is encrypted.
- Azure-managed encryption keys protect data at rest.

---

## 3. Database Schema

Two tables were created inside the `lab10db` database:

### `customers` table
- `customer_id` — Primary key, auto-incremented
- `name` — Customer full name (required)
- `email` — Unique email address (required)
- `created_at` — Timestamp auto-set on insert

### `orders` table
- `order_id` — Primary key, auto-incremented
- `customer_id` — Foreign key referencing customers
- `product` — Product name (required)
- `quantity` — Number of items ordered (required)
- `order_date` — Timestamp auto-set on insert

The foreign key between `orders.customer_id` and `customers.customer_id` enforces **referential integrity** — an order cannot exist without a valid customer.

---

## 4. Connection Method

Connected using **pgAdmin 4 (v9.15)** on macOS.

| Connection Setting | Value |
|---|---|
| Host | lab10-pg-ade.postgres.database.azure.com |
| Port | 5432 |
| Database | postgres / lab10db |
| Username | pgadmin10 |
| SSL | Enabled (Azure default) |

---

## 5. Monitoring

Reviewed via Azure Portal → Monitoring → Metrics:
- **CPU Percent (Avg): ~15.5%** — spike observed during SQL query execution
- Metrics tracked over last 24 hours using line chart view

---

## 6. Backup Configuration

| Setting | Value |
|---|---|
| Backup Type | Automated (Azure-managed) |
| Retention Period | 7 days |
| First Backup Completed | 2026-06-15 14:09:37 UTC |
| Retained Until | 2026-06-22 14:09:37 UTC |
| Geo-redundancy | Not enabled |

Point-in-time restore is available from the earliest restore point: **2026-06-15 14:09:37 UTC**.

---

## 7. Screenshots Index

| Filename | Description |
|---|---|
| Lab10_Step1_ResourceGroup.png | Resource group rg-lab10-postgres created |
| Lab10_Step2_ServerBasics_Resized.png | Server basics configuration |
| Lab10_Step3_Networking.png | Firewall rule and networking setup |
| Lab10_Step4_ReviewSummary_A.png | Review page — Basics summary |
| Lab10_Step4_Review_Summary_B.png | Review page — Networking & cost estimate |
| Lab10_Step5_ServerDeployed.png | Server deployed and showing Ready status |
| Lab10_Phase2_pgAdminInstalled.png | pgAdmin 4 installed and open |
| Lab10_Phase2_pgAdminConnected.png | Successfully connected to Azure PostgreSQL |
| Lab10_Phase3_DatabaseCreated.png | lab10db database created |
| Lab10_Phase3_TablesCreated.png | customers and orders tables created |
| Lab10_Phase3_CRUDOperations.png | INSERT and SELECT operations |
| Lab10_Phase3_UpdateDelete.png | UPDATE and DELETE operations confirmed |
| Lab10_Phase4_Metrics_CPU.png | CPU monitoring chart in Azure Portal |
| Lab10_Phase4_Authentication.png | Authentication settings page |
| Lab10_Phase4_BackupRestore.png | Automated backup confirmed |
