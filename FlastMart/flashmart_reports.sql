
USE flashmart_db;

SELECT * FROM Customers;
SELECT * FROM Products;
SELECT * FROM Orders;
SELECT
    c.customer_id,
    c.name,
    COUNT(o.order_id) AS total_orders
FROM Customers c
LEFT JOIN Orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;
SELECT
    p.product_id,
    p.product_name
FROM Products p
LEFT JOIN Orders o
    ON p.product_id = o.product_id
WHERE o.order_id IS NULL;