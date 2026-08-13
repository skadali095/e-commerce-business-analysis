-- ============================================
-- SALES PERFORMANCE ANALYSIS
-- ============================================

-- Monthly Revenue Trend
SELECT
    YEAR(OrderDate) AS OrderYear,
    MONTH(OrderDate) AS OrderMonth,
    ROUND(SUM(TotalAmount),2) AS Revenue
FROM Orders
WHERE OrderStatus = 'Delivered'
GROUP BY
    YEAR(OrderDate),
    MONTH(OrderDate)
ORDER BY
    OrderYear,
    OrderMonth;
    
-- Monthly Gross Profit Trend
SELECT
    YEAR(OrderDate) AS OrderYear,
    MONTH(OrderDate) AS OrderMonth,
    ROUND(SUM(TotalProfit),2) AS GrossProfit
FROM Orders
WHERE OrderStatus='Delivered'
GROUP BY
    YEAR(OrderDate),
    MONTH(OrderDate)
ORDER BY
    OrderYear,
    OrderMonth;
    
-- Monthly Gross Profit Margin
SELECT
    YEAR(OrderDate) AS OrderYear,
    MONTH(OrderDate) AS OrderMonth,
    ROUND(SUM(TotalProfit) * 100.0 /SUM(TotalAmount),2) AS GrossProfitMargin
FROM Orders
WHERE OrderStatus='Delivered'
GROUP BY
    YEAR(OrderDate),
    MONTH(OrderDate)
ORDER BY
    OrderYear,
    OrderMonth;
    
-- Monthly Average Order Value (AOV)
SELECT
    YEAR(OrderDate) AS OrderYear,
    MONTH(OrderDate) AS OrderMonth,
    ROUND(AVG(FinalAmount),2) AS AverageOrderValue
FROM Orders
WHERE OrderStatus='Delivered'
GROUP BY
    YEAR(OrderDate),
    MONTH(OrderDate)
ORDER BY
    OrderYear,
    OrderMonth;
    
-- Monthly Order Volume
SELECT
	YEAR(OrderDate) AS OrderYear,
	MONTH(OrderDate) AS OrderMonth,
	COUNT(*) AS Orders
FROM Orders
WHERE OrderStatus='Delivered'
GROUP BY
	YEAR(OrderDate),
	MONTH(OrderDate)
ORDER BY
	OrderYear,
	OrderMonth;
    
-- Best Sales Months
SELECT
	MONTHNAME(OrderDate) AS Month,
	ROUND(SUM(TotalAmount),2) AS Revenue
FROM Orders
WHERE OrderStatus='Delivered'
GROUP BY
	MONTHNAME(OrderDate),
MONTH(OrderDate)
ORDER BY Revenue DESC;

-- Revenue by Order Status
SELECT
	OrderStatus,
	COUNT(*) AS Orders,ROUND(SUM(TotalAmount),2) AS Revenue
FROM Orders
GROUP BY OrderStatus
ORDER BY Revenue DESC;

-- Payment Method Analysis
SELECT
	PaymentMethod,
	COUNT(*) AS Orders,
	ROUND(SUM(TotalAmount),2) AS Revenue,
	ROUND(AVG(FinalAmount),2) AS AverageOrderValue
FROM Orders
WHERE OrderStatus='Delivered'
GROUP BY PaymentMethod
ORDER BY Revenue DESC;
