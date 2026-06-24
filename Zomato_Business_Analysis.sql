-- ==========================================
-- ZOMATO BUSINESS ANALYSIS PROJECT
-- PostgreSQL End-to-End SQL Script
-- ==========================================

-- DATABASE
CREATE DATABASE zomato_analysis;

-- ==========================================
-- TABLES
-- ==========================================

CREATE TABLE financials (
    quarter VARCHAR(20),
    revenue NUMERIC,
    adjusted_revenue NUMERIC,
    ebitda NUMERIC,
    ebitda_margin NUMERIC,
    pat NUMERIC,
    pat_margin NUMERIC,
    cash_balance NUMERIC
);

CREATE TABLE food_delivery (
    quarter VARCHAR(20),
    gov NUMERIC,
    revenue NUMERIC,
    contribution NUMERIC,
    ebitda NUMERIC,
    monthly_transacting_customers NUMERIC
);

CREATE TABLE blinkit (
    quarter VARCHAR(20),
    gov NUMERIC,
    revenue NUMERIC,
    contribution NUMERIC,
    ebitda NUMERIC,
    orders NUMERIC,
    customers NUMERIC,
    naov NUMERIC,
    store_count NUMERIC
);

CREATE TABLE other_businesses (
    quarter VARCHAR(20),
    hyperpure_revenue NUMERIC,
    hyperpure_ebitda NUMERIC,
    goingout_gov NUMERIC,
    goingout_revenue NUMERIC,
    goingout_ebitda NUMERIC
);

-- ==========================================
-- MASTER BUSINESS VIEW
-- ==========================================

CREATE VIEW zomato_business_view AS

SELECT

f.quarter,

f.revenue,
f.adjusted_revenue,
f.ebitda,
f.ebitda_margin,
f.pat,
f.pat_margin,
f.cash_balance,

fd.gov AS food_gov,
fd.revenue AS food_revenue,
fd.contribution AS food_contribution,
fd.ebitda AS food_ebitda,
fd.monthly_transacting_customers,

b.gov AS blinkit_gov,
b.revenue AS blinkit_revenue,
b.contribution AS blinkit_contribution,
b.ebitda AS blinkit_ebitda,
b.orders,
b.customers,
b.naov,
b.store_count,

ob.hyperpure_revenue,
ob.hyperpure_ebitda,
ob.goingout_gov,
ob.goingout_revenue,
ob.goingout_ebitda

FROM financials f

LEFT JOIN food_delivery fd
ON f.quarter = fd.quarter

LEFT JOIN blinkit b
ON f.quarter = b.quarter

LEFT JOIN other_businesses ob
ON f.quarter = ob.quarter;

-- ==========================================
-- CHECK VIEW
-- ==========================================

SELECT * FROM zomato_business_view;

-- ==========================================
-- REVENUE GROWTH %
-- ==========================================

SELECT
quarter,
revenue,
ROUND(
100.0 *
(revenue - LAG(revenue) OVER(ORDER BY quarter))
/
LAG(revenue) OVER(ORDER BY quarter)
,2) AS revenue_growth_pct
FROM zomato_business_view;

-- ==========================================
-- ADJUSTED REVENUE GROWTH %
-- ==========================================

SELECT
quarter,
adjusted_revenue,
ROUND(
100.0 *
(adjusted_revenue - LAG(adjusted_revenue) OVER(ORDER BY quarter))
/
LAG(adjusted_revenue) OVER(ORDER BY quarter)
,2) AS adjusted_revenue_growth_pct
FROM zomato_business_view;

-- ==========================================
-- EBITDA MARGIN
-- ==========================================

SELECT
quarter,
revenue,
ebitda,
ROUND(100.0 * ebitda / revenue,2) AS ebitda_margin
FROM zomato_business_view;

-- ==========================================
-- PAT MARGIN
-- ==========================================

SELECT
quarter,
revenue,
pat,
ROUND(100.0 * pat / revenue,2) AS pat_margin
FROM zomato_business_view;

-- ==========================================
-- CASH BALANCE CHANGE
-- ==========================================

SELECT
quarter,
cash_balance,
cash_balance -
LAG(cash_balance)
OVER(ORDER BY quarter)
AS cash_change
FROM zomato_business_view;

-- ==========================================
-- HIGHEST REVENUE QUARTER
-- ==========================================

SELECT *
FROM zomato_business_view
ORDER BY revenue DESC
LIMIT 1;

-- ==========================================
-- HIGHEST EBITDA QUARTER
-- ==========================================

SELECT
quarter,
ebitda
FROM zomato_business_view
ORDER BY ebitda DESC
LIMIT 1;

-- ==========================================
-- HIGHEST PAT QUARTER
-- ==========================================

SELECT
quarter,
pat
FROM zomato_business_view
ORDER BY pat DESC
LIMIT 1;

-- ==========================================
-- FOOD DELIVERY SHARE
-- ==========================================

SELECT
quarter,
ROUND(
100.0 * food_revenue / revenue
,2) AS food_revenue_share_pct
FROM zomato_business_view;

-- ==========================================
-- BLINKIT SHARE
-- ==========================================

SELECT
quarter,
ROUND(
100.0 * blinkit_revenue / revenue
,2) AS blinkit_revenue_share_pct
FROM zomato_business_view;

-- ==========================================
-- REVENUE CONTRIBUTION OF BUSINESSES
-- ==========================================

SELECT
quarter,
food_revenue,
blinkit_revenue,
hyperpure_revenue,
goingout_revenue
FROM zomato_business_view;

-- ==========================================
-- FOOD DELIVERY CUSTOMER GROWTH
-- ==========================================

SELECT
quarter,
monthly_transacting_customers,
ROUND(
100.0 *
(
monthly_transacting_customers -
LAG(monthly_transacting_customers)
OVER(ORDER BY quarter)
)
/
LAG(monthly_transacting_customers)
OVER(ORDER BY quarter)
,2) AS customer_growth_pct
FROM zomato_business_view;

-- ==========================================
-- FOOD DELIVERY REVENUE PER CUSTOMER
-- ==========================================

SELECT
quarter,
food_revenue,
monthly_transacting_customers,
ROUND(
food_revenue /
monthly_transacting_customers
,2) AS revenue_per_customer
FROM zomato_business_view;

-- ==========================================
-- BLINKIT REVENUE PER STORE
-- ==========================================

SELECT
quarter,
store_count,
blinkit_revenue,
ROUND(
blinkit_revenue /
store_count
,2) AS revenue_per_store
FROM zomato_business_view;

-- ==========================================
-- BLINKIT ORDERS PER CUSTOMER
-- ==========================================

SELECT
quarter,
orders,
customers,
ROUND(
orders /
customers
,2) AS orders_per_customer
FROM zomato_business_view;

-- ==========================================
-- BLINKIT STORE EXPANSION
-- ==========================================

SELECT
quarter,
store_count
FROM zomato_business_view
ORDER BY quarter;

-- ==========================================
-- HYPERPURE PERFORMANCE
-- ==========================================

SELECT
quarter,
hyperpure_revenue,
hyperpure_ebitda
FROM zomato_business_view;

-- ==========================================
-- GOING OUT PERFORMANCE
-- ==========================================

SELECT
quarter,
goingout_revenue,
goingout_ebitda
FROM zomato_business_view;

-- ==========================================
-- REVENUE VS EBITDA
-- ==========================================

SELECT
quarter,
revenue,
ebitda
FROM zomato_business_view;

-- ==========================================
-- REVENUE VS PAT
-- ==========================================

SELECT
quarter,
revenue,
pat
FROM zomato_business_view;

-- ==========================================
-- CUMULATIVE REVENUE
-- ==========================================

SELECT
quarter,
revenue,
SUM(revenue)
OVER(
ORDER BY quarter
) AS cumulative_revenue
FROM zomato_business_view;

-- ==========================================
-- CUMULATIVE EBITDA
-- ==========================================

SELECT
quarter,
ebitda,
SUM(ebitda)
OVER(
ORDER BY quarter
) AS cumulative_ebitda
FROM zomato_business_view;

-- ==========================================
-- CUMULATIVE PAT
-- ==========================================

SELECT
quarter,
pat,
SUM(pat)
OVER(
ORDER BY quarter
) AS cumulative_pat
FROM zomato_business_view;

-- ==========================================
-- REVENUE RANKING
-- ==========================================

SELECT
quarter,
revenue,
RANK()
OVER(
ORDER BY revenue DESC
) AS revenue_rank
FROM zomato_business_view;

-- ==========================================
-- EBITDA RANKING
-- ==========================================

SELECT
quarter,
ebitda,
RANK()
OVER(
ORDER BY ebitda DESC
) AS ebitda_rank
FROM zomato_business_view;

-- ==========================================
-- PAT RANKING
-- ==========================================

SELECT
quarter,
pat,
RANK()
OVER(
ORDER BY pat DESC
) AS pat_rank
FROM zomato_business_view;

-- ==========================================
-- EXECUTIVE SUMMARY DATASET
-- ==========================================
CREATE OR REPLACE VIEW zomato_dashboard_view AS
SELECT
    f.quarter,

    CASE
        WHEN f.quarter = 'Q1 FY23' THEN 1
        WHEN f.quarter = 'Q2 FY23' THEN 2
        WHEN f.quarter = 'Q3 FY23' THEN 3
        WHEN f.quarter = 'Q4 FY23' THEN 4
        WHEN f.quarter = 'Q1 FY24' THEN 5
        WHEN f.quarter = 'Q2 FY24' THEN 6
        WHEN f.quarter = 'Q3 FY24' THEN 7
        WHEN f.quarter = 'Q4 FY24' THEN 8
        WHEN f.quarter = 'Q1 FY25' THEN 9
        WHEN f.quarter = 'Q2 FY25' THEN 10
        WHEN f.quarter = 'Q3 FY25' THEN 11
        WHEN f.quarter = 'Q4 FY25' THEN 12
        WHEN f.quarter = 'Q1 FY26' THEN 13
        WHEN f.quarter = 'Q2 FY26' THEN 14
        WHEN f.quarter = 'Q3 FY26' THEN 15
        WHEN f.quarter = 'Q4 FY26' THEN 16
    END AS quarter_order,

    /* FINANCIALS */
    f.revenue,
    f.adjusted_revenue,
    f.ebitda,
    f.ebitda_margin,
    f.pat,
    f.pat_margin,
    f.cash_balance,

    /* FOOD DELIVERY */
    fd.gov AS food_delivery_gov,
    fd.revenue AS food_delivery_revenue,
    fd.contribution AS food_delivery_contribution,
    fd.ebitda AS food_delivery_ebitda,
    fd.monthly_transacting_customers,

    /* BLINKIT */
    b.gov AS blinkit_gov,
    b.revenue AS blinkit_revenue,
    b.contribution AS blinkit_contribution,
    b.ebitda AS blinkit_ebitda,
    b.orders AS blinkit_orders,
    b.customers AS blinkit_customers,
    b.naov AS blinkit_naov,
    b.store_count,

    /* OTHER BUSINESSES */
    ob.hyperpure_revenue,
    ob.hyperpure_ebitda,
    ob.goingout_gov,
    ob.goingout_revenue,
    ob.goingout_ebitda

FROM financials f

LEFT JOIN food_delivery fd
       ON f.quarter = fd.quarter

LEFT JOIN blinkit b
       ON f.quarter = b.quarter

LEFT JOIN other_businesses ob
       ON f.quarter = ob.quarter;

SELECT *
FROM zomato_dashboard_view
LIMIT 1;
-- ==========================================
-- END OF PROJECT SQL FILE
-- ==========================================