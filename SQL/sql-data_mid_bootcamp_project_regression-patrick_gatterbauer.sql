/***
(Use sub queries or views wherever necessary)
xxxx ASSIGN PRIMARY KEY
***/

USE house_price_regression;

#1. Create a database called `house_price_regression`.

CREATE DATABASE house_price_regression;

#2. Create a table `house_price_data` with the same columns as given in the csv file.
#Please make sure you use the correct data types for the columns.


CREATE TABLE house_price_data (
	id VARCHAR(20),
	date VARCHAR(20),
	bedrooms INT,
	bathrooms FLOAT,
	sqft_living INT,
	sqft_lot INT,
	floors FLOAT,
	waterfront INT,
	view INT,
	`condition` INT,
	grade INT,
	sqft_above INT,
	sqft_basement INT,
	yr_built INT,
	yr_renovated INT,
	zipcode INT,
	lat FLOAT,
	`long` FLOAT,
	sqft_living15 INT,
	sqft_lot15 INT,
	price INT
);


#3. Import the data from the csv file into the table. 

LOAD DATA LOCAL INFILE '/Users/Xaver/Dropbox/Ironhack/Boot_Camp/unit_5/data_mid_bootcamp_project_regression/dataset/regression_data_sql.csv'
INTO TABLE house_price_data
FIELDS TERMINATED  BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
;

#4. Select all the data from table house_price_data to check if the data was imported correctly
SELECT * FROM house_price_data LIMIT 5;

#5. Use the alter table command to drop the column date from the database, as we would not use it in the analysis with SQL. 
# Select all the data from the table to verify if the command worked. Limit your returned results to 10.

#5.1 drop column date
ALTER TABLE house_price_data DROP COLUMN date;

#5.2 check if it worked
SELECT * FROM house_price_data LIMIT 10;

#6. Use sql query to find how many rows of data you have.
SELECT COUNT(*)
FROM house_price_data;

#7. Now we will try to find the unique values in some of the categorical columns:
# 7.1 What are the unique values in the column bedrooms?
SELECT 
	DISTINCT bedrooms 
FROM 
	house_price_data;

# 7.2 What are the unique values in the column bathrooms?
SELECT 
	DISTINCT bathrooms 
FROM 
	house_price_data;

# 7.3 What are the unique values in the column floors?
SELECT 
	DISTINCT floors 
FROM 
	house_price_data;

# 7.3 What are the unique values in the column condition?
SELECT 
	DISTINCT `condition` 
FROM 
	house_price_data;

# 7.5 What are the unique values in the column grade?
SELECT 
	DISTINCT grade 
FROM 
	house_price_data;

#8. Arrange the data in a decreasing order by the price of the house. 
# Return only the IDs of the top 10 most expensive houses in your data.
SELECT 
	id 
FROM 
	house_price_data
ORDER BY
	price DESC
LIMIT 10;

#9. What is the average price of all the properties in your data?
# -> round to to decimals, looks nicer
SELECT
	ROUND(AVG(price), 2)
FROM 
	house_price_data;

#10. In this exercise we will use simple group by to check the properties of some of the categorical 
# variables in our data

#10.1 What is the average price of the houses grouped by bedrooms? 
#The returned result should have only two columns, bedrooms and Average of the prices. 
#Use an alias to change the name of the second column.
# I also ordered by bedroom to see the difference of average price better
SELECT
	bedrooms, 
    ROUND(AVG(price), 2) as avg_price
FROM
	house_price_data
GROUP BY
	bedrooms
ORDER BY
	bedrooms;

#10.2 What is the average sqft_living of the houses grouped by bedrooms? 
# The returned result should have only two columns, bedrooms and Average of the sqft_living. 
# Use an alias to change the name of the second column.
# I also ordered by bedroom to see the difference better
SELECT
	bedrooms, 
    ROUND(AVG(sqft_living), 2) as avg_sqft_living
FROM
	house_price_data
GROUP BY
	bedrooms
ORDER BY
	bedrooms;

#10.3 What is the average price of the houses with a waterfront and without a waterfront? 
# The returned result should have only two columns, waterfront and Average of the prices. 
# Use an alias to change the name of the second column.
SELECT
	waterfront, 
    ROUND(AVG(price), 2) as avg_price
FROM
	house_price_data
GROUP BY
	waterfront;
    
# 10.4 Is there any correlation between the columns condition and grade? 
# You can analyse this by grouping the data by one of the variables and 
# then aggregating the results of the other column. Visually check if there is a 
# positive correlation or negative correlation or no correlation between the variables.
# I used the AVG for grade and ordered it by condition
SELECT
	`condition`, 
    AVG(grade)
FROM
	house_price_data
GROUP BY
	`condition`
ORDER BY
	`condition`;

# 11. One of the customers is only interested in the following houses:
#- Number of bedrooms either 3 or 4
#- Bathrooms more than 3
#- One Floor
#- No waterfront
#- Condition should be 3 at least
#- Grade should be 5 at least
#- Price less than 300000
#- For the rest of the things, they are not too concerned. 
#Write a simple query to find what are the options available for them?
SELECT
	*
FROM
	house_price_data
WHERE
	(bedrooms = 3 || bedrooms = 4)
    AND
		bathrooms > 3
    AND
		floors = 1
    AND
		waterfront = 0
    AND
		`condition` >= 3
    AND
		grade >= 5
    AND
		price < 300000;
        
#12. Your manager wants to find out the list of 
# properties whose prices are twice more than the average of all the properties in the database. 
#Write a query to show them the list of such properties. 
#You might need to use a sub query for this problem.
#I ordered by price to see the result better

SELECT
	*
FROM
	house_price_data
WHERE
	price >
		(SELECT 
			AVG(price)*2
		FROM
			house_price_data)
ORDER BY
	price ASC;
    
#13. Since this is something that the senior management is regularly interested in, 
# create a view of the same query.

CREATE VIEW
	double_avg_price_properties AS
SELECT
	*
FROM
	house_price_data
WHERE
	price >
		(SELECT 
			AVG(price)*2
		FROM
			house_price_data)
ORDER BY
	price ASC;

SELECT * FROM double_avg_price_properties;

#14. Most customers are interested in properties with three or four bedrooms. 
# What is the difference in average prices of the properties with three and four bedrooms?
SELECT
	bedrooms,
    AVG(price) AS avg_price
FROM
	house_price_data
WHERE
	bedrooms = 3 || bedrooms = 4
GROUP BY 
	bedrooms;

SELECT
    (SELECT 
		ROUND(AVG(price),2)
	FROM
		house_price_data
    WHERE
		bedrooms = 4)
	- 
    (SELECT 
		ROUND(AVG(price),2)
	FROM
		house_price_data
    WHERE 
		bedrooms = 3)
AS difference;

#15. What are the different locations where properties are available in your database? 
# (distinct zip codes)

SELECT
	DISTINCT zipcode
FROM
	house_price_data;

#16. Show the list of all the properties that were renovated.
#16.1 first check distinct values for yr_renovated
SELECT
	DISTINCT yr_renovated
FROM 
	house_price_data
ORDER BY
	yr_renovated;
    
#16.2 select everything where yr_renovated is not "0"
SELECT 
	*
FROM
	house_price_data
WHERE
	yr_renovated != 0;

#17. Provide the details of the property that is the 11th most expensive property in your database.
#see which is the 11th highest price -> use limit 15 to see "equal prices"
SELECT
	price, id
FROM
	house_price_data
ORDER BY
	price DESC
LIMIT 11;

#Approach one find the 11th most exepnsiver property and ignore, if properties have the same prices
#check with common_table_expression 
WITH eleventh_property AS  
(  
    SELECT
		*
	FROM
		house_price_data
	ORDER BY
		price DESC
	LIMIT 11
)  
SELECT 
	*  
FROM 
	eleventh_property 
ORDER BY
	price ASC
LIMIT 1; 

#check the same with a window function
SELECT 
	*
FROM 
	(SELECT *, ROW_NUMBER() OVER
	(ORDER BY price DESC) AS price_desc
FROM 
	house_price_data) sub
WHERE 
	price_desc = 11
LIMIT 1; 
