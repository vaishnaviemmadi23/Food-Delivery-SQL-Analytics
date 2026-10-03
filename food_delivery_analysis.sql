CREATE DATABASE food_delivery_analytics;
USE food_delivery_analytics;
-- creation of table
CREATE TABLE food_orders (
    order_id VARCHAR(20),
    order_date DATE,
    customer_id VARCHAR(20),
    customer_city VARCHAR(50),
    restaurant_name VARCHAR(100),
    cuisine VARCHAR(50),
    order_amount DECIMAL(10,2),
    payment_method VARCHAR(50),
    order_status VARCHAR(30),
    delivery_time_minutes INT,
    customer_rating DECIMAL(2,1)
);
DROP TABLE food_orders;
SELECT COUNT(*) AS total_orders
FROM food_orders;
SELECT MIN(order_id) AS first_order,
       MAX(order_id) AS last_order,
       COUNT(*) AS total_rows
FROM food_orders;


SELECT *
FROM food_orders
LIMIT 10;

DESCRIBE food_orders;

SELECT COUNT(*) AS total_orders
FROM food_orders;

-- Query 1 — Total Revenue
SELECT 
    SUM(order_amount) AS total_revenue
FROM food_orders
WHERE order_status = 'Delivered';

-- Query 2 — Average Order Value
SELECT 
    ROUND(AVG(order_amount), 2) AS average_order_value
FROM food_orders
WHERE order_status = 'Delivered';

-- Query 3 — Total Delivered Orders
SELECT 
    COUNT(*) AS delivered_orders
FROM food_orders
WHERE order_status = 'Delivered';

-- Query 4 — Cancelled Orders
SELECT 
    COUNT(*) AS cancelled_orders
FROM food_orders
WHERE order_status = 'Cancelled';

-- Query 5 — Cancellation Rate
SELECT 
    ROUND(
        100.0 * SUM(CASE WHEN order_status = 'Cancelled' THEN 1 ELSE 0 END) 
        / COUNT(*),
        2
    ) AS cancellation_rate
FROM food_orders;

-- Monthly Revenue Analysis
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    ROUND(SUM(order_amount), 2) AS monthly_revenue
FROM food_orders
WHERE order_status = 'Delivered'
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;

-- highest-revenue month
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    ROUND(SUM(order_amount), 2) AS monthly_revenue
FROM food_orders
WHERE order_status = 'Delivered'
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY monthly_revenue DESC
LIMIT 1;

-- Restaurant Performance
-- Revenue by Restaurant
SELECT
    restaurant_name,
    COUNT(*) AS total_orders,
    ROUND(SUM(order_amount), 2) AS total_revenue
FROM food_orders
WHERE order_status = 'Delivered'
GROUP BY restaurant_name
ORDER BY total_revenue DESC;

-- Top 5 Restaurants
SELECT
    restaurant_name,
    COUNT(*) AS total_orders,
    ROUND(SUM(order_amount), 2) AS total_revenue
FROM food_orders
WHERE order_status = 'Delivered'
GROUP BY restaurant_name
ORDER BY total_revenue DESC
LIMIT 5;

-- Average Order Value by Restaurant
SELECT
    restaurant_name,
    COUNT(*) AS total_orders,
    ROUND(AVG(order_amount), 2) AS average_order_value
FROM food_orders
WHERE order_status = 'Delivered'
GROUP BY restaurant_name
ORDER BY average_order_value DESC;

-- Cuisine Analysis
-- Orders & Revenue by Cuisine
SELECT
    cuisine,
    COUNT(*) AS total_orders,
    ROUND(SUM(order_amount), 2) AS total_revenue
FROM food_orders
WHERE order_status = 'Delivered'
GROUP BY cuisine
ORDER BY total_revenue DESC;

-- Top 3 Cuisines by Orders
SELECT
    cuisine,
    COUNT(*) AS total_orders
FROM food_orders
WHERE order_status = 'Delivered'
GROUP BY cuisine
ORDER BY total_orders DESC
LIMIT 3;

-- Average Order Value by Cuisine
SELECT
    cuisine,
    ROUND(AVG(order_amount), 2) AS average_order_value
FROM food_orders
WHERE order_status = 'Delivered'
GROUP BY cuisine
ORDER BY average_order_value DESC;

-- City-wise Analysis
-- Orders & Revenue by City

SELECT
    customer_city,
    COUNT(*) AS total_orders,
    ROUND(SUM(order_amount), 2) AS total_revenue
FROM food_orders
WHERE order_status = 'Delivered'
GROUP BY customer_city
ORDER BY total_revenue DESC;

SELECT
    customer_city,
    ROUND(AVG(order_amount), 2) AS average_order_value
FROM food_orders
WHERE order_status = 'Delivered'
GROUP BY customer_city
ORDER BY average_order_value DESC;

-- Query 3 — City + Cuisine ⭐


SELECT
    customer_city,
    cuisine,
    COUNT(*) AS total_orders,
    ROUND(SUM(order_amount), 2) AS total_revenue
FROM food_orders
WHERE order_status = 'Delivered'
GROUP BY customer_city, cuisine
ORDER BY customer_city, total_revenue DESC;

 SELECT
    customer_id,
    COUNT(*) AS total_orders,
    ROUND(SUM(order_amount), 2) AS total_spent
FROM food_orders
WHERE order_status = 'Delivered'
GROUP BY customer_id
ORDER BY total_spent DESC;

SELECT
    customer_id,
    COUNT(*) AS total_orders,
    ROUND(SUM(order_amount), 2) AS total_spent
FROM food_orders
WHERE order_status = 'Delivered'
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 10;

WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(*) AS order_count
    FROM food_orders
    WHERE order_status = 'Delivered'
    GROUP BY customer_id
)
SELECT
    CASE
        WHEN order_count = 1 THEN 'One-time'
        ELSE 'Repeat'
    END AS customer_type,
    COUNT(*) AS customer_count
FROM customer_orders
GROUP BY
    CASE
        WHEN order_count = 1 THEN 'One-time'
        ELSE 'Repeat'
    END;
    
    WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(*) AS order_count
    FROM food_orders
    WHERE order_status = 'Delivered'
    GROUP BY customer_id
)
SELECT
    ROUND(
        100.0 * SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS repeat_customer_percentage
FROM customer_orders;


-- Delivery Performance
-- Average delivery time
SELECT
    ROUND(AVG(delivery_time_minutes), 2) AS average_delivery_time
FROM food_orders
WHERE order_status = 'Delivered';

SELECT
    customer_city,
    ROUND(AVG(delivery_time_minutes), 2) AS average_delivery_time
FROM food_orders
WHERE order_status = 'Delivered'
GROUP BY customer_city
ORDER BY average_delivery_time DESC;

-- Payment & Cancellation Analysis
-- Orders & revenue by payment method
SELECT
    payment_method,
    COUNT(*) AS total_orders,
    ROUND(SUM(order_amount), 2) AS total_revenue
FROM food_orders
WHERE order_status = 'Delivered'
GROUP BY payment_method
ORDER BY total_revenue DESC;

-- Cancellation by payment method
SELECT
    payment_method,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN order_status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_orders,
    ROUND(
        100.0 * SUM(CASE WHEN order_status = 'Cancelled' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS cancellation_rate
FROM food_orders
GROUP BY payment_method
ORDER BY cancellation_rate DESC;

SELECT
    COUNT(*) AS total_orders,
    SUM(CASE WHEN order_status = 'Delivered' THEN 1 ELSE 0 END) AS delivered_orders,
    SUM(CASE WHEN order_status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_orders,
    ROUND(
        100.0 * SUM(CASE WHEN order_status = 'Cancelled' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS cancellation_rate
FROM food_orders;


-- Advanced SQL
-- Rank restaurants by revenue
WITH restaurant_revenue AS (
    SELECT
        restaurant_name,
        ROUND(SUM(order_amount), 2) AS total_revenue
    FROM food_orders
    WHERE order_status = 'Delivered'
    GROUP BY restaurant_name
)
SELECT
    restaurant_name,
    total_revenue,
    RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank
FROM restaurant_revenue
ORDER BY revenue_rank;

WITH cuisine_revenue AS (
    SELECT
        customer_city,
        cuisine,
        ROUND(SUM(order_amount), 2) AS total_revenue
    FROM food_orders
    WHERE order_status = 'Delivered'
    GROUP BY customer_city, cuisine
)
SELECT
    customer_city,
    cuisine,
    total_revenue,
    RANK() OVER (
        PARTITION BY customer_city
        ORDER BY total_revenue DESC
    ) AS cuisine_rank
FROM cuisine_revenue
ORDER BY customer_city, cuisine_rank;

-- Top 3 restaurants in each city
WITH restaurant_revenue AS (
    SELECT
        customer_city,
        restaurant_name,
        ROUND(SUM(order_amount), 2) AS total_revenue
    FROM food_orders
    WHERE order_status = 'Delivered'
    GROUP BY customer_city, restaurant_name
),
ranked_restaurants AS (
    SELECT
        customer_city,
        restaurant_name,
        total_revenue,
        RANK() OVER (
            PARTITION BY customer_city
            ORDER BY total_revenue DESC
        ) AS restaurant_rank
    FROM restaurant_revenue
)
SELECT
    customer_city,
    restaurant_name,
    total_revenue,
    restaurant_rank
FROM ranked_restaurants
WHERE restaurant_rank <= 3
ORDER BY customer_city, restaurant_rank;

-- Each restaurant's revenue vs city average
WITH restaurant_revenue AS (
    SELECT
        customer_city,
        restaurant_name,
        SUM(order_amount) AS total_revenue
    FROM food_orders
    WHERE order_status = 'Delivered'
    GROUP BY customer_city, restaurant_name
),
city_average AS (
    SELECT
        customer_city,
        AVG(total_revenue) AS avg_restaurant_revenue
    FROM restaurant_revenue
    GROUP BY customer_city
)
SELECT
    r.customer_city,
    r.restaurant_name,
    ROUND(r.total_revenue, 2) AS total_revenue,
    ROUND(c.avg_restaurant_revenue, 2) AS city_average_revenue,
    ROUND(r.total_revenue - c.avg_restaurant_revenue, 2) AS difference_from_average
FROM restaurant_revenue r
JOIN city_average c
    ON r.customer_city = c.customer_city
ORDER BY r.customer_city, r.total_revenue DESC;

SELECT
    COUNT(*) AS total_orders,
    SUM(CASE WHEN order_status = 'Delivered' THEN 1 ELSE 0 END) AS delivered_orders,
    SUM(CASE WHEN order_status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_orders,
    ROUND(SUM(CASE WHEN order_status = 'Delivered' THEN order_amount ELSE 0 END), 2) AS total_revenue,
    ROUND(AVG(CASE WHEN order_status = 'Delivered' THEN order_amount END), 2) AS average_order_value,
    ROUND(AVG(CASE WHEN order_status = 'Delivered' THEN delivery_time_minutes END), 2) AS average_delivery_time
FROM food_orders;

SELECT
    customer_city,
    ROUND(SUM(order_amount), 2) AS total_revenue
FROM food_orders
WHERE order_status = 'Delivered'
GROUP BY customer_city
ORDER BY total_revenue DESC
LIMIT 1;
SELECT
    restaurant_name,
    ROUND(SUM(order_amount), 2) AS total_revenue
FROM food_orders
WHERE order_status = 'Delivered'
GROUP BY restaurant_name
ORDER BY total_revenue DESC
LIMIT 1;
SELECT
    cuisine,
    ROUND(SUM(order_amount), 2) AS total_revenue
FROM food_orders
WHERE order_status = 'Delivered'
GROUP BY cuisine
ORDER BY total_revenue DESC
LIMIT 1;


