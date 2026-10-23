-- 9. For order 1636, show each item’s product_name, category_name, quantity, unit_price and line revenue (rounded). Add a sensible ORDER BY.
SELECT * FROM order_items WHERE order_id = 1636;
SELECT * FROM order_items WHERE product_id = 10;
SELECT 
    p.product_name, c.category_name, o.quantity AS total_qty, o.unit_price AS unit_price,
    ROUND(o.quantity * o.unit_price * (1 - o.discount_pct),
            2) AS revenue
FROM
    order_items o
        JOIN
    products p ON p.product_id = o.product_id
        JOIN
    categories c ON p.category_id = c.category_id
WHERE o.order_id = 1636
-- GROUP BY p.product_name, c.category_name
ORDER BY revenue DESC;

-- 10. List every sub-category next to its parent category name, e.g. Laptops | Electronics. Top-level categories like Electronics 
-- shouldn’t appear in the sub-category column. Give the row count.
SELECT 
	cc.category_name AS parent_category,
    c.category_name AS sub_category
FROM
    categories c
        JOIN
    categories cc ON c.parent_category_id = cc.category_id;

-- 11. Show every supplier with the number of products they supply, fewest first. Every supplier must appear, including ones with no products.
SELECT 
    s.supplier_name, COUNT(p.product_id) AS prod_cnt
FROM
    suppliers s
        LEFT JOIN
    products p ON s.supplier_id = p.supplier_id
GROUP BY s.supplier_id, s.supplier_name
ORDER BY prod_cnt;

-- 12. How many orders have no payment record at all? Then break that number down by order status. 
-- What does the breakdown tell you, and is it a data problem or expected?
SELECT o.status, COUNT(*) FROM orders o LEFT JOIN payments p on  o.order_id = p.order_id WHERE p.payment_id IS NULL GROUP BY o.status;

-- 13. For every Sales Representative, show their full name, their manager’s full name and how many orders they handled. 
-- Marco, the new hire, must appear with 0. Most orders first.
SELECT * FROM orders WHERE sales_rep_id IS NULL;
SELECT * FROM employees;
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS emp_name,
    CONCAT(m.first_name, ' ', m.last_name) AS man_name,
    COUNT(o.order_id) AS order_cnt
FROM
    employees e
        JOIN
    employees m ON e.manager_id = m.employee_id
		LEFT JOIN
	orders o ON e.employee_id = o.sales_rep_id
    WHERE e.job_title = 'Sales Representative'
GROUP BY e.employee_id, emp_name, man_name
ORDER BY order_cnt DESC, emp_name;

-- 14. Find employees who earn more than their own manager. 
-- Show the employee’s name and salary next to the manager’s name and salary.
SELECT 
    *
FROM
    employees;
SELECT 
    e.first_name AS emp_name,
    e.salary AS emp_sal,
    m.first_name AS man_name,
    m.salary AS man_sal
FROM
    employees e
        JOIN
    employees m ON e.manager_id = m.employee_id
WHERE
    e.salary > m.salary OR e.salary IS NULL;

-- 15. Show revenue for the 5 top-level categories (Electronics, Home & Kitchen, ...), highest first.
-- Hint: products are linked to sub-categories, not top-level ones. You have to climb one more step: item → product → sub-category → parent category. 
-- That means joining categories twice with different aliases.
SELECT 
    cc.category_name,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct)),
            2) AS revenue
FROM
    products p
        JOIN
    order_items oi ON p.product_id = oi.product_id
		JOIN
	categories c ON p.category_id = c.category_id
		JOIN
	categories cc ON c.parent_category_id = cc.category_id
GROUP BY cc.category_name
ORDER BY revenue DESC;

-- 16. For each category, show items sold, items returned, the return rate % (1 decimal) and total refund amount. 
-- Highest return rate first.
SELECT 
    c.category_name,
    COUNT(oi.order_item_id) AS sold_items,
    COUNT(r.return_id) AS item_return,
    ROUND(100 * COUNT(r.return_id) / COUNT(oi.order_item_id), 1) AS return_rate,
    ROUND(SUM(r.refund_amount), 1) AS total_refund
FROM
    order_items oi
        JOIN
    products p ON oi.product_id = p.product_id
		JOIN
	categories c ON p.category_id = c.category_id
		LEFT JOIN
	returns r ON oi.order_item_id = r.order_item_id
GROUP BY c.category_id
ORDER BY COUNT(r.return_id) / COUNT(oi.order_item_id) DESC;

-- 17 A colleague wrote this to show each product’s number of reviews, average rating and total units sold:
-- Run it. Then calculate review_cnt and units_sold separately, with two simple queries, for one product of your choice. 
-- Which columns are wrong, and why? Would COUNT(DISTINCT ...) fix all of them?

SELECT 
    p.product_name,
    COUNT(DISTINCT r.review_id) AS review_cnt,
    ROUND(AVG(r.rating), 2) AS avg_rating,
    SUM(oi.quantity) AS units_sold
FROM
    products p
        JOIN
    reviews r ON r.product_id = p.product_id
        JOIN
    order_items oi ON oi.product_id = p.product_id
GROUP BY p.product_id , p.product_name;

SELECT 
    p.product_name, COUNT(r.review_id) AS review_cnt
FROM
    products p
        JOIN
    reviews r ON p.product_id = r.product_id
GROUP BY p.product_name;

SELECT 
    p.product_name, SUM(oi.quantity) AS review_cnt
FROM
    products p
        JOIN
    order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_name;

-- 18. For each region, show region_name, the Regional Sales Manager’s full name, the number of customers and the number of orders. Most orders first. 
-- Check your customer counts with a simple GROUP BY on customers alone; they must match.
SELECT * FROM regions;
SELECT * FROM employees;
SELECT * FROM orders;
SELECT * FROM customers;

SELECT 
    r.region_name,
    CONCAT(e.first_name, ' ', e.last_name) AS emp_name,
	COUNT(DISTINCT c.customer_id) AS no_customers,
    COUNT(o.order_id) AS no_orders
FROM
    regions r
        JOIN
    employees e ON r.region_id = e.region_id
		JOIN
	customers c ON r.region_id = c.region_id
		LEFT JOIN
	orders o ON o.customer_id = c.customer_id
WHERE
    job_title = 'Regional Sales Manager'
GROUP BY r.region_name, emp_name
ORDER BY no_orders DESC;

SELECT region_id, COUNT(*) FROM customers GROUP BY region_id

