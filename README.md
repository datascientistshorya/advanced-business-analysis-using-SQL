# Analytical SQL — Customer, Product & Business Analysis

A practical **MySQL analytical SQL project** focused on transforming transactional data into meaningful business insights.

This project covers customer behavior, product performance, category analysis, revenue concentration, cancellation behavior, repeat purchases, benchmarking, and executive-level business diagnosis.

The objective is to go beyond writing SQL queries and use SQL to answer **real-world business questions**.

---

## Objectives

* Analyze customer revenue and purchasing behavior
* Measure customer order frequency and Average Order Value (AOV)
* Identify high-value customers
* Evaluate product and category performance
* Analyze customer × product relationships
* Measure completed revenue and revenue contribution
* Analyze customer cancellation behavior
* Identify repeat-purchase customers
* Compare product performance against category benchmarks
* Compare category revenue share with order-volume share
* Identify high-priority business cases
* Strengthen analytical SQL and business problem-solving skills

---

# Project Structure

This repository contains two analytical SQL batches.

### Batch 3 — Customer & Product Analytics

Focuses on customer, product, category, and customer-product performance.

### Batch 4 — Advanced Business Case Analysis

Focuses on segmentation, benchmarking, ranking, revenue concentration, cancellation analysis, and executive-level diagnosis.

---

# Business Questions Solved

## Batch 3 — Customer & Product Analytics

### Q1 — Customer Revenue

**Business Question:**
How much total revenue does each customer generate?

**Analysis:**

* Customer revenue
* Customer-level ranking
* Revenue-based sorting

---

### Q2 — Customer Order Frequency

**Business Question:**
How many orders has each customer placed?

**Analysis:**

* Total orders per customer
* Customer-level order frequency
* Customers with zero orders

---

### Q3 — Customer Average Order Value

**Business Question:**
What is the average order value for each customer?

**Analysis:**

* Total customer revenue
* Total customer orders
* Average Order Value

---

### Q4 — Customer Purchase Profile

**Business Question:**
What does each customer's overall purchasing profile look like?

**Metrics:**

* Total orders
* Total revenue
* Average Order Value

---

### Q5 — High-Value Customers

**Business Question:**
Which customers are generating significant revenue?

**Criteria:**

* Total revenue > 20,000

---

### Q6 — Product Revenue

**Business Question:**
How much revenue does each product generate?

**Metrics:**

* Product revenue
* Product category
* Revenue ranking

---

### Q7 — Product Order Volume

**Business Question:**
How many orders has each product received?

**Analysis:**

* Product-level order volume
* Products with zero orders
* Order-volume ranking

---

### Q8 — Category Performance

**Business Question:**
Which product categories contribute the most revenue?

**Metrics:**

* Total orders
* Total revenue
* Average Order Value

---

### Q9 — Best-Selling Product by Revenue

**Business Question:**
Which product generated the highest total revenue?

This analysis uses aggregation and a subquery to identify the highest-revenue product.

---

### Q10 — Customer × Product Analysis

**Business Question:**
Which customers are spending the most on which products?

The analysis combines customer and product information to measure:

* Customer-product order volume
* Customer-product revenue
* Product purchasing relationships

---

# Batch 4 — Advanced Business Case Analysis

## Q1 — Customer Value Segmentation

**Business Question:**
Which customers contribute the most completed-order revenue?

Customers were segmented into:

| Segment      | Completed Revenue |
| ------------ | ----------------: |
| High Value   |          ≥ 10,000 |
| Medium Value |       5,000–9,999 |
| Low Value    |           < 5,000 |

---

## Q2 — Product Revenue Contribution

**Business Question:**
Which products are driving the company's completed revenue?

The analysis measures:

* Completed orders
* Completed revenue
* Percentage contribution to total completed revenue
* Revenue contribution ranking

---

## Q3 — Category Performance Diagnosis

**Business Question:**
Which categories require investigation?

The analysis measures:

* Total orders
* Completed orders
* Cancelled orders
* Completion rate
* Cancellation rate
* Completed revenue
* Average completed order value

Categories are classified as:

| Classification | Completion Rate |
| -------------- | --------------: |
| Strong         |           ≥ 80% |
| Watch          |      60%–79.99% |
| Critical       |           < 60% |

---

## Q4 — Customer Cancellation Analysis

**Business Question:**
Which customers show unusually high cancellation behavior?

Customers are classified as:

| Risk Level  | Cancellation Rate |
| ----------- | ----------------: |
| High Risk   |             ≥ 50% |
| Medium Risk |        25%–49.99% |
| Low Risk    |             < 25% |

---

## Q5 — Product × Customer Analysis

**Business Question:**
Who are the strongest customer-product relationships within each category?

The analysis identifies the highest-revenue customer-product combination within every product category.

---

## Q6 — Revenue Concentration Analysis

**Business Question:**
Is revenue concentrated among a small number of customers?

Each customer is evaluated using:

* Completed revenue
* Percentage contribution to total completed revenue
* Revenue rank
* Contributor classification

Customers are classified as:

| Classification      | Revenue Contribution |
| ------------------- | -------------------: |
| Top Contributor     |                ≥ 20% |
| Major Contributor   |                ≥ 10% |
| Regular Contributor |                < 10% |

---

## Q7 — Product Performance vs Category Average

**Business Question:**
Which products outperform or underperform their category's typical order value?

Each product's completed AOV is compared with the average completed AOV of its category.

The analysis provides:

* Product completed revenue
* Product AOV
* Category average AOV
* Difference
* Performance classification

---

## Q8 — Customer Repeat-Purchase Analysis

**Business Question:**
Which customers demonstrate strong repeat-purchase behavior?

Only customers with more than one completed order are analyzed.

Metrics include:

* Completed orders
* Completed revenue
* Average completed order value
* Highest completed order value
* Lowest completed order value

Classification:

| Segment             | Completed Orders |
| ------------------- | ---------------: |
| High Repeat Value   |               4+ |
| Medium Repeat Value |              2–3 |

---

## Q9 — Category Revenue vs Order Volume

**Business Question:**
Which categories generate disproportionate revenue relative to their order volume?

Each category's:

* Completed order share
* Completed revenue share

is compared.

Classification:

* **Revenue Heavy** — Revenue share > Order share
* **Order Heavy** — Order share > Revenue share
* **Balanced** — Revenue share = Order share

---

## Q10 — Executive Business Diagnosis

**Business Question:**
Which customers generate significant revenue but also exhibit unusually high cancellation behavior?

A customer is identified as a **high-priority business case** when both conditions are satisfied:

1. Customer cancellation rate is above the overall cancellation rate
2. Customer completed revenue is above the overall average customer revenue

This combines multiple business metrics into a single decision-oriented analysis.

---

# SQL Techniques Used

## Aggregation

Used extensively for business KPI calculations:

```sql
SUM()
COUNT()
AVG()
MIN()
MAX()
```

---

## Conditional Aggregation

Used to separate completed and cancelled orders:

```sql
SUM(
    CASE
        WHEN status = 'Completed' THEN 1
        ELSE 0
    END
)
```

This technique was used throughout the project for revenue, order, cancellation, and completion analysis.

---

## CASE Expressions

Used for business classification and segmentation:

* Customer value
* Cancellation risk
* Category performance
* Revenue contribution
* Product performance

---

## JOINs

Used to combine relational data across:

```text
Customers → Orders → Products
```

The project uses `INNER JOIN` extensively for customer, product, and transaction analysis.

---

## GROUP BY

Used to aggregate data at different analytical levels:

* Customer
* Product
* Category
* Customer × Product

---

## HAVING

Used to filter aggregated results, such as identifying customers above a revenue threshold or customers with multiple completed purchases.

---

## Common Table Expressions (CTEs)

CTEs were used to break complex analytical problems into logical stages.

Examples include:

* Customer-level datasets
* Product-level datasets
* Category benchmarks
* Revenue benchmarks
* Ranked datasets

---

## Subqueries

Used for benchmark comparisons and identifying maximum aggregated values.

---

## CROSS JOIN

Used to bring overall benchmark metrics into analytical datasets for comparison.

---

## Window Functions

Window functions were used for ranking and category-level analysis.

### RANK()

```sql
RANK() OVER (
    ORDER BY completed_revenue DESC
)
```

Used to rank customers by completed revenue.

### ROW_NUMBER()

```sql
ROW_NUMBER() OVER (
    PARTITION BY category
    ORDER BY completed_revenue DESC
)
```

Used to identify the highest-revenue customer-product relationship within each category.

---

# Analytical Workflow

The project follows a business-first analytical workflow:

```text
Transactional Data
        ↓
Data Aggregation
        ↓
Business Metrics
        ↓
Benchmarks
        ↓
Ranking & Segmentation
        ↓
Business Diagnosis
        ↓
Decision-Oriented Insight
```

The focus is not only on:

> What does the data show?

but also:

> What does the data mean for the business?

---

# Key Learning Outcomes

Through this project, I strengthened my ability to:

* Convert business questions into SQL queries
* Build analytical queries using multiple CTEs
* Perform conditional aggregation
* Calculate business KPIs
* Analyze customers, products, and categories
* Compare performance against benchmarks
* Rank entities using window functions
* Perform customer-product analysis
* Identify revenue concentration
* Analyze cancellation behavior
* Segment customers using business rules
* Diagnose high-priority business cases
* Combine multiple metrics for decision-making
* Think about SQL from a business analyst perspective

---

# Business Analytics Perspective

This project demonstrates how SQL can answer practical questions such as:

* Who are our most valuable customers?
* Which products drive revenue?
* Which categories have performance issues?
* Where are cancellation rates unusually high?
* Is revenue dependent on a small number of customers?
* Which customers repeatedly purchase?
* Which products outperform their category?
* Which categories generate disproportionate revenue?
* Which customers represent both revenue opportunity and business risk?

The ultimate goal is to transform **SQL output into business insight**.

---

# Tools & Technologies

* **MySQL**
* **MySQL Workbench**
* **SQL**
* **CTEs**
* **Window Functions**
* **CASE Expressions**
* **JOINs**
* **Conditional Aggregation**
* **Business KPI Analysis**

---

# Database Schema

The project uses a simple e-commerce-style relational dataset.

### Customers

```text
customer_id
customer_name
city
```

### Orders

```text
order_id
customer_id
product_id
amount
status
order_date
```

### Products

```text
product_id
product_name
category
price
```

### Relationships

```text
Customers
    │
    │ customer_id
    ↓
Orders
    │
    │ product_id
    ↓
Products
```

---

# Author

## Shorya Dev Bisht

**Data Analyst | Data Scientist | Web Analyst**

I am focused on using data analytics, SQL, data science, and machine learning to solve practical business problems and support data-driven decision-making.

---

# Connect With Me

* **LinkedIn:** https://www.linkedin.com/in/shorya-bisht-a20144349/
* **GitHub:** https://github.com/datascientistshorya
* **Medium:** https://medium.com/@its.shoryabisht

---

## Final Takeaway

This project represents a progression from writing basic SQL queries to thinking about **customers, products, revenue, risk, benchmarks, and business decisions**.

> **SQL becomes powerful when it helps answer a business question — not just when the query runs successfully.**
