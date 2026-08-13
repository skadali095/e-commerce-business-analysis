-- ============================================
-- DATA VALIDATION
-- ============================================


-- 01. TABLE ROW COUNTS
-- Verify that all major tables contain the expected number of records.

SELECT 'Customers' AS TableName, COUNT(*) AS RowCount
FROM Customers

UNION ALL

SELECT 'Products', COUNT(*)
FROM Products

UNION ALL

SELECT 'Orders', COUNT(*)
FROM Orders

UNION ALL

SELECT 'OrderItems', COUNT(*)
FROM OrderItems

UNION ALL

SELECT 'ProductReturns', COUNT(*)
FROM ProductReturns

UNION ALL

SELECT 'MarketingCampaigns', COUNT(*)
FROM MarketingCampaigns

UNION ALL

SELECT 'CampaignPerformance', COUNT(*)
FROM CampaignPerformance;


-- 02. NULL VALUES IN CUSTOMERS
-- Identify missing values in important customer attributes.

SELECT
    SUM(CustomerID IS NULL) AS MissingCustomerID,
    SUM(FullName IS NULL) AS MissingFullName,
    SUM(Email IS NULL) AS MissingEmail,
    SUM(SignUpDate IS NULL) AS MissingSignUpDate,
    SUM(City IS NULL) AS MissingCity,
    SUM(Country IS NULL) AS MissingCountry
FROM Customers;


-- 03. NULL VALUES IN PRODUCTS
-- Identify missing values in important product attributes.

SELECT
    SUM(ProductID IS NULL) AS MissingProductID,
    SUM(ProductName IS NULL) AS MissingProductName,
    SUM(Category IS NULL) AS MissingCategory,
    SUM(Brand IS NULL) AS MissingBrand,
    SUM(UnitPrice IS NULL) AS MissingUnitPrice
FROM Products;


-- 04. NULL VALUES IN ORDERS
-- Identify missing values in important order attributes.

SELECT
    SUM(OrderID IS NULL) AS MissingOrderID,
    SUM(CustomerID IS NULL) AS MissingCustomerID,
    SUM(OrderDate IS NULL) AS MissingOrderDate,
    SUM(OrderStatus IS NULL) AS MissingOrderStatus,
    SUM(PaymentMethod IS NULL) AS MissingPaymentMethod,
    SUM(TotalAmount IS NULL) AS MissingTotalAmount,
    SUM(FinalAmount IS NULL) AS MissingFinalAmount,
    SUM(TotalCost IS NULL) AS MissingTotalCost,
    SUM(TotalProfit IS NULL) AS MissingTotalProfit
FROM Orders;


-- 05. DUPLICATE CUSTOMER RECORDS
-- Check whether any customer IDs appear more than once.

SELECT
    CustomerID,
    COUNT(*) AS DuplicateCount
FROM Customers
GROUP BY CustomerID
HAVING COUNT(*) > 1;


-- 06. DUPLICATE PRODUCT RECORDS
-- Check whether any product IDs appear more than once.

SELECT
    ProductID,
    COUNT(*) AS DuplicateCount
FROM Products
GROUP BY ProductID
HAVING COUNT(*) > 1;


-- 07. DUPLICATE ORDER RECORDS
-- Check whether any order IDs appear more than once.

SELECT
    OrderID,
    COUNT(*) AS DuplicateCount
FROM Orders
GROUP BY OrderID
HAVING COUNT(*) > 1;


-- 08. DUPLICATE ORDER ITEM RECORDS
-- Check whether any order item IDs appear more than once.

SELECT
    OrderItemID,
    COUNT(*) AS DuplicateCount
FROM OrderItems
GROUP BY OrderItemID
HAVING COUNT(*) > 1;


-- 09. ORPHAN CUSTOMER REFERENCES
-- Identify orders linked to customers that do not exist in the Customers table.

SELECT
    o.OrderID,
    o.CustomerID
FROM Orders o
LEFT JOIN Customers c
    ON o.CustomerID = c.CustomerID
WHERE c.CustomerID IS NULL;


-- 10. ORPHAN PRODUCT REFERENCES IN ORDER ITEMS
-- Identify order items linked to products that do not exist in the Products table.

SELECT
    oi.OrderItemID,
    oi.ProductID
FROM OrderItems oi
LEFT JOIN Products p
    ON oi.ProductID = p.ProductID
WHERE p.ProductID IS NULL;


-- 11. ORPHAN ORDER REFERENCES IN ORDER ITEMS
-- Identify order items linked to orders that do not exist in the Orders table.

SELECT
    oi.OrderItemID,
    oi.OrderID
FROM OrderItems oi
LEFT JOIN Orders o
    ON oi.OrderID = o.OrderID
WHERE o.OrderID IS NULL;


-- 12. ORPHAN REFERENCES IN PRODUCT RETURNS
-- Identify returns linked to non-existing orders or products.

SELECT
    r.ReturnID,
    r.OrderID,
    r.ProductID
FROM ProductReturns r
LEFT JOIN Orders o
    ON r.OrderID = o.OrderID
LEFT JOIN Products p
    ON r.ProductID = p.ProductID
WHERE o.OrderID IS NULL
   OR p.ProductID IS NULL;


-- 13. INVALID ORDER STATUS VALUES
-- Identify orders containing unexpected order status values.

SELECT DISTINCT
    OrderStatus
FROM Orders
WHERE OrderStatus NOT IN (
    'Delivered',
    'Shipped',
    'Processing',
    'Pending',
    'Cancelled'
);


-- 14. INVALID PAYMENT METHODS
-- Identify orders containing unexpected payment methods.

SELECT DISTINCT
    PaymentMethod
FROM Orders
WHERE PaymentMethod NOT IN (
    'UPI',
    'Credit Card',
    'Debit Card',
    'Cash on Delivery',
    'Net Banking'
);


-- 15. INVALID ORDER QUANTITIES
-- Identify order items with zero or negative quantities.

SELECT
    OrderItemID,
    OrderID,
    ProductID,
    Quantity
FROM OrderItems
WHERE Quantity <= 0;


-- 16. INVALID PRODUCT PRICES
-- Identify products with zero or negative selling prices.

SELECT
    ProductID,
    ProductName,
    UnitPrice
FROM Products
WHERE UnitPrice <= 0;


-- 17. INVALID ORDER ITEM PRICES
-- Identify order items with zero or negative selling prices.

SELECT
    OrderItemID,
    OrderID,
    ProductID,
    PricePerUnit
FROM OrderItems
WHERE PricePerUnit <= 0;


-- 18. INVALID ORDER DATES
-- Identify orders outside the expected analysis period.

SELECT
    MIN(OrderDate) AS EarliestOrderDate,
    MAX(OrderDate) AS LatestOrderDate
FROM Orders;


-- 19. CUSTOMER SIGN-UP DATE RANGE
-- Check the overall customer acquisition date range.

SELECT
    MIN(SignUpDate) AS EarliestSignupDate,
    MAX(SignUpDate) AS LatestSignupDate
FROM Customers;


-- 20. RETURN DATE RANGE
-- Check the overall return date range.

SELECT
    MIN(ReturnDate) AS EarliestReturnDate,
    MAX(ReturnDate) AS LatestReturnDate
FROM ProductReturns;


-- 21. RETURNS BEFORE ORDER DATE
-- Identify returns recorded before the corresponding order date.

SELECT
    r.ReturnID,
    r.OrderID,
    o.OrderDate,
    r.ReturnDate
FROM ProductReturns r
JOIN Orders o
    ON r.OrderID = o.OrderID
WHERE r.ReturnDate < o.OrderDate;


-- 22. NEGATIVE FINANCIAL VALUES
-- Identify orders containing negative revenue, cost, or profit values.

SELECT
    OrderID,
    TotalAmount,
    FinalAmount,
    TotalCost,
    TotalProfit
FROM Orders
WHERE TotalAmount < 0
   OR FinalAmount < 0
   OR TotalCost < 0
   OR TotalProfit < 0;


-- 23. PROFIT CALCULATION CONSISTENCY
-- Check whether TotalProfit is consistent with revenue and cost.

SELECT
    OrderID,
    TotalAmount,
    TotalCost,
    TotalProfit,
    ROUND(TotalAmount - TotalCost, 2) AS CalculatedProfit
FROM Orders
WHERE ROUND(TotalAmount - TotalCost, 2) <> ROUND(TotalProfit, 2);


-- 24. ORDER ITEM REVENUE CONSISTENCY
-- Compare calculated line revenue with the stored LineRevenue value.

SELECT
    OrderItemID,
    Quantity,
    PricePerUnit,
    LineRevenue,
    ROUND(Quantity * PricePerUnit, 2) AS CalculatedRevenue
FROM OrderItems
WHERE ROUND(Quantity * PricePerUnit, 2)
      <> ROUND(LineRevenue, 2);


-- 25. ORDER ITEM PROFIT CONSISTENCY
-- Check whether LineProfit is consistent with LineRevenue and product cost.

SELECT
    oi.OrderItemID,
    oi.ProductID,
    oi.LineRevenue,
    oi.LineProfit,
    p.UnitCost,
    ROUND(
        oi.LineRevenue - (oi.Quantity * p.UnitCost),
        2
    ) AS CalculatedProfit
FROM OrderItems oi
JOIN Products p
    ON oi.ProductID = p.ProductID
WHERE ROUND(
        oi.LineRevenue - (oi.Quantity * p.UnitCost),
        2
      ) <> ROUND(oi.LineProfit, 2);


-- 26. ORDER TOTAL VS ORDER ITEM TOTAL
-- Check whether order-level revenue matches the sum of its order items.

SELECT
    o.OrderID,
    o.TotalAmount,
    ROUND(SUM(oi.LineRevenue), 2) AS ItemRevenue
FROM Orders o
JOIN OrderItems oi
    ON o.OrderID = oi.OrderID
GROUP BY
    o.OrderID,
    o.TotalAmount
HAVING ROUND(SUM(oi.LineRevenue), 2)
       <> ROUND(o.TotalAmount, 2);


-- 27. ORDER ITEM COUNT VALIDATION
-- Identify orders that do not contain any order items.

SELECT
    o.OrderID,
    o.OrderStatus
FROM Orders o
LEFT JOIN OrderItems oi
    ON o.OrderID = oi.OrderID
WHERE oi.OrderItemID IS NULL;


-- 28. DELIVERED ORDERS WITH RETURNS
-- Verify that returns are associated with delivered orders.

SELECT
    r.ReturnID,
    r.OrderID,
    o.OrderStatus
FROM ProductReturns r
JOIN Orders o
    ON r.OrderID = o.OrderID
WHERE o.OrderStatus <> 'Delivered';


-- 29. MARKETING CAMPAIGN DATE VALIDATION
-- Identify campaigns where the end date occurs before the start date.

SELECT
    CampaignID,
    CampaignName,
    StartDate,
    EndDate
FROM MarketingCampaigns
WHERE EndDate < StartDate;


-- 30. CAMPAIGN PERFORMANCE DATE VALIDATION
-- Identify campaign performance records outside the campaign period.

SELECT
    cp.CampaignID,
    cp.Date,
    mc.StartDate,
    mc.EndDate
FROM CampaignPerformance cp
JOIN MarketingCampaigns mc
    ON cp.CampaignID = mc.CampaignID
WHERE cp.Date < mc.StartDate
   OR cp.Date > mc.EndDate;


-- 31. CAMPAIGN PERFORMANCE REFERENCE VALIDATION
-- Identify campaign performance records linked to non-existing campaigns.

SELECT
    cp.CampaignID
FROM CampaignPerformance cp
LEFT JOIN MarketingCampaigns mc
    ON cp.CampaignID = mc.CampaignID
WHERE mc.CampaignID IS NULL;


-- 32. NEGATIVE MARKETING VALUES
-- Identify invalid negative values in campaign performance metrics.

SELECT
    CampaignID,
    Date,
    Impressions,
    Clicks,
    Conversions,
    Orders,
    Spend,
    AttributedRevenue
FROM CampaignPerformance
WHERE Impressions < 0
   OR Clicks < 0
   OR Conversions < 0
   OR Orders < 0
   OR Spend < 0
   OR AttributedRevenue < 0;


-- 33. CAMPAIGN METRIC LOGIC VALIDATION
-- Check for impossible relationships between impressions, clicks, and conversions.

SELECT
    CampaignID,
    Date,
    Impressions,
    Clicks,
    Conversions
FROM CampaignPerformance
WHERE Clicks > Impressions
   OR Conversions > Clicks;


-- 34. FINAL DATA QUALITY SUMMARY
-- Provide a high-level summary of the main tables before analysis.

SELECT
    'Customers' AS TableName,
    COUNT(*) AS Records
FROM Customers

UNION ALL

SELECT
    'Products',
    COUNT(*)
FROM Products

UNION ALL

SELECT
    'Orders',
    COUNT(*)
FROM Orders

UNION ALL

SELECT
    'OrderItems',
    COUNT(*)
FROM OrderItems

UNION ALL

SELECT
    'ProductReturns',
    COUNT(*)
FROM ProductReturns

UNION ALL

SELECT
    'MarketingCampaigns',
    COUNT(*)
FROM MarketingCampaigns

UNION ALL

SELECT
    'CampaignPerformance',
    COUNT(*)
FROM CampaignPerformance;
