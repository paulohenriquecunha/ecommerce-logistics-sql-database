USE ecommerce_db;
SET autocommit = 1;
SET sql_safe_updates = 0;

-- Semente estável/reprodutível
SET @seed := 20251103; -- semente determinística para reprodutibilidade
SELECT RAND(@seed);

-- LIMPEZA (ordem de FKs)
DELETE FROM shipments;
DELETE FROM payments;
DELETE FROM order_items;
DELETE FROM orders;
DELETE FROM inventory;
DELETE FROM carriers;
DELETE FROM warehouses;
DELETE FROM products;
DELETE FROM categories;
DELETE FROM addresses;
DELETE FROM customers;

-- Reset auto-increment counters
ALTER TABLE customers AUTO_INCREMENT = 1;
ALTER TABLE addresses AUTO_INCREMENT = 1;
ALTER TABLE categories AUTO_INCREMENT = 1;
ALTER TABLE products AUTO_INCREMENT = 1;
ALTER TABLE warehouses AUTO_INCREMENT = 1;
ALTER TABLE inventory AUTO_INCREMENT = 1;
ALTER TABLE carriers AUTO_INCREMENT = 1;
ALTER TABLE orders AUTO_INCREMENT = 1;
ALTER TABLE order_items AUTO_INCREMENT = 1;
ALTER TABLE payments AUTO_INCREMENT = 1;
ALTER TABLE shipments AUTO_INCREMENT = 1;

-- =========================================================
-- NOTA DE REALISMO:
-- * Custos de envio variam por região e método.
-- * Carriers selecionados por região (UPS/FedEx nos EUA/CA; DHL/DPD na UE).
-- * ~78% dos pedidos pagos/authorized recebem shipment; status em 73/17/7/3.
-- * Tempos de envio/entrega variam por região.
-- * ~3% dos pedidos pendentes são cancelados sem envio.

-- DADOS BASE
-- =========================================================

-- CATEGORIES (9)
INSERT INTO categories (category_name) VALUES
('Smartphones'),('Laptops'),('Tablets'),('Audio & Headphones'),
('Cameras'),('Gaming & Consoles'),('Networking'),('Smart Home'),('Accessories');

SET @cat_smartphones = (SELECT category_id FROM categories WHERE category_name = 'Smartphones');
SET @cat_laptops = (SELECT category_id FROM categories WHERE category_name = 'Laptops');
SET @cat_tablets = (SELECT category_id FROM categories WHERE category_name = 'Tablets');
SET @cat_audio = (SELECT category_id FROM categories WHERE category_name = 'Audio & Headphones');
SET @cat_cameras = (SELECT category_id FROM categories WHERE category_name = 'Cameras');
SET @cat_gaming = (SELECT category_id FROM categories WHERE category_name = 'Gaming & Consoles');
SET @cat_networking = (SELECT category_id FROM categories WHERE category_name = 'Networking');
SET @cat_smarthome = (SELECT category_id FROM categories WHERE category_name = 'Smart Home');
SET @cat_accessories = (SELECT category_id FROM categories WHERE category_name = 'Accessories');

-- WAREHOUSES (5)
INSERT INTO warehouses (warehouse_name, country) VALUES
('US-East DC – Newark', 'United States'),
('US-West DC – Los Angeles', 'United States'),
('US-Central DC – Dallas', 'United States'),
('EU-North DC – Amsterdam', 'Netherlands'),
('EU-Central DC – Berlin', 'Germany');

SET @wh_east = (SELECT warehouse_id FROM warehouses WHERE warehouse_name = 'US-East DC – Newark');
SET @wh_west = (SELECT warehouse_id FROM warehouses WHERE warehouse_name = 'US-West DC – Los Angeles');
SET @wh_central = (SELECT warehouse_id FROM warehouses WHERE warehouse_name = 'US-Central DC – Dallas');
SET @wh_eu_north = (SELECT warehouse_id FROM warehouses WHERE warehouse_name = 'EU-North DC – Amsterdam');
SET @wh_eu_central = (SELECT warehouse_id FROM warehouses WHERE warehouse_name = 'EU-Central DC – Berlin');

-- CARRIERS
INSERT INTO carriers (carrier_name) VALUES ('UPS'),('FedEx'),('DHL'),('DPD');

SET @carrier_ups = (SELECT carrier_id FROM carriers WHERE carrier_name = 'UPS');
SET @carrier_fedex = (SELECT carrier_id FROM carriers WHERE carrier_name = 'FedEx');
SET @carrier_dhl = (SELECT carrier_id FROM carriers WHERE carrier_name = 'DHL');
SET @carrier_dpd = (SELECT carrier_id FROM carriers WHERE carrier_name = 'DPD');

-- =========================================================
-- CUSTOMERS (137)
-- =========================================================

INSERT INTO customers (full_name, email, phone, created_at, updated_at) VALUES
('James Smith', 'james.smith001@example.com', '+11234567890', '2023-12-15 10:00:00', '2023-12-15 10:00:00'),
('Mary Johnson', 'mary.johnson002@mail.com', '+11234567891', '2023-12-16 10:00:00', '2023-12-16 10:00:00'),
('Robert Williams', 'robert.williams003@inbox.com', '+11234567892', '2023-12-17 10:00:00', '2023-12-17 10:00:00'),
('Patricia Brown', 'patricia.brown004@post.com', '+11234567893', '2023-12-18 10:00:00', '2023-12-18 10:00:00'),
('John Jones', 'john.jones005@shopmail.com', '+11234567894', '2023-12-19 10:00:00', '2023-12-19 10:00:00'),
('Jennifer Garcia', 'jennifer.garcia006@example.com', '+11234567895', '2023-12-20 10:00:00', '2023-12-20 10:00:00'),
('Michael Miller', 'michael.miller007@mail.com', '+11234567896', '2023-12-21 10:00:00', '2023-12-21 10:00:00'),
('Linda Davis', 'linda.davis008@inbox.com', '+11234567897', '2023-12-22 10:00:00', '2023-12-22 10:00:00'),
('William Rodriguez', 'william.rodriguez009@post.com', '+11234567898', '2023-12-23 10:00:00', '2023-12-23 10:00:00'),
('Elizabeth Martinez', 'elizabeth.martinez010@shopmail.com', '+11234567899', '2023-12-24 10:00:00', '2023-12-24 10:00:00'),
('David Hernandez', 'david.hernandez011@example.com', '+11234567900', '2023-12-25 10:00:00', '2023-12-25 10:00:00'),
('Barbara Lopez', 'barbara.lopez012@mail.com', '+11234567901', '2023-12-26 10:00:00', '2023-12-26 10:00:00'),
('Richard Gonzalez', 'richard.gonzalez013@inbox.com', '+11234567902', '2023-12-27 10:00:00', '2023-12-27 10:00:00'),
('Susan Wilson', 'susan.wilson014@post.com', '+11234567903', '2023-12-28 10:00:00', '2023-12-28 10:00:00'),
('Joseph Anderson', 'joseph.anderson015@shopmail.com', '+11234567904', '2023-12-29 10:00:00', '2023-12-29 10:00:00'),
('Jessica Thomas', 'jessica.thomas016@example.com', '+11234567905', '2023-12-30 10:00:00', '2023-12-30 10:00:00'),
('Thomas Taylor', 'thomas.taylor017@mail.com', '+11234567906', '2023-12-31 10:00:00', '2023-12-31 10:00:00'),
('Sarah Moore', 'sarah.moore018@inbox.com', '+11234567907', '2024-01-01 10:00:00', '2024-01-01 10:00:00'),
('Charles Jackson', 'charles.jackson019@post.com', '+11234567908', '2024-01-02 10:00:00', '2024-01-02 10:00:00'),
('Karen Martin', 'karen.martin020@shopmail.com', '+11234567909', '2024-01-03 10:00:00', '2024-01-03 10:00:00');

-- Adicionar mais 117 customers
INSERT INTO customers (full_name, email, phone, created_at, updated_at)
SELECT 
    CONCAT(fn, ' ', ln) as full_name,
    CONCAT(LOWER(fn), '.', LOWER(ln), LPAD(id+20, 3, '0'), '@', domain) as email,
    CONCAT('+1', LPAD(100000000 + (id * 12345) % 900000000, 9, '0')) as phone,
    DATE_ADD('2023-12-15 10:00:00', INTERVAL (id % 20) DAY) as created_at,
    DATE_ADD('2023-12-15 10:00:00', INTERVAL (id % 20) DAY) as updated_at
FROM (
    SELECT 
        seq as id,
        ELT(1 + (seq % 40), 'James','Mary','Robert','Patricia','John','Jennifer','Michael','Linda',
            'William','Elizabeth','David','Barbara','Richard','Susan','Joseph','Jessica',
            'Thomas','Sarah','Charles','Karen','Christopher','Nancy','Daniel','Lisa',
            'Matthew','Sandra','Anthony','Ashley','Mark','Kimberly','Andrew','Donna',
            'Joshua','Emily','Ethan','Sophia','Liam','Olivia','Noah','Ava') as fn,
        ELT(1 + (seq % 38), 'Smith','Johnson','Williams','Brown','Jones','Garcia','Miller','Davis',
            'Rodriguez','Martinez','Hernandez','Lopez','Gonzalez','Wilson','Anderson',
            'Thomas','Taylor','Moore','Jackson','Martin','Lee','Perez','Thompson',
            'White','Harris','Sanchez','Clark','Ramirez','Lewis','Robinson','Walker',
            'Young','Allen','King','Wright','Scott','Torres','Nguyen','Hill') as ln,
        ELT(1 + (seq % 5), 'example.com','mail.com','inbox.com','post.com','shopmail.com') as domain
    FROM (
        SELECT a.N + b.N * 10 + c.N * 100 as seq
        FROM (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a
        CROSS JOIN (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b
        CROSS JOIN (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) c
    ) numbers
    WHERE seq BETWEEN 1 AND 117
) customer_data;

-- =========================================================
-- ADDRESSES (1 por cliente)
-- =========================================================

INSERT INTO addresses (customer_id, address_type, line1, line2, city, state_region, postal_code, country, is_default)
SELECT 
    c.customer_id,
    'shipping' as address_type,
    CONCAT(FLOOR(100 + (c.customer_id * 7) % 900), ' ', 
           ELT(1 + (c.customer_id % 15), 'Main St','Oak Ave','Maple St','Pine Rd','Cedar Blvd','Elm St','Sunset Ave',
               'Park Lane','Riverside Dr','Highland Rd','Broadway','Market St','Union St','Lakeview Dr','Spring St')) as line1,
    CONCAT('Apt ', 1 + (c.customer_id % 50)) as line2,
    ELT(1 + (c.customer_id % 20), 'Los Angeles','New York','Dallas','Miami','Chicago','Seattle','Atlanta','Newark','Boston',
        'Toronto','Vancouver','Montreal','Calgary','London','Berlin','Paris','Madrid','Rome','Lisboa','Amsterdam') as city,
    ELT(1 + (c.customer_id % 20), 'CA','NY','TX','FL','IL','WA','GA','NJ','MA','ON','BC','QC','AB','England','BE','IDF','MD','LAZ','Lisboa','NH') as state_region,
    ELT(1 + (c.customer_id % 20), '90001','10001','75201','33101','60601','98101','30301','07101','02108','M5H 2N2','V5K 0A1','H1A 0A1','T1X 0L3',
        'SW1A 1AA','10115','75001','28001','00118','1100-001','1011') as postal_code,
    CASE 
        WHEN (c.customer_id % 20) <= 12 THEN 
            CASE WHEN (c.customer_id % 20) <= 8 THEN 'United States' ELSE 'Canada' END
        ELSE ELT(1 + (c.customer_id % 20) - 13, 'United Kingdom','Germany','France','Spain','Italy','Portugal','Netherlands')
    END as country,
    1 as is_default
FROM customers c;

-- =========================================================
-- PRODUCTS (84)
-- =========================================================

INSERT INTO products (sku, product_name, category_id, unit_price, is_active) VALUES
-- Smartphones
('EL-0001', 'NovaTech Phone 101', @cat_smartphones, 799.99, 1),
('EL-0002', 'BlueWave Phone 102', @cat_smartphones, 649.99, 1),
('EL-0003', 'Apextron Phone 103', @cat_smartphones, 899.99, 1),
('EL-0004', 'UrbanX Phone 104', @cat_smartphones, 549.99, 1),
('EL-0005', 'Lumina Phone 105', @cat_smartphones, 699.99, 1),
('EL-0006', 'Voltix Phone 106', @cat_smartphones, 459.99, 1),
('EL-0007', 'Zenith Phone 107', @cat_smartphones, 999.99, 1),
('EL-0008', 'Polarix Phone 108', @cat_smartphones, 749.99, 1),
('EL-0009', 'NovaTech Phone 109', @cat_smartphones, 829.99, 1),

-- Laptops
('EL-0010', 'NovaTech Laptop 110', @cat_laptops, 1299.99, 1),
('EL-0011', 'BlueWave Laptop 111', @cat_laptops, 1099.99, 1),
('EL-0012', 'Apextron Laptop 112', @cat_laptops, 1599.99, 1),
('EL-0013', 'UrbanX Laptop 113', @cat_laptops, 899.99, 1),
('EL-0014', 'Lumina Laptop 114', @cat_laptops, 1199.99, 1),
('EL-0015', 'Voltix Laptop 115', @cat_laptops, 799.99, 1),
('EL-0016', 'Zenith Laptop 116', @cat_laptops, 1799.99, 1),
('EL-0017', 'Polarix Laptop 117', @cat_laptops, 1399.99, 1),
('EL-0018', 'NovaTech Laptop 118', @cat_laptops, 1499.99, 1),

-- Tablets
('EL-0019', 'NovaTech Tab 119', @cat_tablets, 499.99, 1),
('EL-0020', 'BlueWave Tab 120', @cat_tablets, 399.99, 1),
('EL-0021', 'Apextron Tab 121', @cat_tablets, 599.99, 1),
('EL-0022', 'UrbanX Tab 122', @cat_tablets, 349.99, 1),
('EL-0023', 'Lumina Tab 123', @cat_tablets, 449.99, 1),
('EL-0024', 'Voltix Tab 124', @cat_tablets, 299.99, 1),
('EL-0025', 'Zenith Tab 125', @cat_tablets, 699.99, 1),
('EL-0026', 'Polarix Tab 126', @cat_tablets, 529.99, 1),

-- Audio & Headphones
('EL-0027', 'NovaTech Audio 127', @cat_audio, 199.99, 1),
('EL-0028', 'BlueWave Audio 128', @cat_audio, 149.99, 1),
('EL-0029', 'Apextron Audio 129', @cat_audio, 249.99, 1),
('EL-0030', 'UrbanX Audio 130', @cat_audio, 99.99, 1),
('EL-0031', 'Lumina Audio 131', @cat_audio, 179.99, 1),
('EL-0032', 'Voltix Audio 132', @cat_audio, 79.99, 1),
('EL-0033', 'Zenith Audio 133', @cat_audio, 299.99, 1),
('EL-0034', 'Polarix Audio 134', @cat_audio, 219.99, 1),

-- Cameras
('EL-0035', 'NovaTech Cam 135', @cat_cameras, 899.99, 1),
('EL-0036', 'BlueWave Cam 136', @cat_cameras, 699.99, 1),
('EL-0037', 'Apextron Cam 137', @cat_cameras, 1199.99, 1),
('EL-0038', 'UrbanX Cam 138', @cat_cameras, 599.99, 1),
('EL-0039', 'Lumina Cam 139', @cat_cameras, 799.99, 1),
('EL-0040', 'Voltix Cam 140', @cat_cameras, 499.99, 1),
('EL-0041', 'Zenith Cam 141', @cat_cameras, 1499.99, 1),
('EL-0042', 'Polarix Cam 142', @cat_cameras, 999.99, 1),

-- Gaming & Consoles
('EL-0043', 'NovaTech Game 143', @cat_gaming, 499.99, 1),
('EL-0044', 'BlueWave Game 144', @cat_gaming, 399.99, 1),
('EL-0045', 'Apextron Game 145', @cat_gaming, 599.99, 1),
('EL-0046', 'UrbanX Game 146', @cat_gaming, 349.99, 1),
('EL-0047', 'Lumina Game 147', @cat_gaming, 449.99, 1),
('EL-0048', 'Voltix Game 148', @cat_gaming, 299.99, 1),
('EL-0049', 'Zenith Game 149', @cat_gaming, 699.99, 1),
('EL-0050', 'Polarix Game 150', @cat_gaming, 529.99, 1),

-- Networking
('EL-0051', 'NovaTech Net 151', @cat_networking, 199.99, 1),
('EL-0052', 'BlueWave Net 152', @cat_networking, 149.99, 1),
('EL-0053', 'Apextron Net 153', @cat_networking, 249.99, 1),
('EL-0054', 'UrbanX Net 154', @cat_networking, 99.99, 1),
('EL-0055', 'Lumina Net 155', @cat_networking, 179.99, 1),
('EL-0056', 'Voltix Net 156', @cat_networking, 79.99, 1),
('EL-0057', 'Zenith Net 157', @cat_networking, 299.99, 1),
('EL-0058', 'Polarix Net 158', @cat_networking, 219.99, 1),

-- Smart Home
('EL-0059', 'NovaTech Smart 159', @cat_smarthome, 299.99, 1),
('EL-0060', 'BlueWave Smart 160', @cat_smarthome, 199.99, 1),
('EL-0061', 'Apextron Smart 161', @cat_smarthome, 399.99, 1),
('EL-0062', 'UrbanX Smart 162', @cat_smarthome, 149.99, 1),
('EL-0063', 'Lumina Smart 163', @cat_smarthome, 249.99, 1),
('EL-0064', 'Voltix Smart 164', @cat_smarthome, 99.99, 1),
('EL-0065', 'Zenith Smart 165', @cat_smarthome, 499.99, 1),
('EL-0066', 'Polarix Smart 166', @cat_smarthome, 349.99, 1),

-- Accessories
('EL-0067', 'NovaTech Acc 167', @cat_accessories, 49.99, 1),
('EL-0068', 'BlueWave Acc 168', @cat_accessories, 39.99, 1),
('EL-0069', 'Apextron Acc 169', @cat_accessories, 69.99, 1),
('EL-0070', 'UrbanX Acc 170', @cat_accessories, 29.99, 1),
('EL-0071', 'Lumina Acc 171', @cat_accessories, 59.99, 1),
('EL-0072', 'Voltix Acc 172', @cat_accessories, 19.99, 1),
('EL-0073', 'Zenith Acc 173', @cat_accessories, 89.99, 1),
('EL-0074', 'Polarix Acc 174', @cat_accessories, 79.99, 1),
('EL-0075', 'NovaTech Acc 175', @cat_accessories, 44.99, 1),
('EL-0076', 'BlueWave Acc 176', @cat_accessories, 34.99, 1),
('EL-0077', 'Apextron Acc 177', @cat_accessories, 64.99, 1),
('EL-0078', 'UrbanX Acc 178', @cat_accessories, 24.99, 1),
('EL-0079', 'Lumina Acc 179', @cat_accessories, 54.99, 1),
('EL-0080', 'Voltix Acc 180', @cat_accessories, 14.99, 1),
('EL-0081', 'Zenith Acc 181', @cat_accessories, 84.99, 1),
('EL-0082', 'Polarix Acc 182', @cat_accessories, 74.99, 1),
('EL-0083', 'NovaTech Acc 183', @cat_accessories, 47.99, 1),
('EL-0084', 'BlueWave Acc 184', @cat_accessories, 37.99, 1);

-- =========================================================
-- INVENTORY (produto×warehouse)
-- =========================================================

INSERT INTO inventory (product_id, warehouse_id, stock_qty, safety_stock)
SELECT p.product_id, w.warehouse_id,
       FLOOR(50 + (p.product_id * w.warehouse_id) % 451) as stock_qty,
       FLOOR(5 + (p.product_id * w.warehouse_id) % 21) as safety_stock
FROM products p
CROSS JOIN warehouses w;

-- =========================================================
-- ORDERS (411 pedidos) - PERÍODO CORRIGIDO: 2024-01-01 até 2025-10-31
-- =========================================================

INSERT INTO orders (customer_id, order_status, order_date, billing_address_id, shipping_address_id, shipping_method, shipping_cost, created_at, updated_at)
SELECT 
    c.customer_id,
    'pending' as order_status,
    DATE_ADD('2024-01-01 08:00:00', 
             INTERVAL (seq * TIMESTAMPDIFF(SECOND, '2024-01-01 08:00:00', '2025-10-31 20:00:00') / 411) SECOND) as order_date,
    a.address_id as billing_address_id,
    a.address_id as shipping_address_id,
    CASE WHEN seq % 4 = 0 THEN 'express' ELSE 'standard' END as shipping_method,
    CASE WHEN seq % 4 = 0 THEN 14.90 ELSE 6.90 END as shipping_cost,
    DATE_ADD('2024-01-01 08:00:00', 
             INTERVAL (seq * TIMESTAMPDIFF(SECOND, '2024-01-01 08:00:00', '2025-10-31 20:00:00') / 411) SECOND) as created_at,
    DATE_ADD('2024-01-01 08:00:00', 
             INTERVAL (seq * TIMESTAMPDIFF(SECOND, '2024-01-01 08:00:00', '2025-10-31 20:00:00') / 411) SECOND) as updated_at
FROM customers c
JOIN addresses a ON c.customer_id = a.customer_id
JOIN (
    SELECT ones.n + tens.n * 10 + hundreds.n * 100 as seq
    FROM 
        (SELECT 0 AS n UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) ones,
        (SELECT 0 AS n UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) tens,
        (SELECT 0 AS n UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) hundreds
    WHERE ones.n + tens.n * 10 + hundreds.n * 100 BETWEEN 1 AND 411
) numbers ON c.customer_id = 1 + (seq % (SELECT COUNT(*) FROM customers));

-- =========================================================
-- ORDER ITEMS (1-9 itens por pedido)
-- =========================================================

INSERT INTO order_items (order_id, product_id, warehouse_id, quantity, unit_price)
SELECT 
    o.order_id,
    p.product_id,
    CASE 
        WHEN a.country IN ('United States','Canada') THEN
            CASE o.order_id % 3
                WHEN 0 THEN @wh_east
                WHEN 1 THEN @wh_west
                ELSE @wh_central
            END
        ELSE
            CASE o.order_id % 2
                WHEN 0 THEN @wh_eu_north
                ELSE @wh_eu_central
            END
    END as warehouse_id,
    CASE 
        WHEN (o.order_id + p.product_id) % 10 < 2 THEN 3
        WHEN (o.order_id + p.product_id) % 10 < 7 THEN 2
        ELSE 1
    END as quantity,
    p.unit_price
FROM orders o
JOIN addresses a ON o.shipping_address_id = a.address_id
CROSS JOIN (
    SELECT 1 as item_num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 
    UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9
) items
JOIN products p ON p.product_id = 1 + ((o.order_id * 3 + items.item_num) % (SELECT COUNT(*) FROM products))
WHERE items.item_num <= 1 + (o.order_id % 9);

-- =========================================================
-- PAYMENTS
-- =========================================================

INSERT INTO payments (order_id, payment_method, payment_status, amount, transaction_ref, paid_at, created_at)
SELECT 
    o.order_id,
    CASE o.order_id % 4
        WHEN 0 THEN 'credit_card'
        WHEN 1 THEN 'bank_transfer'
        WHEN 2 THEN 'paypal'
        ELSE 'cash_on_delivery'
    END as payment_method,
    CASE 
        WHEN o.order_id % 100 < 87 THEN 'paid'
        WHEN o.order_id % 100 < 93 THEN 'authorized'
        WHEN o.order_id % 100 < 97 THEN 'pending'
        ELSE 'failed'
    END as payment_status,
    (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM order_items WHERE order_id = o.order_id) + o.shipping_cost as amount,
    CONCAT('TX-', LPAD(o.order_id, 6, '0')) as transaction_ref,
    CASE WHEN o.order_id % 100 < 87 THEN DATE_ADD(o.order_date, INTERVAL (1 + o.order_id % 5) DAY) ELSE NULL END as paid_at,
    DATE_ADD(o.order_date, INTERVAL 1 HOUR) as created_at
FROM orders o;

-- Marcar alguns como refunded
UPDATE payments 
SET payment_status = 'refunded'
WHERE payment_status = 'paid' AND order_id % 97 = 0;


-- =========================================================
-- SHIPMENTS (~78% dos pedidos pagos/authorized) – distribuição 73/17/7/3 e lógica por região
-- =========================================================

/*
Regras:
- Seleciona deterministicamente ~78% dos orders pagos/authorized para receber shipment usando randval estável.
- Carrier por região: US/CA → UPS/FedEx; UE → DHL/DPD; senão balanceado.
- shipped_at e delivered_at variam por região (tempos mais curtos intra-região).
*/

INSERT INTO shipments (order_id, carrier_id, tracking_number, shipment_status, shipped_at, delivered_at, created_at)
SELECT 
    p.order_id,
    -- carrier regional
    CASE 
        WHEN a.country IN ('United States','Canada') THEN CASE WHEN (p.order_id % 2) = 0 THEN @carrier_ups ELSE @carrier_fedex END
        WHEN a.country IN ('United Kingdom','Germany','France','Spain','Italy','Portugal','Netherlands') THEN CASE WHEN (p.order_id % 2) = 0 THEN @carrier_dhl ELSE @carrier_dpd END
        ELSE 1 + (p.order_id % 4)
    END AS carrier_id,
    CONCAT('TRK', LPAD(p.order_id, 8, '0')) AS tracking_number,
    -- status conforme thresholds fixos 0.73/0.90/0.97 usando mesma randval
    CASE 
        WHEN (CRC32(CONCAT(@seed, ':ship:', p.order_id)) / 4294967295.0) < 0.73 THEN 'delivered'
        WHEN (CRC32(CONCAT(@seed, ':ship:', p.order_id)) / 4294967295.0) < 0.90 THEN 'in_transit'
        WHEN (CRC32(CONCAT(@seed, ':ship:', p.order_id)) / 4294967295.0) < 0.97 THEN 'ready'
        ELSE 'issue'
    END AS shipment_status,
    -- shipped_at: 1–3 dias (US/CA), 1–2 dias (UE), 3–5 dias (outros)
    DATE_ADD(o.order_date, INTERVAL 
        CASE 
            WHEN a.country IN ('United States','Canada') THEN 1 + (p.order_id % 3)
            WHEN a.country IN ('United Kingdom','Germany','France','Spain','Italy','Portugal','Netherlands') THEN 1 + (p.order_id % 2)
            ELSE 3 + (p.order_id % 3)
        END DAY
    ) AS shipped_at,
    -- delivered_at somente quando delivered: 3–7 (US/CA), 2–5 (UE), 7–12 (outros)
    CASE 
        WHEN (CRC32(CONCAT(@seed, ':ship:', p.order_id)) / 4294967295.0) < 0.73 THEN 
            DATE_ADD(o.order_date, INTERVAL 
                CASE 
                    WHEN a.country IN ('United States','Canada') THEN 3 + (p.order_id % 5)
                    WHEN a.country IN ('United Kingdom','Germany','France','Spain','Italy','Portugal','Netherlands') THEN 2 + (p.order_id % 4)
                    ELSE 7 + (p.order_id % 6)
                END DAY
            )
        ELSE NULL
    END AS delivered_at,
    DATE_ADD(o.order_date, INTERVAL 2 DAY) AS created_at
FROM payments p
JOIN orders o ON p.order_id = o.order_id
JOIN addresses a ON o.shipping_address_id = a.address_id
-- Cobertura ~78% de pagos/authorized
WHERE p.payment_status IN ('paid','authorized')
  AND (CRC32(CONCAT(@seed, ':cover:', p.order_id)) / 4294967295.0) < 0.78;
    
-- =========================================================
-- ATUALIZAR STATUS DOS PEDIDOS
-- (sem triggers, fazendo manualmente)
-- =========================================================

-- 1) Refunded 
UPDATE orders o
JOIN payments p ON o.order_id = p.order_id
SET o.order_status = 'refunded'
WHERE p.payment_status = 'refunded';

-- 2) Failed payments
UPDATE orders o
JOIN payments p ON o.order_id = p.order_id
LEFT JOIN shipments s ON o.order_id = s.order_id
SET o.order_status = 'cancelled'
WHERE p.payment_status = 'failed';

-- 3) Delivered (baseado na shipment)
UPDATE orders o
JOIN shipments s ON o.order_id = s.order_id
SET o.order_status = 'delivered'
WHERE s.shipment_status = 'delivered'
  AND o.order_status NOT IN ('refunded', 'cancelled');

-- 4) Shipped (baseado na shipment, exceto os delivered)
UPDATE orders o
JOIN shipments s ON o.order_id = s.order_id
SET o.order_status = 'shipped'
WHERE s.shipment_status IN ('ready', 'in_transit', 'issue')
  AND o.order_status NOT IN ('delivered', 'refunded', 'cancelled');

-- 5) Paid (para pedidos pagos sem shipment)
UPDATE orders o
JOIN payments p ON o.order_id = p.order_id
LEFT JOIN shipments s ON o.order_id = s.order_id
SET o.order_status = 'paid'
WHERE p.payment_status = 'paid'
  AND s.order_id IS NULL
  AND o.order_status NOT IN ('shipped', 'delivered', 'refunded', 'cancelled');

-- 6) Pending (para pedidos authorized ou pending sem shipment)
UPDATE orders o
JOIN payments p ON o.order_id = p.order_id
LEFT JOIN shipments s ON o.order_id = s.order_id
SET o.order_status = 'pending'
WHERE p.payment_status IN ('authorized', 'pending')
  AND s.order_id IS NULL
  AND o.order_status NOT IN ('paid', 'shipped', 'delivered', 'refunded', 'cancelled');
-- 7) Cancelled aleatório em uma pequena fração dos pendentes (simulando desistência do cliente)
UPDATE orders o
LEFT JOIN shipments s ON s.order_id = o.order_id
SET o.order_status = 'cancelled'
WHERE o.order_status = 'pending'
  AND s.order_id IS NULL
  AND (CRC32(CONCAT(@seed, ':cancel:', o.order_id)) / 4294967295.0) < 0.03;


-- =========================================================

-- Correção abrangente: para qualquer pedido em ('paid','shipped','delivered'),
-- garantir que TODOS os pagamentos associados estejam com payment_status='paid'.
UPDATE payments p
JOIN orders o ON o.order_id = p.order_id
SET p.payment_status = 'paid',
    p.paid_at = COALESCE(p.paid_at, NOW())
WHERE o.order_status IN ('paid','shipped','delivered')
  AND p.payment_status <> 'paid';

-- VERIFICAÇÕES FINAIS
-- =========================================================

-- Contagens básicas
SELECT 
    (SELECT COUNT(*) FROM customers) as customers,
    (SELECT COUNT(*) FROM addresses) as addresses,
    (SELECT COUNT(*) FROM categories) as categories,
    (SELECT COUNT(*) FROM products) as products,
    (SELECT COUNT(*) FROM warehouses) as warehouses,
    (SELECT COUNT(*) FROM inventory) as inventory,
    (SELECT COUNT(*) FROM orders) as orders,
    (SELECT COUNT(*) FROM order_items) as order_items,
    (SELECT COUNT(*) FROM payments) as payments,
    (SELECT COUNT(*) FROM shipments) as shipments;

-- Verificar período dos pedidos
SELECT 
    MIN(order_date) as primeiro_pedido,
    MAX(order_date) as ultimo_pedido,
    DATEDIFF(MAX(order_date), MIN(order_date)) as dias_cobertura
FROM orders;

-- Verificar 1 endereço por cliente
SELECT 'one_address_per_customer' as check_name,
       CASE WHEN EXISTS (
           SELECT customer_id FROM addresses 
           GROUP BY customer_id 
           HAVING COUNT(*) > 1
       ) THEN 'ERRO' ELSE 'OK' END as result;

-- Distribuição de pagamentos
SELECT payment_status, COUNT(*) as qtd,
       ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM payments), 2) as pct
FROM payments 
GROUP BY payment_status 
ORDER BY qtd DESC;

-- Distribuição de orders
SELECT order_status, COUNT(*) as qtd,
       ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM orders), 2) as pct
FROM orders 
GROUP BY order_status 
ORDER BY qtd DESC;

-- Distribuição de shipments (VERIFICAÇÃO DA DISTRIBUIÇÃO EXATA)
SELECT shipment_status, COUNT(*) as qtd,
       ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM shipments), 2) as pct
FROM shipments 
GROUP BY shipment_status 
ORDER BY 
    CASE shipment_status 
        WHEN 'delivered' THEN 1
        WHEN 'in_transit' THEN 2
        WHEN 'ready' THEN 3
        WHEN 'issue' THEN 4
    END;

-- Shipments sobre pagos
SELECT
  (SELECT COUNT(*) FROM payments WHERE payment_status IN ('paid','authorized')) AS pagos_aut,
  (SELECT COUNT(*) FROM shipments) AS remessas,
  CASE WHEN (SELECT COUNT(*) FROM payments WHERE payment_status IN ('paid','authorized'))=0 THEN NULL
       ELSE ROUND(100*(SELECT COUNT(*) FROM shipments)/
                  (SELECT COUNT(*) FROM payments WHERE payment_status IN ('paid','authorized')),2)
  END AS pct_ship_sobre_pago;

-- Verificar unicidade de SKU
SELECT 'unique_sku' as check_name,
       CASE WHEN EXISTS (
           SELECT sku FROM products 
           GROUP BY sku 
           HAVING COUNT(*) > 1
       ) THEN 'ERRO' ELSE 'OK' END as result;

-- Sanidade do inventário
SELECT 
    MIN(stock_qty) as min_stock,
    MAX(stock_qty) as max_stock,
    MIN(safety_stock) as min_safety,
    MAX(safety_stock) as max_safety
FROM inventory;

COMMIT;

SELECT 'SEED DATA COMPLETED SUCCESSFULLY - ATUALIZAÇÕES MANUAIS DE STATUS' as status;