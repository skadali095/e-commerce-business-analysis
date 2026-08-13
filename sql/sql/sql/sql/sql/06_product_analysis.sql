-- ============================================================
--  PRODUCT ANALYSIS
-- ============================================================


-- 1. REVENUE BY CATEGORY
-- Identify the categories generating the most revenue.

SELECT
    p.Category,
    ROUND(SUM(oi.LineRevenue), 2) AS Revenue,
    ROUND(
        SUM(oi.LineRevenue) * 100.0 /
        SUM(SUM(oi.LineRevenue)) OVER (),
        2
    ) AS RevenueContribution
FROM OrderItems oi
JOIN Products p
    ON oi.ProductID = p.ProductID
JOIN Orders o
    ON oi.OrderID = o.OrderID
WHERE o.OrderStatus = 'Delivered'
GROUP BY p.Category
ORDER BY Revenue DESC;


-- 2. GROSS PROFIT BY CATEGORY
-- Identify categories generating the most gross profit.

SELECT
    p.Category,
    ROUND(SUM(oi.LineProfit), 2) AS GrossProfit,
    ROUND(
        SUM(oi.LineProfit) * 100.0 /
        SUM(SUM(oi.LineProfit)) OVER (),
        2
    ) AS ProfitContribution
FROM OrderItems oi
JOIN Products p
    ON oi.ProductID = p.ProductID
JOIN Orders o
    ON oi.OrderID = o.OrderID
WHERE o.OrderStatus = 'Delivered'
GROUP BY p.Category
ORDER BY GrossProfit DESC;


-- 3. GROSS PROFIT MARGIN BY CATEGORY
-- Compare profitability across product categories.

SELECT
    p.Category,
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
ORDER BY GrossProfitMargin DESC;


-- 4. TOP 10 PRODUCTS BY REVENUE
-- Identify the products driving the highest revenue.

SELECT
    p.ProductName,
    p.Category,
    ROUND(SUM(oi.LineRevenue), 2) AS Revenue,
    SUM(oi.Quantity) AS UnitsSold
FROM OrderItems oi
JOIN Products p
    ON oi.ProductID = p.ProductID
JOIN Orders o
    ON oi.OrderID = o.OrderID
WHERE o.OrderStatus = 'Delivered'
GROUP BY
    p.ProductName,
    p.Category
ORDER BY Revenue DESC
LIMIT 10;


-- 5. TOP 10 PRODUCTS BY GROSS PROFIT
-- Identify the products generating the highest gross profit.

SELECT
    p.ProductName,
    ROUND(SUM(oi.LineProfit), 2) AS GrossProfit,
    SUM(oi.Quantity) AS UnitsSold
FROM OrderItems oi
JOIN Products p
    ON oi.ProductID = p.ProductID
JOIN Orders o
    ON oi.OrderID = o.OrderID
WHERE o.OrderStatus = 'Delivered'
GROUP BY p.ProductName
ORDER BY GrossProfit DESC
LIMIT 10;


-- 6. LOWEST PERFORMING PRODUCTS
-- Identify products with the lowest realised revenue.

SELECT
    p.ProductName,
    ROUND(SUM(oi.LineRevenue), 2) AS Revenue,
    SUM(oi.Quantity) AS UnitsSold
FROM OrderItems oi
JOIN Products p
    ON oi.ProductID = p.ProductID
JOIN Orders o
    ON oi.OrderID = o.OrderID
WHERE o.OrderStatus = 'Delivered'
GROUP BY p.ProductName
ORDER BY Revenue
LIMIT 10;


-- 7. BRAND PERFORMANCE
-- Compare revenue, gross profit and unit sales by brand.

SELECT
    p.Brand,
    ROUND(SUM(oi.LineRevenue), 2) AS Revenue,
    ROUND(SUM(oi.LineProfit), 2) AS GrossProfit,
    SUM(oi.Quantity) AS UnitsSold
FROM OrderItems oi
JOIN Products p
    ON oi.ProductID = p.ProductID
JOIN Orders o
    ON oi.OrderID = o.OrderID
WHERE o.OrderStatus = 'Delivered'
GROUP BY p.Brand
ORDER BY Revenue DESC;


-- 8. SUPPLIER PERFORMANCE
-- Compare supplier contribution to revenue and gross profit.

SELECT
    p.Supplier,
    ROUND(SUM(oi.LineRevenue), 2) AS Revenue,
    ROUND(SUM(oi.LineProfit), 2) AS GrossProfit
FROM OrderItems oi
JOIN Products p
    ON oi.ProductID = p.ProductID
JOIN Orders o
    ON oi.OrderID = o.OrderID
WHERE o.OrderStatus = 'Delivered'
GROUP BY p.Supplier
ORDER BY Revenue DESC;


-- 9. AVERAGE SELLING PRICE BY CATEGORY
-- Compare average realised selling prices across categories.

SELECT
    p.Category,
    ROUND(AVG(oi.PricePerUnit), 2) AS AverageSellingPrice
FROM OrderItems oi
JOIN Products p
    ON oi.ProductID = p.ProductID
JOIN Orders o
    ON oi.OrderID = o.OrderID
WHERE o.OrderStatus = 'Delivered'
GROUP BY p.Category
ORDER BY AverageSellingPrice DESC;


-- 10. CATEGORY-WISE UNITS SOLD
-- Identify categories with the highest sales volume.

SELECT
    p.Category,
    SUM(oi.Quantity) AS UnitsSold,
    ROUND(
        SUM(oi.Quantity) * 100.0 /
        SUM(SUM(oi.Quantity)) OVER (),
        2
    ) AS UnitsContribution
FROM OrderItems oi
JOIN Products p
    ON oi.ProductID = p.ProductID
JOIN Orders o
    ON oi.OrderID = o.OrderID
WHERE o.OrderStatus = 'Delivered'
GROUP BY p.Category
ORDER BY UnitsSold DESC;


-- 11. REVENUE VS PROFIT CONTRIBUTION
-- Identify categories where profit contribution differs significantly
-- from revenue contribution.

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
        )
        -
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


-- 12. PRODUCT COUNT BY CATEGORY
-- Understand the number of products available in each category.

SELECT
    Category,
    COUNT(*) AS Products
FROM Products
GROUP BY Category
ORDER BY Products DESC;


-- 13. ITEM RETURN RATE BY PRODUCT RATING
-- Examine whether product ratings are associated with return rates.

SELECT
    p.ProductRating,
    COUNT(DISTINCT p.ProductID) AS Products,
    COUNT(DISTINCT pr.ReturnID) AS Returns,
    ROUND(
        COUNT(DISTINCT pr.ReturnID) * 100.0 /
        NULLIF(COUNT(DISTINCT oi.OrderItemID), 0),
        2
    ) AS ReturnRate
FROM Products p
LEFT JOIN OrderItems oi
    ON p.ProductID = oi.ProductID
LEFT JOIN ProductReturns pr
    ON oi.OrderID = pr.OrderID
    AND oi.ProductID = pr.ProductID
GROUP BY p.ProductRating
ORDER BY p.ProductRating;
