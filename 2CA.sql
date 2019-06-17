# Michal Borkowski
# Introduction to Databases: CA2
# Student no 17164532
# 18 04 2019
# Operational Data

create database twoCA;
use twoCA;

Create table Customer(
LoginID varchar(20) not null default 'C',
FirstName varchar(20) not null,
LastName varchar(20)not null,
dob date not null,
Age int,
Address varchar(90) not null,
City varchar (100),
PremiumCustomer boolean,
primary key (LoginID),
check (Age>=18)
);

Create table Orders(
OrderID varchar(10) not null default 'O',
LoginID varchar(20) not null default 'C', 
Quantity int not null,
TotalPrice double,
OrderDate date,
foreign key (LoginID) references Customer(LoginID) on update cascade,
primary key (OrderID)
);

Create table Stock(
ProductNo varchar(10) not null default 'P',
ItemCountry varchar(40) not null,
Price double,
PremiumPrice double,
DateIssue int(10),
CurrentStock int(255),
primary key (ProductNo)
);

Create table Supply(
Supplier varchar(10) not null,
ProductNo varchar(10) not null,
email varchar(50) not null,
TimeZone varchar(50) not null,
ContractType varchar (10) check ('EG''SQ'),
foreign key (ProductNo) references Stock(ProductNo) on update cascade
);

Create table Cancellations(
CancelReason varchar(10) not null check ('AgeLimit' 'Complaint' 'Withdraw'),
OrderID varchar(10),
StatusCase varchar (10) check ('Accept''Declined'),
foreign key (OrderID) references Orders(OrderID) on update cascade
);

/*
Michal Borkowski 17164532
1. Show all transactions for a given week in your business
*/

use twoCA;

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
    DAYNAME(Orders.OrderDate) as Day_in_week
  from Orders
  where OrderDate
    between date '2018-01-01' and '2018-01-08'
    group by OrderDate with rollup;

 /*
Michal Borkowski 17164532
2. Create a trigger that stores stock levels once a sale takes place
*/

use twoCA;

# every time we update the level stock then we will store the old value in table called "previous_stock"
Drop table if exists previous_stock;
create table Previous_stock (
id int auto_increment primary key,
ProductNo varchar(10) not null default 'P',
LastLevel int not null,
ChangeDate datetime default null,	
Actions varchar(50) default null
);
Drop Trigger if exists level_stock;
use twoCA;
DELIMITER $$
CREATE TRIGGER level_stock
BEFORE UPDATE ON Stock #trigger is set on stock table
FOR EACH ROW 
		BEGIN
        INSERT INTO previous_stock #saved on previous_stock table
        SET actions = 'update',
			ProductNo = OLD.ProductNo, # OLD is a key word
            LastLevel = OLD.CurrentStock,
            ChangeDate = NOW(); # NOW current tistaff_auditstaffstaffme, when the change was applied
		END$$
DELIMITER ;

drop trigger level_stock;

update Stock set CurrentStock='125' where ProductNo='P11007'; 

/*
Michal Borkowski 17164532
3. Create a view of stock (by supplier) purchased by you
*/

use twoCA;

create view my_stock_bySupplier
as
select 
	Supply.Supplier,
    Supply.TimeZone,
	stock.ProductNo, 
    stock.CurrentStock as my_Purchase
from Stock
inner join Supply on Stock.ProductNo=Supply.ProductNo # joining only in elements which are related to query
order by CurrentStock asc;

/*
Michal Borkowski 17164532
4. Total stock sold to general public (by supplier) (A group by with roll-up)
*/

use twoCA;

SELECT
    Supply.Supplier,
    SUM(Price * CurrentStock) AS "Total revenue"
  FROM Stock
  inner join Supply on Stock.ProductNo=Supply.ProductNo
  group by Supplier with rollup;
  
/*
Michal Borkowski 17164532
5. Detail and total transactions for the month-to-date. (A Group By with Roll-up)
*/

use twoCA;

select 
	OrderDate as Date_,
	sum(Quantity) as Total_MTD_Transactions,
    DAYNAME(ORDERS.OrderDate) as Day_in_month
	from Orders
	where OrderDate between '2019-03-11' and now()
group by Quantity with rollup;

/*
Michal Borkowski 17164532
6. Detail and total revenue for the year-to-date. (A group By with Roll-up)
*/

use twoCA;

select 
	sum(TotalPrice) as income_statement, 
	monthname(ORDERS.OrderDate) as Month_in_2019
	from Orders
	where OrderDate between '2019-01-01' and now()
group by Month(Orders.OrderDate) with rollup;

/*
Michal Borkowski 17164532
7. Detail and total transactions broken down on a monthly basis for 1 year. (A group By with Roll-up)
*/
use twoCA;

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
8. Display the growth in sales/services (as a percentage) for your business, from the 1st month of opening until now.
*/

use twoCA;

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


