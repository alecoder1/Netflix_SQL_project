drop TABLE if exists netflix3;
CREATE TABLE netflix3
(
    show_id character varying(6),
    type character varying(10), 
    title character varying(150),
    director character varying(250),
    casts character varying(1000),
    country character varying(150),
    date_added character varying(50),
    release_year integer,
    rating character varying(10),
    duration character varying(15),
    listed_in character varying(100),
    description character varying(250)
);

SELECT * from netflix3;


SELECT 
	count(*) as total_content
from netflix3;


SELECT 
	distinct type
from netflix3;


SELECT 
	count(distinct director)
from netflix3;


select * from netflix3;

-- 15 Business Problems
-- 1. count the number of movies vs TV SHOWS.

SELECT 
	type, 
	count(*) as total_content
FROM netflix3
group by type;

--2. Find the most common rating for movies and tv shows.

select * from netflix3;

select 
	type,
	rating
from 
	(
		SELECT
			type,
			rating,
			count(*),
			rank() over(partition by type order by count(*) DESC) as ranking
		from netflix3
		group by 1,2
	) as t1
where ranking = 1;

--3. List all movies released in a specific year (e.g..2020)

-- filter 2020
-- movies

select * from netflix3
where 
	type = 'Movie'
	and
	release_year = 2020;

--4. Find the top 5 countries with the most content on Netflix

SELECT 
	unnest(string_to_array(country, ',')) as new_country,
	count(show_id) as total_content
FROM NETFLIX3
group by 1
ORDER by 2 DESC
LIMIT 5;


select 
	unnest(string_to_array(country, ',')) as new_country
from netflix3;

--5. Identify the longest movie.
select 
	title, duration
from netflix3
where 
	type = 'Movie'
	and
	duration = (select max(duration) from netflix3);

--6. Find the content added in the last 5 years.

SELECT * FROM netflix3;
select 
	to_date(date_added, 'Month DD, YYYY') as Datees,
	count(date_added)
from netflix3
group by Datees
order by 1 DESC;


SELECT 
	*
FROM netflix3
where 
	TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL'5 years';

select current_date - interval '2 years';


7. Find all the movies/TV shows by diractor 'Rajiv Chilaka'

select 
	*
from netflix3
where
	director ilike '%Rajiv Chilaka%';
	

8. List all the TV SHOWS with more than 5 seasons.

select 
	* 
from netflix3
where
	type = 'TV Show'
	and
	split_part(duration, ' ', 1)::numeric > 5;


9. Count the number of content items in each genre.

SELECT
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
	count(show_id) AS total_content
FROM netflix3
GROUP BY 1;

10. Find each year and the average number of content released by India on netflix.
	Return top 5 year with highest avg content release.

SELECT 
	EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year,
	COUNT(*),
	ROUND(COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix3 WHERE country = 'India')::numeric * 100 
		  ,2) AS Avg_Content_per_year
FROM netflix3
WHERE 
	country = 'India'
GROUP BY 1;


11. List all movies that are documentaries.

SELECT * FROM netflix3
WHERE
	listed_in ILIKE '%documentaries%'

12. Find all content without director.

SELECT * FROM netflix3
WHERE director ISNULL


13. Find out how many movies actor 'Salman Khan' appeared in the last 10 years.

SELECT * FROM netflix3
WHERE
	casts ILIKE '%Salman Khan%'
	AND
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;

14. Find the top 10 actors who have appeared in the highest number of movies produced in India

SELECT 
	--show_id,
	--casts,
	UNNEST(STRING_TO_ARRAY(casts, ',')),
	COUNT(*) AS total_content
FROM netflix3
WHERE
	country ILIKE '%india%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

15. Categorize the content based on the presence of keywords 'kill' and 'violence' in the 
	description field. Label content containing these keywords as 'Bad' and all other content
	as 'Good'. Count how many items fall in each category.
	
WITH new_table
AS
(
SELECT 
	*,
	CASE 
	WHEN
		description ILIKE '%kill%' OR
		description ILIKE '%violence%' THEN 'Bad_Content'
		ELSE 'Good_Content'
	END category
FROM netflix3
)
SELECT 
	category,
	COUNT(*) AS total_content
FROM new_table
GROUP BY 1;

