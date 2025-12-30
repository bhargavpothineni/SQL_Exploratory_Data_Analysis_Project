
/*
Script Purpose: 
        - To group data into meaningful categories for targeted insights.
        - For customer segmentation, product categorization, or regional analysis.


*/
--- data segmentation
--group the data based on specific range
-- helps understand the correlation between two measures


-- Task : segment products into cost ranges and count how many products fall into each segment

with cte as (
select product_key, product_name, cost,
case 
    when cost < 100 then 'below 100'
	when cost between 100 and 500 then '100 - 500'
	when cost between 500 and 1000 then '500 - 1000'
	else 'above 1000'
end as cost_range
from gold.dim_products)

select  cost_range, count(product_key) as no_of_products
from cte
group by cost_range
order by no_of_products desc

-- sql task :
/* Group customers into three sqgments based on their spending behaviour.
  -: vip : atleast 12 months of history and spending more than $5000.
  -: regular: atleast 12 months of history but spending $5000 or less.
  -: new : lifespan less than 12 months.

  and find the total number of customers by each group.

*/

with cte as (
select fs.customer_key,
datediff(MONTH, min(order_date), max(order_date)) as no_of_months,
sum(sales_amount) as  total_spent,
case 
    when sum(sales_amount) > 5000 and datediff(MONTH, min(order_date), max(order_date)) >= 12 then 'vip'
	when sum(sales_amount) <= 5000 and datediff(MONTH, min(order_date), max(order_date)) >= 12 then 'regular'
	else 'new'
end as customer_groups
from gold.fact_sales fs
left join gold.dim_customers dc
on fs.customer_key = dc.customer_key
group by fs.customer_key)

select customer_groups, count(customer_key) as no_of_customers
from cte
group by customer_groups
order by no_of_customers
