/*
Script Purpose:
              - to view all the tables resides in "datawarehouse" database
              - to view all the columns that are in the table "dim_customers"
*/



--- Database exploration 
use datwarehouse;
-- retrive all the tables details
select * from INFORMATION_SCHEMA.TABLES;
-- retrive all the columns details
select * from INFORMATION_SCHEMA.columns
where TABLE_NAME = 'dim_customers';
