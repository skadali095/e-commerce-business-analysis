-- ============================================
--  MARKETING CAMPAIGN ANALYSIS
-- ============================================

-- 1. OVERALL MARKETING PERFORMANCE
-- Evaluate the overall scale and financial performance of marketing campaigns.

SELECT
    COUNT(DISTINCT CampaignID) AS TotalCampaigns,
    SUM(Orders) AS CampaignOrders,
    ROUND(SUM(AttributedRevenue), 2) AS AttributedRevenue,
    ROUND(SUM(Spend), 2) AS TotalSpend
FROM CampaignPerformance;


-- 2. REVENUE BY MARKETING CHANNEL
-- Identify which marketing channels generate the most attributed revenue.

SELECT
    Channel,
    ROUND(SUM(AttributedRevenue), 2) AS AttributedRevenue,
    SUM(Orders) AS Orders,
    ROUND(
        SUM(AttributedRevenue) * 100.0 /
        SUM(SUM(AttributedRevenue)) OVER (),
        2
    ) AS RevenueContribution
FROM CampaignPerformance
GROUP BY Channel
ORDER BY AttributedRevenue DESC;


-- 3. MARKETING SPEND BY CHANNEL
-- Compare how marketing budget is distributed across different channels.

SELECT
    Channel,
    ROUND(SUM(Spend), 2) AS MarketingSpend,
    ROUND(
        SUM(Spend) * 100.0 /
        SUM(SUM(Spend)) OVER (),
        2
    ) AS SpendContribution
FROM CampaignPerformance
GROUP BY Channel
ORDER BY MarketingSpend DESC;


-- 4. ROAS BY MARKETING CHANNEL
-- Measure the revenue generated for every unit of marketing spend.

SELECT
    Channel,
    ROUND(
        SUM(AttributedRevenue) /
        NULLIF(SUM(Spend), 0),
        2
    ) AS ROAS
FROM CampaignPerformance
GROUP BY Channel
ORDER BY ROAS DESC;


-- 5. ORDERS BY MARKETING CHANNEL
-- Identify which channels contribute the highest number of campaign-attributed orders.

SELECT
    Channel,
    SUM(Orders) AS CampaignOrders,
    ROUND(
        SUM(Orders) * 100.0 /
        SUM(SUM(Orders)) OVER (),
        2
    ) AS OrderContribution
FROM CampaignPerformance
GROUP BY Channel
ORDER BY CampaignOrders DESC;


-- 6. CONVERSION RATE BY MARKETING CHANNEL
-- Evaluate how effectively each channel converts clicks into conversions.

SELECT
    Channel,
    SUM(Clicks) AS Clicks,
    SUM(Conversions) AS Conversions,
    ROUND(
        SUM(Conversions) * 100.0 /
        NULLIF(SUM(Clicks), 0),
        2
    ) AS ConversionRate
FROM CampaignPerformance
GROUP BY Channel
ORDER BY ConversionRate DESC;


-- 7. CLICK-THROUGH RATE BY MARKETING CHANNEL
-- Measure how effectively each channel converts impressions into clicks.

SELECT
    Channel,
    SUM(Impressions) AS Impressions,
    SUM(Clicks) AS Clicks,
    ROUND(
        SUM(Clicks) * 100.0 /
        NULLIF(SUM(Impressions), 0),
        2
    ) AS CTR
FROM CampaignPerformance
GROUP BY Channel
ORDER BY CTR DESC;


-- 8. COST PER ACQUISITION BY MARKETING CHANNEL
-- Compare the average marketing cost required to generate a conversion.

SELECT
    Channel,
    ROUND(
        SUM(Spend) /
        NULLIF(SUM(Conversions), 0),
        2
    ) AS CPA
FROM CampaignPerformance
GROUP BY Channel
ORDER BY CPA;


-- 9. MARKETING BUDGET VS ACTUAL SPEND
-- Compare campaign budgets with the actual marketing expenditure.

SELECT
    mc.Channel,
    ROUND(SUM(mc.Budget), 2) AS TotalBudget,
    ROUND(
        SUM(COALESCE(cp.Spend, 0)),
        2
    ) AS ActualSpend
FROM MarketingCampaigns mc
LEFT JOIN
(
    SELECT
        CampaignID,
        SUM(Spend) AS Spend
    FROM CampaignPerformance
    GROUP BY CampaignID
) cp
    ON mc.CampaignID = cp.CampaignID
GROUP BY mc.Channel
ORDER BY TotalBudget DESC;


-- 10. CAMPAIGN-LEVEL PERFORMANCE
-- Evaluate individual campaigns based on spend, orders, revenue and ROAS.

SELECT
    mc.CampaignID,
    mc.CampaignName,
    mc.Channel,
    ROUND(mc.Budget, 2) AS Budget,
    ROUND(SUM(cp.Spend), 2) AS Spend,
    SUM(cp.Orders) AS Orders,
    ROUND(SUM(cp.AttributedRevenue), 2) AS AttributedRevenue,
    SUM(cp.Conversions) AS Conversions,
    ROUND(
        SUM(cp.AttributedRevenue) /
        NULLIF(SUM(cp.Spend), 0),
        2
    ) AS ROAS
FROM MarketingCampaigns mc
JOIN CampaignPerformance cp
    ON mc.CampaignID = cp.CampaignID
GROUP BY
    mc.CampaignID,
    mc.CampaignName,
    mc.Channel,
    mc.Budget
ORDER BY ROAS DESC;


-- 11. TOP 10 CAMPAIGNS BY ROAS
-- Identify the campaigns that generate the highest return on marketing spend.

SELECT
    mc.CampaignName,
    mc.Channel,
    ROUND(
        SUM(cp.AttributedRevenue) /
        NULLIF(SUM(cp.Spend), 0),
        2
    ) AS ROAS,
    ROUND(SUM(cp.AttributedRevenue), 2) AS Revenue,
    ROUND(SUM(cp.Spend), 2) AS Spend
FROM MarketingCampaigns mc
JOIN CampaignPerformance cp
    ON mc.CampaignID = cp.CampaignID
GROUP BY
    mc.CampaignID,
    mc.CampaignName,
    mc.Channel
ORDER BY ROAS DESC
LIMIT 10;


-- 12. LOWEST PERFORMING CAMPAIGNS
-- Identify campaigns with the weakest return on marketing spend.

SELECT
    mc.CampaignName,
    mc.Channel,
    ROUND(
        SUM(cp.AttributedRevenue) /
        NULLIF(SUM(cp.Spend), 0),
        2
    ) AS ROAS,
    ROUND(SUM(cp.Spend), 2) AS Spend,
    ROUND(SUM(cp.AttributedRevenue), 2) AS Revenue
FROM MarketingCampaigns mc
JOIN CampaignPerformance cp
    ON mc.CampaignID = cp.CampaignID
GROUP BY
    mc.CampaignID,
    mc.CampaignName,
    mc.Channel
HAVING SUM(cp.Spend) > 0
ORDER BY ROAS ASC
LIMIT 10;


-- 13. MONTHLY MARKETING PERFORMANCE
-- Analyze how campaign revenue, spend and ROAS change over time.

SELECT
    YEAR(Date) AS OrderYear,
    MONTH(Date) AS OrderMonth,
    ROUND(SUM(AttributedRevenue), 2) AS Revenue,
    ROUND(SUM(Spend), 2) AS Spend,
    SUM(Orders) AS Orders,
    ROUND(
        SUM(AttributedRevenue) /
        NULLIF(SUM(Spend), 0),
        2
    ) AS ROAS
FROM CampaignPerformance
GROUP BY
    YEAR(Date),
    MONTH(Date)
ORDER BY
    OrderYear,
    OrderMonth;


-- 14. MARKETING REVENUE CONTRIBUTION
-- Measure the share of delivered revenue attributed to marketing campaigns.

SELECT
    ROUND(
        (
            SELECT SUM(AttributedRevenue)
            FROM CampaignPerformance
        ) * 100.0 /
        (
            SELECT SUM(TotalAmount)
            FROM Orders
            WHERE OrderStatus = 'Delivered'
        ),
        2
    ) AS CampaignRevenueContribution;
    
