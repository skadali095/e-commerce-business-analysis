-- ============================================
-- PROFITABILITY ANALYSIS
-- ============================================


-- 1. OVERALL PROFITABILITY
-- Evaluate the company's overall revenue, cost and gross profit performance.

SELECT
    ROUND(SUM(TotalAmount), 2) AS Revenue,
    ROUND(SUM(TotalCost), 2) AS TotalCost,
    ROUND(SUM(TotalProfit), 2) AS GrossProfit,
    ROUND(
        SUM(TotalProfit) * 100.0 /
        NULLIF(SUM(TotalAmount), 0),
        2
    ) AS GrossProfitMargin
FROM Orders
WHERE OrderStatus = 'Delivered';


-- 2. MONTHLY PROFITABILITY TREND
-- Analyze how revenue, gross profit and profit margin change over time.

SELECT
    YEAR(OrderDate) AS OrderYear,
    MONTH(OrderDate) AS OrderMonth,
    ROUND(SUM(TotalAmount), 2) AS Revenue,
    ROUND(SUM(TotalCost), 2) AS TotalCost,
    ROUND(SUM(TotalProfit), 2) AS GrossProfit,
    ROUND(
        SUM(TotalProfit) * 100.0 /
        NULLIF(SUM(TotalAmount), 0),
        2
    ) AS GrossProfitMargin
FROM Orders
WHERE OrderStatus = 'Delivered'
GROUP BY
    YEAR(OrderDate),
    MONTH(OrderDate)
ORDER BY
    OrderYear,
    OrderMonth;


-- 3. PROFITABILITY BY CATEGORY
-- Identify which product categories generate the highest gross profit.

SELECT
    p.Category,
    ROUND(SUM(oi.LineRevenue), 2) AS Revenue,
    ROUND(SUM(oi.LineProfit), 2) AS GrossProfit,
    ROUND(
        SUM(oi.LineProfit) * 100.0 /
        NULLIF(SUM(SUM(oi.LineProfit)) OVER (), 0),
        2
    ) AS ProfitContribution,
    ROUND(
        SUM(oi.LineProfit) * 100.0 /
        NULLIF(SUM(oi.LineRevenue), 0),
        2
    ) AS GrossProfitMargin
FROM OrderItems oi
JOIN Products p
    ON oi.ProductID = p.ProductID
JOIN Orders o
    ON oi.OrderID = o.OrderID
WHERE o.OrderStatus = 'Delivered'
GROUP BY p.Category
ORDER BY GrossProfit DESC;


-- 4. REVENUE VS PROFIT CONTRIBUTION
-- Identify categories whose contribution to profit differs significantly from their revenue contribution.

SELECT
    p.Category,
    ROUND(SUM(oi.LineRevenue), 2) AS Revenue,
    ROUND(
        SUM(oi.LineRevenue) * 100.0 /
        SUM(SUM(oi.LineRevenue)) OVER (),
        2
    ) AS RevenueContribution,
    ROUND(SUM(oi.LineProfit), 2) AS GrossProfit,
    ROUND(
        SUM(oi.LineProfit) * 100.0 /
        SUM(SUM(oi.LineProfit)) OVER (),
        2
    ) AS ProfitContribution,
    ROUND(
        (
            SUM(oi.LineProfit) * 100.0 /
            SUM(SUM(oi.LineProfit)) OVER ()
        ) -
        (
            SUM(oi.LineRevenue) * 100.0 /
            SUM(SUM(oi.LineRevenue)) OVER ()
        ),
        2
    ) AS ContributionGap
FROM OrderItems oi
JOIN Products p
    ON oi.ProductID = p.ProductID
JOIN Orders o
    ON oi.OrderID = o.OrderID
WHERE o.OrderStatus = 'Delivered'
GROUP BY p.Category
ORDER BY Revenue DESC;


-- 5. PROFITABILITY BY BRAND
-- Identify brands that generate the highest revenue and gross profit.

SELECT
    p.Brand,
    ROUND(SUM(oi.LineRevenue), 2) AS Revenue,
    ROUND(SUM(oi.LineProfit), 2) AS GrossProfit,
    ROUND(
        SUM(oi.LineProfit) * 100.0 /
        NULLIF(SUM(oi.LineRevenue), 0),
        2
    ) AS GrossProfitMargin
FROM OrderItems oi
JOIN Products p
    ON oi.ProductID = p.ProductID
JOIN Orders o
    ON oi.OrderID = o.OrderID
WHERE o.OrderStatus = 'Delivered'
GROUP BY p.Brand
ORDER BY GrossProfit DESC;


-- 6. PROFITABILITY BY SUPPLIER
-- Compare suppliers based on revenue, gross profit and margin.

SELECT
    p.Supplier,
    ROUND(SUM(oi.LineRevenue), 2) AS Revenue,
    ROUND(SUM(oi.LineProfit), 2) AS GrossProfit,
    ROUND(
        SUM(oi.LineProfit) * 100.0 /
        NULLIF(SUM(oi.LineRevenue), 0),
        2
    ) AS GrossProfitMargin
FROM OrderItems oi
JOIN Products p
    ON oi.ProductID = p.ProductID
JOIN Orders o
    ON oi.OrderID = o.OrderID
WHERE o.OrderStatus = 'Delivered'
GROUP BY p.Supplier
ORDER BY GrossProfit DESC;


-- 7. TOP 10 PRODUCTS BY GROSS PROFIT
-- Identify the products contributing the most absolute gross profit.

SELECT
    p.ProductName,
    p.Category,
    ROUND(SUM(oi.LineRevenue), 2) AS Revenue,
    ROUND(SUM(oi.LineProfit), 2) AS GrossProfit,
    ROUND(
        SUM(oi.LineProfit) * 100.0 /
        NULLIF(SUM(oi.LineRevenue), 0),
        2
    ) AS GrossProfitMargin
FROM OrderItems oi
JOIN Products p
    ON oi.ProductID = p.ProductID
JOIN Orders o
    ON oi.OrderID = o.OrderID
WHERE o.OrderStatus = 'Delivered'
GROUP BY
    p.ProductID,
    p.ProductName,
    p.Category
ORDER BY GrossProfit DESC
LIMIT 10;


-- 8. LOW-MARGIN PRODUCTS
-- Identify products generating revenue but operating with relatively low gross margins.

SELECT
    p.ProductName,
    p.Category,
    ROUND(SUM(oi.LineRevenue), 2) AS Revenue,
    ROUND(SUM(oi.LineProfit), 2) AS GrossProfit,
    ROUND(
        SUM(oi.LineProfit) * 100.0 /
        NULLIF(SUM(oi.LineRevenue), 0),
        2
    ) AS GrossProfitMargin
FROM OrderItems oi
JOIN Products p
    ON oi.ProductID = p.ProductID
JOIN Orders o
    ON oi.OrderID = o.OrderID
WHERE o.OrderStatus = 'Delivered'
GROUP BY
    p.ProductID,
    p.ProductName,
    p.Category
HAVING SUM(oi.LineRevenue) > 0
ORDER BY GrossProfitMargin ASC
LIMIT 10;


-- 9. HIGH-REVENUE LOW-MARGIN PRODUCTS
-- Identify products where strong sales volume is accompanied by weak profitability.

SELECT
    p.ProductName,
    p.Category,
    ROUND(SUM(oi.LineRevenue), 2) AS Revenue,
    ROUND(SUM(oi.LineProfit), 2) AS GrossProfit,
    ROUND(
        SUM(oi.LineProfit) * 100.0 /
        NULLIF(SUM(oi.LineRevenue), 0),
        2
    ) AS GrossProfitMargin
FROM OrderItems oi
JOIN Products p
    ON oi.ProductID = p.ProductID
JOIN Orders o
    ON oi.OrderID = o.OrderID
WHERE o.OrderStatus = 'Delivered'
GROUP BY
    p.ProductID,
    p.ProductName,
    p.Category
HAVING SUM(oi.LineRevenue) > 50000000
ORDER BY GrossProfitMargin ASC;


-- 10. TOP CUSTOMERS BY GROSS PROFIT
-- Identify customers who contribute the most absolute gross profit.

SELECT
    c.CustomerID,
    c.FullName,
    COUNT(o.OrderID) AS TotalOrders,
    ROUND(SUM(o.TotalAmount), 2) AS Revenue,
    ROUND(SUM(o.TotalProfit), 2) AS GrossProfit,
    ROUND(
        SUM(o.TotalProfit) * 100.0 /
        NULLIF(SUM(o.TotalAmount), 0),
        2
    ) AS GrossProfitMargin
FROM Customers c
JOIN Orders o
    ON c.CustomerID = o.CustomerID
WHERE o.OrderStatus = 'Delivered'
GROUP BY
    c.CustomerID,
    c.FullName
ORDER BY GrossProfit DESC
LIMIT 10;


-- 11. REPEAT VS ONE-TIME CUSTOMER PROFITABILITY
-- Compare profitability between repeat and one-time customers.

SELECT
    CASE
        WHEN c.OrderCount = 1
            THEN 'One-time Customer'
        ELSE 'Repeat Customer'
    END AS CustomerType,
    COUNT(DISTINCT c.CustomerID) AS Customers,
    ROUND(SUM(o.TotalAmount), 2) AS Revenue,
    ROUND(SUM(o.TotalProfit), 2) AS GrossProfit,
    ROUND(
        SUM(o.TotalProfit) * 100.0 /
        NULLIF(SUM(o.TotalAmount), 0),
        2
    ) AS GrossProfitMargin
FROM Customers c
JOIN Orders o
    ON c.CustomerID = o.CustomerID
WHERE o.OrderStatus = 'Delivered'
GROUP BY
    CASE
        WHEN c.OrderCount = 1
            THEN 'One-time Customer'
        ELSE 'Repeat Customer'
    END
ORDER BY GrossProfit DESC;


-- 12. PROFITABILITY BY ORDER VALUE
-- Determine whether higher-value orders generate better gross margins.

SELECT
    CASE
        WHEN FinalAmount < 10000
            THEN 'Below ₹10K'
        WHEN FinalAmount < 25000
            THEN '₹10K-25K'
        WHEN FinalAmount < 50000
            THEN '₹25K-50K'
        WHEN FinalAmount < 100000
            THEN '₹50K-100K'
        ELSE 'Above ₹100K'
    END AS OrderValue,
    COUNT(*) AS Orders,
    ROUND(SUM(TotalAmount), 2) AS Revenue,
    ROUND(SUM(TotalProfit), 2) AS GrossProfit,
    ROUND(
        SUM(TotalProfit) * 100.0 /
        NULLIF(SUM(TotalAmount), 0),
        2
    ) AS GrossProfitMargin
FROM Orders
WHERE OrderStatus = 'Delivered'
GROUP BY OrderValue
ORDER BY GrossProfit DESC;


-- 13. PROFITABILITY BY PAYMENT METHOD
-- Compare revenue and gross profit across payment methods.

SELECT
    PaymentMethod,
    COUNT(*) AS Orders,
    ROUND(SUM(TotalAmount), 2) AS Revenue,
    ROUND(SUM(TotalProfit), 2) AS GrossProfit,
    ROUND(
        SUM(TotalProfit) * 100.0 /
        NULLIF(SUM(TotalAmount), 0),
        2
    ) AS GrossProfitMargin
FROM Orders
WHERE OrderStatus = 'Delivered'
GROUP BY PaymentMethod
ORDER BY GrossProfit DESC;


-- 14. PROFITABILITY IMPACT OF RETURNS
-- Compare the profitability of returned and non-returned orders.

SELECT
    CASE
        WHEN r.OrderID IS NOT NULL
            THEN 'Returned Order'
        ELSE 'Non-Returned Order'
    END AS ReturnStatus,
    COUNT(DISTINCT o.OrderID) AS Orders,
    ROUND(SUM(o.TotalAmount), 2) AS Revenue,
    ROUND(SUM(o.TotalProfit), 2) AS GrossProfit,
    ROUND(
        SUM(o.TotalProfit) * 100.0 /
        NULLIF(SUM(o.TotalAmount), 0),
        2
    ) AS GrossProfitMargin
FROM Orders o
LEFT JOIN (
    SELECT DISTINCT OrderID
    FROM ProductReturns
) r
    ON o.OrderID = r.OrderID
WHERE o.OrderStatus = 'Delivered'
GROUP BY
    CASE
        WHEN r.OrderID IS NOT NULL
            THEN 'Returned Order'
        ELSE 'Non-Returned Order'
    END
ORDER BY GrossProfit DESC;


-- 15. PROFITABILITY BY MONTH
-- Identify months with the strongest and weakest gross profit margins.

SELECT
    MONTHNAME(OrderDate) AS Month,
    ROUND(SUM(TotalAmount), 2) AS Revenue,
    ROUND(SUM(TotalProfit), 2) AS GrossProfit,
    ROUND(
        SUM(TotalProfit) * 100.0 /
        NULLIF(SUM(TotalAmount), 0),
        2
    ) AS GrossProfitMargin
FROM Orders
WHERE OrderStatus = 'Delivered'
GROUP BY
    MONTHNAME(OrderDate),
    MONTH(OrderDate)
ORDER BY GrossProfitMargin DESC;
