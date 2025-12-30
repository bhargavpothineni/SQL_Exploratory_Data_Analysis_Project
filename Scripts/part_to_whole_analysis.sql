/*
Script Purpose: 
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

*/

--- part to whole analysis
-- analyse how an individual part is performing compare dto the overall, allowing us to understand which category has the greastest impact on business

-- which category contributes the most to overall sales

with cte as
(
select dp.category, sum(fs.sales_amount) as total_sales 
from gold.fact_sales fs
left join gold.dim_products dp
on fs.product_key = dp.product_key
group by dp.category)

select category, total_sales,
sum(total_sales) over() overall_sales,
concat(round((cast(total_sales as float)/ sum(total_sales) over()) * 100 , 2),' %') as percentage_total
from cte
order by total_sales desc;
