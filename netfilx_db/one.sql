-- total entry
select count(*) as total_shows_netflix
from netflix

--total movies and web_series
SELECT
    type,
    COUNT(*) as total_count
FROM netflix
GROUP BY type



--countries with most content on netflix

SELECT 
    country,
    COUNT(*) as total_content_count
FROM 
    netflix
WHERE 
    country is not null
GROUP BY  
    country
ORDER BY 
    COUNT(*) desc
LIMIT 5

--longest movie and TV show duration
--concept of correlated subquery is used here

SELECT 
    show_id,
    title,
    duration
FROM 
    netflix n1
                    --SPLIT_PART(duration,' ',1) → gets the number before space
                    --"90 min" → 90 -> is still a string so 
                    --CAST(... AS INTEGER) → convert text to number
WHERE 
    CAST(SPLIT_PART(duration,' ',1)AS INTEGER)=  --here 90 mins is temporarily transforms to 90.
            (
               SELECT
                    MAX(CAST(SPLIT_PART(duration,' ',1)AS INTEGER)) as duration
                FROM 
                    netflix n2
                WHERE 
                    n1.type=n2.type
                        
            )


--Content added in last five years

                    --   TO_DATE change the text into date
                    --   use ::date, but it only works when the text 
                    --   is already in a standard date format that 
                    --   PostgreSQL can automatically understand.(2022-04-29)
                /*
                SELECT 
                    EXTRACT(year from TO_DATE(date_added, 'Month DD,YYYY')) as year
                FROM 
                    netflix
                GROUP BY year*/

SELECT
    title,
    release_year
FROM 
    netflix
WHERE 
    release_year in (
        SELECT 
            DISTINCT release_year 
        FROM 
            netflix
        ORDER BY release_year DESC
        LIMIT 5
    )
ORDER BY release_year 

-- Better and much cleaner approach 
SELECT
    title,
    release_year
FROM netflix
WHERE release_year >= EXTRACT(YEAR FROM CURRENT_DATE) - 5
ORDER BY release_year;


-- TV shows with more than 5 seasons

-- select * from netflix
-- limit 100
SELECT 
    title,
    country,
    rating,
    duration
FROM
    netflix
WHERE 
    type = 'TV Show' AND
    CAST(SPLIT_PART(duration,' ',1) AS INTEGER)>5
LIMIT 20;


--NUMBER OF CONTENT IN EACH GENRE 

SELECT 
    genre,
    count(*) as content_count
FROM 
    netflix
GROUP BY 
    genre
ORDER BY content_count DESC


-- AVERAGE RELEASING YEAR FOR CONTENT FROM EACH COUNTRY

SELECT 
    country,
    ROUND(AVG(release_year),0) as average_rel_yr
FROM 
    netflix
GROUP BY 
    country
LIMIT 50

-- ALL MOVIES THAT ARE DOCUMENTARIES 

SELECT
    show_id,
    title,
    country,
    rating,
    genre
FROM 
    netflix
WHERE type='Movie' AND
    genre='Documentaries'OR
    genre like '%Documentaries%'
LIMIT 20

-- MOVIES OF SALMAN IN LAST 10 YEARS

SELECT
    show_id,
    type,
    title,
    release_year,
    genre
FROM 
    netflix
WHERE
    casts like '%Salman Khan%'
    AND
    release_year>=EXTRACT(year from CURRENT_DATE)-10
 
 --========= OR ======================
 SELECT
    show_id,
    title,
    type
FROM 
    netflix
CROSS JOIN 
    UNNEST (STRING_TO_ARRAY(casts, ', ')) as actor
WHERE 
    actor='Salman Khan'
    AND
    release_year>=EXTRACT(year from CURRENT_DATE)-10


-- =================== actor who has appeared most in the netflix content =================

/*Because the casts column stores many actors in one string,

 we must first split the string into separate rows. After that we can count how many titles each actor appears in.

PostgreSQL has a very useful function for this: STRING_TO_ARRAY() + UNNEST().'

STRING_TO_ARRAY() → convert text list to array
UNNEST() → turn array into rows
GROUP BY → aggregate actors*/

SELECT
   actor,
   count(*) as total_movies 
FROM (
    SELECT  
        UNNEST(STRING_TO_ARRAY(casts, ',')) as actor
    FROM 
        netflix
      )   
GROUP BY 
    actor
ORDER BY total_movies DESC
LIMIT 20

-- ===================== EVERY MOVIES OF SALMAN KHAN AVAILABLE IN NETFLIX     ===========
SELECT
    show_id,
    title,
    release_year,
    actor
FROM 
    netflix
CROSS JOIN
    UNNEST(STRING_TO_ARRAY(casts,', '))as actor
WHERE 
    actor='Salman Khan'
