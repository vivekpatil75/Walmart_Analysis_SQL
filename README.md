# Walmart-Sales-Analysis-SQL-Project
## About
We are analysing Walmart's sales data to identify high-performing branches and products, analyze the sales patterns of various products, and understand customer behavior. The primary objective is to enhance and optimize sales strategies. The dataset utilized in this project is sourced from the Kaggle Walmart Sales Forecasting Competition.

## Purposes of the Project
The main goal of this project is to gain understanding from Walmart's sales data, exploring the various factors that influence sales across different branches.

## About Data
This project's data was obtained from the Kaggle Walmart Sales Forecasting Competition and it encompasses sales transactions from three Walmart branches situated in Mandalay, Yangon, and Naypyitaw, respectively.
The data contains 17 columns and 1000 rows:
| Column            | Description                                   | Data Type        |
|-------------------|-----------------------------------------------|------------------|
| invoice_id        | Invoice of the sales made                     | VARCHAR(30)      |
| branch            | Branch at which sales were made               | VARCHAR(5)       |
| city              | The location of the branch                    | VARCHAR(30)      |
| customer_type     | The type of the customer                       | VARCHAR(30)      |
| gender            | Gender of the customer making purchase        | VARCHAR(10)      |
| product_line      | Product line of the product sold               | VARCHAR(100)     |
| unit_price        | The price of each product                     | DECIMAL(10, 2)   |
| quantity          | The amount of the product sold                 | INT              |
| VAT               | The amount of tax on the purchase             | FLOAT(6, 4)      |
| total             | The total cost of the purchase                | DECIMAL(12, 4)   |
| date              | The date on which the purchase was made       | DATETIME         |
| time              | The time at which the purchase was made       | TIME             |
| payment           | The total amount paid                         | DECIMAL(10, 2)   |
| cogs              | Cost Of Goods sold                            | DECIMAL(10, 2)   |
| gross_margin_pct  | Gross margin percentage                       | FLOAT(11, 9)     |
| gross_income      | Gross Income                                  | DECIMAL(12, 4)   |
| rating            | Rating                                        | FLOAT(2, 1)      |


## Analysis List:

1.	Product Analysis

> Perform an analysis on the data to gain insights into different product lines, determine the top-performing product lines, and identify areas for improvement in other product lines.

2. City Analysis

> Analysing orders,sales and gender preferences from cities.

3.	Sales Analysis
   
> The objective of this analysis is to address the inquiry regarding the sales trends of the product. The outcomes of this analysis can assist in evaluating the efficiency of each applied sales strategy in the business and determining necessary modifications to increase sales.

4.	Customer Analysis

> This analysis is focused on identifying various customer segments, understanding purchasing trends, and evaluating the profitability associated with each of these customer segments.

## Steps for Analysis
***1.	Data Wrangling***

During this initial phase, the data is examined to detect any NULL or missing values, and strategies for data replacement are implemented to address and substitute these values effectively.
- Build a database
- Create a table and insert the data.
- Select columns with null values in them. Null values are not present in our database because, in creating the tables, NOT NULL was specified for each field, effectively filtering out any null values.


***2.  Exploratory Data Analysis (EDA)***

Conducting exploratory data analysis to gain insights from data and perpare new business strategy to improve sales and customer engagement.


## Business Questions to Answer

### Basic EDA
1.	How many distinct cities are present in the dataset?
2.	Types of Customers
3.	No. of Branches
4.	Types of payment methods
5.	Types of products category
6.	Time frame of this data
7.	Finding which branch belongs to which city

### City/Regional Analysis
1.  Total Orders from each city
2.  Total Sales for cities
3.  Which payment method does the gender use and how much does the gender in each city contribute to overall orders and sales
4.  Finding which payment method does the gender use considering every city individually
5.  How much they spend in city gender wise
6.  How much payment method contribution in city
7.  Sales and Oredrs done by customer type in cities

### Product Analysis
1.  Sales by products
2.  Top ordered product category
3.  Finding which gender buys which products
4.  Find which category generates how much profit
5.  Finding tax paid by each product 

### Sales Analysis
1.	Number of sales made in each time of the day per weekday
2.	Identify the customer type that generates the highest revenue.
3.	Which city has the largest tax percent/ VAT (Value Added Tax)?
4.	Which customer type pays the most VAT?

### Customer Analysis
1.	Sales and Orders by Customer type

### Time Analysis
1.  Orders by Hour of Day
2.  Product Orders by Hour
3.  Finding Nmbers of Orders by morning,afternoon and evening
4.  Finding revenue by month
5.  Finding revenue by days
6.  Which branch sold more products than average product sold?
7.  Finding total orders for every hour of weekdays
8.  Which day of the week has the best average ratings per branch?
