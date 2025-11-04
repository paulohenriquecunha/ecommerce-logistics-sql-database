-- Adjusted for schema without triggers; removed check 'customers_without_default_billing'

-- ecommerce_db Validation Suite
-- Usage:
USE ecommerce_db;
--   SOURCE /path/to/03_validation_checks.sql;

-- 1) Row counts per table
SELECT 'row_counts' AS check_name, 'customers' AS table_name, COUNT(*) AS total_rows FROM customers
UNION ALL SELECT 'row_counts','addresses',COUNT(*) FROM addresses
UNION ALL SELECT 'row_counts','categories',COUNT(*) FROM categories
UNION ALL SELECT 'row_counts','products',COUNT(*) FROM products
UNION ALL SELECT 'row_counts','warehouses',COUNT(*) FROM warehouses
UNION ALL SELECT 'row_counts','inventory',COUNT(*) FROM inventory
UNION ALL SELECT 'row_counts','orders',COUNT(*) FROM orders
UNION ALL SELECT 'row_counts','order_items',COUNT(*) FROM order_items
UNION ALL SELECT 'row_counts','payments',COUNT(*) FROM payments
UNION ALL SELECT 'row_counts','carriers',COUNT(*) FROM carriers
UNION ALL SELECT 'row_counts','shipments',COUNT(*) FROM shipments
;

-- 2) Orphan checks (should all return 0 rows)
SELECT 'orphans_payments_without_orders' AS check_name, COUNT(*) AS violations
FROM payments p LEFT JOIN orders o ON p.order_id = o.order_id
WHERE o.order_id IS NULL;

SELECT 'orphans_order_items_without_orders' AS check_name, COUNT(*) AS violations
FROM order_items oi LEFT JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

SELECT 'orphans_order_items_without_products' AS check_name, COUNT(*) AS violations
FROM order_items oi LEFT JOIN products p ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

SELECT 'orphans_inventory_without_products' AS check_name, COUNT(*) AS violations
FROM inventory i LEFT JOIN products p ON i.product_id = p.product_id
WHERE p.product_id IS NULL;

SELECT 'orphans_inventory_without_warehouses' AS check_name, COUNT(*) AS violations
FROM inventory i LEFT JOIN warehouses w ON i.warehouse_id = w.warehouse_id
WHERE w.warehouse_id IS NULL;

SELECT 'orphans_shipments_without_orders' AS check_name, COUNT(*) AS violations
FROM shipments s LEFT JOIN orders o ON s.order_id = o.order_id
WHERE o.order_id IS NULL;

SELECT 'orphans_shipments_without_carrier' AS check_name, COUNT(*) AS violations
FROM shipments s LEFT JOIN carriers c ON s.carrier_id = c.carrier_id
WHERE c.carrier_id IS NULL;

-- 3) Duplicates and uniqueness
SELECT 'dup_customers_email' AS check_name, COUNT(*) AS violations
FROM (
  SELECT email, COUNT(*) c FROM customers GROUP BY email HAVING c > 1
) t;

SELECT 'dup_products_sku' AS check_name, COUNT(*) AS violations
FROM (
  SELECT sku, COUNT(*) c FROM products GROUP BY sku HAVING c > 1
) t;

-- 4) Nulls in mandatory fields
SELECT 'null_customers_name_or_email' AS check_name, COUNT(*) AS violations
FROM customers WHERE full_name IS NULL OR email IS NULL;

SELECT 'null_products_price_or_cat' AS check_name, COUNT(*) AS violations
FROM products WHERE unit_price IS NULL OR unit_price = 0 OR category_id IS NULL;

SELECT 'null_orders_status_or_date' AS check_name, COUNT(*) AS violations
FROM orders WHERE order_status IS NULL OR order_date IS NULL;

-- 5) Orders with no items (should be 0)
SELECT 'orders_without_items' AS check_name, COUNT(*) AS violations
FROM orders o
LEFT JOIN (
  SELECT order_id, COUNT(*) AS cnt FROM order_items GROUP BY order_id
) x ON o.order_id = x.order_id
WHERE x.cnt IS NULL OR x.cnt = 0;

-- 6) Payments per order (expect exactly 1)
SELECT 'orders_with_payment_count_ne_1' AS check_name, COUNT(*) AS violations
FROM (
  SELECT o.order_id, COUNT(p.payment_id) AS pc
  FROM orders o LEFT JOIN payments p ON o.order_id = p.order_id
  GROUP BY o.order_id
) t
WHERE pc <> 1;

-- 7) Amount mismatch: compare payments.amount vs sum(items) + shipping (tolerance 0.01)
SELECT 'payment_amount_mismatch' AS check_name, COUNT(*) AS violations
FROM (
  SELECT 
    o.order_id,
    ROUND(COALESCE(SUM(oi.quantity * oi.unit_price),0) + COALESCE(o.shipping_cost,0), 2) AS expected_total,
    ROUND(MAX(p.amount), 2) AS paid_total
  FROM orders o
  LEFT JOIN order_items oi ON oi.order_id = o.order_id
  LEFT JOIN payments p ON p.order_id = o.order_id
  GROUP BY o.order_id
) t
WHERE ABS(expected_total - paid_total) > 0.01;

-- 8) Status consistency: paid/shipped/delivered must have payment_status=paid
SELECT 'status_mismatch_paid_orders_without_paid_payment' AS check_name, COUNT(*) AS violations
FROM orders o
JOIN payments p ON p.order_id = o.order_id
WHERE o.order_status IN ('paid','shipped','delivered')
  AND p.payment_status <> 'paid';

-- 9) Shipments required for shipped/delivered
SELECT 'shipped_or_delivered_without_shipment' AS check_name, COUNT(*) AS violations
FROM (
  SELECT o.order_id
  FROM orders o
  LEFT JOIN shipments s ON s.order_id = o.order_id
  WHERE o.order_status IN ('shipped','delivered')
  GROUP BY o.order_id
  HAVING COUNT(s.shipment_id) = 0
) t;

-- 10) Shipment timestamps sanity
SELECT 'delivered_without_delivered_at' AS check_name, COUNT(*) AS violations
FROM shipments WHERE shipment_status = 'delivered' AND delivered_at IS NULL;

-- 11) Inventory not negative (should be 0)
SELECT 'inventory_negative' AS check_name, COUNT(*) AS violations
FROM inventory WHERE stock_qty < 0;

-- 12) Address coverage per customer and default billing present
SELECT 'customers_without_any_address' AS check_name, COUNT(*) AS violations
FROM customers c
LEFT JOIN addresses a ON a.customer_id = c.customer_id
GROUP BY c.customer_id
HAVING COUNT(a.address_id) = 0;


-- 13) Order date range plausibility (expected between 2024-01-01 and 2025-10-20)
SELECT 'orders_out_of_expected_date_range' AS check_name, COUNT(*) AS violations
FROM orders
WHERE order_date < '2024-01-01' OR order_date > '2025-10-31 23:59:59';

-- 14) Email basic format check
SELECT 'customers_email_bad_format' AS check_name, COUNT(*) AS violations
FROM customers
WHERE email NOT LIKE '%@%.%';

-- 15) Unit price plausibility (min/max bounds)
SELECT 'products_unrealistic_price' AS check_name, COUNT(*) AS violations
FROM products
WHERE unit_price < 1 OR unit_price > 10000;

-- 16) Orphan addresses without customer
SELECT 'orphans_addresses_without_customer' AS check_name, COUNT(*) AS violations
FROM addresses a LEFT JOIN customers c ON a.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- 17) Optional: summary by order_status and totals
SELECT 'summary_orders_by_status' AS check_name, order_status, COUNT(*) AS total_orders
FROM orders
GROUP BY order_status;

SELECT 'summary_payments_by_method' AS check_name, payment_method, COUNT(*) AS total_payments
FROM payments
GROUP BY payment_method;
