## E-commerce Database Project

This project implements a complete **relational database** for an **e-commerce system**, covering customers, addresses, products, categories, warehouses, inventory, orders, order items, payments, carriers, and shipments.

---

## Project Structure

| File | Description |
|------|-------------|
| **01_schema.sql** | Creates the `ecommerce_db` schema, tables, foreign keys. |
| **02_seed_data.sql** | Inserts realistic sample data (~1,200 records) with coherent relationships. |
| **03_validation_checks.sql** | Runs validation tests to check data integrity and consistency. |

---

## Main Entities

- **customers** – customer information  
- **addresses** – billing and shipping addresses  
- **categories** – product categories  
- **products** – product list with SKU, price, and category  
- **warehouses** – stock locations  
- **inventory** – quantity and safety stock control  
- **orders** – customer orders  
- **order_items** – products within each order  
- **payments** – payment records  
- **carriers** – shipping carriers  
- **shipments** – shipment tracking data  

---

## How to Run

1. Create the database:
   SOURCE C:/TEMP/01_schema.sql;

2. Insert the seed data:
SOURCE C:/TEMP/02_seed_data.sql;

3. Validate data integrity:
SOURCE C:/TEMP/03_validation_checks.sql;

---

## Data Integrity Validation
The 03_validation_checks.sql script automatically checks:
* Row counts for each table
* Orphaned foreign keys
* Null values in mandatory fields
* Duplicate emails and SKUs
* Orders without items or payments
* Consistency between order, payment, and shipment statuses
* Negative stock quantities
* Out-of-range order dates
* Email format validation
* Summary by status and payment method

If all checks return 0 violations, your database is fully consistent.

---

## Technical Notes
* Compatible with MySQL 8+
* Seed data generated using realistic distributions of prices, categories, and dates
* Suitable for ETL/EDA projects, Power BI dashboards, or sales analysis

---

## Author
**Paulo Henrique P. Cunha**
Data Analyst | Web Developer
LinkedIn: www.linkedin.com/in/paulo-henrique-p-cunha/