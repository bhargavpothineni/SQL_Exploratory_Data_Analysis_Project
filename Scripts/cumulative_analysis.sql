/*
Script Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.


*/

--cumulative analysis
-- aggregate the data progressively over time

--- claclulate the total sales for each month and running total of sales over time

select order_date, total_sales,
sum(total_sales) over (order by year(order_date)) as running_total_sales,
sum(total_sales) over (partition by year(order_date) order by order_date) as running_total_sales_by_month,
avg(avg_price) over (order by year(order_date)) as moving_avg_price
from
(
select DATETRUNC(month,order_date) as order_date, sum(sales_amount) as total_sales,
avg(price) as avg_price
from gold.fact_sales
where order_date is not null
group by DATETRUNC(month, order_date)
) t 
