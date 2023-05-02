/*Querying the database using JOIN*/

/* Rockbuster Top 10 countries with most customers */
SELECT D.country,count(A.customer_id)
FROM customer A
INNER JOIN address B ON A.address_id = B.address_id
INNER JOIN city C ON B.city_id = C.city_id
INNER JOIN country D ON C.country_id = D.country_id
GROUP BY country
ORDER BY count(customer_id) Desc
LIMIT 10;

/* Rockbuster Top 10 cities located in top 10 countries with most customers */
SELECT C.city,D.country,count(A.customer_id)
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
			   LIMIT 10;
			   
/*Top 5 customers in the top 10 cities who have paid the highest total amounts to Rockbuster.*/
SELECT A.customer_id, A.first_name, A.last_name, D.country, C.city,
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
LIMIT 5;

/*Top 10 countries generate the most revenue*/
SELECT  D.country,
SUM (E.amount) AS Total_Amount_Paid
FROM customer A
INNER JOIN address B ON A.address_id = B.address_id
INNER JOIN city C ON B.city_id = C.city_id
INNER JOIN country D ON C.country_id = D.country_id
INNER JOIN payment E ON A.customer_id = E.customer_id
GROUP BY country
ORDER BY Total_Amount_Paid Desc
LIMIT 10;

/*Most profitable and least profitable film genre*/
SELECT A.name as category_name,
SUM (E.amount) AS revenue
FROM category A
INNER JOIN film_category B ON A.category_id = B.category_id
INNER JOIN inventory C ON B.film_id = C.film_id
INNER JOIN rental D ON C.inventory_id = D.inventory_id
INNER JOIN payment E ON D.rental_id = E.rental_id
GROUP BY category_name
ORDER BY revenue Desc;

/*Most profitable ratings*/
SELECT rating,
SUM (D.amount) AS revenue
FROM film A
INNER JOIN inventory B ON A.film_id = B.film_id
INNER JOIN rental C ON B.inventory_id = C.inventory_id
INNER JOIN payment D ON C.rental_id = D.rental_id
GROUP BY rating
ORDER BY revenue Desc;

/*Customers with high lifetime value based*/
SELECT A.customer_id, A.first_name, A.last_name, D.country, C.city,
SUM (E.amount) AS Total_Amount_Paid
FROM customer A
INNER JOIN address B ON A.address_id = B.address_id
INNER JOIN city C ON B.city_id = C.city_id
INNER JOIN country D ON C.country_id = D.country_id
INNER JOIN payment E ON A.customer_id = E.customer_id
GROUP BY country,city, first_name, last_name, A.customer_id
ORDER BY Total_Amount_Paid Desc
LIMIT 10;

/* Average rental duration by rating*/
Select rating ,avg(rental_duration) as average_rental_duration
from film
group by rating
order by average_rental_duration desc ;

/* Average rental duration by Genre*/
Select C.name as film_Genre ,avg(rental_duration) as average_rental_duration
from film A
inner join film_category B on A.film_id =B.film_id
inner join category C on B.category_id=C.category_id
group by film_Genre
order by average_rental_duration desc ;

/*Top 50 movies by revenue*/
SELECT title,
SUM (D.amount) AS revenue
FROM film A
INNER JOIN inventory B ON A.film_id = B.film_id
INNER JOIN rental C ON B.inventory_id = C.inventory_id
INNER JOIN payment D ON C.rental_id = D.rental_id
GROUP BY title
ORDER BY revenue Desc
limit 50;

/*Least 50 movies by revenue*/
SELECT title,
SUM (D.amount) AS revenue
FROM film A
INNER JOIN inventory B ON A.film_id = B.film_id
INNER JOIN rental C ON B.inventory_id = C.inventory_id
INNER JOIN payment D ON C.rental_id = D.rental_id
GROUP BY title
ORDER BY revenue Asc
limit 50;


