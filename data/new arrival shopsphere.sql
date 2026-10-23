USE shopsphere;

INSERT INTO suppliers (supplier_id, supplier_name, country, rating)
VALUES (9, 'Lumen Lighting Co', 'Italy', 4.0);

INSERT INTO employees (employee_id, first_name, last_name, department, job_title,
                       manager_id, hire_date, salary, region_id)
VALUES (33, 'Marco', 'Bianchi', 'Sales', 'Sales Representative', 9, '2025-12-01', 52000, 4);

UPDATE employees SET salary = 195000 WHERE employee_id = 30;