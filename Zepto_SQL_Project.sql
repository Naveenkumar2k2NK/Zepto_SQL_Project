USE nk_project;

-- (DATA EXPLORATION)

-- (COUNT OF ROWS)
select count(*) from zepto_v2;

-- (SAMPLE DATA)
select * from zepto_v2
limit 10;

-- (TABLE DISCRIPTION)
DESCRIBE zepto_v2;

-- (SET PRIMARY KEY)
ALTER TABLE zepto_v2
ADD product_id serial FIRST,
ADD PRIMARY KEY (product_id);

-- (RENAME COLUMNS)
ALTER TABLE zepto_v2 RENAME COLUMN ï»¿Category TO Category;
ALTER TABLE zepto_v2 RENAME COLUMN product_id TO Product_ID;
ALTER TABLE zepto_v2 RENAME COLUMN name TO Name;
ALTER TABLE zepto_v2 RENAME COLUMN mrp TO MRP;
ALTER TABLE zepto_v2 RENAME COLUMN discountPercent TO Discount_Percent;
ALTER TABLE zepto_v2 RENAME COLUMN availableQuantity TO Available_Quantity;
ALTER TABLE zepto_v2 RENAME COLUMN discountedSellingPrice TO Discounted_Selling_Price;
ALTER TABLE zepto_v2 RENAME COLUMN weightInGms TO Weight_In_Gms;
ALTER TABLE zepto_v2 RENAME COLUMN outOfStock TO Out_Of_Stock;
ALTER TABLE zepto_v2 RENAME COLUMN quantity TO Quantity;

-- (NULL VALUES)
SELECT * FROM zepto_v2
WHERE name is null or Category is null or MRP is null or Discount_Percent is null 
or Available_Quantity is null or Discounted_Selling_Price is null or 
Weight_In_Gms is null or Out_Of_Stock is null or Quantity is null;

-- (DIFFERENT PRODUCT CATEGORIES)
select distinct Category
FROM zepto_v2
ORDER BY Category;

-- (PRODUCT IN_STOCK VS OUT_OF_STOCK)
SELECT Out_OF_Stock, COUNT(Product_ID) FROM zepto_v2
GROUP BY Out_Of_Stock;

-- (NO OF TIMES PRESENT NAME IN PRODUCT)
SELECT Name, COUNT(Product_ID) as Count_of_Product
FROM zepto_v2
GROUP BY Name
HAVING COUNT(Product_ID)>1
ORDER BY COUNT(Product_ID) DESC;

-- (DATA CLEANING)

-- (PRODUCT WITH PRICE = 0)
SELECT * FROM zepto_v2
WHERE MRP=0 OR Discounted_Selling_Price=0;

DELETE FROM zepto_v2
WHERE MRP=0;

-- (CONVERT PAISE TO RUPEES)
UPDATE zepto_v2
SET MRP = MRP/100.0,
Discounted_Selling_Price = Discounted_Selling_Price/100.0;

SELECT MRP, Discounted_Selling_Price FROM zepto_v2;

-- (Q1. Find the Top 10 Best Value Product Based on the Discount Percentage.)
SELECT DISTINCT Name, MRP, Discount_Percent
FROM zepto_v2
ORDER BY Discount_Percent DESC
LIMIT 10;

-- (Q2. What are the Products with High MRP but Out_OF_Stock)
SELECT DISTINCT Name, MRP
FROM zepto_v2
WHERE Out_OF_Stock = TRUE AND MRP>300
ORDER BY MRP DESC;

-- (Q3. Calculate Estimated Revenue for Each Category)
SELECT Category, SUM(Discounted_Selling_Price * Available_Quantity) AS Total_Revenue
FROM zepto_v2
GROUP BY Category
ORDER BY Total_Revenue;

-- (Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.)
SELECT DISTINCT Name, MRP, Discount_Percent
FROM zepto_v2
WHERE MRP>500 AND Discount_Percent<10
ORDER BY MRP DESC, Discount_Percent DESC;

-- (Q5. Identify the top 5 Categories offering the Highest Average Discount Percentage.)
SELECT Category,
AVG(Discount_Percent) AS Avg_Discount
FROM zepto_v2
GROUP BY Category
ORDER BY Avg_Discount DESC
LIMIT 5;

-- (Q6. Find the price per gram for products above 100g and sort by best value.)
SELECT DISTINCT Name, Weight_In_Gms, Discounted_Selling_Price,
ROUND(Discounted_Selling_Price/Weight_In_Gms,2) AS Price_Per_Gram
FROM zepto_v2
WHERE Weight_In_Gms >= 100
ORDER BY Price_Per_Gram;

-- (Q7.Group the products into categories like Low, Medium, Bulk.)
SELECT DISTINCT Name, Weight_In_Gms,
CASE WHEN Weight_In_Gms < 1000 THEN 'LOW'
	 WHEN Weight_In_Gms < 5000 THEN 'MEDIUM'
     ELSE 'BULK'
     END AS Weight_Category
FROM zepto_v2;

-- (Q8. What is the Total Inventory Weight Per Category)
SELECT Category,
SUM(Weight_In_Gms * Available_Quantity) AS Total_Weight
FROM zepto_v2
GROUP BY Category
ORDER BY Total_Weight;
     