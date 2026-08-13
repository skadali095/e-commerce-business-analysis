-- ============================================================
-- 02. SALES PERFORMANCE ANALYSIS
-- ============================================================


-- 1. MONTHLY REVENUE TREND
-- Track realised revenue over time.

SELECT
    YEAR(OrderDate) AS OrderYear,
    MONTH(OrderDate) AS OrderMonth,
    ROUND(SUM(TotalAmount), 2) AS Revenue
FROM Orders
WHERE OrderStatus = 'Delivered'
GROUP BY
    YEAR(OrderDate),
    MONTH(OrderDate)
ORDER BY
    OrderYear,
    OrderMonth;


-- 2. MONTHLY GROSS PROFIT TREND
-- Track gross profit generated over time.

SELECT
    YEAR(OrderDate) AS OrderYear,
    MONTH(OrderDate) AS OrderMonth,
    ROUND(SUM(TotalProfit), 2) AS GrossProfit
FROM Orders
WHERE OrderStatus = 'Delivered'
GROUP BY
    YEAR(OrderDate),
    MONTH(OrderDate)
ORDER BY
    OrderYear,
    OrderMonth;


-- 3. MONTHLY GROSS PROFIT MARGIN
-- Monitor changes in profitability over time.

SELECT
    YEAR(OrderDate) AS OrderYear,
    MONTH(OrderDate) AS OrderMonth,
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


-- 4. MONTHLY AVERAGE ORDER VALUE
-- Track changes in average customer order value.

SELECT
    YEAR(OrderDate) AS OrderYear,
    MONTH(OrderDate) AS OrderMonth,
    ROUND(AVG(FinalAmount), 2) AS AverageOrderValue
FROM Orders
WHERE OrderStatus = 'Delivered'
GROUP BY
    YEAR(OrderDate),
    MONTH(OrderDate)
ORDER BY
    OrderYear,
    OrderMonth;


-- 5. MONTHLY ORDER VOLUME
-- Track the number of delivered orders over time.

SELECT
    YEAR(OrderDate) AS OrderYear,
    MONTH(OrderDate) AS OrderMonth,
    COUNT(*) AS Orders
FROM Orders
WHERE OrderStatus = 'Delivered'
GROUP BY
    YEAR(OrderDate),
    MONTH(OrderDate)
ORDER BY
    OrderYear,
    OrderMonth;


-- 6. BEST SALES MONTHS
-- Identify the calendar months generating the highest revenue.

SELECT
    MONTHNAME(OrderDate) AS Month,
    ROUND(SUM(TotalAmount), 2) AS Revenue
FROM Orders
WHERE OrderStatus = 'Delivered'
GROUP BY
    MONTHNAME(OrderDate),
    MONTH(OrderDate)
ORDER BY Revenue DESC;


-- 7. REVENUE BY ORDER STATUS
-- Compare revenue across order statuses.

SELECT
    OrderStatus,
    COUNT(*) AS Orders,
    ROUND(SUM(TotalAmount), 2) AS Revenue
FROM Orders
GROUP BY OrderStatus
ORDER BY Revenue DESC;


-- 8. PAYMENT METHOD ANALYSIS
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
