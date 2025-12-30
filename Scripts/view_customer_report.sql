/*
==================================================================================================================
Customer Report
======================================================================================================================

purpose: 
           - this report consolidates key customer metrics and behaviours
           - creating a view based on the customer report script

Highlights: 
        1.Gathers essential fields such as names, ages, and transaction details.
		2.Segments customers into categories (VIP, Regular, New) and age groups.
		3. aggregates customer- level metrics:
		            - total orders
					- total sales
					- total quantity purchased
					- total products
					- lifespan(in months)
		4. calculates valueable KPI's
		            - recency(months since last order)
					- average order value
					- average monthly spend
*/

--------------------------------------------------------------------------------------------------------------------------
create view gold.report_customers as

with base_query as (

select fs.order_number, fs.order_date, fs.sales_amount, fs.quantity,
fs.product_key,
dc.customer_id,concat( dc.first_name, ' ',dc.last_name) as full_name , dc.gender,dc.country , datediff(year, dc.birthdate, GETDATE()) as customer_age
from gold.fact_sales fs
left join gold.dim_products dp
on fs.product_key = dp.product_key
left join gold.dim_customers dc
on fs.customer_key = dc.customer_key
where fs.order_date is not null
)
, customer_aggeragtion as(

select 
customer_id,full_name, customer_age,
count( distinct order_number) as total_orders, sum(sales_amount) as total_sales, sum(quantity) as total_quantity, count(distinct product_key) as total_products, 
max(order_date) as last_order_date,
datediff(MONTH, min(order_date), max(order_date)) as no_of_months
from base_query
group by customer_id, full_name, customer_age
)

select 
customer_id, full_name, customer_age,
total_orders, total_sales, total_quantity, total_products, no_of_months,
last_order_date,
case 
     when no_of_months >= 12 and total_sales > 5000 then 'VIP'
	 when no_of_months >= 12 and total_sales < 5000 then 'Regular'
	 else 'new'
end as customer_segment,
case 
    when customer_age < 20 then 'under 20'
	when customer_age between 20 and 30 then '20 - 30'
	when  customer_age between 30 and 50 then '30 - 50'
	else 'above 50'
end as age_segment,
DATEDIFF(month, last_order_date, GETDATE()) as recency
-- compute average order value
,case when total_sales = 0 then 0
     else total_sales/total_orders
end as avg_order_value ,
case when total_sales = 0 or no_of_months = 0  then 0
     else total_sales/ no_of_months
end as avg_monthly_spent 
from
customer_aggeragtion

select * from gold.report_customers;
