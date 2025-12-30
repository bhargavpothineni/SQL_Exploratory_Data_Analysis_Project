/*
Scrpit Purpose:
               - This Scrpit showcases the Data Exploration part including :
                          - date
                          - dimensions
                          - how many years of sales available 
                          - youngest and oldest customers                                                            
*/

--dimensions exploration
select distinct country
from gold.dim_customers

select distinct category ,subcategory, product_name from gold.dim_products order by 1,2,3

-- date exploration : exploring the business span (early to latest)

select min(order_date) from gold.fact_sales;

select max(order_date) from gold.fact_sales;

--how many years of sales available 

select min(order_date) as first_order,max(order_date) as last_order,
datediff(YEAR,min(order_date),max(order_date) ) as years
from gold.fact_sales;

-- find the youngest and oldest customer
select min(birthdate) as oldest_customer  , max(birthdate) as youngest_customer ,
DATEDIFF(YEAR,min(birthdate), getdate()) as oldest_age,
DATEDIFF(YEAR,max(birthdate), getdate()) as youngest_age
from gold.dim_customers;
