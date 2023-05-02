/*Querying the database using CTE*/

/* To find the average amount paid by the top 5 customers in the top 10 cities in top countries.*/

With CTE_country (country) AS
                              (SELECT D.country
                              FROM customer A
			                  INNER JOIN address B ON A.address_id = B.address_id
              			      INNER JOIN city C ON B.city_id = C.city_id
               				  INNER JOIN country D ON C.country_id = D.country_id
	 						  GROUP BY country
							  ORDER BY count(customer_id) Desc
							  LIMIT 10),
     CTE_city (city) AS  
                              (SELECT C.city
                              FROM customer A
			                  INNER JOIN address B ON A.address_id = B.address_id
                              INNER JOIN city C ON B.city_id = C.city_id
                              INNER JOIN country D ON C.country_id = D.country_id
                              WHERE country IN (SELECT country from CTE_country)
			                  GROUP BY country,city
			                  ORDER BY count(customer_id) Desc
							  LIMIT 10),
     CTE_Top_5_Customers (customer_id,First_name,Last_name,country,city,Total_amount) AS 							  						
							  (SELECT A.customer_id, A.first_name, A.last_name, D.country, C.city,SUM (E.amount) as Total_amount
                               FROM customer A
                               INNER JOIN address B ON A.address_id = B.address_id
                               INNER JOIN city C ON B.city_id = C.city_id
                               INNER JOIN country D ON C.country_id = D.country_id
                               INNER JOIN payment E ON A.customer_id = E.customer_id
                               WHERE city IN (SELECT city from CTE_city)
			                   GROUP BY country,city,first_name,last_name, A.customer_id
                               ORDER BY Total_Amount Desc
                               LIMIT 5)
SELECT AVG(Total_Amount) as "Top 5 Average"
FROM CTE_Top_5_Customers;	

/*Find out how many of the top 5 customers are based within each country*/


With CTE_country (country) AS
                              (SELECT D.country
                              FROM customer A
			                  INNER JOIN address B ON A.address_id = B.address_id
              			      INNER JOIN city C ON B.city_id = C.city_id
               				  INNER JOIN country D ON C.country_id = D.country_id
	 						  GROUP BY country
							  ORDER BY count(customer_id) Desc
							  LIMIT 10),
     CTE_city (city) AS  
                              (SELECT C.city
                              FROM customer A
			                  INNER JOIN address B ON A.address_id = B.address_id
                              INNER JOIN city C ON B.city_id = C.city_id
                              INNER JOIN country D ON C.country_id = D.country_id
                              WHERE country IN (SELECT country from CTE_country)
			                  GROUP BY country,city
			                  ORDER BY count(customer_id) Desc
							  LIMIT 10),
     CTE_Top_5_Customers (customer_id,First_name,Last_name,country,city,Total_amount) AS 							  						
							  (SELECT A.customer_id, A.first_name, A.last_name, D.country, C.city,SUM (E.amount) as Total_amount
                               FROM customer A
                               INNER JOIN address B ON A.address_id = B.address_id
                               INNER JOIN city C ON B.city_id = C.city_id
                               INNER JOIN country D ON C.country_id = D.country_id
                               INNER JOIN payment E ON A.customer_id = E.customer_id
                               WHERE city IN (SELECT city from CTE_city)
			                   GROUP BY country,city,first_name,last_name, A.customer_id
                               ORDER BY Total_Amount Desc
                               LIMIT 5)
SELECT D.country,
COUNT(distinct A.customer_id) AS all_customer_count,
COUNT(distinct CTE_Top_5_Customers.customer_id) AS top_customer_count
FROM customer A
INNER JOIN address B ON A.address_id = B.address_id
INNER JOIN city C ON B.city_id = C.city_id
INNER JOIN country D ON C.country_id = D.country_id	
LEFT JOIN CTE_Top_5_Customers ON A.customer_id=CTE_Top_5_Customers.customer_id
GROUP BY D.country
HAVING COUNT(CTE_Top_5_Customers)>0
ORDER BY top_customer_count,all_customer_count Desc;