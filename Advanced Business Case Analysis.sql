-- BATCH 4
/*Q1 — Customer Value Segmentation
For each customer, calculate:
•	customer_id 
•	customer_name 
•	total number of orders 
•	total revenue from completed orders only 
•	average completed order value 
Classify customers:
•	High Value → revenue ≥ 10,000 
•	Medium Value → revenue between 5,000 and 9,999 
•	Low Value → revenue < 5,000 
Show only customers with at least one completed order.
Business question: Which customers contribute the most completed-order revenue?*/
select c.customer_id,c.customer_name,count(o.customer_id) as total_orders,
sum(case when o.status='Completed' then o.amount else 0 end) as  completed_revenue,
sum(case when o.status='Completed' then o.amount else 0 end)/
sum(case when o.status='Completed' then 1 else 0 end)as completed_AOV,
case when
	     sum(case when o.status='Completed' then o.amount else 0 end)>=10000 then 'High Value'
	when
         sum(case when o.status='Completed' then o.amount else 0 end)>=5000 then 'Medium Value'
         else 'Low value' end as segment
from customers c inner join orders o 
on c.customer_id=o.customer_id
group by c.customer_id,c.customer_name
having (sum(case when o.status='Completed' then 1 else 0 end))>0;

/*Q2 — Product Revenue Contribution
For each product, calculate:
•	product name 
•	category 
•	total completed orders 
•	total completed revenue 
•	percentage of total completed revenue contributed by that product 
Rank the products from highest to lowest revenue contribution.
Business question: Which products are driving the company's revenue?*/

with prod_data as(
select p.product_name,p.category,
sum(o.amount) as total_completed_revenue,
count(*) as total_orders
from products p inner join orders o 
on p.product_id=o.product_id
where o.status='Completed'
group by  p.product_name,p.category
),
benchmark as(
	select sum(total_completed_revenue) as overall_completed_revenue from prod_data
)
select*,
total_completed_revenue/overall_completed_revenue * 100 as contribution_percent
from prod_data pd
cross join benchmark b
order by contribution_percent desc;

/* Q3 — Category Performance Diagnosis
For each product category, calculate:
•	total orders 
•	completed orders 
•	cancelled orders 
•	completion rate 
•	cancellation rate 
•	total completed revenue 
•	average completed order value 
Then classify the category:
•	Strong → completion rate ≥ 80% 
•	Watch → completion rate between 60% and 79.99% 
•	Critical → completion rate < 60% 
Business question: Which categories require investigation, 
and is the issue volume, conversion, or revenue?*/
WITH prod_data AS (
    SELECT
        p.category,

        COUNT(*) AS total_orders,

        SUM(
            CASE
                WHEN o.status = 'Completed' THEN 1
                ELSE 0
            END
        ) AS completed_orders,

        SUM(
            CASE
                WHEN o.status = 'Cancelled' THEN 1
                ELSE 0
            END
        ) AS cancelled_orders,

        SUM(
            CASE
                WHEN o.status = 'Completed' THEN o.amount
                ELSE 0
            END
        ) AS completed_revenue,

        SUM(
            CASE
                WHEN o.status = 'Completed' THEN o.amount
                ELSE 0
            END
        )
        /
        SUM(
            CASE
                WHEN o.status = 'Completed' THEN 1
                ELSE 0
            END
        ) AS avg_completed_order_value

    FROM products p
    INNER JOIN orders o
        ON p.product_id = o.product_id

    GROUP BY p.category
)

SELECT
    *,
    completed_orders / total_orders * 100 AS completion_rate,
    cancelled_orders / total_orders * 100 AS cancellation_rate,

    CASE
        WHEN completed_orders / total_orders * 100 >= 80
            THEN 'Strong'
        WHEN completed_orders / total_orders * 100 >= 60
            THEN 'Watch'
        ELSE 'Critical'
    END AS class

FROM prod_data;

/*Q4 — Customer Cancellation Analysis
For every customer with at least one order, calculate:
•	total orders 
•	completed orders 
•	cancelled orders 
•	cancellation rate 
•	completed revenue 
Classify customers:
•	High Risk → cancellation rate ≥ 50% 
•	Medium Risk → cancellation rate between 25% and 49.99% 
•	Low Risk → cancellation rate < 25% 
Sort by cancellation rate descending.
Business question: Which customers show unusually high cancellation behavior?*/

with customer_data as(
select c.customer_id,c.customer_name,count(o.customer_id) as total_orders,
sum(case when o.status='Completed' then 1 else 0 end) as  completed_orders,
sum(case when o.status='Cancelled' then 1 else 0 end) as  cancelled_orders,
sum(case when o.status='Completed' then o.amount else 0 end) as  completed_revenue
from customers c inner join orders o 
on c.customer_id=o.customer_id
group by c.customer_id,c.customer_name
)
select * ,
cancelled_orders/total_orders*100 as cancellation_rate,
case 
	when cancelled_orders/total_orders*100>=50 then 'High Risk'
    when cancelled_orders/total_orders*100>=25 then 'Medium Risk'
    else 'Low Risk'
    end as Risk_analysis
from customer_data;

/*Q5 — Product × Customer Analysis
For every customer-product combination that has at least one order, calculate:
•	customer name 
•	product name 
•	category 
•	total orders 
•	completed orders 
•	completed revenue 
•	average completed order value 
Then identify the highest-revenue customer-product combination within each category.
Business question: Who are the strongest customer-product relationships within each category?*/

with customer_data as (
	select c.customer_name,p.product_name,p.category,
    count(o.customer_id) as total_orders,
    sum(case when o.status='Completed' then 1 else 0 end) as completed_orders,
    sum(case when o.status='Completed' then o.amount else 0 end) as completed_revenue,
    sum(case when o.status='Completed' then o.amount else 0 end)/
    sum(case when o.status='Completed' then 1 else 0 end) as avg_completed_revenue
    from customers c inner join orders o 
    on c.customer_id=o.customer_id
    inner join products p 
    on p.product_id=o.product_id
    group by c.customer_name,p.product_name,p.category
),
ranked_data AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY category
            ORDER BY completed_revenue DESC
        ) AS revenue_rank
    FROM customer_data
)
select * from ranked_data
where revenue_rank=1;

/*Q6 — Revenue Concentration Analysis
Calculate each customer's:
•	completed revenue 
•	percentage contribution to total completed revenue 
•	rank by completed revenue 
Then classify customers:
•	Top Contributor → revenue ≥ 20% of total revenue 
•	Major Contributor → revenue ≥ 10% 
•	Regular Contributor → revenue < 10% 
Business question: Is revenue concentrated among a small number of customers?*/
with customer_data as(
	select c.customer_name,
    sum(case when o.status='Completed' then o.amount else 0 end) as completed_revenue
    from customers c inner join orders o 
    on c.customer_id=o.customer_id
    group by c.customer_name
),
benchmark as(
	select sum(completed_revenue) as total_completed_revenue
    from customer_data
),
ranked_data as(
select *,
cd.completed_revenue/b.total_completed_revenue*100 as contribution,
rank() over(order by cd.completed_revenue desc) as revenue_rank
from customer_data cd
cross join benchmark b
)
select *,
case when contribution>=20 then 'Top contributor'
	 when contribution>=10 then 'Major contributor'
	 else  'Regular contributor'
     end as category
     from ranked_data;

/*Q7 — Product Performance vs Category Average
For each product, calculate:
•	product name 
•	category 
•	product completed revenue 
•	product average completed order value 
•	category average completed order value 
Then classify each product:
•	Above Category Average 
•	Below Category Average 
Show the difference between the product's average order value and its category average.
Business question: Which products are outperforming or 
underperforming their category's typical order value?*/
with prod_data as(
	select p.product_name,p.category,
    sum(o.amount) as completed_revenue,
    sum(o.amount)/count(*) as avg_completed_revenue
    from products p inner join orders o
    on p.product_id=o.product_id
    where o.status='Completed'
    group by p.product_name,p.category
),
cat_benchmark as(
	select category,avg(avg_completed_revenue) cat_avg from prod_data
    group by category
)
select *,
pd.avg_completed_revenue-cb.cat_avg as difference,
case when pd.avg_completed_revenue>cb.cat_avg then 'above avg'
	 else 'below avg'
     end as class
from prod_data pd
INNER JOIN cat_benchmark cb
    ON pd.category = cb.category;
    
/*Q8 — Customer Repeat-Purchase Analysis
Identify customers who have placed more than one completed order.
For each qualifying customer, calculate:
•	customer name 
•	number of completed orders 
•	total completed revenue 
•	average completed order value 
•	highest completed order value 
•	lowest completed order value 
Then classify them:
•	High Repeat Value → 4+ completed orders 
•	Medium Repeat Value → 2–3 completed orders 
Sort by completed orders and then revenue.
Business question: Which customers demonstrate strong repeat-purchase behavior?*/
    
with customer_data as(
	select c.customer_id,c.customer_name,sum(o.amount) as completed_revenue,
    count(*) as completed_orders,
    sum(o.amount)/count(*) as avg_completed_AOV
    from customers c inner join orders o 
    on c.customer_id=o.customer_id
    where o.status='Completed'
    group by c.customer_id,c.customer_name
),
stats as (
	select customer_id,
    max(amount) as max_revenue,
    min(amount) as min_revenue
    from orders
    where status='Completed'
    group by customer_id
)
select *,
case 
	when cd.completed_orders>=4 then 'High Repeat value'
    else
    'Medium Repeat value'
    end as class 
from
customer_data cd inner join stats s
on cd.customer_id=s.customer_id
having cd.completed_orders>1
order by cd.completed_orders desc,cd.completed_revenue desc;

/*Q9 — Category Revenue vs Order Volume
For each category, calculate:
total completed orders
total completed revenue
average completed order value
percentage of total completed orders
percentage of total completed revenue
Then determine whether each category is:
Revenue Heavy → revenue share > order share
Volume Heavy → order share > revenue share
Balanced → revenue share = order share
Business question: Which categories generate disproportionate revenue relative to their order volume?*/

with category_data as(
	select p.category,count(o.order_id) as total_orders,
    sum(case when o.status='Completed' then 1 else 0 end) as total_completed_orders, 
	sum(case when o.status='Completed' then o.amount else 0 end) as total_completed_revenue,
    sum(o.amount) as total_revenue
    from products p inner join orders o 
    on p.product_id=o.product_id
    group by p.category
),
benchmark AS (
    SELECT
	
        SUM(total_completed_revenue) AS overall_completed_revenue,
        SUM(total_completed_orders) AS overall_completed_orders
    FROM category_data
    
)

select category,
cd.total_completed_revenue/b.overall_completed_revenue*100 as revenue_share,
cd.total_completed_orders/b.overall_completed_orders* 100 as order_share,
case 
	when cd.total_completed_revenue/b.overall_completed_revenue*100> cd.total_completed_orders/b.overall_completed_orders* 100 then 'Revenue Heavy'
	when cd.total_completed_orders/b.overall_completed_orders* 100> cd.total_completed_revenue/b.overall_completed_revenue*100 then 'Order Heavy'
    else 'Balanced' end as segment
from category_data cd cross join benchmark b;

/*Q10 — Executive Business Diagnosis

Build a customer-level business analysis containing:

customer name
total orders
completed orders
cancelled orders
cancellation rate
completed revenue
average completed order value
customer revenue rank
Then identify customers who satisfy both conditions:
Their cancellation rate is above the overall customer cancellation rate
Their completed revenue is above the overall average customer revenue
Return these customers as high-priority business cases.
Business question: Which customers generate significant revenue but also exhibit unusually high cancellation behavior?*/
with customer_data as(
	select c.customer_name, count(o.customer_id) as total_orders,
    sum(case when o.status='Completed' then 1 else 0 end) as completed_order,
    sum(case when o.status='Cancelled' then 1 else 0 end) as cancelled_orders,
	sum(case when o.status='Completed' then o.amount else 0 end) as completed_revenue,
    sum(case when o.status='Completed' then o.amount else 0 end)/
    sum(case when o.status='Completed' then 1 else 0 end) as avg_completed_revenue,
    sum(case when o.status='Cancelled' then 1 else 0 end)/ count(o.customer_id) *100 as cancellation_rate
    from customers c inner join orders o 
    on c.customer_id=o.customer_id
    group by c.customer_name
),
ranked_data AS (
    SELECT *,
        RANK() OVER(
            ORDER BY completed_revenue DESC
        ) AS customer_revenue_rank
    FROM customer_data
),
benchmark as(
	select sum(cancelled_orders) / SUM(total_orders) * 100
            AS overall_cancellation_rate,

        AVG(completed_revenue)
            AS overall_average_customer_revenue
    FROM ranked_data
)
select * from ranked_data cd cross join benchmark b
where cd.cancellation_rate>b.overall_cancellation_rate
and 
cd.completed_revenue>b. overall_average_customer_revenue;


    
    

		