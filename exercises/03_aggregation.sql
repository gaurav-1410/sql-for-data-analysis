-- 1. In one query, return three numbers: the total number of customers, the number of customers 
-- with an email, and the number of different countries. Hint: COUNT can be used in three different ways.
SELECT COUNT(*) AS total_no_cust, COUNT(email) AS cust_with_email, COUNT(DISTINCT country) AS no_of_country FROM customers;

-- 2. How many orders are there in each status? Most common status first.
SELECT DISTINCTROW(status), COUNT(*) AS cnt FROM orders GROUP BY 1 ORDER BY 2 DESC;

-- 3. Which countries have more than 30 customers? Show the country and its customer count, highest first.
SELECT DISTINCTROW(country), COUNT(*) AS cust_cnt FROM customers GROUP BY 1 HAVING cust_cnt > 30 ORDER BY 2 DESC;

-- 4. Using order_items, calculate each order’s revenue as quantity × unit_price × (1 − discount_pct). 
-- Show the 10 orders with the highest revenue, rounded to 2 decimals.
SELECT order_id, ROUND(SUM(quantity * unit_price * (1 - discount_pct)), 2) AS revenue FROM order_items GROUP BY 1 ORDER BY revenue DESC LIMIT 10;

-- 5. For completed payments only, show each payment_method with its number of payments and total amount. 
-- Keep only methods whose total is above 50,000.
SELECT payment_method, COUNT(*), SUM(amount) FROM payments WHERE payment_status = 'Completed' GROUP BY 1 HAVING SUM(amount) > 50000;

-- 6. Using only the orders table, answer in one query: how many different customers have placed at least one order, 
-- and what is the average number of orders per ordering customer?
SELECT COUNT(DISTINCT customer_id) AS cst_cnt, COUNT(*) / COUNT(DISTINCT customer_id) AS avg_order FROM orders;

-- 7. Show the number of orders for each year and each status combination, 
-- sorted by year and then by order count, highest first. Use YEAR(order_date).
SELECT YEAR(order_date), status, COUNT(*) FROM orders GROUP BY 1,2 ORDER BY 1 DESC, 3 DESC;

-- 8. Run this and explain why the two numbers are different. Which one is the “average salary”?
SELECT AVG(salary), SUM(salary) / COUNT(*) FROM employees;

-- 9. Find customers with at least 10 orders. Show customer_id, their number of orders and their total shipping cost, most orders first. 
-- Also tell me how many customers qualify.
SELECT customer_id, COUNT(order_id), SUM(shipping_cost) FROM orders GROUP BY 1 HAVING COUNT(*) >= 10 ORDER BY 2 DESC;