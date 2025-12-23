/* 
Project: B2C Product Analytics – Funnel, Cohort & LTV Analysis
Purpose: Demonstrate product analytics capability using synthetic user data
Data Type: Anonymized / synthetic (non-client)
Author: Parasuram P
*/

/* -----------------------------
1. USER FUNNEL ANALYSIS
------------------------------ */

/*
Goal:
Analyze how users move through the funnel:
signup → activation → conversion
*/

WITH funnel_events AS (
    SELECT 
        user_id,
        MIN(CASE WHEN event_name = 'signup' THEN event_date END) AS signup_date,
        MIN(CASE WHEN event_name = 'activation' THEN event_date END) AS activation_date,
        MIN(CASE WHEN event_name = 'conversion' THEN event_date END) AS conversion_date
    FROM user_events
    GROUP BY user_id
),

funnel_counts AS (
    SELECT
        COUNT(DISTINCT user_id) AS total_signups,
        COUNT(DISTINCT CASE WHEN activation_date IS NOT NULL THEN user_id END) AS activated_users,
        COUNT(DISTINCT CASE WHEN conversion_date IS NOT NULL THEN user_id END) AS converted_users
    FROM funnel_events
)

SELECT
    total_signups,
    activated_users,
    converted_users,
    ROUND(activated_users * 100.0 / total_signups, 2) AS activation_rate_pct,
    ROUND(converted_users * 100.0 / activated_users, 2) AS conversion_rate_pct
FROM funnel_counts;


/* -----------------------------
2. COHORT RETENTION ANALYSIS
------------------------------ */

/*
Goal:
Track monthly user retention based on signup cohort
*/

WITH signup_cohort AS (
    SELECT 
        user_id,
        DATE_TRUNC('month', MIN(event_date)) AS cohort_month
    FROM user_events
    WHERE event_name = 'signup'
    GROUP BY user_id
),

user_activity AS (
    SELECT 
        ue.user_id,
        DATE_TRUNC('month', ue.event_date) AS activity_month
    FROM user_events ue
),

cohort_activity AS (
    SELECT
        sc.cohort_month,
        ua.activity_month,
        COUNT(DISTINCT ua.user_id) AS active_users
    FROM signup_cohort sc
    JOIN user_activity ua
        ON sc.user_id = ua.user_id
    GROUP BY sc.cohort_month, ua.activity_month
),

cohort_size AS (
    SELECT
        cohort_month,
        COUNT(DISTINCT user_id) AS cohort_users
    FROM signup_cohort
    GROUP BY cohort_month
)

SELECT
    ca.cohort_month,
    ca.activity_month,
    ca.active_users,
    cs.cohort_users,
    ROUND(ca.active_users * 100.0 / cs.cohort_users, 2) AS retention_pct
FROM cohort_activity ca
JOIN cohort_size cs
    ON ca.cohort_month = cs.cohort_month
ORDER BY ca.cohort_month, ca.activity_month;


/* -----------------------------
3. REVENUE & LTV ANALYSIS
------------------------------ */

/*
Goal:
Calculate average revenue per user and estimate LTV
*/

WITH user_revenue AS (
    SELECT
        user_id,
        SUM(revenue_amount) AS total_revenue
    FROM transactions
    GROUP BY user_id
),

user_lifetime AS (
    SELECT
        user_id,
        MIN(event_date) AS first_activity,
        MAX(event_date) AS last_activity
    FROM user_events
    GROUP BY user_id
),

ltv_calculation AS (
    SELECT
        ur.user_id,
        ur.total_revenue,
        DATE_PART('day', ul.last_activity - ul.first_activity) + 1 AS lifetime_days
    FROM user_revenue ur
    JOIN user_lifetime ul
        ON ur.user_id = ul.user_id
)

SELECT
    ROUND(AVG(total_revenue), 2) AS avg_ltv,
    ROUND(AVG(total_revenue / NULLIF(lifetime_days, 0)), 2) AS avg_daily_revenue
FROM ltv_calculation;


/* -----------------------------
4. HIGH-VALUE USER SEGMENTATION
------------------------------ */

/*
Goal:
Identify top revenue-generating users for targeted strategies
*/

SELECT
    user_id,
    SUM(revenue_amount) AS total_revenue,
    NTILE(4) OVER (ORDER BY SUM(revenue_amount) DESC) AS revenue_quartile
FROM transactions
GROUP BY user_id
ORDER BY total_revenue DESC;


/* -----------------------------
5. KPI SUMMARY VIEW (EXECUTIVE READY)
------------------------------ */

CREATE OR REPLACE VIEW product_kpi_summary AS
SELECT
    COUNT(DISTINCT user_id) AS total_users,
    COUNT(DISTINCT CASE WHEN event_name = 'conversion' THEN user_id END) AS paying_users,
    ROUND(
        COUNT(DISTINCT CASE WHEN event_name = 'conversion' THEN user_id END) * 100.0 /
        COUNT(DISTINCT user_id), 2
    ) AS conversion_rate_pct
FROM user_events;
