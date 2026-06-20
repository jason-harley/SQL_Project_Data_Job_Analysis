/*
Question: What skills are required for the top-paying Data Analyst jobs?
- Use the top 10 highest-paying Data Analyst jobs from the first query
- Add the specific skills required for these roles
- Why? It provides a detailed looks at which high-paying jobs demand certain skills,
    helping job seekers understand which skills to develop that align with top salaries
*/

-- We use the first query within a CTE

WITH top_paying_jobs AS (
-- First query (to find top-paying roles)
    SELECT
        job_id,
        job_title,
        job_location,
        salary_year_avg AS salary,
        company_dim.name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim
    ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst'
        AND job_schedule_type = 'Full-time'
        AND salary_year_avg IS NOT NULL
        AND (job_location LIKE '%UK%' OR job_location LIKE '%United Kingdom%')
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT
    top_paying_jobs.*,
    skills
FROM 
    top_paying_jobs
-- We use inner joins as we do not care for jobs which do not have any skills listed
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary DESC

-- Use chatGPT to analyse excel export of results!