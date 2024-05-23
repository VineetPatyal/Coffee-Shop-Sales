SELECT * FROM coffee_shop_sales_db.coffee_shop_sales;
#Data Cleaning in MySQL
#1 Change Data Type to DATE for transaction_date column
update coffee_shop_sales
SET transaction_date = str_to_date(transaction_date, '%d/%m/%Y');

Alter table coffee_shop_sales
MODIFY column transaction_date DATE;

describe coffee_shop_sales;

#2 Change Data Type to TIME for transaction_time column
update coffee_shop_sales
SET transaction_time = str_to_date(transaction_time, '%H:%i:%s');

Alter table coffee_shop_sales
MODIFY column transaction_time time;

describe coffee_shop_sales;

#3 Change field name for column transaction_id column?

ALTER table coffee_shop_sales
CHANGE COLUMN ï»¿transaction_id transaction_id int;

describe coffee_shop_sales;

## PROBLEM STATMENT ##
#1. Total Sales Analysis
-- Calculate total sales for each respective month
-- Determine month on month increase or descrease in sales
-- Difference in sales between selected month and previous month
Select 
MONTH(transaction_date) as month, -- No. of months
round(sum(unit_price * transaction_qty)) as total_sales, -- Total sales column
(sum(unit_price * transaction_qty) - LAG(sum(unit_price * transaction_qty),1) -- Month Sale Difference
over(order by month(transaction_date)))/ LAG(sum(unit_price * transaction_qty),1) -- Division by prev month sale
over(order by month(transaction_date))*100 As mom_increased_percentage -- percentage of sales increase or descrease
from coffee_shop_sales
Where month(transaction_date) IN (4,5) -- for months of April(prev M) Month and may(current M)
Group by 
    month(transaction_date)
order by
    month(transaction_date);

#2. Total Orders Analysis
-- Calculate the total number of orders for each month
-- Determine the month-on-month increase or decrease in the number of orders
-- Calculate the difference in the number of orders between the selected month and the previous month

Select
month(transaction_date) as month,
Round(count(transaction_id)) as total_Orders,
(count(transaction_id) - LAG(count(transaction_id),1)
over(order by month(transaction_date))) / LAG(count(transaction_id),1)
over(order by month(transaction_date))*100 as mom_increase_order
from coffee_shop_sales
Where month(transaction_date) IN (4,5)
Group by
	month(transaction_date)
Order by
    month(transaction_date);

#3. Total Quantity Sold Analysis
-- Calculate the total quantity sold for each month
-- Determine the month-on-month increase or decrease in the total quantity sold
-- Calculate the difference in the total quantity sold between the selected month and the previous month

Select
month(transaction_date) as month,
Round(sum(transaction_qty)) as total_quantity_sold,
(sum(transaction_qty) - LAG(sum(transaction_qty),1)
over(order by month(transaction_date))) / LAG(sum(transaction_qty),1)
over(order by month(transaction_date))*100 as mom_order
from coffee_shop_sales
Where month(transaction_date) IN (4,5)  -- for April and may
Group by
	month(transaction_date)
Order by
    month(transaction_date);
    
# CALENDAR TABLE – DAILY SALES, QUANTITY and TOTAL ORDERS

Select CONCAT(ROUND(sum(unit_price * transaction_qty)/1000,1),"K") as Total_sales,
       CONCAT(ROUND(sum(transaction_qty)/1000,1),"K") as Total_Qty_Sold,
       CONCAT(ROUND(count(transaction_id)/1000,1),"K") as Total_Orders
from coffee_shop_sales
Where transaction_date = '2023-03-27';

# Sales Analysis by Weekdays and Weekends
-- Weekends - sat & sun
-- Weekdays - Mon to Fri
-- By Default in MySQl sun = 1, mon = 2, Tue = 3, Wed = 4, Thu = 5 , Fri = 6, Sat = 7

Select
     CASE WHEN dayofweek(transaction_date) IN (1,7) Then 'Weekends'
     Else 'Weekdays' END as Day_type,
     CONCAT(ROUND(sum(unit_price * transaction_qty)/1000,1),'K') as Total_sales
From coffee_shop_sales
Where MONTH(transaction_date) = 2 -- Month
group by
       CASE WHEN dayofweek(transaction_date) IN (1,7) Then 'Weekends'
       Else 'Weekdays' END;

# Sales Analysis by Store Location:

Select
     store_location,
     CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,2),'K') as Total_Sales
From coffee_shop_sales
Where month(transaction_date) = 5 -- May
group by store_location
order by Total_Sales desc;

# Daily Sales Analysis with Average Line

SELECT
     CONCAT(ROUND(AVG(Total_Sales)/1000,1),' K') as Avg_Sales
From
   ( Select SUM(unit_price * transaction_qty) as Total_Sales
    From coffee_shop_sales
    Where month(transaction_date) = 4
    group by transaction_date
    ) as inner_query;
    
# Daily sales/ sales of each day for a selected month

Select
     DAY(transaction_date) as day_of_month,
     CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,1),'K') as total_sales
from coffee_shop_sales
Where month(transaction_date) = 5
Group by DAY(transaction_date)
order by DAY(transaction_date); 

# Highlight bars exceeding or falling below the average sales to identify exceptional sales days.

Select
    Day_of_month,  
	CASE
      WHEN Total_Sales > Avg_sales THEN 'Above Average'
      WHEN Total_Sales < Avg_sales THEN 'Below Average'
      Else 'Average'
    END as sales_status,
    Total_Sales
from(
     Select
     day(transaction_date) as Day_of_month,
     ROUND(SUM(unit_price * transaction_qty),1) as Total_Sales,
     avg(sum(unit_price * transaction_qty)) over() as Avg_sales
	 from 
        coffee_shop_sales
	 Where 
        month(transaction_date) = 5  -- May Month
     group by 
        day(transaction_date)
) As Sales_data
order by
       Day_of_month;
     
 # Sales Analysis by Product Category:
     
Select
    product_category,
    CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,1),'K') as Total_sales
From
    coffee_shop_sales
Where MONTH(transaction_date) = 5
Group by product_category
Order by SUM(unit_price * transaction_qty) desc;

# Top 10 Products by Sales

Select
      product_type,
      CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,1),'K') as Total_sales
From
    coffee_shop_sales
Where MONTH(transaction_date) = 5
Group by product_type
Order by SUM(unit_price * transaction_qty) desc
Limit 10;

# Sales by product Category 'Coffee'

Select
      product_type,
      CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,1),'K') as Total_sales
From
    coffee_shop_sales
Where MONTH(transaction_date) = 5 AND product_category = 'Coffee'
Group by product_type
Order by SUM(unit_price * transaction_qty) desc
Limit 10;

# Sales Analysis by Days and Hours, show total sales, qty sold, total orders

Select
      ROUND(SUM(unit_price * transaction_qty),1) as Total_sales,
      sum(transaction_qty) As Total_qty_sold,
      count(*) as Total_orders
From
    coffee_shop_sales
Where MONTH(transaction_date) = 5  -- May
AND dayofweek(transaction_date) = 1 -- Sunday
AND hour(transaction_time) = 14 -- hour no. 8

# Sales patterns by hours

Select
      Hour(transaction_time),
      CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,2),'K') as Total_sales
From
    coffee_shop_sales
Where MONTH(transaction_date) = 5  -- May
group by Hour(transaction_time)
Order by Hour(transaction_time);

# Sales patterns by days

Select
      CASE 
		WHEN dayofweek(transaction_date) = 2 THEN 'Monday'
        WHEN dayofweek(transaction_date) = 3 THEN 'Tuesday'
        WHEN dayofweek(transaction_date) = 4 THEN 'Wednesday'
        WHEN dayofweek(transaction_date) = 5 THEN 'Thursday'
        WHEN dayofweek(transaction_date) = 6 THEN 'Friday'
        WHEN dayofweek(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
      END as Day_of_Week,
      ROUND(SUM(unit_price * transaction_qty),2) as Total_sales
From
    coffee_shop_sales
Where MONTH(transaction_date) = 5  -- May
group by 
	  CASE 
		WHEN dayofweek(transaction_date) = 2 THEN 'Monday'
        WHEN dayofweek(transaction_date) = 3 THEN 'Tuesday'
        WHEN dayofweek(transaction_date) = 4 THEN 'Wednesday'
        WHEN dayofweek(transaction_date) = 5 THEN 'Thursday'
        WHEN dayofweek(transaction_date) = 6 THEN 'Friday'
        WHEN dayofweek(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
      END;