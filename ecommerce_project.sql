CREATE DATABASE ecommerce_project;

USE ecommerce_project;

DROP TABLE orders;
ALTER TABLE customers
ADD PRIMARY KEY (customer_id);
DESCRIBE customers;

SHOW KEYS FROM customers;

SET SQL_SAFE_UPDATES = 0;

CREATE TABLE orders (
    order_id INT,
    customer_id VARCHAR(10),
    product_id VARCHAR(10),
    order_date DATE,
    quantity INT,
    sales DECIMAL(10,2),
    discount INT,
    region VARCHAR(50),
    delivery_days INT,
    payment_status VARCHAR(50)
);

CREATE TABLE customers (
    customer_id VARCHAR(10),
    customer_name VARCHAR(100),
    gender VARCHAR(20),
    age INT,
    state VARCHAR(100),
    signup_date DATE
);

CREATE TABLE products (
    product_id VARCHAR(10),
    product_name VARCHAR(100),
    category VARCHAR(50),
    cost_price DECIMAL(10,2),
    selling_price DECIMAL(10,2)
);

CREATE TABLE website_traffic (
    date DATE,
    visitors INT,
    orders INT,
    bounce_rate INT
);

CREATE TABLE returns_data (
    return_id VARCHAR(10),
    order_id INT,
    return_reason VARCHAR(100),
    refund_amount DECIMAL(10,2)
);

SELECT * FROM orders;

-- TASK 1 — Count Records
SELECT COUNT(*) FROM orders;

-- TASK 2 — Check Table Structure
DESCRIBE orders;

-- TASK 3 — Preview Data
SELECT *
FROM customers
LIMIT 10;

-- -------------------------------
-- IDENTIFY DATA QUALITY ISSUES
-- -------------------------------

-- TASK 1 — Find Missing Values
SELECT *
FROM orders
WHERE sales IS NULL;

-- TASK 2 — Check Gender Inconsistency
SELECT DISTINCT gender
FROM customers;

-- TASK 3 — Check Category Inconsistency
SELECT DISTINCT category
FROM products;

-- TASK 4 — Find Delivery Delays
SELECT *
FROM orders
WHERE delivery_days > 7;

-- TASK 5 — Detect Outliers
SELECT *
FROM orders
WHERE sales > 500000;

-- ------------------------------------
-- DATA CLEANING
-- ------------------------------------

-- CLEAN GENDER VALUES
UPDATE customers
SET gender = 'Male'
WHERE gender IN ('M','male','MALE');

-- Clean Female Values
UPDATE customers
SET gender = 'Female'
WHERE gender IN ('F','female');

UPDATE products
SET category = 'Electronics'
WHERE category = 'electronics';

UPDATE orders
SET sales = 50000
WHERE order_id = 1003;

SELECT *
FROM orders
WHERE delivery_days > 7;

-- -----------------------------------------
-- BUSINESS ANALYSIS
-- -----------------------------------------

-- TOTAL REVENUE
SELECT SUM(sales) AS total_revenue
FROM orders;

-- CATEGORY-WISE SALES
SELECT
    p.category,
    SUM(o.sales) AS revenue
FROM orders o
JOIN products p
ON o.product_id = p.product_id
GROUP BY p.category;

-- REGION-WISE SALES
SELECT
    region,
    SUM(sales) AS revenue
FROM orders
GROUP BY region
ORDER BY revenue DESC;

-- DELIVERY ISSUES
SELECT *
FROM orders
WHERE delivery_days > 7;

-- RETURNS ANALYSIS
SELECT
    return_reason,
    COUNT(*) AS total_returns
FROM returns_data
GROUP BY return_reason;

-- REPEAT CUSTOMERS
SELECT
    customer_id,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id) > 1;