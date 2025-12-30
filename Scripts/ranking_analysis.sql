
/*
  Script Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.
*/




-- ranking Analysis
-- order the values of dimensions by measure to identify the top and bottom performers
-- fromula: rank[dimension] by agg[measure]

-- which 5 products generate highest revenue

select top 5 dp.product_name,sum(fs.sales_amount) as total_revenue from gold.fact_sales fs
left join gold.dim_products dp
on fs.product_key = dp.product_key
group by dp.product_name order by sum(fs.sales_amount) desc;


-- what are the 5 worst performing products in terms of sale

select top 5 dp.product_name,sum(fs.sales_amount) as total_revenue from gold.fact_sales fs
left join gold.dim_products dp
on fs.product_key = dp.product_key
group by dp.product_name order by sum(fs.sales_amount);

-- with window functions
select * from 
(
select 
ROW_NUMBER() over (order by sum(fs.sales_amount) desc) as rank_products,
dp.product_name,sum(fs.sales_amount) as total_revenue from gold.fact_sales fs
left join gold.dim_products dp
on fs.product_key = dp.product_key
group by dp.product_name)t
where rank_products <= 5;

-- find the top 1 customers who have generated the highest revenue and 3 customers with the fewest orders placed

select * from gold.fact_sales;
select * from gold.dim_customers;


select  top 10 dc.customer_id,dc.first_name, dc.last_name, sum(sales_amount) as total_sales from gold.fact_sales fs
left join gold.dim_customers dc
on fs.customer_key = dc.customer_key
group by dc.customer_id,dc.first_name, dc.last_name
order by total_sales desc

select  top 3 dc.customer_id, dc.first_name, dc.last_name,count(distinct fs.order_number) as total_orders from gold.fact_sales fs
left join gold.dim_customers dc
on fs.customer_key = dc.customer_key
group by dc.customer_id, dc.first_name, dc.last_name
order by total_orders
