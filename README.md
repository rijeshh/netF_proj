# Netflix Content Strategy & Data Analysis (SQL)
-  Research and analysis on Netflix's library to uncover trends in content distribution, genres, and cast performance using PostgreSQL.
##  Introduction

### Objective:
-  The goal of this project is to analyze Netflix's dataset to answer key business questions regarding content types, geographical distribution, and historical trends.

### Dataset:
-  The dataset for this project is sourced from Kaggle and contains information on over 8,000 titles available on Netflix.

### Key Columns:

show_id: Unique identifier for every movie/show.

type: Identifier - Movie or TV Show.

title: Title of the content.

director: Director(s) of the content.

cast: Actors involved in the production.

country: Country where the content was produced.

date_added: Date the title was added to the Netflix library.

release_year: Original release year of the content.

duration: Total duration in minutes or number of seasons.

genre: Genre or category of the content.

### The Challenges (Business Questions)

Content Volume: What is the total number of entries, and how is the library split between Movies and TV Shows?

Geographic Distribution: Which countries are the top contributors to Netflix's library?

Temporal Trends: What content has been added in the last 5 years?

Deep Dives: Who are the most frequent actors, and what are the longest-running TV shows (more than 5 seasons)?

Actor-Specific Analysis: Identifying all content featuring specific stars like Salman Khan.

### Technical SQL Skills Demonstrated
String Manipulation: SPLIT_PART() and LIKE patterns to clean duration and genre data.

Data Type Casting: Converting text-based durations into integers for mathematical comparison.

Array Normalization: Using STRING_TO_ARRAY() and UNNEST() to break down multi-actor strings into individual rows for accurate counting.

Subqueries: Implementing Correlated Subqueries to find the longest content per type.

Date Functions: Using EXTRACT() and CURRENT_DATE for dynamic time-based filtering.

# Featured Queries & Analysis
### Handling Unnormalized Data (Actor Analysis)
Because the casts column contains multiple names in a single string, I used UNNEST to expand the data for an accurate count of appearances.

SELECT
   actor,
   count(*) as total_movies 
FROM (
    SELECT  
        UNNEST(STRING_TO_ARRAY(casts, ', ')) as actor
    FROM 
        netflix
      )   
GROUP BY 
    actor
ORDER BY total_movies DESC
LIMIT 20

# Finding the Longest Content per Type (Correlated Subquery)
This query identifies the longest movie (in minutes) and the longest TV show (by seasons) dynamically.

``` sql
    SELECT 
    show_id,
    title,
    duration
FROM 
    netflix n1                    
WHERE 
    CAST(SPLIT_PART(duration,' ',1)AS INTEGER)= 
            (
               SELECT
                    MAX(CAST(SPLIT_PART(duration,' ',1)AS INTEGER)) as duration
                FROM 
                    netflix n2
                WHERE 
                    n1.type=n2.type
                        
            )
```
# Insights Found
Content Mix: The library is heavily weighted towards Movies, though TV Shows show a higher density of long-term engagement (seasons).

Global Hubs: The United States and India emerge as the leading producers, with distinct genre preferences (e.g., high volume of Documentaries in western markets).

Recent Growth: A significant portion of the current library was added within the last 5 years, highlighting Netflix's aggressive content acquisition strategy.

# Conclusion
This project demonstrates the power of SQL in transforming raw, semi-structured metadata into actionable business intelligence. The ability to clean and normalize data within the database layer allows for more efficient reporting and deeper exploratory data analysis.

### "Next step: Connecting this PostgreSQL database to Tableau for a visual dashboard."
