SELECT c.name, COUNT(f.film_id)
FROM film_category AS f
JOIN category AS c ON c.category_id=f.category_id
GROUP BY c.name
ORDER BY COUNT(f.film_id) DESC


SELECT a.first_name, a.last_name, COUNT(r.rental_id)
FROM actor AS a
JOIN film_actor AS fa ON a.actor_id=fa.actor_id
JOIN film AS f ON f.film_id=fa.film_id
JOIN inventory AS i On i.film_id=f.film_id
JOIN rental AS r ON r.inventory_id=r.rental_id
GROUP BY a.first_name, a.last_name
ORDER BY SUM(r.rental_id) DESC
LIMIT 10

SELECT c.name, SUM(p.amount)
FROM category AS c
JOIN film_category AS fc ON c.category_id=fc.category_id
JOIN film AS f ON f.film_id=fc.film_id
JOIN inventory AS i ON i.film_id=f.film_id
JOIN rental AS r ON r.inventory_id=i.inventory_id
JOIN payment AS p ON p.rental_id=r.rental_id
GROUP BY c.name
ORDER BY SUM(p.amount) DESC
LIMIT 1

SELECT f.title
FROM film AS f
WHERE EXISTS (
SELECT * 
FROM inventory AS i
WHERE f.film_id = i.film_id
)


SELECT first_name, last_name, appearance_count
FROM (
  SELECT a.first_name, a.last_name, COUNT(*) AS appearance_count,
         RANK() OVER (ORDER BY COUNT(*) DESC) AS num_rank
  FROM actor AS a
  JOIN film_actor fa ON a.actor_id = fa.actor_id
  JOIN film f ON fa.film_id = f.film_id
  JOIN film_category fc ON f.film_id = fc.film_id
  JOIN category c ON fc.category_id = c.category_id
  WHERE c.name = 'Children'
  GROUP BY a.actor_id
) AS t1
WHERE num_rank <= 3


SELECT a.first_name, a.last_name, rank() OVER (PARTITION BY a.first_name, a.last_name ORDER BY COUNT(c.name) DESC) AS total
FROM actor AS a
JOIN film_actor AS fa ON fa.actor_id=a.actor_id
JOIN film_category AS fc ON fa.film_id=fc.film_id
JOIN category AS c ON fc.category_id=c.category_id
GROUP BY a.first_name, a.last_name, c.name
HAVING c.name='Children'



SELECT c.city, SUM(CASE WHEN cus.active=1 THEN 1 ELSE 0 END) AS active, SUM(CASE WHEN cus.active=0 THEN 1 ELSE 0 END) AS non_active
FROM customer AS cus
JOIN address AS a ON a.address_id=cus.address_id
JOIN city AS c ON c.city_id=a.city_id
GROUP BY c.city

WITH t1 AS (SELECT cat.name, SUM(f.rental_duration) AS total, c.city
FROM category AS cat
JOIN film_category AS fc ON cat.category_id=fc.category_id
JOIN film AS f ON f.film_id=fc.film_id
JOIN inventory AS i ON i.film_id=f.film_id
JOIN rental AS r ON r.inventory_id=i.inventory_id
JOIN customer AS cus ON cus.customer_id=r.customer_id
JOIN address AS a ON a.address_id=cus.address_id
JOIN city AS c ON c.city_id=a.city_id
GROUP BY cat.name, c.city
ORDER BY SUM(f.rental_duration) DESC)
(SELECT *
FROM t1 
WHERE city LIKE 'A%')
UNION 
(SELECT *
FROM t1 
WHERE city LIKE '%-%')


