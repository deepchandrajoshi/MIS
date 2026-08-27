USE SalesOperationsMIS;
GO

-- 01 Total revenue
SELECT SUM(Revenue) AS Total_Revenue FROM Sales WHERE Order_Status <> 'Cancelled';

-- 02 Total profit
SELECT SUM(Profit) AS Total_Profit FROM Sales WHERE Order_Status <> 'Cancelled';

-- 03 Monthly revenue
SELECT YEAR(Order_Date) AS Sales_Year,
       MONTH(Order_Date) AS Sales_Month,
       SUM(Revenue) AS Revenue
FROM Sales
WHERE Order_Status <> 'Cancelled'
GROUP BY YEAR(Order_Date), MONTH(Order_Date)
ORDER BY Sales_Year, Sales_Month;

-- 04 Regional performance
SELECT Region,
       SUM(Revenue) AS Revenue,
       SUM(Profit) AS Profit,
       SUM(Profit) / NULLIF(SUM(Revenue),0) AS Profit_Margin
FROM Sales
WHERE Order_Status <> 'Cancelled'
GROUP BY Region
ORDER BY Revenue DESC;

-- 05 Category performance
SELECT p.Category,
       SUM(s.Revenue) AS Revenue,
       SUM(s.Profit) AS Profit,
       SUM(s.Quantity) AS Units
FROM Sales s
JOIN Products p ON s.Product_ID = p.Product_ID
WHERE s.Order_Status <> 'Cancelled'
GROUP BY p.Category
ORDER BY Revenue DESC;

-- 06 Top 10 products
SELECT TOP 10 p.Product_Name,
       SUM(s.Revenue) AS Revenue,
       SUM(s.Profit) AS Profit,
       SUM(s.Quantity) AS Units
FROM Sales s
JOIN Products p ON s.Product_ID = p.Product_ID
WHERE s.Order_Status <> 'Cancelled'
GROUP BY p.Product_Name
ORDER BY Revenue DESC;

-- 07 Top 10 customers
SELECT TOP 10 c.Customer_ID, c.Customer_Name,
       SUM(s.Revenue) AS Revenue,
       SUM(s.Profit) AS Profit,
       COUNT(DISTINCT s.Order_ID) AS Orders
FROM Sales s
JOIN Customers c ON s.Customer_ID = c.Customer_ID
WHERE s.Order_Status <> 'Cancelled'
GROUP BY c.Customer_ID, c.Customer_Name
ORDER BY Revenue DESC;

-- 08 Salesperson performance
SELECT sp.Salesperson_ID, sp.Salesperson_Name,
       SUM(s.Revenue) AS Actual_Sales,
       SUM(s.Profit) AS Profit,
       COUNT(DISTINCT s.Order_ID) AS Orders
FROM Sales s
JOIN Salespersons sp ON s.Salesperson_ID = sp.Salesperson_ID
WHERE s.Order_Status <> 'Cancelled'
GROUP BY sp.Salesperson_ID, sp.Salesperson_Name
ORDER BY Actual_Sales DESC;

-- 09 Monthly growth using LAG
WITH Monthly AS (
    SELECT DATEFROMPARTS(YEAR(Order_Date), MONTH(Order_Date), 1) AS Sales_Month,
           SUM(Revenue) AS Revenue
    FROM Sales
    WHERE Order_Status <> 'Cancelled'
    GROUP BY DATEFROMPARTS(YEAR(Order_Date), MONTH(Order_Date), 1)
)
SELECT Sales_Month,
       Revenue,
       LAG(Revenue) OVER (ORDER BY Sales_Month) AS Previous_Month_Revenue,
       (Revenue - LAG(Revenue) OVER (ORDER BY Sales_Month))
        / NULLIF(LAG(Revenue) OVER (ORDER BY Sales_Month),0) AS MoM_Growth
FROM Monthly
ORDER BY Sales_Month;

-- 10 Product ranking within category
SELECT p.Category, p.Product_Name,
       SUM(s.Revenue) AS Revenue,
       RANK() OVER (
          PARTITION BY p.Category
          ORDER BY SUM(s.Revenue) DESC
       ) AS Category_Rank
FROM Sales s
JOIN Products p ON s.Product_ID = p.Product_ID
WHERE s.Order_Status <> 'Cancelled'
GROUP BY p.Category, p.Product_Name;

-- 11 High revenue but low margin products
SELECT p.Product_Name,
       SUM(s.Revenue) AS Revenue,
       SUM(s.Profit) AS Profit,
       SUM(s.Profit) / NULLIF(SUM(s.Revenue),0) AS Margin
FROM Sales s
JOIN Products p ON s.Product_ID = p.Product_ID
WHERE s.Order_Status <> 'Cancelled'
GROUP BY p.Product_Name
HAVING SUM(s.Revenue) > 100000
   AND SUM(s.Profit) / NULLIF(SUM(s.Revenue),0) < 0.15
ORDER BY Revenue DESC;

-- 12 Average Order Value
SELECT SUM(Revenue) / NULLIF(COUNT(DISTINCT Order_ID),0) AS Average_Order_Value
FROM Sales
WHERE Order_Status <> 'Cancelled';
