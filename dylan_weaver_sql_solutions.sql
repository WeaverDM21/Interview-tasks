/*
    Dylan Weaver - SQL Assessment Solutions
    Database: SQL Server
    Tables and column names are based on setup_database.sql.
*/

-- Question 1: Basic SELECT with WHERE
SELECT
    name,
    email,
    signup_date,
    status
FROM Customers
WHERE name = 'Alice Johnson';


-- Question 2: Filtering with Multiple Conditions
SELECT
    name,
    email,
    signup_date
FROM Customers
WHERE status = 'inactive'
  AND signup_date < '2024-06-01'
ORDER BY signup_date;


-- Question 3: Counting Records
SELECT
    category AS category_name,
    COUNT(*) AS product_count
FROM Products
GROUP BY category
ORDER BY category;


-- Question 4: Calculating Totals
SELECT
    SUM(total_amount) AS total_completed_order_revenue
FROM Orders
WHERE status = 'completed';


-- Question 5: Sorting and Limiting Results
SELECT TOP (10)
    id AS order_id,
    customer_id,
    order_date,
    total_amount,
    status
FROM Orders
ORDER BY order_date DESC, id DESC;


-- Question 6: String Pattern Matching
SELECT
    name,
    email
FROM Customers
WHERE LOWER(email) LIKE '%smith%';


-- Question 7: Handling NULL Values
SELECT
    id,
    name,
    signup_date
FROM Customers
WHERE email IS NULL;


-- Question 8: Root Cause Analysis / Complex Filtering
-- Join Orders to itself to compare pairs belonging to the same customer and date.
-- o1.id < o2.id prevents matching an order to itself and avoids returning each pair twice.
SELECT
    o1.id AS order_id_1,
    o2.id AS order_id_2,
    o1.customer_id,
    o1.order_date,
    o1.total_amount AS total_amount_1,
    o2.total_amount AS total_amount_2
FROM Orders AS o1
INNER JOIN Orders AS o2
    ON o1.customer_id = o2.customer_id
   AND o1.order_date = o2.order_date
   AND o1.id < o2.id
WHERE ABS(o1.total_amount - o2.total_amount) < 5.00
ORDER BY o1.customer_id, o1.order_date, o1.id;


-- Question 9: Stored Procedure Debugging Scenario
-- Aggregate all orders for each customer, then exclude any customer who has
-- at least one cancelled order. The totals therefore include all statuses
-- for qualifying customers, as requested ("across all their orders").
SELECT
    c.name AS customer_name,
    COUNT(o.id) AS total_number_of_orders,
    SUM(o.total_amount) AS total_amount_spent
FROM Customers AS c
INNER JOIN Orders AS o
    ON o.customer_id = c.id
WHERE NOT EXISTS (
    SELECT 1
    FROM Orders AS cancelled_order
    WHERE cancelled_order.customer_id = c.id
      AND cancelled_order.status = 'cancelled'
)
GROUP BY c.id, c.name
HAVING COUNT(o.id) > 2
ORDER BY c.name;


-- Extra Credit 1: Basic INNER JOIN
SELECT
    o.id AS order_id,
    o.order_date,
    o.total_amount,
    c.name AS customer_name
FROM Orders AS o
INNER JOIN Customers AS c
    ON c.id = o.customer_id
WHERE o.status = 'completed'
ORDER BY o.order_date DESC, o.id DESC;
