# E-Commerce Profitability & Performance Analysis
SQL | MySQL | Business Analytics
An end-to-end SQL business analytics project analyzing an e-commerce company's sales, customers, products, operations, returns, marketing campaigns, and profitability to identify the key drivers of sustainable and profitable growth.

# Business Problem
The company is generating strong revenue, but management needs to understand whether revenue growth is translating into sustainable profitability.
The business wants to identify:
•	Which products and categories drive revenue and profit? 
•	Which customers generate the most value? 
•	Which marketing channels and campaigns are most effective? 
•	What factors are contributing to product returns? 
•	Where are the biggest opportunities to improve profitability? 

# Project Objective
Use SQL to analyze transactional and marketing data and provide data-driven insights and business recommendations focused on:
•	Revenue and sales performance 
•	Customer value and retention 
•	Product and category profitability 
•	Operational and return performance 
•	Marketing effectiveness 
•	Overall profitability 

# Dataset
The project uses relational e-commerce data containing:
Dataset	Records
Customers	60,000
Products	300
Orders	75,000
Order Items	199,84
Product Returns	5630
Marketing Campaigns	60
Campaign Performance	1,762

Dataset: This project uses a synthetically generated e-commerce dataset designed to simulate realistic business transactions across customers, orders, products, returns, and marketing campaigns. The dataset is intended for analytical and portfolio demonstration purposes.

# Executive KPIs
KPI	Result
Total Revenue	₹3.67B
Total Cost	₹2.35B
Gross Profit	₹1.32B
Gross Profit Margin	35.93%
Average Order Value	₹48,203.92
Customers with Sales	36,399
Units Sold	275,764
Order Return Rate	7.77%

# Analysis Performed
1. Executive Overview:
Evaluated overall revenue, cost, profit, margin, AOV, customers, units sold, and returns.
2. Sales Performance Analysis:
Analyzed monthly and yearly revenue, orders, AOV, gross profit, profitability trends, payment methods, and seasonality.
3. Customer Analysis:
Evaluated customer spending, repeat purchasing, revenue concentration, customer profitability, geographic performance, and customer acquisition trends.
4. Product Analysis:
Analyzed category revenue, profit, margins, products, brands, suppliers, units sold, pricing, ratings, and product returns.
5. Operations & Returns Analysis:
Evaluated order status, payment methods, basket size, discounts, return rates, return reasons, and products with higher return activity.
6. Marketing Campaign Analysis:
Analyzed campaign revenue, spending, conversions, CTR, CPC, CPA, ROAS, channel contribution, and campaign-level performance.
7. Profitability Analysis:
Compared revenue contribution with profit contribution to identify profitable and underperforming areas of the business.

# Key Business Insights
1. Electronics drive revenue but underperform on margin
Electronics generate 57.53% of revenue but only 38.95% of gross profit, with a 24.32% gross margin.
2. High-margin categories provide growth opportunities
Apparel, Beauty & Health, and Sports & Outdoors achieve margins above 50%, significantly higher than Electronics.
3. Repeat customers are the core revenue base
Repeat customers contribute 75.87% of total revenue, highlighting the importance of customer retention.
4. Revenue concentration does not equal profit concentration
The top 10 customers contribute 33.26% of revenue but only 28.55% of gross profit, showing that high-revenue customers are not necessarily the most profitable.
5. Returns represent an operational opportunity
The overall order return rate is 7.77%, with Apparel showing the highest category return rate at 7.03%.
6. Marketing efficiency varies by channel
Social Media delivers the highest channel ROAS at 37.97, followed by Affiliate at 37.51, while PPC has the lowest at 30.28.
7. Sales are strongly seasonal
October–December represents the strongest sales period, with November generating the highest monthly revenue.

# Business Recommendations
Based on the analysis:
1.	Improve Electronics profitability through better supplier negotiations, pricing, discount management, and SKU-level margin optimization. 
2.	Increase focus on high-margin categories such as Apparel, Sports & Outdoors, and Beauty & Health. 
3.	Strengthen customer retention through loyalty programs, personalized offers, cross-selling, and repeat-purchase strategies. 
4.	Reduce avoidable returns by improving product descriptions, sizing information, product imagery, and fulfillment accuracy. 
5.	Optimize marketing allocation toward high-ROAS channels while reviewing underperforming campaigns. 
6.	Prepare inventory and marketing capacity ahead of the October–December seasonal peak. 
7.	Adopt profit-based performance measurement instead of evaluating success through revenue alone. 

# Tools Used
•	MySQL — Database management and SQL analysis 
•	Python — Synthetic dataset generation 
•	GitHub — Project documentation and version control


# Project Structure
E-Commerce-Analytics/
│
├── data/
├── sql/
│   └── ecommerce_analysis.sql
├── documentation/
│   └── Business_Case_Study.pdf
└── README.md

# Conclusion
The analysis shows that the company has a strong revenue and gross-profit base, but significant opportunities exist to improve the quality and sustainability of that growth.
The key priorities are to improve Electronics margins, expand high-margin categories, retain valuable customers, reduce returns, optimize marketing investment, and shift decision-making from revenue-focused to profit-focused performance management.

# Disclaimer
This project uses synthetically generated data created specifically for portfolio and analytical demonstration purposes.
The results and business recommendations do not represent the actual performance of a real company.
