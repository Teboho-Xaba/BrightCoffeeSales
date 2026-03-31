-- Full raw data
SELECT * FROM workspace.default.bright_coffee_shop_analysis;

-- Check for NULL values
SELECT * 
FROM workspace.default.bright_coffee_shop_analysis
WHERE transaction_id IS NULL 
   OR transaction_date IS NULL 
   OR transaction_time IS NULL 
   OR store_id IS NULL 
   OR transaction_qty IS NULL 
   OR Store_location IS NULL 
   OR product_id IS NULL 
   OR product_category IS NULL 
   OR product_type IS NULL 
   OR product_detail IS NULL 
   OR unit_price IS NULL;

-- Basic counts
SELECT COUNT(DISTINCT product_id) AS unique_product_id 
FROM workspace.default.bright_coffee_shop_analysis;

SELECT COUNT(DISTINCT transaction_id) AS number_of_rows
FROM workspace.default.bright_coffee_shop_analysis;

-- Transactions per store
SELECT store_location, COUNT(transaction_id) AS number_of_transaction 
FROM workspace.default.bright_coffee_shop_analysis
GROUP BY store_location;

-- Time range
SELECT MIN(transaction_time) AS earliest_transaction,
       MAX(transaction_time) AS latest_transaction
FROM workspace.default.bright_coffee_shop_analysis;

-- Date & Month analysis
SELECT dayname(to_date(transaction_date)) AS day_of_the_week 
FROM workspace.default.bright_coffee_shop_analysis;

SELECT 
    store_location, 
    SUM(transaction_qty * unit_price) AS revenue, 
    monthname(to_date(transaction_date)) AS month_names 
FROM workspace.default.bright_coffee_shop_analysis
GROUP BY store_location, month_names 
ORDER BY revenue DESC;

SELECT to_char(to_date(transaction_date),'yyyymm') AS month_id
FROM workspace.default.bright_coffee_shop_analysis;

-- Total revenue
SELECT SUM(transaction_qty * unit_price) AS total_revenue
FROM workspace.default.bright_coffee_shop_analysis;

-- Cheapest products
SELECT 
    product_category, product_detail, product_type, 
    MIN(unit_price) AS cheapest_product 
FROM workspace.default.bright_coffee_shop_analysis
GROUP BY product_category, product_detail, product_type
ORDER BY cheapest_product ASC;
-- Expensive products
SELECT 
    product_category, product_detail, product_type, 
    MAX(unit_price) AS expensive_product 
FROM workspace.default.bright_coffee_shop_analysis
GROUP BY product_category, product_detail, product_type
ORDER BY expensive_product DESC;

-- Total quantity sold
SELECT SUM(transaction_qty) AS total_quantity_sold
FROM workspace.default.bright_coffee_shop_analysis;

SELECT
    *,
    CAST(REPLACE(unit_price, ',', '.') AS DECIMAL(10,2)) AS unit_price_clean,
    transaction_qty * CAST(REPLACE(unit_price, ',', '.') AS DECIMAL(10,2)) AS total_amount,
    CASE 
        WHEN transaction_time BETWEEN '06:00:00' AND '08:59:59' THEN '06:00-09:00'
        WHEN transaction_time BETWEEN '09:00:00' AND '11:59:59' THEN '09:00-12:00'
        WHEN transaction_time BETWEEN '12:00:00' AND '14:59:59' THEN '12:00-15:00'
        WHEN transaction_time BETWEEN '15:00:00' AND '17:59:59' THEN '15:00-18:00'
        WHEN transaction_time BETWEEN '18:00:00' AND '20:59:59' THEN '18:00-21:00 (closes at 9pm)'
        ELSE 'No sales after 9pm'
    END AS transaction_time_bucket
FROM workspace.default.bright_coffee_shop_analysis
ORDER BY transaction_id;
