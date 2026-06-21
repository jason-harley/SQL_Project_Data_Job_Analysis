/*
Question: What are the top-paying Data Analyst jobs?
- Identify the top 10 highest-paying Data Analyst roles that are available in the UK
- Focussed on job postings with specified salaries (remove null values)
- Why? Highlight the top-paying opportunities for Data Analysts, offering insights into employment opportunities
*/

SELECT
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