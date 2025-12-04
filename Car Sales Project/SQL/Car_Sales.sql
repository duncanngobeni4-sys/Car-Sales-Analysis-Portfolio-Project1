USE Cars_marketing;

---------------------------CARS-------------------------------------------
SELECT *
FROM cars;

---------------------------CUSTOMERS--------------------------------------

ALTER TABLE customers
ADD First_Name NVARCHAR(50),
    Last_Name NVARCHAR(50);

UPDATE customers
SET 
    First_Name = LEFT(Name, CHARINDEX(' ', Name) - 1),
    Last_Name  = RIGHT(Name, LEN(Name) - CHARINDEX(' ', Name))
WHERE CHARINDEX(' ', Name) > 0;

SELECT Customer_ID,First_Name,Last_Name,Gender,Age,Phone,Email,City
FROM customers;


----------------------------SALES----------------------------------------
SELECT *
FROM sales; 


---------------------------------------------------------------------------------------------------
--Question 1: Which car models have generated the highest total revenue?
SELECT c.Brand, c.Model, SUM(s.Sale_Price * s.Quantity) AS Total_Revenue
FROM Sales s
JOIN Cars c ON s.Car_ID = c.Car_ID
GROUP BY c.Brand, c.Model
ORDER BY Total_Revenue DESC; 

--Question 2: Which customer age groups contribute most to revenue?
SELECT 
 CASE 
           WHEN c.Age BETWEEN 18 AND 25 THEN 'Young Adults'
           WHEN c.Age BETWEEN 26 AND 35 THEN 'Middle Age'
           WHEN c.Age BETWEEN 36 AND 50 THEN 'Adults'
           ELSE 'Seniors' END AS Age_Group,
FORMAT(SUM(s.sale_price * s.Quantity),'N2') AS Total_Revenue
FROM Sales s
JOIN Customers c ON s.Customer_ID = c.Customer_ID
GROUP BY CASE 
           WHEN c.Age BETWEEN 18 AND 25 THEN 'Young Adults'
           WHEN c.Age BETWEEN 26 AND 35 THEN 'Middle Age'
           WHEN c.Age BETWEEN 36 AND 50 THEN 'Adults'
           ELSE 'Seniors' END
ORDER BY Total_Revenue DESC;

--Question 3: How has revenue changed month by month?
SELECT FORMAT(s.Sale_Date, 'yyyy-MM') AS Sale_Month, 
       SUM(s.Sale_Price * s.Quantity) AS Monthly_Revenue
FROM Sales s
GROUP BY FORMAT(s.Sale_Date, 'yyyy-MM')
ORDER BY Sale_Month;

--Question 4: What is the average sale price per car model?
SELECT c.Brand, c.Model, FORMAT(AVG(CAST(s.Sale_Price AS FLOAT)),'N2') AS Avg_Sale_Price
FROM Sales s
JOIN Cars c ON s.Car_ID = c.Car_ID
GROUP BY c.Brand, c.Model
ORDER BY Avg_Sale_Price DESC; 

--Question 5: Which payment method do customers mostly prefere?
SELECT Payment_Method, COUNT(*) AS Number_of_Sales 
FROM Sales
GROUP BY Payment_Method
ORDER BY Number_of_Sales DESC;

--Question 6: Which cars have the highest stock and low sales?
SELECT c.Brand, c.Model, c.Quantity_In_Stock, 
       SUM(s.Quantity) AS Sold_Quantity
FROM Cars c
LEFT JOIN Sales s ON c.Car_ID = s.Car_ID
GROUP BY c.Brand, c.Model, c.Quantity_In_Stock
ORDER BY (c.Quantity_In_Stock - SUM(s.Quantity)) DESC;

--Question 7: Which engine types are selling the most?
SELECT c.Engine_Type, SUM(s.Quantity) AS Total_Sold
FROM cars c
JOIN Sales s ON c.Car_ID = s.Car_ID
GROUP BY c.Engine_Type
ORDER BY SUM(s.Quantity) DESC;

--Question 8: Which salesperson has generated the highest revenue?
SELECT Salesperson, SUM(Sale_Price * Quantity) AS Total_Revenue, COUNT(Sale_ID) AS Total_Sales
FROM Sales
GROUP BY Salesperson
ORDER BY SUM(Sale_Price * Quantity) DESC;

--Question 9: Does the age of a car affect its sales?
SELECT c.Car_Age, SUM(s.Quantity) AS Units_Sold
FROM Sales s
JOIN Cars c ON s.Car_ID = c.Car_ID
GROUP BY c.Car_Age
ORDER BY c.Car_Age ASC;















