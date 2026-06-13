-- Subqueries and CTEs

-- SubQuery
SELECT *
FROM
    ( -- SubQuery starts here
    SELECT *
    FROM
        job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
    ) AS january_jobs;
    -- SubQuery ends here

-- CTE
WITH january_jobs AS ( -- CTE definition starts here
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
    ) -- CTE definition ends here
SELECT *
FROM january_jobs;

-- SubQuery example (names from company table, avoids needing JOIN!)
SELECT name AS company_name
FROM company_dim
WHERE company_id IN (
    SELECT
        company_id
    FROM
        job_postings_fact
    WHERE
        job_no_degree_mention = 'TRUE'
)

-- CTEs example
/*
Find the companies that have the most job openings
- Get the total number of job postings per company id (job_postings_fact)
- Return the total number of jobs with the company name (company_dim)
*/

-- The below counts the number of job postings per company ID
SELECT  
    company_id,
    COUNT(*)
FROM 
    job_postings_fact
GROUP BY
    company_id

-- We then use this as our CTE
WITH company_job_count AS (
    SELECT  
    company_id,
    COUNT(*) AS total_jobs
FROM 
    job_postings_fact
GROUP BY
    company_id)

SELECT
    company_dim.name AS company_name,
    company_job_count.total_jobs
FROM company_dim
LEFT JOIN company_job_count
ON company_dim.company_id = company_job_count.company_id
ORDER BY
    total_jobs DESC

-- Practice Problem 1

-- Subquery
SELECT
    COUNT(skill_id) AS skill_count,
    skill_id
FROM 
    skills_job_dim
GROUP BY
    skill_id
ORDER BY
    skill_count DESC

-- Using subquery as left join to return top 5 skills in job postings
SELECT
    skills_dim.skills,
    count_table.skill_count
FROM
    skills_dim
LEFT JOIN (SELECT
    COUNT(skill_id) AS skill_count,
    skill_id
FROM 
    skills_job_dim
GROUP BY
    skill_id
ORDER BY
    skill_count DESC) AS count_table
ON count_table.skill_id = skills_dim.skill_id
LIMIT 5

-- Practice Problem 2

-- Subquery
SELECT
    company_id,
    COUNT(job_id) AS num_jobs
FROM
    job_postings_fact
GROUP BY
    company_id
ORDER BY 
    num_jobs DESC

-- Subquery as left join with case expression to categorise company sizes by jobs available
SELECT
    name,
    CASE
        WHEN num_jobs > 50 THEN 'Large'
        WHEN num_jobs BETWEEN 10 AND 50 THEN 'Medium'
        ELSE 'Small'
    END AS company_size,
    company_and_job_counts.num_jobs
FROM company_dim
LEFT JOIN (SELECT
    company_id,
    COUNT(job_id) AS num_jobs
FROM
    job_postings_fact
GROUP BY
    company_id) AS company_and_job_counts
ON company_and_job_counts.company_id = company_dim.company_id
LIMIT 10

-- Practice Problem 7
/* Find the number of remote job postings per skill
    - Display the top 5 skills by their demand in emote jobs
    - Include skill ID, name, and count of postings requiring the skill
*/

SELECT
    skills_dim.skills,
    count_table.skill_count
FROM
    skills_dim
LEFT JOIN (SELECT
    COUNT(skill_id) AS skill_count,
    skill_id
FROM 
    skills_job_dim
WHERE skills_job_dim.job_id IN
    (SELECT
        job_id
    FROM
        job_postings_fact
    WHERE
    job_location = 'Anywhere')
GROUP BY
    skill_id) AS count_table
ON count_table.skill_id = skills_dim.skill_id
WHERE skill_count IS NOT NULL
ORDER BY
    skill_count DESC
LIMIT 5

-- Solution with CTE instead

WITH remote_job_skills AS (
    SELECT
        skill_id,
        COUNT(*) AS skill_count
    FROM
        skills_job_dim AS skills_to_job
    INNER JOIN job_postings_fact ON job_postings_fact.job_id = skills_to_job.job_id
    WHERE
        job_postings_fact.job_work_from_home = True
    GROUP BY
        skill_id
)
SELECT
    skills_dim.skill_id,
    skills,
    skill_count
FROM
    remote_job_skills
INNER JOIN skills_dim ON skills_dim.skill_id = remote_job_skills.skill_id
ORDER BY
    skill_count DESC
LIMIT 5










