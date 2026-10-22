-- 1. Find all premium customers from Germany or France. Show name, country and is_premium. 
-- Write it two ways: once with OR and once with IN. Both must return the same row count.
SELECT CONCAT(first_name, ' ', last_name) AS full_name, country, is_premium FROM customers where (is_premium = 1 AND (country = 'France' OR country = 'Germany'));
SELECT CONCAT(first_name, ' ', last_name) AS full_name, country, is_premium FROM customers where (is_premium = 1 AND country IN ('France', 'Germany'));

-- 2. List active products priced between 50 and 200 (inclusive), cheapest first.
SELECT * FROM products WHERE (is_active = 1 and unit_price BETWEEN 50 AND 200) ORDER BY unit_price;

-- 3. Which customers have no email address on file? Then write a second query for customers who have both an email and a phone number.
SELECT * FROM customers WHERE email IS NULL;
SELECT * FROM customers WHERE (email IS NOT NULL and phone IS NOT NULL);

-- 4. Find all products whose name contains the word “Pro” anywhere in it.
SELECT * FROM products WHERE (product_name like '% Pro' OR product_name LIKE '% Pro %');

-- 5. Show all orders placed in January 2024. Then tell me the row count and explain how you made sure orders on January 31st weren’t missed.
SELECT * FROM orders WHERE (order_date >= '2024-01-01' AND order_date < '2024-02-01');

-- 6. Show orders that were Cancelled or Returned and used a discount code. Then write it again without any 
-- parentheses or IN, using only =, OR and AND. Compare the row counts and explain why they differ.
SELECT * FROM orders WHERE (status IN ('Cancelled', 'Returned') AND discount_code IS NOT NULL);
SELECT * FROM orders WHERE status = 'Cancelled' OR status = 'Returned' AND discount_code IS NOT NULL;

-- 7. Show all orders that did not use the discount code 'WELCOME10'. This should include orders that used no code at all. Check your row count carefully.
SELECT * FROM orders WHERE (discount_code != 'WELCOME10' OR discount_code IS NULL);

-- 8. Find customers who signed up in 2024 and came through Paid Search or Social Media, and whose birth_date is known. Use the date pattern from above.
SELECT 
    *
FROM
    customers
WHERE
    (signup_date >= '2024-01-01'
        AND signup_date < '2025-01-01'
        AND acquisition_channel IN ('Paid Search' , 'Social Media')
        AND birth_date IS NOT NULL);