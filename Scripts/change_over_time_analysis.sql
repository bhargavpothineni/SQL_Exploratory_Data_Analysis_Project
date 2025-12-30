/*
Script Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

*/
--change over time
-- sales performance over time

select 
year(order_date) as order_year,
month(order_date) as order_month , sum(sales_amount) as total_sales ,
count(distinct customer_key) as total_customers,
sum(quantity) as total_quantity
from gold.fact_sales
where order_date is not null
group by year(order_date), month(order_date)
order by year(order_date), month(order_date);

---- using datetrunc

select 
DATETRUNC(month, order_date) as order_date , sum(sales_amount) as total_sales ,
count(distinct customer_key) as total_customers,
sum(quantity) as total_quantity
from gold.fact_sales
where order_date is not null
group by DATETRUNC(month, order_date)
order by DATETRUNC(month, order_date);

-- using format

select 
FORMAT(order_date, 'yyyy-MMM') as order_date , sum(sales_amount) as total_sales ,
count(distinct customer_key) as total_customers,
sum(quantity) as total_quantity
from gold.fact_sales
where order_date is not null
group by FORMAT(order_date, 'yyyy-MMM') 
order by FORMAT(order_date, 'yyyy-MMM') ;
