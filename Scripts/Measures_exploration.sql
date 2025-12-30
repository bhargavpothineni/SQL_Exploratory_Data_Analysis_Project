/*
Script Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

*/



-- Measures exploration
-- calculate the key metrics of the business(big numbers)
-- highest level of aggregation, lowest level of details.

-- find the total sales
-- find how many items are sold
-- find the average selling price
-- find the total number of orders
--find the total number of products
-- find the total number of customers
-- find the total number of customers that has placed an order

select sum(sales_amount) from gold.fact_sales -- 29356250

select sum(quantity) from gold.fact_sales -- 60423

select avg(price) from gold.fact_sales -- 486

select count( distinct order_number) from gold.fact_sales -- 27659
select count( distinct product_id) from gold.dim_products -- 295
select count(customer_id) from gold.dim_customers -- 18484

select count(customer_id) from gold.dim_customers where customer_id in (select customer_id from gold.fact_sales) -- 18484

-- generate a report that shows all key metrics of the business
select 'total sales ' as measure_name ,sum(sales_amount) as measure_value from gold.fact_sales
union all
select 'total quantity ' as measure_name ,sum(quantity) as measure_value from gold.fact_sales
union all
select 'Avg price ' as measure_name ,avg(price) as measure_value from gold.fact_sales
union all
select 'total orders ' as measure_name ,count( distinct order_number) as measure_value from gold.fact_sales
union all
select 'total products ' as measure_name ,count( distinct product_id) as measure_value from gold.dim_products
union all
select 'total customers ' as measure_name ,count(customer_id) as measure_value from gold.dim_customers
union all
select 'total customers who placed orders' as measure_name ,count(customer_id) 
  from gold.dim_customers where customer_id in (select customer_id from gold.fact_sales);
