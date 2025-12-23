# Product_Cohort_Analytics
---

# 📊 B2C Product Analytics – Funnel, Cohort & LTV (SQL)

## Overview

This repository demonstrates a **product analytics case study** focused on **consumer behavior, funnel performance, cohort retention, and monetization metrics** using SQL.

The project is designed as a **representative analytics exercise** to showcase how product and business analysts extract actionable insights from large-scale event and transaction data in **B2C digital products**.

> **Note:** All data referenced in this project is **synthetic and anonymized**. No client or proprietary data is used.

---

## Business Problem

Digital products rely heavily on understanding how users move through key lifecycle stages and how those behaviors translate into revenue.

This project answers questions such as:

* Where do users drop off in the funnel?
* How strong is user retention across signup cohorts?
* Which users contribute most to revenue?
* What is the estimated Lifetime Value (LTV) of a user?

---

## Key Analyses Covered

### 1️⃣ Funnel Analysis

* Modeled a user journey from **Signup → Activation → Conversion**
* Calculated activation and conversion rates
* Identified funnel efficiency and drop-offs

### 2️⃣ Cohort Retention Analysis

* Grouped users by **signup month**
* Tracked monthly retention behavior
* Measured retention percentage over time to assess product stickiness

### 3️⃣ Revenue & LTV Estimation

* Calculated total and average revenue per user
* Estimated user lifetime based on first and last activity
* Derived **average LTV and daily revenue metrics**

### 4️⃣ High-Value User Segmentation

* Ranked users based on revenue contribution
* Used window functions to segment users into revenue quartiles
* Identified top-performing user cohorts for targeted strategies

### 5️⃣ Executive KPI Summary

* Created a consolidated KPI view for:

  * Total users
  * Paying users
  * Overall conversion rate

---

## Data Model (Logical)

### Tables Used

* **user_events**

  * `user_id`
  * `event_name` (signup, activation, conversion, etc.)
  * `event_date`

* **transactions**

  * `user_id`
  * `revenue_amount`
  * `transaction_date`

---

## Skills & Concepts Demonstrated

* Product & consumer analytics
* Funnel and cohort analysis
* Revenue and LTV modeling
* Advanced SQL (CTEs, window functions, aggregations)
* KPI definition and executive reporting
* Business storytelling through data

---

## Tools

* SQL (PostgreSQL-compatible syntax)

---

## Use Case

This project is intended to:

* Demonstrate **product analytics thinking** for B2C digital platforms
* Serve as a **portfolio artifact** for Product Analyst / Business Analyst roles
* Showcase SQL proficiency in analytics-driven environments such as **AdTech, FinTech, and Media platforms**

---

## Disclaimer

This project is a **representative analytics case study** created for demonstration purposes only.
All datasets are synthetic and do not reflect real users or business data.

---

## Author

**Parasuram P**


Just tell me.

