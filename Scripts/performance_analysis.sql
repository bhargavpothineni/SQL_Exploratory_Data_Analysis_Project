/*
Script Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.
*/
--- performance analysis
--- comparing current value with target value


-- analyse the yearly performance of products by comparing each product's sales to both 
-- its average sale performance and previous year's sales

select*, 
avg(avg_sales) over (partition by product_key order by  product_key)
from
(
select product_key,  year(order_date) as order_date, sum(sales_amount) as product_sales, avg(sales_amount) as avg_sales
from gold.fact_sales
where order_date is not null
group by product_key, year(order_date)
) t


select  product_key,year(order_date) as year_order_date, sum(sales_amount) as sales_amount,
avg(sum(sales_amount)) over( partition by product_key) as avg_sales_performance,
sum(sales_amount) - avg(sum(sales_amount)) over( partition by product_key) as diff_avg,
 case
      when sum(sales_amount) - avg(sum(sales_amount)) over( partition by product_key) > 0 then 'Above avg'
	  when sum(sales_amount) - avg(sum(sales_amount)) over( partition by product_key) <0 then 'below avg'
	  else 'avg'
 end as avg_change,
lag(sum(sales_amount)) over(partition by product_key order by year(order_date)) as previous_year_sales,
sum(sales_amount) - lag(sum(sales_amount),1,0) over(partition by product_key order by product_key, year(order_date)) as diff_current_vs_previous,
case
      when sum(sales_amount) - lag(sum(sales_amount),1,0) over(partition by product_key order by product_key, year(order_date)) > 0 then 'increasing'
	  when sum(sales_amount) - lag(sum(sales_amount),1,0) over(partition by product_key order by product_key, year(order_date)) <0 then 'decreasing'
	  else 'no change'
 end as previous_year_change

from gold.fact_sales
where order_date is not null
group by  product_key, year(order_date)
order by product_key, year_order_date;

-- write the same with cte and prduct name

with cte as (
select dp.product_name, year(fs.order_date) as order_year, sum(fs.sales_amount)  as current_sales from gold.fact_sales fs
left join gold.dim_products dp
on fs.product_key = dp.product_key
where fs.order_date is not null
group by dp.product_name, year(fs.order_date))

select product_name, order_year, current_sales,
avg(current_sales) over (partition by product_name) as avg_sales,
current_sales - avg(current_sales) over (partition by product_name) as current_sales_vs_avg_sales,
case 
     when current_sales - avg(current_sales) over (partition by product_name) < 0 then 'below average'
	 when current_sales - avg(current_sales) over (partition by product_name) > 0 then 'above average'
	 else 'average'
end as avg_change,
lag(current_sales) over(partition by product_name order by order_year) as previous_year_sales,
current_sales - lag(current_sales) over(partition by product_name order by order_year) as current_sales_vs_last_year,
case 
     when current_sales - lag(current_sales) over(partition by product_name order by order_year) < 0 then 'decrease'
	 when current_sales - lag(current_sales) over(partition by product_name order by order_year) > 0 then 'increase'
	 else 'no change'
end as avg_change
from cte
