-- ============================================================
-- 03. CUSTOMER ANALYSIS
-- ============================================================


-- 1. TOP 10 CUSTOMERS BY LIFETIME REVENUE
-- Identify the highest-value customers by realised revenue.

SELECT
    c.CustomerID,
    c.FullName,
    COUNT(o.OrderID) AS TotalOrders,
    ROUND(SUM(o.TotalAmount), 2) AS Revenue,
    ROUND(SUM(o.TotalProfit), 2) AS GrossProfit
FROM Customers c
JOIN Orders o
    ON c.CustomerID = o.CustomerID
WHERE o.OrderStatus = 'Delivered'
GROUP BY
    c.CustomerID,
    c.FullName
ORDER BY Revenue DESC
LIMIT 10;


-- 2. CUSTOMER LIFETIME VALUE DISTRIBUTION
-- Understand how customers are distributed by lifetime spending.

SELECT
    CASE
        WHEN LifetimeSpend < 10000 THEN 'Below ₹10K'
        WHEN LifetimeSpend < 50000 THEN '₹10K–50K'
        WHEN LifetimeSpend < 100000 THEN '₹50K–100K'
        WHEN LifetimeSpend < 250000 THEN '₹100K–250K'
        ELSE 'Above ₹250K'
    END AS SpendingSegment,
    COUNT(*) AS Customers
FROM Customers
GROUP BY SpendingSegment
ORDER BY Customers DESC;


-- 3. REPEAT PURCHASE ANALYSIS
-- Classify customers as one-time or repeat customers.

SELECT
    CASE
        WHEN OrderCount = 1 THEN 'One-time Customer'
        ELSE 'Repeat Customer'
    END AS CustomerType,
    COUNT(*) AS Customers
FROM Customers
GROUP BY CustomerType;


-- 4. AVERAGE REVENUE PER CUSTOMER
-- Measure average realised revenue generated per customer.

SELECT
    ROUND(
        SUM(TotalAmount) /
        NULLIF(COUNT(DISTINCT CustomerID), 0),
        2
    ) AS RevenuePerCustomer
FROM Orders
WHERE OrderStatus = 'Delivered';


-- 5. CUSTOMER RANKING BY ORDER FREQUENCY
-- Identify customers placing the highest number of orders.

SELECT
    CustomerID,
    COUNT(*) AS Orders,
    ROUND(SUM(TotalAmount), 2) AS Revenue
FROM Orders
WHERE OrderStatus = 'Delivered'
GROUP BY CustomerID
ORDER BY
    Orders DESC,
    Revenue DESC
LIMIT 10;


-- 6. REVENUE BY CITY
-- Compare customer activity and revenue across cities.

SELECT
    c.City,
    COUNT(DISTINCT o.CustomerID) AS Customers,
    COUNT(o.OrderID) AS Orders,
    ROUND(SUM(o.TotalAmount), 2) AS Revenue
FROM Customers c
JOIN Orders o
    ON c.CustomerID = o.CustomerID
WHERE o.OrderStatus = 'Delivered'
GROUP BY c.City
ORDER BY Revenue DESC;


-- 7. AVERAGE ORDER VALUE BY CITY
-- Compare customer order values across cities.

SELECT
    c.City,
    ROUND(AVG(o.FinalAmount), 2) AS AverageOrderValue
FROM Customers c
JOIN Orders o
    ON c.CustomerID = o.CustomerID
WHERE o.OrderStatus = 'Delivered'
GROUP BY c.City
ORDER BY AverageOrderValue DESC;


-- 8. CUSTOMER ACQUISITION TREND
-- Track the number of new customers acquired over time.

SELECT
    YEAR(SignUpDate) AS SignupYear,
    MONTH(SignUpDate) AS SignupMonth,
    COUNT(*) AS NewCustomers
FROM Customers
GROUP BY
    YEAR(SignUpDate),
    MONTH(SignUpDate)
ORDER BY
    SignupYear,
    SignupMonth;


-- 9. REPEAT CUSTOMER RATE
-- Measure the percentage of customers who placed multiple orders.

SELECT
    ROUND(
        SUM(
            CASE
                WHEN OrderCount > 1 THEN 1
                ELSE 0
            END
        ) * 100.0 /
        NULLIF(
            SUM(
                CASE
                    WHEN OrderCount >= 1 THEN 1
                    ELSE 0
                END
            ),
            0
        ),
        2
    ) AS RepeatCustomerRate
FROM (
    SELECT
        c.CustomerID,
        COUNT(o.OrderID) AS OrderCount
    FROM Customers c
    LEFT JOIN Orders o
        ON c.CustomerID = o.CustomerID
    GROUP BY c.CustomerID
) t;


-- 10. REPEAT VS ONE-TIME CUSTOMER PERFORMANCE
-- Compare customer groups by revenue, profitability and AOV.

SELECT
    CASE
        WHEN c.OrderCount = 1 THEN 'One-time Customer'
        ELSE 'Repeat Customer'
    END AS CustomerType,
    COUNT(DISTINCT c.CustomerID) AS Customers,
    COUNT(DISTINCT o.OrderID) AS Orders,
    ROUND(SUM(o.TotalAmount), 2) AS Revenue,
    ROUND(SUM(o.TotalProfit), 2) AS GrossProfit,
    ROUND(
        SUM(o.TotalProfit) * 100.0 /
        NULLIF(SUM(o.TotalAmount), 0),
        2
    ) AS GrossProfitMargin,
    ROUND(
        SUM(o.TotalAmount) /
        NULLIF(COUNT(DISTINCT o.OrderID), 0),
        2
    ) AS AOV
FROM Customers c
JOIN Orders o
    ON c.CustomerID = o.CustomerID
WHERE o.OrderStatus = 'Delivered'
GROUP BY
    CASE
        WHEN c.OrderCount = 1 THEN 'One-time Customer'
        ELSE 'Repeat Customer'
    END
ORDER BY Revenue DESC;


-- 11. REVENUE CONTRIBUTION BY CUSTOMER TYPE
-- Compare the revenue contribution of repeat and one-time customers.

SELECT
    CASE
        WHEN c.OrderCount = 1 THEN 'One-time Customer'
        ELSE 'Repeat Customer'
    END AS CustomerType,
    ROUND(SUM(o.TotalAmount), 2) AS Revenue,
    ROUND(
        SUM(o.TotalAmount) * 100.0 /
        SUM(SUM(o.TotalAmount)) OVER (),
        2
    ) AS RevenueContribution
FROM Customers c
JOIN Orders o
    ON c.CustomerID = o.CustomerID
WHERE o.OrderStatus = 'Delivered'
GROUP BY
    CASE
        WHEN c.OrderCount = 1 THEN 'One-time Customer'
        ELSE 'Repeat Customer'
    END;


-- 12. TOP 10 CUSTOMERS BY GROSS PROFIT
-- Identify the customers generating the highest gross profit.

SELECT
    c.CustomerID,
    c.FullName,
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
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


-- 13. TOP REVENUE CUSTOMERS VS PROFIT
-- Compare revenue generated by top customers with their profitability.

SELECT
    c.CustomerID,
    c.FullName,
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
ORDER BY Revenue DESC
LIMIT 10;


-- 14. REVENUE CONCENTRATION
-- Rank customers by realised revenue.

WITH CustomerRevenue AS (
    SELECT
        c.CustomerID,
        SUM(o.TotalAmount) AS Revenue
    FROM Customers c
    JOIN Orders o
        ON c.CustomerID = o.CustomerID
    WHERE o.OrderStatus = 'Delivered'
    GROUP BY c.CustomerID
),
RankedCustomers AS (
    SELECT
        CustomerID,
        Revenue,
        ROW_NUMBER() OVER (
            ORDER BY Revenue DESC
        ) AS CustomerRank
    FROM CustomerRevenue
)
SELECT
    CustomerRank,
    ROUND(Revenue, 2) AS Revenue
FROM RankedCustomers
WHERE CustomerRank <= 20
ORDER BY CustomerRank;


-- 15. TOP 10% CUSTOMER REVENUE AND PROFIT CONTRIBUTION
-- Measure revenue and profit concentration among the highest-value customers.

WITH CustomerProfitability AS (
    SELECT
        c.CustomerID,
        SUM(o.TotalAmount) AS Revenue,
        SUM(o.TotalProfit) AS GrossProfit
    FROM Customers c
    JOIN Orders o
        ON c.CustomerID = o.CustomerID
    WHERE o.OrderStatus = 'Delivered'
    GROUP BY c.CustomerID
),
RankedCustomers AS (
    SELECT
        CustomerID,
        Revenue,
        GrossProfit,
        ROW_NUMBER() OVER (
            ORDER BY Revenue DESC
        ) AS CustomerRank,
        COUNT(*) OVER () AS TotalCustomers
    FROM CustomerProfitability
)
SELECT
    ROUND(
        SUM(
            CASE
                WHEN CustomerRank <= CEIL(TotalCustomers * 0.10)
                THEN Revenue
                ELSE 0
            END
        ) * 100.0 /
        SUM(Revenue),
        2
    ) AS Top10RevenueContribution,

    ROUND(
        SUM(
            CASE
                WHEN CustomerRank <= CEIL(TotalCustomers * 0.10)
                THEN GrossProfit
                ELSE 0
            END
        ) * 100.0 /
        SUM(GrossProfit),
        2
    ) AS Top10ProfitContribution
FROM RankedCustomers;
