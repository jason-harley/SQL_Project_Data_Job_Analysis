-- Union Operators

-- Combines result sets row-wise
-- (Provided they have the same no. columns + data types)
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    january_jobs
UNION
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    february_jobs

-- UNION ALL
-- Does the same thing as Union, keeping all duplicates (whereas 'UNION' removes them)

SELECT
    job_title_short,
    company_id,
    job_location
FROM
    january_jobs
UNION ALL
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    february_jobs



-- Practice Problem 1
SELECT
    skills_job_dim.job_id,
    skills,
    type
FROM
    skills_dim
LEFT JOIN skills_job_dim
ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE skills_job_dim.job_id IN (
    SELECT
        job_id
    FROM
        job_postings_fact
    WHERE
        salary_year_avg > 70000 AND
        EXTRACT(MONTH FROM job_posted_date) < 4
)

UNION

SELECT
    job_id,
    NULL AS skills_null,
    NULL AS type_null
FROM
    job_postings_fact
WHERE
    salary_year_avg > 70000 AND
    EXTRACT(MONTH FROM job_posted_date) < 4
    AND job_id NOT IN (
        SELECT
            job_id
        FROM
        skills_job_dim)

-- Solution (without skills)

SELECT
    q1_job_postings.job_title_short,
    q1_job_postings.job_location,
    q1_job_postings.job_via,
    q1_job_postings.job_posted_date::DATE,
    q1_job_postings.salary_year_avg
FROM (
    SELECT *
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs
) AS q1_job_postings
    WHERE q1_job_postings.salary_year_avg > 70000

