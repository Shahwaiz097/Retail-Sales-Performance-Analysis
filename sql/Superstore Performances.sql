
use superstore;
drop table if exists superstore;
CREATE TABLE superstore (
    order_id VARCHAR(50),
    order_date VARCHAR(50),
    ship_date VARCHAR(50),
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    region VARCHAR(50),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(255),
    sales DECIMAL(10,2),
    quantity INT,
    profit DECIMAL(10,2),
    month_year VARCHAR(20),
    profit_margin DECIMAL(10,4),
    profit_flag VARCHAR(20),
    sales_band VARCHAR(20)
);
LOAD DATA LOCAL INFILE 'E:/Projects/Project Sales  Dashboard/superstore_sql_ready.csv'
INTO TABLE superstore
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(order_id, order_date, ship_date, customer_name, segment, category, sub_category, product_name, sales, quantity, profit, month_year, profit_margin, profit_flag, sales_band,region);
SELECT * FROM superstore LIMIT 10;
# 1 Monthly revenue#
select month_year,round(sum(sales),2) as total_revenue
from superstore
group by month_year
order by month_year;
# 2 Monthly Profit#
select month_year,round(sum(profit),2) as total_profit
from superstore
group by month_year
order by month_year;
# 3 Revenue by Region#
select region,round(sum(sales),2) as total_revenue
from superstore
group by region
order by total_revenue desc ;
# 4 Profit by Category#
SELECT
    category,
    ROUND(SUM(profit), 2) AS total_profit
FROM superstore
GROUP BY category
ORDER BY total_profit DESC;
# 5 Top 10 products by revenue#
select product_name,round(sum(sales),2) as total_revenue
from superstore
group by product_name
order by total_revenue desc
limit 10;
# 6 Top 10 products by profit#
select product_name,round(sum(profit),2) as total_profit
from superstore
group by product_name
order by total_profit desc
limit 10;
# 7 Lowest-profit sub-categories#
select sub_category,round(sum(profit),2) as total_profit
from superstore
group by sub_category
order by total_profit;
# 8 Percent of total revenue by region#
SELECT
    region,
    ROUND(SUM(sales), 2) AS total_revenue,
    ROUND(100.0 * SUM(sales) / SUM(SUM(sales)) OVER (), 2) AS pct_total_revenue
FROM superstore
GROUP BY region
ORDER BY total_revenue DESC;
# 9 Running total of monthly revenue#
SELECT
    month_year,
    monthly_revenue,
    ROUND(SUM(monthly_revenue) OVER (ORDER BY month_year), 2) AS running_total_revenue
FROM (
    SELECT
        month_year,
        SUM(sales) AS monthly_revenue
    FROM superstore
    GROUP BY month_year
) t
ORDER BY month_year;
# 10 Average profit margin by category#
SELECT
    category,
    ROUND(AVG(profit_margin) * 100, 2) AS avg_profit_margin_pct
FROM superstore
GROUP BY category
ORDER BY avg_profit_margin_pct DESC;