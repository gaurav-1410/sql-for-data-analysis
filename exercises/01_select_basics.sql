-- 1. Show the first_name, last_name, country and signup_date of all customers.
SELECT first_name, last_name, country, signup_date FROM customers;

-- 2. Show all products sorted by unit_price from most expensive to cheapest. Return only product_name and unit_price.
SELECT product_name, unit_price FROM products ORDER BY unit_price DESC;

-- 3. Which 5 orders had the highest shipping_cost? Show order_id, order_date and shipping_cost.
SELECT order_id, order_date, shipping_cost FROM orders ORDER BY shipping_cost DESC, order_date DESC LIMIT 5;

-- 4. Give me the list of countries our customers come from, with each country appearing only once and sorted A to Z.
SELECT DISTINCT country FROM customers ORDER BY country;

-- 5. Show all orders with status 'Cancelled', newest first.
SELECT * FROM orders WHERE status = 'Cancelled' ORDER BY order_date DESC;