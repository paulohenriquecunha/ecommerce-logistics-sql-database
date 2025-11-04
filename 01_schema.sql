-- 0) Clean start (optional for demos)
DROP DATABASE IF EXISTS ecommerce_db;

-- 1) Create database and select it
CREATE DATABASE IF NOT EXISTS ecommerce_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;
USE ecommerce_db;

-- 2) Core tables

-- 2.1) Customers
CREATE TABLE customers (
  customer_id INT AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(100) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  phone VARCHAR(20),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_customers_email (email)
);

-- 2.2) Addresses (billing/shipping)
CREATE TABLE addresses (
  address_id INT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT NOT NULL,
  address_type ENUM('billing','shipping') NOT NULL,
  line1 VARCHAR(120) NOT NULL,
  line2 VARCHAR(120),
  city VARCHAR(80) NOT NULL,
  state_region VARCHAR(80),
  postal_code VARCHAR(20),
  country VARCHAR(80) NOT NULL,
  is_default TINYINT(1) NOT NULL DEFAULT 0,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_addresses_customer (customer_id),
  INDEX idx_addresses_type (address_type)
);

-- 2.3) Categories
CREATE TABLE categories (
  category_id INT AUTO_INCREMENT PRIMARY KEY,
  category_name VARCHAR(80) NOT NULL UNIQUE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 2.4) Products
CREATE TABLE products (
  product_id INT AUTO_INCREMENT PRIMARY KEY,
  sku VARCHAR(50) NOT NULL UNIQUE,
  product_name VARCHAR(120) NOT NULL,
  category_id INT NOT NULL,
  unit_price DECIMAL(10,2) NOT NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_products_category (category_id),
  INDEX idx_products_sku (sku)
);

-- 2.5) Warehouses
CREATE TABLE warehouses (
  warehouse_id INT AUTO_INCREMENT PRIMARY KEY,
  warehouse_name VARCHAR(80) NOT NULL,
  country VARCHAR(80) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 2.6) Inventory (by warehouse)
CREATE TABLE inventory (
  inventory_id INT AUTO_INCREMENT PRIMARY KEY,
  product_id INT NOT NULL,
  warehouse_id INT NOT NULL,
  stock_qty INT NOT NULL DEFAULT 0,
  safety_stock INT NOT NULL DEFAULT 0,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uk_inventory_product_wh (product_id, warehouse_id),
  INDEX idx_inventory_product (product_id),
  INDEX idx_inventory_wh (warehouse_id)
);

-- 2.7) Orders
CREATE TABLE orders (
  order_id INT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT NOT NULL,
  order_status ENUM('pending','paid','shipped','delivered','cancelled','refunded') NOT NULL DEFAULT 'pending',
  order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  billing_address_id INT,
  shipping_address_id INT,
  shipping_method ENUM('standard','express') NOT NULL DEFAULT 'standard',
  shipping_cost DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  coupon_code VARCHAR(30),
  notes VARCHAR(255),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_orders_customer (customer_id),
  INDEX idx_orders_status_date (order_status, order_date)
);

-- 2.8) Order items (includes warehouse_id to control stock decrement)
CREATE TABLE order_items (
  order_item_id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT NOT NULL,
  product_id INT NOT NULL,
  warehouse_id INT NOT NULL DEFAULT 1,
  quantity INT NOT NULL,
  unit_price DECIMAL(10,2) NOT NULL,
  line_total DECIMAL(10,2) AS (quantity * unit_price) STORED,
  INDEX idx_order_items_order (order_id),
  INDEX idx_order_items_product (product_id),
  INDEX idx_order_items_wh (warehouse_id)
);

-- 2.9) Payments
CREATE TABLE payments (
  payment_id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT NOT NULL,
  payment_method ENUM('credit_card','debit_card','pix','bank_transfer','paypal','cash_on_delivery') NOT NULL,
  payment_status ENUM('pending','authorized','paid','failed','refunded') NOT NULL DEFAULT 'pending',
  amount DECIMAL(10,2) NOT NULL,
  transaction_ref VARCHAR(80),
  paid_at DATETIME,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_payments_order (order_id),
  INDEX idx_payments_status (payment_status)
);

-- 2.10) Carriers
CREATE TABLE carriers (
  carrier_id INT AUTO_INCREMENT PRIMARY KEY,
  carrier_name VARCHAR(80) NOT NULL UNIQUE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 2.11) Shipments
CREATE TABLE shipments (
  shipment_id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT NOT NULL,
  carrier_id INT NOT NULL,
  tracking_number VARCHAR(60),
  shipment_status ENUM('ready','in_transit','delivered','issue') NOT NULL DEFAULT 'ready',
  shipped_at DATETIME,
  delivered_at DATETIME,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_shipments_order (order_id),
  INDEX idx_shipments_status (shipment_status)
);

-- 3) Foreign keys via ALTER TABLE with explicit names

ALTER TABLE addresses
  ADD CONSTRAINT fk_addresses_customer
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id);

ALTER TABLE products
  ADD CONSTRAINT fk_products_category
  FOREIGN KEY (category_id) REFERENCES categories(category_id);

ALTER TABLE inventory
  ADD CONSTRAINT fk_inventory_product
  FOREIGN KEY (product_id) REFERENCES products(product_id),
  ADD CONSTRAINT fk_inventory_warehouse
  FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id);

ALTER TABLE orders
  ADD CONSTRAINT fk_orders_customer
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  ADD CONSTRAINT fk_orders_billing_address
  FOREIGN KEY (billing_address_id) REFERENCES addresses(address_id),
  ADD CONSTRAINT fk_orders_shipping_address
  FOREIGN KEY (shipping_address_id) REFERENCES addresses(address_id);

ALTER TABLE order_items
  ADD CONSTRAINT fk_order_items_order
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  ADD CONSTRAINT fk_order_items_product
  FOREIGN KEY (product_id) REFERENCES products(product_id),
  ADD CONSTRAINT fk_order_items_warehouse
  FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id);

ALTER TABLE payments
  ADD CONSTRAINT fk_payments_order
  FOREIGN KEY (order_id) REFERENCES orders(order_id);

ALTER TABLE shipments
  ADD CONSTRAINT fk_shipments_order
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  ADD CONSTRAINT fk_shipments_carrier
  FOREIGN KEY (carrier_id) REFERENCES carriers(carrier_id);
