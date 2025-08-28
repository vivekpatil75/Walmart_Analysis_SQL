

bulk insert dbo.sales
from 'C:\temp\Walmart_Sales_Data.csv'
with (
	firstrow=2,
	fieldterminator=',',
	rowterminator='\n',
	tablock
);


select * from sales;
==============================================================================================================================
Basic Analysis

-- how many city in which walmart operates
select distinct(city) from sales;


-- types of customer
select distinct(customer_type) from sales;


---how many branch 
select distinct(Branch) from sales; 


--types of payment methods
select distinct(payment) from sales;


--types of products category
select distinct(product_line) from sales;


-- time frame of this data
select min(Date) as start_date, max(Date) as last_date from sales;


-- finding which branch belongs to which city
select distinct(city),branch 
from sales 
group by city,branch
order by branch;

======================================================================================================================================
City Analysis

--orders from cities
with total_orders as(
select count(invoice_ID) as orders from sales
)
select city,count(invoice_ID) as 'Orders from Each City',
round(count(invoice_ID)*100.0/nullif(t.orders,0),2) as 'Order Count Percentage'
from sales,total_orders  t
group by city,t.orders
order by Count(invoice_ID) desc;


-- revenue from city
with total_sales as(
select sum(total) as revenue from sales
)
select city,sum(total) as 'Total Sales',
cast(round(sum(total)*100.0/nullif(t.revenue,0),2) as decimal(5,2)) as 'sales percentage'
from sales,total_sales t
group by city,t.revenue
order by sum(total) desc;


-- which payment method does the gender use and how much does the gender in each city contribute to overall orders and sales
 
	SELECT 
    s.city,
    s.gender,
    s.payment,
    COUNT(s.invoice_id) AS total_orders,
    (SELECT COUNT(invoice_id) FROM sales) AS total_orders_all,
    CAST(ROUND(COUNT(s.invoice_id) * 100.0 / NULLIF((SELECT COUNT(invoice_id) FROM sales), 0), 2) AS DECIMAL(6,2)) AS [Order Percentage],
    SUM(s.total) AS total_sales,
    CAST(ROUND(SUM(s.total) * 100.0 / NULLIF((SELECT SUM(total) FROM sales), 0), 2) AS DECIMAL(6,2)) AS [Sales Percentage]
FROM 
    sales s
GROUP BY 
    s.city,s.gender, s.payment
ORDER BY 
    s.city, s.gender, s.payment;


-- finding which payment method does the gender use considering every city individually
WITH city_totals AS (
    SELECT 
        city,
        COUNT(invoice_id) AS city_order_total,
        SUM(total) AS city_sales_total
    FROM sales
    GROUP BY city
)
SELECT 
    s.city,
    s.gender,
    s.payment,
    COUNT(s.invoice_id) AS total_orders,ct.city_order_total,
    CAST(ROUND(COUNT(s.invoice_id) * 100.0 / NULLIF(ct.city_order_total, 0), 2) AS DECIMAL(6,2)) AS [Order Percentage],
    SUM(s.total) AS total_sales,ct. city_sales_total,
    CAST(ROUND(SUM(s.total) * 100.0 / NULLIF(ct.city_sales_total, 0), 2) AS DECIMAL(6,2)) AS [Sales Percentage]
FROM 
    sales s
JOIN city_totals ct ON s.city = ct.city
GROUP BY 
    s.city, s.gender, s.payment, ct.city_order_total, ct.city_sales_total
ORDER BY 
    s.city, s.gender, s.payment;


-- how much they spend in city gender wise
select city,gender,sum(total) as 'Total Sales'
from sales
group by city,gender
order by city;


-- how much payment method contribution in city
with payments as (
select city,sum(total) as revenue
from sales 
group by city
)
select s.city,
s.payment,
sum(s.total) as total_sales,
cast(round(sum(s.total)*100.0/nullif(p.revenue,0),2)as decimal(5,2)) as 'sales percentage'
from sales s join  payments p on s.city=p.city
group by s.city,s.payment,p.revenue
order by s.city;


--sales and Oredrs done by customer type in cities
with totals as(
select city,sum(total) as revenue,count(invoice_id) as total_orders
from sales
group by city
)
select s.city,s.customer_type,count(invoice_id) as order_count,
cast(round(count(invoice_id)*100.0/nullif(t.total_orders,0),2)as decimal(5,2)) as 'Order Percentage',
sum(s.total) as total_sales,
cast(round(sum(total)*100.0/nullif(t.revenue,0),2)as decimal(5,2)) as 'Sales Percentage'
from sales s join totals t 
on s.city=t.city
group by s.city,s.customer_type,t.revenue,t.total_orders
order by s.city;

=======================================================================================================================================
	CUSTOMER TYPE ANALYSIS

-- sales and orders by customer type
with totals as (
select sum(total) as revenue,count(invoice_id) as total_orders 
from sales 
)
select customer_type,count(invoice_id) as orders_count,
cast(round(count(invoice_id)*100.0/nullif(t.total_orders,0),2)as decimal(5,2)) as 'Order Percentage',
sum(total) as total_sales,
cast(round(sum(total)*100.0/nullif(t.revenue,0),2)as decimal(5,2)) as 'Sales Percentage'
from sales,totals t
group by customer_type,t.total_orders,t.revenue;

=====================================================================================================================================
PRODUCT ANALYSIS

--top sales by products
with totals as(
select sum(total) as revenue from sales
)
select product_line,
sum(total) as total_sales,
cast(round(sum(total)*100.0/nullif(t.revenue,0),2)as decimal(5,2)) as [Sales Percentage]
from sales , totals t
group by product_line,t.revenue
order by sum(total) desc;


--top ordered product category
with totals as(
select count(invoice_id) as total_orders from sales
)
select product_line,count(invoice_id) as orders,
cast(round(count(invoice_id)*100.0/nullif(t.total_orders,0),2)as decimal(5,2)) as [Order Percentage Share],
sum(quantity) as total_quantity_ordered 
from sales , totals t
group by product_line,t.total_orders
order by sum(quantity) desc;


--finding which gender buys which products
with totals as (
    select gender, sum(total) as revenue
    from sales 
    group by gender
)
select 
    s.gender,
    s.product_line,
    sum(s.total) as total_sales,
    cast(round(sum(s.total)*100.0 / nullif(t.revenue, 0), 2) as decimal(5,2)) as [sales percentage (sales/total sales by gender)],
	cast(round(sum(s.total)*100.0 / nullif((select sum(total) from sales), 0), 2) as decimal(5,2)) as [sales percentage (sales/overall sales)]
from 
    sales s
    join totals t on s.gender = t.gender
group by 
    s.gender, s.product_line, t.revenue
order by 
    gender asc,total_sales desc;


--- find which category generates how much profit
with totals as (
    select sum(gross_income) as total_profit
    from sales 
)
select product_line,sum(gross_income) as profit,
cast(round(sum(gross_income)*100.0/nullif(t.total_profit,0),2)as decimal(5,2)) as [Profit Share]
from sales, totals t
group by product_line,t.total_profit
order by sum(gross_income) desc;


--finding tax paid by each product 
with totals as (
    select sum(vat) as total_tax
    from sales 
)
select product_line,sum(vat) as tax_paid,
cast(round(sum(vat)*100.0/nullif(t.total_tax,0),2)as decimal(5,2)) as [Tax Share]
from sales, totals t
group by product_line,t.total_tax
order by sum(vat) desc;

=============================================================================================================================
# SALES ANALYSIS

--Number of sales made in each time of the day per weekday

with days as (
select 
invoice_id,date,time,
case
when time between '00:00:00' and '12:00:00' then 'Morning'
when time between '12:01:00' and '16:00:00' then 'Afternoon'
else 'Evening' 
end as time_of_day
from sales
)
select
datename(weekday, date) as day_name, 
time_of_day, 
count(invoice_id) as total_orders
from days
where datename(weekday, date) not in ('Sunday', 'Saturday')
group by datename(weekday, date), time_of_day;



--Identify the customer type that generates the highest revenue.
SELECT customer_type, SUM(total) AS total_sales
FROM sales 
GROUP BY customer_type 
ORDER BY total_sales DESC;


-- Which city pays how much VAT (Value Added Tax)?
SELECT city, SUM(VAT) AS total_VAT
FROM sales 
GROUP BY city 
ORDER BY total_VAT DESC;


--.Which customer type pays the most in VAT?
SELECT customer_type, SUM(VAT) AS total_VAT
FROM sales 
GROUP BY customer_type 
ORDER BY total_VAT DESC ;

===================================================================================================================================
TIME ANALYSIS

--Orders by Hour of Day
SELECT 
    DATEPART(HOUR, time) AS Order_Hour,
    COUNT(*) AS Number_of_Orders
FROM sales
GROUP BY DATEPART(HOUR, time)
ORDER BY Number_of_Orders DESC;


--Product Orders by Hour
SELECT 
    DATEPART(HOUR, time) AS Order_Hour,
    product_line,
    COUNT(*) AS Number_of_Orders
FROM 
    sales
GROUP BY 
    DATEPART(HOUR, time), product_line
ORDER BY 
    Order_Hour, Number_of_Orders DESC;


-----Finding Nmbers of Orders by morning,afternoon and evening
SELECT 
    CASE 
        WHEN DATEPART(HOUR, [Time]) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN DATEPART(HOUR, [Time]) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN DATEPART(HOUR, [Time]) BETWEEN 18 AND 21 THEN 'Evening'
        ELSE 'Night'
    END AS Time_of_Day,
    COUNT(*) AS Number_of_Orders
FROM 
    [walmart].[dbo].[sales]
GROUP BY 
    CASE 
        WHEN DATEPART(HOUR, [Time]) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN DATEPART(HOUR, [Time]) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN DATEPART(HOUR, [Time]) BETWEEN 18 AND 21 THEN 'Evening'
        ELSE 'Night'
    END
ORDER BY 
    Number_of_Orders DESC;



-- finding revenue by month
select datepart(month,date) as month,sum(total) as revenue 
from sales 
group by datepart(month,date)
order by datepart(month,date) asc;


--finding revenue by days
select datepart(month,date),datepart(day,date) as day,sum(total) as revenue 
from sales 
group by datepart(month,date),datepart(day,date)
order by datepart(day,date) asc;


-- Which branch sold more products than average product sold?
SELECT branch, SUM(quantity) AS quantity
FROM sales GROUP BY branch HAVING SUM(quantity) > AVG(quantity) ORDER BY quantity DESC;


--finding total orders for every hour of weekdays
SELECT datename(weekday,date)as day_name, datepart(hour,time)as time_of_day, COUNT(invoice_id) AS total_orders
FROM sales 
GROUP BY datename(weekday,date), datepart(hour,time)  
HAVING datename(weekday,date) NOT IN ('Sunday','Saturday');


-- Which day of the week has the best average ratings per branch?
SELECT  branch,datename(weekday,date)as day_name , AVG(rating) AS average_rating
FROM sales 
GROUP BY datename(weekday,date), branch 
ORDER BY branch,day_name,average_rating DESC;