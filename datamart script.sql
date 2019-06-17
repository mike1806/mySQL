# Michal Borkowski
# Introduction to Databases: CA2
# Student no 17164532
# 18 04 2019
# Data Mart

/*
Michal Borkowski 17164532
report on:
ex 1. Show all transactions for a given week in your business
*/

create database DataMart;
Create Database  if not exists DataMart;
USE twoCA;
SET GLOBAL event_scheduler = ON;


drop event IF EXISTS sqlReport1;
CREATE EVENT if not exists SQLReport1
On Schedule Every 5 hour
starts current_time() + interval 1 second
ends '2019-04-30 23:59:59'
ON COMPLETION PRESERVE
DO 	
#crate a new table from select statement	
Create Table DataMart.sqlReport1
select
	coalesce (OrderDate, 'GrandTotal') as Date_,
	sum(Quantity) as "Total transactions/day",
    DAYNAME(Orders.OrderDate) as
    Day_in_week
  from Orders
  where OrderDate
    between date '2018-01-01' and '2018-01-08'
    group by OrderDate with rollup;

/*
Michal Borkowski 17164532
report on:
ex 4. Total stock sold to general public (by supplier) (A group by with roll-up)
*/
Create Database  if not exists DataMart;
USE twoCA;
SET GLOBAL event_scheduler = ON;

drop event IF EXISTS sqlReport4;
CREATE EVENT if not exists SQLReport4
On Schedule Every 1 week
starts current_time() + interval 30 minute
ends '2019-12-31 23:59:59'
ON COMPLETION PRESERVE
DO 	
#crate a new table from select statement	
Create Table DataMart.sqlreport4   
  SELECT
    Supply.Supplier,
    SUM(Price * CurrentStock) AS "Total revenue" 
  FROM Stock
  inner join Supply on Stock.ProductNo=Supply.ProductNo
  group by Supplier with rollup;

use dreamhome;
show events from dreamhome;

/*
Michal Borkowski 17164532
report on:
ex 5. Total stock sold to general public (by supplier) (A group by with roll-up)
*/

Create Database  if not exists DataMart;
USE twoCA;
SET GLOBAL event_scheduler = ON;

drop event IF EXISTS sqlReport5;
CREATE EVENT if not exists SQLReport5
On Schedule Every 1 week
starts current_time() + interval 30 minute
ends '2019-12-31 23:59:59'
ON COMPLETION PRESERVE
DO 	
#crate a new table from select statement	
Create Table DataMart.sqlreport5   
select 
	OrderDate as Date_,
	sum(Quantity) as Total_MTD_Transactions,
    DAYNAME(ORDERS.OrderDate) as Day_in_month
	from Orders
	where OrderDate between '2019-03-11' and now()
group by Quantity with rollup;

/*
Michal Borkowski 17164532
report on:
ex 6. Total stock sold to general public (by supplier) (A group by with roll-up)
*/

Create Database  if not exists DataMart;
USE twoCA;
SET GLOBAL event_scheduler = ON;

drop event IF EXISTS sqlReport6;
CREATE EVENT if not exists SQLReport6
On Schedule Every 1 week
starts current_time() + interval 10 minute
ends '2019-12-31 23:59:59'
ON COMPLETION PRESERVE
DO 	
#crate a new table from select statement	
Create Table DataMart.sqlreport6
select 
	sum(TotalPrice) as income_statement, 
	monthname(ORDERS.OrderDate) as Month_in_2019
	from Orders
	where OrderDate between '2019-01-01' and now()
group by Month(Orders.OrderDate) with rollup;

/*
Michal Borkowski 17164532
report on:
ex 7. Detail and total transactions broken down on a monthly basis for 1 year. (A group By with Roll-up)
*/
Create Database  if not exists DataMart;
USE twoCA;
SET GLOBAL event_scheduler = ON;

Create table dataMart.ReportTransactionsMonth
select  
	MONTHNAME(ORDERS.OrderDate) as OrderDate, 
	sum(ORDERS.Quantity) as SumQuantity,
	month(ORDERS.OrderDate) as MonthNum
	from ORDERS
	where OrderDate between '2018-01-01' and '2018-12-31'
group by 
	month(ORDERS.OrderDate) with rollup;
    
drop event IF EXISTS sqlReport7;
CREATE EVENT if not exists SQLReport7
On Schedule Every 1 day
starts current_time() + interval 1 second
ends '2019-04-30 23:59:59'
ON COMPLETION PRESERVE
DO 	
#crate a new table from select statement	
Create Table DataMart.sqlReport7 
select  
	MONTHNAME(ORDERS.OrderDate) as OrderDate, 
	sum(ORDERS.Quantity) as SumQuantity,
	month(ORDERS.OrderDate) as MonthNum
	from ORDERS
	where OrderDate between '2018-01-01' and '2018-12-31'
group by 
	month(ORDERS.OrderDate) with rollup;     
    
/*
Michal Borkowski 17164532
report on:
ex 7. Display the growth in sales/services (as a percentage) for your business, from the 1st month of opening until now.
*/

Create Database  if not exists DataMart;
USE twoCA;
SET GLOBAL event_scheduler = ON;

drop event IF EXISTS sqlReport8;
CREATE EVENT if not exists SQLReport8
On Schedule Every 1 day
starts current_time() + interval 1 second
ends '2019-04-30 23:59:59'
ON COMPLETION PRESERVE
DO 	
Create table dataMart.sqlreport8
select OrderDate, TotalService, PercentageGrowth
from (
	select OrderDate, TotalService,
    case when @start_growth = 0
	then null
    else (TotalService - @start_growth) * 100.00 / @start_growth
	end as PercentageGrowth,
	@start_growth := TotalService,
	MonthNum
from (
    select(Orders.OrderDate) as OrderDate, 
    sum(Orders.Quantity) as TotalService,
	month(ORDERS.OrderDate) as MonthNum
    from Orders
	where OrderDate between '2018-01-01' and '2018-12-31'
	group by MONTHNAME(Orders.OrderDate),
	month(Orders.OrderDate)
	) as T
	order by MonthNum) as SQ
order by MonthNum;
set @start_growth := 0;