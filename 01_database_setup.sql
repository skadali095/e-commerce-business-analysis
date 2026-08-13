-- ============================================
-- E-COMMERCE PROFITABILITY & PERFORMANCE ANALYSIS
-- SQL BUSINESS ANALYSIS
-- ============================================

-- Create database
CREATE DATABASE ecommerce_business_analytics;

-- Select database
USE ecommerce_business_analytics;

-- ============================================
-- CREATE TABLES
-- ============================================

CREATE TABLE Customers (
    CustomerID      VARCHAR(15) PRIMARY KEY,
    FullName        VARCHAR(100) NOT NULL,
    Email           VARCHAR(150) NOT NULL UNIQUE,
    SignUpDate      DATE NOT NULL,
    City            VARCHAR(50) NOT NULL,
    Country         VARCHAR(50) NOT NULL,
    Gender          VARCHAR(10) NOT NULL,
    Age             TINYINT NOT NULL,
    LifetimeSpend   DECIMAL(15,2) NOT NULL DEFAULT 0,
    OrderCount      INT NOT NULL DEFAULT 0,
    CHECK (Age >= 18),
    CHECK (LifetimeSpend >= 0),
    CHECK (OrderCount >= 0)
);

CREATE TABLE Products (
    ProductID          VARCHAR(15) PRIMARY KEY,
    ProductName        VARCHAR(150) NOT NULL,
    Category           VARCHAR(50) NOT NULL,
    Brand              VARCHAR(100) NOT NULL,
    Supplier           VARCHAR(100) NOT NULL,
    UnitPrice          DECIMAL(12,2) NOT NULL,
    UnitCost           DECIMAL(12,2) NOT NULL,
    ProductRating      DECIMAL(2,1) NOT NULL,
    LaunchDate         DATE NOT NULL,
    ProductStatus      VARCHAR(20) NOT NULL,
    Weight             DECIMAL(6,2) NOT NULL,
    CHECK (UnitPrice >= 0),
    CHECK (UnitCost >= 0),
    CHECK (ProductRating BETWEEN 1.0 AND 5.0),
    CHECK (Weight > 0)
);

CREATE TABLE Orders (
    OrderID             VARCHAR(15) PRIMARY KEY,
    CustomerID          VARCHAR(15) NOT NULL,
    OrderDate           DATE NOT NULL,
    OrderStatus         VARCHAR(20) NOT NULL,
    DiscountPercent     DECIMAL(10,2) NOT NULL DEFAULT 0,
    DiscountAmount      DECIMAL(15,2) NOT NULL DEFAULT 0,
    ShippingCost        DECIMAL(10,2) NOT NULL DEFAULT 0,
    FinalAmount         DECIMAL(15,2) NOT NULL,
    PaymentMethod       VARCHAR(30) NOT NULL,
    CampaignID          VARCHAR(15),
    TotalAmount         DECIMAL(15,2) NOT NULL,
    TotalCost           DECIMAL(15,2) NOT NULL,
    TotalProfit         DECIMAL(15,2) NOT NULL,
    CHECK (TotalAmount >= 0),
    CHECK (TotalCost >= 0),
    CHECK (DiscountPercent BETWEEN 0 AND 100),
    CHECK (DiscountAmount >= 0),
    CHECK (ShippingCost >= 0),
    CHECK (FinalAmount >= 0)
);

CREATE TABLE OrderItems (
    OrderItemID        VARCHAR(20) PRIMARY KEY,
    OrderID            VARCHAR(15) NOT NULL,
    ProductID          VARCHAR(15) NOT NULL,
    Quantity           INT NOT NULL,
    PricePerUnit       DECIMAL(12,2) NOT NULL,
    UnitCost           DECIMAL(12,2) NOT NULL,
    LineRevenue        DECIMAL(15,2) NOT NULL,
    LineCost           DECIMAL(15,2) NOT NULL,
    LineProfit         DECIMAL(15,2) NOT NULL,
    CHECK (Quantity > 0),
    CHECK (PricePerUnit >= 0),
    CHECK (UnitCost >= 0)
);

CREATE TABLE ProductReturns (
    ReturnID        VARCHAR(15) PRIMARY KEY,
    OrderID         VARCHAR(15) NOT NULL,
    ProductID       VARCHAR(15) NOT NULL,
    ReturnDate      DATE NOT NULL,
    Reason          VARCHAR(100) NOT NULL
);

CREATE TABLE MarketingCampaigns (
    CampaignID        VARCHAR(15) PRIMARY KEY,
    CampaignName      VARCHAR(100) NOT NULL,
    Channel           VARCHAR(50) NOT NULL,
    StartDate         DATE NOT NULL,
    EndDate           DATE NOT NULL,
    Budget            DECIMAL(15,2) NOT NULL,
    CHECK (Budget >= 0),
    CHECK (EndDate >= StartDate)
);


CREATE TABLE CampaignPerformance (
    CampaignID          VARCHAR(15) NOT NULL,
    Date                DATE NOT NULL,
    Orders              INT NOT NULL,
    AttributedRevenue   DECIMAL(15,2) NOT NULL,
    CampaignName      VARCHAR(100) NOT NULL,
    Channel             VARCHAR(50) NOT NULL,
    StartDate           DATE NOT NULL,
    EndDate             DATE NOT NULL,
    Budget              DECIMAL(15,2) NOT NULL,
    Impressions         INT NOT NULL,
    Spend               DECIMAL(15,2) NOT NULL,
    Clicks              INT NOT NULL,
    CTR                 DECIMAL(6,2) NOT NULL,
    Conversions         INT NOT NULL,
    ConversionRate      DECIMAL(6,2) NOT NULL,
    CPC                 DECIMAL(10,2) NOT NULL,
    CPA                 DECIMAL(10,2) NOT NULL,
    ROAS                DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (CampaignID, Date),
    CHECK (Orders >= 0),
    CHECK (AttributedRevenue >= 0),
    CHECK (Budget >= 0),
    CHECK (Impressions >= 0),
    CHECK (Spend >= 0),
    CHECK (Clicks >= 0),
    CHECK (Conversions >= 0),
    CHECK (CTR >= 0),
    CHECK (ConversionRate >= 0),
    CHECK (CPC >= 0),
    CHECK (CPA >= 0),
    CHECK (ROAS >= 0)
);

SET FOREIGN_KEY_CHECKS = 0;

-- ============================================
-- IMPORT DATA
-- ============================================

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Customers.csv'
INTO TABLE Customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Products.csv'
INTO TABLE Products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Orders.csv'
INTO TABLE Orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Order_Items.csv'
INTO TABLE OrderItems
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Product_Returns.csv'
INTO TABLE ProductReturns
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Marketing_Campaigns.csv'
INTO TABLE MarketingCampaigns
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Campaign_Performance.csv'
INTO TABLE CampaignPerformance
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- ============================================
-- ADD FOREIGN KEYS
-- ============================================

ALTER TABLE Orders
ADD CONSTRAINT fk_orders_customer
FOREIGN KEY (CustomerID)
REFERENCES Customers(CustomerID);

ALTER TABLE Orders
ADD CONSTRAINT fk_orders_campaign
FOREIGN KEY (CampaignID)
REFERENCES MarketingCampaigns(CampaignID);

ALTER TABLE OrderItems
ADD CONSTRAINT fk_orderitems_order
FOREIGN KEY (OrderID)
REFERENCES Orders(OrderID);

ALTER TABLE OrderItems
ADD CONSTRAINT fk_orderitems_product
FOREIGN KEY (ProductID)
REFERENCES Products(ProductID);

ALTER TABLE ProductReturns
ADD CONSTRAINT fk_returns_order
FOREIGN KEY (OrderID)
REFERENCES Orders(OrderID);

ALTER TABLE ProductReturns
ADD CONSTRAINT fk_returns_product
FOREIGN KEY (ProductID)
REFERENCES Products(ProductID);

ALTER TABLE CampaignPerformance
ADD CONSTRAINT fk_campaignperformance_campaign
FOREIGN KEY (CampaignID)
REFERENCES MarketingCampaigns(CampaignID);

-- ============================================
-- ADD INDEXES
-- ============================================

CREATE INDEX idx_orders_customer
ON Orders(CustomerID);

CREATE INDEX idx_orders_campaign
ON Orders(CampaignID);

CREATE INDEX idx_orders_date
ON Orders(OrderDate);

CREATE INDEX idx_orders_status
ON Orders(OrderStatus);

CREATE INDEX idx_orderitems_order
ON OrderItems(OrderID);

CREATE INDEX idx_orderitems_product
ON OrderItems(ProductID);

CREATE INDEX idx_products_category
ON Products(Category);

CREATE INDEX idx_products_brand
ON Products(Brand);

CREATE INDEX idx_customers_city
ON Customers(City);

CREATE INDEX idx_customers_signup
ON Customers(SignUpDate);

CREATE INDEX idx_returns_order
ON ProductReturns(OrderID);

CREATE INDEX idx_returns_product
ON ProductReturns(ProductID);

CREATE INDEX idx_returns_date
ON ProductReturns(ReturnDate);

CREATE INDEX idx_campaign_date
ON CampaignPerformance(Date);

-- VERIFY CONSTRAINTS
SELECT
    TABLE_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'ecommerce_business_analytics'
AND REFERENCED_TABLE_NAME IS NOT NULL;
