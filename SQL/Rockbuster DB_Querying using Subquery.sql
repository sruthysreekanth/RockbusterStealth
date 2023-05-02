/*Querying the database using Subquery*/

/* To find the average amount paid by the top 5 customers in the top 10 cities in top countries.*/

SELECT AVG(Total_Amount_Paid) as "Average"
FROM 
(SELECT A.customer_id, A.first_name, A.last_name, D.country, C.city,
SUM (E.amount) AS Total_Amount_Paid
FROM customer A
INNER JOIN address B ON A.address_id = B.address_id
INNER JOIN city C ON B.city_id = C.city_id
INNER JOIN country D ON C.country_id = D.country_id
INNER JOIN payment E ON A.customer_id = E.customer_id
WHERE city IN (SELECT C.city
               FROM customer A
			   INNER JOIN address B ON A.address_id = B.address_id
               INNER JOIN city C ON B.city_id = C.city_id
               INNER JOIN country D ON C.country_id = D.country_id
               WHERE country IN (SELECT D.country
                                 FROM customer A
			                     INNER JOIN address B ON A.address_id = B.address_id
              					 INNER JOIN city C ON B.city_id = C.city_id
               					 INNER JOIN country D ON C.country_id = D.country_id
	 							 GROUP BY country
								 ORDER BY count(customer_id) Desc
								 LIMIT 10)
			   GROUP BY country,city
			   ORDER BY count(customer_id) Desc
			   LIMIT 10)
GROUP BY country,city, first_name, last_name, A.customer_id
ORDER BY Total_Amount_Paid Desc
LIMIT 5) AS total_amount_paid;

/*Find out how many of the top 5 customers are based within each country*/
SELECT D.country,
COUNT(distinct A.customer_id) AS all_customer_count,
COUNT(distinct top_5_customers.customer_id) AS top_customer_count
FROM customer A
INNER JOIN address B ON A.address_id = B.address_id
INNER JOIN city C ON B.city_id = C.city_id
INNER JOIN country D ON C.country_id = D.country_id
LEFT JOIN
(SELECT A.customer_id, A.first_name, A.last_name, D.country, C.city,
SUM (E.amount) AS Total_Amount_Paid
FROM customer A
INNER JOIN address B ON A.address_id = B.address_id
INNER JOIN city C ON B.city_id = C.city_id
INNER JOIN country D ON C.country_id = D.country_id
INNER JOIN payment E ON A.customer_id = E.customer_id
WHERE city IN (SELECT C.city
               FROM customer A
			   INNER JOIN address B ON A.address_id = B.address_id
               INNER JOIN city C ON B.city_id = C.city_id
               INNER JOIN country D ON C.country_id = D.country_id
               WHERE country IN (SELECT D.country
                                 FROM customer A
			                     INNER JOIN address B ON A.address_id = B.address_id
              					 INNER JOIN city C ON B.city_id = C.city_id
               					 INNER JOIN country D ON C.country_id = D.country_id
	 							 GROUP BY country
								 ORDER BY count(customer_id) Desc
								 LIMIT 10)
			   GROUP BY country,city
			   ORDER BY count(customer_id) Desc
			   LIMIT 10)
GROUP BY country,city, first_name, last_name, A.customer_id
ORDER BY Total_Amount_Paid Desc
LIMIT 5) AS top_5_customers ON A.customer_id=top_5_customers.customer_id
GROUP BY D.country
HAVING COUNT(top_5_customers) >0
ORDER BY COUNT(top_5_customers),COUNT(A.customer_id) Desc;
