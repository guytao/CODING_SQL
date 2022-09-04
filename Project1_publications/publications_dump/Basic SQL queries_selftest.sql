USE publications;

SELECT *
FROM publishers;

SELECT pub_name, state
FROM publishers;

SELECT *
FROM publishers
LIMIT 5;

SELECT *
FROM publishers
WHERE city = 'New York';

SELECT *
FROM publishers
WHERE city = 'New York' OR city = 'BOston';

SELECT COUNT(*)
FROM publishers
WHERE city = 'New York';

SELECT DISTINCT city
FROM publishers;

SELECT *
FROM titles
ORDER BY price DESC;

SELECT state, COUNT(*)
FROM authors
GROUP BY state;

SELECT state, COUNT(*)
FROM authors
WHERE contract >= 1
GROUP BY state
HAVING COUNT(*) > 5
ORDER BY COUNT(*) DESC
LIMIT 5;

