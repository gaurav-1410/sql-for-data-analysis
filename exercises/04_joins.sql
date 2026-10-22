-- 1. Show the 10 most recent orders with the customer’s full name next to each one: order_id, order_date, customer full name, status.
SELECT 
    o.order_id,
    o.order_date,
    CONCAT(c.first_name, ' ', c.last_name) AS cust_name,
    o.status
FROM
    orders o
        JOIN
    customers c ON o.customer_id = c.customer_id
ORDER BY order_date DESC
LIMIT 10;

-- 2. How many orders came from each region? Show region_name and the order count, highest first. 
-- Hint: orders has no region column, so think about which tables you have to pass through to get there.
SELECT 
    r.region_name, COUNT(DISTINCT o.order_id) AS order_count
FROM
    orders o
        JOIN
    customers c ON o.customer_id = c.customer_id
        JOIN
    regions r ON c.region_id = r.region_id
GROUP BY r.region_name
ORDER BY order_count DESC;

-- 3. Find all customers who have never placed an order. 
-- Show customer_id, full name and signup_date, and tell me the row count. Hint: INNER JOIN can’t find missing things.
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS cust_name,
    c.signup_date
FROM
    customers c
        LEFT JOIN
    orders o ON o.customer_id = c.customer_id
WHERE
    o.order_date IS NULL; 

-- 4. Show every employee with their manager’s name next to theirs. The CEO has no manager, but must still appear in the list. 
-- Hint: managers are also in the employees table.
SELECT e.first_name AS emp_name, m.first_name AS man_name FROM employees e LEFT JOIN employees m on e.manager_id = m.employee_id;

-- 5. Which 3 product categories earned the most revenue? Use the revenue formula from Level 3, show category_name and revenue rounded to 2 decimals.
-- Revenue Formula: ROUND(SUM(quantity * unit_price * (1 - discount_pct)), 2) AS revenue
SELECT 
    c.category_name,
    ROUND(SUM(o.quantity * o.unit_price * (1 - o.discount_pct)),
            2) AS revenue
FROM
    order_items o
        JOIN
    products p ON o.product_id = p.product_id
		JOIN
	categories c on p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY revenue DESC 
LIMIT 3;

-- 6. Redo Q4: employee_id, employee full name, job_title, manager full name. 
-- All 32 employees must appear, and the CEO’s manager column should be NULL.
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS emp_name,
    e.job_title,
    CONCAT(m.first_name, ' ', m.last_name) AS man_name
FROM
    employees e
        LEFT JOIN
    employees m ON e.manager_id = m.employee_id;
    
-- 7. For each customer, show customer_id, full name, number of orders and total revenue (from order_items). 
-- Show the top 5 by number of orders. Before you send it, check your order counts against the Level 3 question about customers with at least 10 orders. 
-- If they don’t match, figure out why. This is one of the most common JOIN bugs in real work.
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS cust_name,
    COUNT(DISTINCT o.order_id) AS order_cnt,
    ROUND(SUM(ot.quantity * ot.unit_price * (1 - ot.discount_pct)),
            2) AS revenue
FROM
    customers c
        JOIN
    orders o ON c.customer_id = o.customer_id
        JOIN
    order_items ot ON o.order_id = ot.order_id
GROUP BY c.customer_id
ORDER BY order_cnt DESC , REVENUE DESC
LIMIT 5
;

-- 8. Change your Q3 query to find customers who never placed a Delivered order. 
-- They might have orders that are cancelled, still processing, and so on, but none delivered. 
-- Hint: think about whether the status condition belongs in WHERE or in ON, and try both.
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS cust_name,
    c.signup_date
FROM
    customers c
        LEFT JOIN
    orders o ON o.customer_id = c.customer_id
    AND o.status = 'Delivered'
WHERE
	o.order_id IS NULL;
    