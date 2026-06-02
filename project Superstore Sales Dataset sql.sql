
1. Calculate monthly sales.

select month (order_date) as months,sum(sales)as total_sales
from [Sample - Superstore]
group by month (order_date)
order by month (order_date) asc


2. Find customers who placed more than 5 orders.


select customer_name,quantity
from [Sample - Superstore]
where quantity>5


3. Find products with negative profit.

select product_name from [Sample - Superstore] where profit<'0'


4. Find average delivery days.

select avg(datediff(day ,order_date,ship_date))as avg_delievery_days
 from [Sample - Superstore]



5. Find the state with the highest sales.


 select top 1
 sum(sales)as highest_sales,state
from [Sample - Superstore]
group by state
order by state desc


6. Find the second-highest sale amount.

with cte as
( select sales,dense_rank() over (order by sales desc) as rnk
from [Sample - Superstore])
select sales from cte
where rnk=2


7. Rank customers by total sales.


select sum(sales) as total_sales,customer_name,
rank()over(order by sum(sales) desc) as customer_rank
from [Sample - Superstore] 
group by customer_name


8. Calculate running total sales by month.

with monthly_sales as
(select sum(sales)as monthly_sales,year(order_date) as sales_year,month(order_date)as sales_month from [Sample - Superstore] group by year(order_date),month(order_date))

select sales_year,sales_month,monthly_sales,
sum(monthly_sales) over(order by sales_year,sales_month) as running_total from monthly_sales



9. Find month-over-month sales growth.


WITH monthly_sales AS
(
    SELECT
        SUM(sales) AS monthly_sales,
        YEAR(order_date) AS sales_year,
        MONTH(order_date) AS sales_month
    FROM [Sample - Superstore]
    GROUP BY YEAR(order_date), MONTH(order_date)
)

SELECT
    monthly_sales,
    sales_year,
    sales_month,
    LAG(monthly_sales) OVER
    (
        ORDER BY sales_year, sales_month
    ) AS previous_month_sales,

    monthly_sales -
    LAG(monthly_sales) OVER
    (
        ORDER BY sales_year, sales_month
    ) AS sales_growth

FROM monthly_sales;


10. Find the percentage contribution of each category to total sales.

select category,sum(sales) as category_sales,
round( sum(sales)*100.0/(select sum(sales) from [Sample - Superstore]),2)as sales_percentage
from [Sample - Superstore]
group by category



11. Identify the most profitable product in each category.


WITH ProductProfit AS
(
    SELECT
        Category,
        Product_Name,
        SUM(Profit) AS Total_Profit,
        ROW_NUMBER() OVER
        (
            PARTITION BY Category
            ORDER BY SUM(Profit) DESC
        ) AS rn
    FROM [Sample - Superstore]
    GROUP BY Category, Product_Name
)
SELECT
    Category,
    Product_Name,
    Total_Profit
FROM ProductProfit
WHERE rn = 1;



12. Find customers who haven't ordered in the last 6 months.

select customer_name,
max(order_date) as last_order_date
from [Sample - Superstore]
group by customer_name
having max(order_date)<dateadd(month,-6,getdate())


13. Calculate cumulative profit by year.

with yearly_profit as
(select year(order_date) as year_profit,
sum(profit) as total_profit
from [Sample - Superstore]
group by year(order_date))

select year_profit,total_profit,sum(total_profit) over(order by year_profit) as cumlative_profit
from yearly_profit


14. Find the top-selling product in each region.

WITH ProductSales AS
(
    SELECT
        Region,
        Product_Name,
        SUM(Sales) AS Total_Sales,
        ROW_NUMBER() OVER
        (
            PARTITION BY Region
            ORDER BY SUM(Sales) DESC
        ) AS rn
    FROM [Sample - Superstore]
    GROUP BY Region, Product_Name
)
SELECT
    Region,
    Product_Name,
    Total_Sales
FROM ProductSales
WHERE rn = 1;



15. Find the category with the highest average profit.

SELECT TOP 1
    Category,
    AVG(Profit) AS Avg_Profit
FROM [Sample - Superstore]
GROUP BY Category
ORDER BY Avg_Profit DESC;









