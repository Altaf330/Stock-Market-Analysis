show databases;
create database P230;
use P230;
set sql_safe_updates = 0;
show tables;


create table stock_table_1(Date_ date, Ticker varchar(30), Open_ DECIMAL(6, 2), High DECIMAL(6, 2), Low DECIMAL(6, 2), Close_ DECIMAL(6, 2),
Volume int, Adjusted_Close DECIMAL(6, 2), Dividend_Amount DECIMAL(2, 1), Stock_Split DECIMAL(2, 1),	Moving_Average_10_days DECIMAL(12, 7),	
RSI_14_days DECIMAL(4, 2), MACD DECIMAL(5, 2), Bollinger_Bands_Upper DECIMAL(6, 2), Bollinger_Bands_Lower DECIMAL(5, 2), 
52_Week_High DECIMAL(6, 2), 52_Week_Low DECIMAL(6, 2), Beta DECIMAL(3, 2), Market_Cap DECIMAL(13, 2), PE_Ratio DECIMAL(6, 2));

 # importing_data
load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/for_sql_server/synthetic_stock_data.csv"
into table stock_table_1 fields terminated by ',' enclosed by '"' lines terminated by '\n'
ignore 1 rows;

select * from stock_table_1;

-- KPI_1 Average Daily Trading Volume:
select ticker, avg(volume) from stock_table_1 group by ticker order by avg(volume);
create view KPI_1 AS select ticker, avg(volume) from stock_table_1 group by ticker order by avg(volume);
select * from KPI_1;

-- KPI_2 Most Volatile Stocks:
select ticker, count(beta) from stock_table_1 where beta = 1.5 group by ticker;
create view KPI_2 AS select ticker, count(beta) from stock_table_1 where beta = 1.5 group by ticker;
select * from KPI_2;

-- KPI_3 Stocks with Highest Dividend and Lowest Dividend:
select ticker, sum(Dividend_Amount) from stock_table_1 group by ticker;
create view KPI_3 as select ticker, sum(Dividend_Amount) from stock_table_1 group by ticker;
select * from KPI_3;

-- KPI_4 Highest and Lowest P/E Ratios:
select ticker, max(PE_Ratio), min(PE_Ratio) from stock_table_1 group by ticker;
create view KPI_4 as select ticker, max(PE_Ratio), min(PE_Ratio) from stock_table_1 group by ticker;
select * from KPI_4;

-- KPI_5 Stocks with Highest Market Cap:
select ticker, avg(Market_Cap) from stock_table_1 group by ticker;
create view KPI_5 as select ticker, avg(Market_Cap) from stock_table_1 group by ticker;
select * from KPI_5;

-- KPI_6 Stocks with Strong Buy Signals and stocks with Strong Selling Signal:
call `stock_analysis`(06,2021,"FB");

SELECT  DAY(Date_),MONTH(Date_),YEAR(Date_), TICKER, MACD AS MACD, RSI_14_days AS RSI ,
CASE WHEN MACD >0 AND RSI_14_days < 30 THEN 'BUY'
     WHEN MACD <0 AND RSI_14_days >= 80 THEN 'SELL'
     ELSE 'NEUTRAL'
END AS BUY_SELL
FROM stock_table_1 ORDER BY DAY(DATE_);






