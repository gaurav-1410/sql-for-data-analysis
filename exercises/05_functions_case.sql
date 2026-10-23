-- 1. Run SELECT DISTINCT city FROM customers ORDER BY city; and look closely: some cities are stored inconsistently. 
-- Then write one query that returns two numbers: the count of distinct city values as stored, and the count after cleaning. 
-- Tell me both numbers and what was wrong with the dirty ones.
SELECT COUNT(DISTINCT city) AS old_city, COUNT(DISTINCT TRIM(LOWER(city))) AS new_city FROM customers ORDER BY city;

SELECT DISTINCT
    city, LENGTH(city) AS len, LENGTH(TRIM(city)) AS trimmed_len
FROM
    customers
ORDER BY TRIM(city);

-- 2. For each month, show the month as '2025-01', the number of orders and the revenue. Exclude cancelled orders. Sort by month.
SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m') AS y_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct)),
            2) AS revenue
FROM
    orders o
        JOIN
    order_items oi ON o.order_id = oi.order_id
WHERE
    status <> 'Cancelled'
    AND YEAR(order_date) = 2025
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY y_month;

-- 3. For delivered orders, what is the average number of days from order_date to delivered_date per shipping_country? 
-- Show the 5 slowest countries, rounded to 1 decimal.
SELECT 
    shipping_country,
    ROUND(AVG(DATEDIFF(delivered_date, order_date)),
            1) AS avg_delivery_days
FROM
    orders
WHERE delivered_date IS NOT NULL
GROUP BY shipping_country
ORDER BY AVG(DATEDIFF(delivered_date, order_date)) DESC, shipping_country
LIMIT 5;

-- 4. Calculate each customer’s age as of '2025-12-31' and put them into groups: Under 25, 25-34, 35-49, 50+, and Unknown for missing birth dates. 
-- Show each group and its customer count.
SELECT * FROM customers;
SELECT 
    CASE
        WHEN
            TIMESTAMPDIFF(YEAR,
                birth_date,
                '2025-12-31') < 25
        THEN
            'Under 25'
        WHEN
            TIMESTAMPDIFF(YEAR,
                birth_date,
                '2025-12-31') BETWEEN 25 AND 34
        THEN
            '25-34'
        WHEN
            TIMESTAMPDIFF(YEAR,
                birth_date,
                '2025-12-31') BETWEEN 35 AND 49
        THEN
            '35-49'
        WHEN
            TIMESTAMPDIFF(YEAR,
                birth_date,
                '2025-12-31') >= 50
        THEN
            '50+'
        ELSE 'Unknown'
    END AS age_group,
    COUNT(*) AS customer_cnt
FROM
    customers
GROUP BY age_group
ORDER BY MIN(birth_date) DESC;
