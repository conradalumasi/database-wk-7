-- Question 1: Transform ProductDetail table to 1NF
-- Assuming we have a way to split the comma-separated Products
-- Method 1: If we need to create normalized structure from scratch
-- Step 1: Create a new normalized table structure
CREATE TABLE ProductDetail_1NF AS
SELECT OrderID,
    CustomerName,
    TRIM(
        SUBSTRING_INDEX(
            SUBSTRING_INDEX(Products, ',', numbers.n),
            ',',
            -1
        )
    ) AS Product
FROM ProductDetail
    CROSS JOIN (
        SELECT 1 AS n
        UNION ALL
        SELECT 2
        UNION ALL
        SELECT 3
        UNION ALL
        SELECT 4
        UNION ALL
        SELECT 5
    ) numbers
WHERE CHAR_LENGTH(Products) - CHAR_LENGTH(REPLACE(Products, ',', '')) >= numbers.n - 1
    OR numbers.n = 1
ORDER BY OrderID;
-- Method 2: If we're just showing the normalized structure in a query result
SELECT OrderID,
    CustomerName,
    TRIM(
        SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', 1), ',', -1)
    ) AS Product
FROM ProductDetail
WHERE Products IS NOT NULL
UNION ALL
SELECT OrderID,
    CustomerName,
    TRIM(
        SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', 2), ',', -1)
    ) AS Product
FROM ProductDetail
WHERE CHAR_LENGTH(Products) - CHAR_LENGTH(REPLACE(Products, ',', '')) >= 1
UNION ALL
SELECT OrderID,
    CustomerName,
    TRIM(
        SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', 3), ',', -1)
    ) AS Product
FROM ProductDetail
WHERE CHAR_LENGTH(Products) - CHAR_LENGTH(REPLACE(Products, ',', '')) >= 2;
-- Question 2: Transform to 2NF by removing partial dependencies
-- Current table has composite key: (OrderID, Product)
-- Problem: CustomerName depends only on OrderID (partial dependency)
-- Step 1: Create Orders table to store Order-level information
CREATE TABLE Orders_2NF AS
SELECT DISTINCT OrderID,
    CustomerName
FROM OrderDetails;
-- Step 2: Create OrderItems table to store Product-level information
CREATE TABLE OrderItems_2NF AS
SELECT OrderID,
    Product,
    Quantity
FROM OrderDetails;
-- Step 3: Optional - Show the normalized structure
-- Orders table
SELECT *
FROM Orders_2NF
ORDER BY OrderID;
-- OrderItems table  
SELECT *
FROM OrderItems_2NF
ORDER BY OrderID,
    Product;