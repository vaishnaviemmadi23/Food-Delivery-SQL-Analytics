
# 🍔 Food Delivery SQL Analytics

> A business-focused SQL analytics project analyzing food delivery orders, customer behavior, restaurant performance, revenue trends, delivery efficiency, and cancellation patterns using MySQL.

---

## 📌 Project Overview

Food delivery platforms generate large amounts of transactional data every day.

This project uses SQL to transform raw food delivery order data into meaningful business insights.

The analysis focuses on answering questions such as:

- How much revenue is being generated?
- Which restaurants generate the most revenue?
- Which cuisines are most popular?
- Which cities contribute the most revenue?
- Who are the highest-value customers?
- What percentage of customers are repeat customers?
- Which cities have slower delivery times?
- Which payment methods have higher cancellation rates?
- Which restaurants perform best within each city?

The project demonstrates how SQL can be used not only for querying data, but also for solving practical business problems.

---

# 🎯 Business Objectives

The main objectives of this analysis are:

1. Measure overall business performance.
2. Identify revenue trends over time.
3. Analyze restaurant performance.
4. Understand cuisine-level demand.
5. Compare city-level performance.
6. Analyze customer purchasing behavior.
7. Identify repeat customers.
8. Evaluate delivery performance.
9. Analyze payment methods.
10. Identify cancellation patterns.
11. Apply advanced SQL techniques to solve analytical problems.

---

# 🗂️ Dataset

The dataset contains food delivery order-level information.

### Dataset Columns

| Column | Description |
|---|---|
| `order_id` | Unique order identifier |
| `order_date` | Date of the order |
| `customer_id` | Unique customer identifier |
| `customer_city` | Customer's city |
| `restaurant_name` | Restaurant associated with the order |
| `cuisine` | Cuisine type |
| `order_amount` | Order value |
| `payment_method` | Payment method used |
| `order_status` | Delivered or Cancelled |
| `delivery_time_minutes` | Delivery duration |
| `customer_rating` | Customer rating |

### Dataset Size

- Imported records: **1,499**
- Delivered orders: **1,219**
- Cancelled orders: **280**

---

# 🧹 Data Quality Checks

Before performing analysis, the dataset was inspected for potential data-quality issues.

The analysis considered issues such as:

- Inconsistent city names
- Inconsistent cuisine labels
- Trailing spaces in text fields
- Invalid order amounts
- Invalid customer ratings
- Missing delivery-time values
- Cancelled orders with missing ratings

These checks help ensure that analytical results are interpreted carefully.

---

# 📊 Key Performance Indicators

| KPI | Value |
|---|---:|
| Total Orders | 1,499 |
| Delivered Orders | 1,219 |
| Cancelled Orders | 280 |
| Total Revenue | ₹11,931,114.38 |
| Average Order Value | ₹978.76 |
| Average Delivery Time | 46.92 minutes |

---

# 🔍 Business Questions

## Revenue Analysis

- What is the total revenue generated?
- What is the average order value?
- How does revenue change month by month?
- Which month generated the highest revenue?

## Restaurant Analysis

- Which restaurants generate the highest revenue?
- Which restaurants receive the most orders?
- Which restaurants have the highest average order value?
- Which are the top 3 restaurants in each city?

## Cuisine Analysis

- Which cuisines generate the highest revenue?
- Which cuisines receive the most orders?
- What is the average order value for each cuisine?
- Which cuisine performs best within each city?

## Customer Analysis

- Who are the highest-spending customers?
- How many orders does each customer place?
- What percentage of customers are repeat customers?
- How do repeat customers compare with one-time customers?

## Delivery Analysis

- What is the average delivery time?
- Which cities have the longest average delivery times?
- Are delivery times significantly different between cities?

## Cancellation Analysis

- What is the overall cancellation rate?
- Which cities have higher cancellation rates?
- Which payment methods are associated with different cancellation rates?

---

# 🧠 SQL Techniques Used

This project demonstrates both foundational and advanced SQL concepts.

### Basic SQL

- `SELECT`
- `WHERE`
- `ORDER BY`
- `LIMIT`
- `GROUP BY`

### Aggregations

- `COUNT()`
- `SUM()`
- `AVG()`
- `ROUND()`

### Conditional Logic

- `CASE`
- Conditional aggregation

### Advanced SQL

- Common Table Expressions (CTEs)
- Window Functions
- `RANK()`
- `PARTITION BY`
- Multi-level aggregation
- Top-N analysis
- `JOIN`
- CTE-to-CTE comparison

---

# 🚀 Advanced SQL Examples

## 1. Ranking Restaurants by Revenue

Restaurants are ranked based on total delivered-order revenue.

```sql
WITH restaurant_revenue AS (
    SELECT
        restaurant_name,
        SUM(order_amount) AS total_revenue
    FROM food_orders
    WHERE order_status = 'Delivered'
    GROUP BY restaurant_name
)
SELECT
    restaurant_name,
    total_revenue,
    RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank
FROM restaurant_revenue;
