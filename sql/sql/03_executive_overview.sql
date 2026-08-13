-- ============================================================
--  EXECUTIVE OVERVIEW
-- ============================================================

-- 1. TOTAL REVENUE
-- Total realised revenue from delivered orders.

SELECT
    ROUND(SUM(TotalAmount), 2) AS TotalRevenue
FROM Orders
WHERE OrderStatus = 'Delivered';


-- 2. TOTAL COST
-- Total cost associated with delivered orders.

SELECT
    ROUND(SUM(TotalCost), 2) AS TotalCost
FROM Orders
WHERE OrderStatus = 'Delivered';


-- 3. TOTAL GROSS PROFIT
-- Gross profit generated from delivered orders.

SELECT
    ROUND(SUM(TotalProfit), 2) AS TotalProfit
FROM Orders
WHERE OrderStatus = 'Delivered';


-- 4. GROSS PROFIT MARGIN
-- Measure overall gross profitability.

SELECT
    ROUND(
        SUM(TotalProfit) * 100.0 /
        NULLIF(SUM(TotalAmount), 0),
        2
    ) AS ProfitMargin
FROM Orders
WHERE OrderStatus = 'Delivered';


-- 5. AVERAGE ORDER VALUE
-- Average realised value of a delivered order.

SELECT
    ROUND(AVG(FinalAmount), 2) AS AverageOrderValue
FROM Orders
WHERE OrderStatus = 'Delivered';


-- 6. TOTAL CUSTOMERS
-- Number of unique customers who generated delivered orders.

SELECT
    COUNT(DISTINCT CustomerID) AS Customers
FROM Orders
WHERE OrderStatus = 'Delivered';


-- 7. TOTAL UNITS SOLD
-- Total quantity of products sold.

SELECT
    SUM(Quantity) AS UnitsSold
FROM OrderItems;


-- 8. DELIVERED ORDERS
-- Total number of successfully delivered orders.

SELECT
    COUNT(*) AS DeliveredOrders
FROM Orders
WHERE OrderStatus = 'Delivered';


-- 9. ORDER RETURN RATE
-- Percentage of delivered orders associated with at least one return.

SELECT
    ROUND(
        COUNT(DISTINCT r.OrderID) * 100.0 /
        COUNT(DISTINCT o.OrderID),
        2
    ) AS ReturnRate
FROM Orders o
LEFT JOIN ProductReturns r
    ON o.OrderID = r.OrderID
WHERE o.OrderStatus = 'Delivered';
