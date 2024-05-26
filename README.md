# Coffee-Shop-Sales

## Project Overview ##
This project involves a comprehensive sales analysis for a coffee shop, focusing on key performance indicators (KPIs) like total sales, orders, and quantity sold. Visualizations include calendar heat maps, weekday/weekend comparisons, and product category analysis to identify trends and optimize sales strategies across different store locations and time periods.

## Data Cleaning in MySQL ##

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

**KPI'S Requirements**

1. **Total Sales Analysis**
    * Calculate the total sales for each month
    * Determine the month-on-month increase or decrease in sales
    * Calculate the difference in sales between the selected month and the previous month
2. **Total Orders Analysis**
    * Calculate the total number of orders for each month
    * Determine the month-on-month increase or decrease in the number of orders
    * Calculate the difference in the number of orders between the selected month and the previous month
3. **Total Quantity Sold Analysis**
    * Calculate the total quantity sold for each month
    * Determine the month-on-month increase or decrease in the total quantity sold
    * Calculate the difference in the total quantity sold between the selected month and the previous month


**Chart Requirements**

1. **Calendar Heat Map:**
   - A calendar heat map will be implemented to dynamically adjust based on the month selected from a slicer. 
   - Each day on the calendar will be color-coded based on sales volume, with darker shades representing higher sales.
   - Tooltips will be displayed when hovering over a specific day, revealing detailed metrics like sales, orders, and quantity.

2. **Sales Analysis by Weekdays and Weekends:**
   - Sales data will be segmented into weekdays and weekends to analyze variations in performance.
   - This will provide insights into whether sales patterns differ significantly between these two categories.

3. **Sales Analysis by Store Location:**
   - Sales data will be visualized by different store locations.
   - Month-over-month (MoM) difference metrics will be included based on the month selected in the slicer.
   - MoM sales increase or decrease will be highlighted for each store location to identify trends.

4. **Daily Sales Analysis with Average Line:**
    * Display daily sales for the selected month with a line chart.
    * Incorporate an average line on the chart to represent the average daily sales.
    * Highlight bars exceeding or falling below the average sales to identify exceptional sales days.
    * Use a heat map to visualize sales patterns by days and hour (not shown in the part of the image you sent).

5. **Sales Analysis by Product Category:**
    * Analyze sales performance across different product categories.
    * Provide insights into which product categories contribute the most to overall sales.

6. **Top 10 Products by Sales:**
    * Identify and display the top 10 products based on sales volume.
    * Allow users to quickly visualize the best-performing products in terms of sales.

7. **Sales Analysis by Days and Hours:**
    * Utilize a heat map to visualize sales patterns by days and hours.
    * Implement tooltips to display detailed metrics (Sales, Orders, Quantity) when hovering over a specific day-hour.
