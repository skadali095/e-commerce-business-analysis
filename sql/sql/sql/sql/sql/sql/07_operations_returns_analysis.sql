-- ============================================================
-- 05. OPERATIONS AND RETURNS ANALYSIS
-- ============================================================


-- 1. ORDER STATUS DISTRIBUTION
-- Understand the overall order fulfilment status.

SELECT
    OrderStatus,
    COUNT(*) AS TotalOrders,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS OrderPercentage
FROM Orders
GROUP BY OrderStatus
ORDER BY TotalOrders DESC;


-- 2. REVENUE BY ORDER STATUS
-- Compare revenue generated across different order statuses.

SELECT
    OrderStatus,
    COUNT(*) AS Orders,
    ROUND(SUM(TotalAmount), 2) AS Revenue
FROM Orders
GROUP BY OrderStatus
ORDER BY Revenue DESC;


-- 3. PAYMENT METHOD ANALYSIS
-- Compare order volume, revenue and AOV across payment methods.

SELECT
    PaymentMethod,
    COUNT(*) AS Orders,
    ROUND(SUM(TotalAmount), 2) AS Revenue,
    ROUND(AVG(FinalAmount), 2) AS AverageOrderValue
FROM Orders
WHERE OrderStatus = 'Delivered'
GROUP BY PaymentMethod
ORDER BY Revenue DESC;


-- 4. CANCELLATION RATE BY PAYMENT METHOD
-- Identify payment methods associated with higher cancellation rates.

SELECT
    PaymentMethod,
    COUNT(*) AS TotalOrders,
    SUM(
        CASE
            WHEN OrderStatus = 'Cancelled' THEN 1
            ELSE 0
        END
    ) AS CancelledOrders,
    ROUND(
        SUM(
            CASE
                WHEN OrderStatus = 'Cancelled' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS CancellationRate
FROM Orders
GROUP BY PaymentMethod
ORDER BY CancellationRate DESC;


-- 5. AVERAGE BASKET SIZE
-- Measure the average number of products purchased per order.

SELECT
    ROUND(AVG(TotalItems), 2) AS AverageBasketSize
FROM (
    SELECT
        OrderID,
        SUM(Quantity) AS TotalItems
    FROM OrderItems
    GROUP BY OrderID
) t;


-- 6. ORDER VALUE DISTRIBUTION
-- Understand the distribution of delivered orders by order value.

SELECT
    CASE
        WHEN FinalAmount < 10000 THEN 'Below ₹10K'
        WHEN FinalAmount < 25000 THEN '₹10K-25K'
        WHEN FinalAmount < 50000 THEN '₹25K-50K'
        WHEN FinalAmount < 100000 THEN '₹50K-100K'
        ELSE 'Above ₹100K'
    END AS OrderValue,
    COUNT(*) AS Orders
FROM Orders
WHERE OrderStatus = 'Delivered'
GROUP BY OrderValue
ORDER BY Orders DESC;


-- 7. ITEM RETURN RATE
-- Measure the percentage of delivered order items that were returned.

SELECT
    ROUND(
        COUNT(*) * 100.0 /
        (
            SELECT COUNT(*)
            FROM OrderItems oi
            JOIN Orders o
                ON oi.OrderID = o.OrderID
            WHERE o.OrderStatus = 'Delivered'
        ),
        2
    ) AS ItemReturnRate
FROM ProductReturns;


-- 8. ORDER RETURN RATE
-- Measure the percentage of delivered orders that had at least one return.

SELECT
    ROUND(
        COUNT(DISTINCT r.OrderID) * 100.0 /
        COUNT(DISTINCT o.OrderID),
        2
    ) AS OrderReturnRate
FROM Orders o
LEFT JOIN ProductReturns r
    ON o.OrderID = r.OrderID
WHERE o.OrderStatus = 'Delivered';


-- 9. RETURN RATE BY CATEGORY
-- Identify product categories with higher return rates.

SELECT
    p.Category,
    ROUND(
        COUNT(DISTINCT r.ReturnID) * 100.0 /
        NULLIF(COUNT(DISTINCT oi.OrderItemID), 0),
        2
    ) AS ReturnRate
FROM OrderItems oi
JOIN Orders o
    ON oi.OrderID = o.OrderID
JOIN Products p
    ON oi.ProductID = p.ProductID
LEFT JOIN ProductReturns r
    ON oi.OrderID = r.OrderID
    AND oi.ProductID = r.ProductID
WHERE o.OrderStatus = 'Delivered'
GROUP BY p.Category
ORDER BY ReturnRate DESC;


-- 10. RETURN REASONS
-- Identify the most common reasons for product returns.

SELECT
    Reason,
    COUNT(*) AS TotalReturns,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS Percentage
FROM ProductReturns
GROUP BY Reason
ORDER BY TotalReturns DESC;


-- 11. MOST RETURNED PRODUCTS
-- Identify products with the highest number of returns.

SELECT
    p.ProductName,
    COUNT(*) AS Returns
FROM ProductReturns r
JOIN Products p
    ON r.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY Returns DESC
LIMIT 10;


-- 12. HIGH-REVENUE PRODUCTS WITH RETURN ACTIVITY
-- Identify high-revenue products that also experience returns.

SELECT
    p.ProductName,
    ROUND(SUM(oi.LineRevenue), 2) AS Revenue,
    COUNT(DISTINCT r.ReturnID) AS Returns
FROM OrderItems oi
JOIN Orders o
    ON oi.OrderID = o.OrderID
JOIN Products p
    ON oi.ProductID = p.ProductID
LEFT JOIN ProductReturns r
    ON oi.OrderID = r.OrderID
    AND oi.ProductID = r.ProductID
WHERE o.OrderStatus = 'Delivered'
GROUP BY p.ProductName
HAVING Returns > 0
ORDER BY Revenue DESC, Returns DESC
LIMIT 15;
