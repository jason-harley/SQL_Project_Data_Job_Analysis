-- CASE expressions
SELECT  
    CASE
        WHEN column_name = 'Value1' THEN 'Description for Value1'
        WHEN column_name = 'Value2' THEN 'Description for Value2'
        ELSE 'Other'
    END AS column_description
FROM
    table_name;

-- Example
-- Look at job location info
SELECT
    job_title_short,
    job_location
FROM
    job_postings_fact
LIMIT 5

/*
Label new columns as follows:
- 'Anywhere' as 'Remote'
- 'New York, NY' as 'Local'
- Otherwise 'Onsite'

*/

SELECT
    job_title_short,
    job_location, -- comma as new column is below
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM
    job_postings_fact;

-- Note column is temporary and is not saved to table

-- Using the new 'column'

SELECT
    COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    location_category;

-- Practice Problem

SELECT
    salary_year_avg,
    CASE
        WHEN salary_year_avg > 100000 THEN 'High'
        WHEN salary_year_avg BETWEEN 60000 AND 100000 THEN 'Standard'
        ELSE 'Low'
    END AS salary_cat,
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL