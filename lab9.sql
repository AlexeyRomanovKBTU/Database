DROP TABLE IF EXISTS rental;
DROP TABLE IF EXISTS inventory;
DROP TABLE IF EXISTS film;

INSERT INTO film (title, release_year, rating, rental_rate) VALUES
('The Matrix', 1999, 'R', 2.99),
('Finding Nemo', 2003, 'G', 1.99),
('Inception', 2010, 'PG-13', 3.99),
('Toy Story', 1995, 'G', 1.49),
('Gladiator', 2000, 'R', 2.49);

INSERT INTO inventory (film_id, store_id) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 2),
(5, 2);

INSERT INTO rental (rental_date, inventory_id, customer_id, return_date) VALUES
('2025-11-01', 1, 1, '2025-11-05'),
('2025-11-02', 2, 1, '2025-11-06'),
('2025-11-03', 3, 2, '2025-11-07'),
('2025-11-04', 4, 3, '2025-11-08'),
('2025-11-05', 5, 1, '2025-11-09');


-- Task 1
CREATE OR REPLACE FUNCTION calculate_discount(
    original_price NUMERIC,
    discount_percent NUMERIC
)
RETURNS NUMERIC AS $$
BEGIN
    RETURN original_price - (original_price * discount_percent / 100);
END;
$$ LANGUAGE plpgsql;

-- Test
SELECT calculate_discount(100, 15);   -- 85
SELECT calculate_discount(250.50, 20); -- 200.40


-- Task 2
CREATE OR REPLACE FUNCTION film_stats(
    p_rating VARCHAR,
    OUT total_films INTEGER,
    OUT avg_rental_rate NUMERIC
)
AS $$
BEGIN
    SELECT COUNT(*), AVG(rental_rate)
    INTO total_films, avg_rental_rate
    FROM film
    WHERE rating = p_rating;
END;
$$ LANGUAGE plpgsql;

-- Test
SELECT * FROM film_stats('PG');
SELECT * FROM film_stats('R');


-- Task 3
CREATE OR REPLACE FUNCTION get_customer_rentals(
    p_customer_id INTEGER
)
RETURNS TABLE (
    rental_date DATE,
    film_title VARCHAR,
    return_date DATE
) AS $$
BEGIN
    RETURN QUERY
    SELECT r.rental_date, f.title, r.return_date
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    WHERE r.customer_id = p_customer_id;
END;
$$ LANGUAGE plpgsql;

-- Test
SELECT * FROM get_customer_rentals(1);
SELECT * FROM get_customer_rentals(5) LIMIT 5;


-- Task 4

-- Version 1
CREATE OR REPLACE FUNCTION search_films(
    p_title_pattern VARCHAR
)
RETURNS TABLE (
    title VARCHAR,
    release_year INT
) AS $$
BEGIN
    RETURN QUERY
    SELECT f.title, f.release_year
    FROM film f
    WHERE f.title LIKE p_title_pattern;
END;
$$ LANGUAGE plpgsql;

-- Version 2
CREATE OR REPLACE FUNCTION search_films(
    p_title_pattern VARCHAR,
    p_rating VARCHAR
)
RETURNS TABLE (
    title VARCHAR,
    release_year INT,
    rating VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT f.title, f.release_year, f.rating
    FROM film f
    WHERE f.title LIKE p_title_pattern
      AND f.rating = p_rating;
END;
$$ LANGUAGE plpgsql;

-- Test
SELECT * FROM search_films('T%');
SELECT * FROM search_films('T%', 'G');
