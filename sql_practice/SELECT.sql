SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time
FROM
    job_postings_fact
LIMIT 5;

SELECT
    job_title_short AS title,
    job_location AS location,
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM
    job_postings_fact
LIMIT 5

-- Data Analyst job postings per month (ranked)
SELECT
    COUNT(job_id),
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    month
ORDER BY count DESC;

-- Date Functions PP (1)
SELECT
    ROUND(AVG(salary_year_avg),0) AS avg_yearly_salary,
    ROUND(AVG(salary_hour_avg),0) AS avg_hourly_salary,
    job_schedule_type
FROM
    job_postings_fact
WHERE
    EXTRACT(MONTH FROM job_posted_date) >= 6
    AND EXTRACT(YEAR FROM job_posted_date) >= 2023
GROUP BY
    job_schedule_type
HAVING
    COUNT(salary_year_avg) > 1
    AND COUNT(salary_hour_avg) > 1
ORDER BY
    avg_yearly_salary DESC
LIMIT 5;

-- Date Functions PP (3)
SELECT 
     jpf.company_id,
 --    jpf.job_health_insurance,
     companies.name,
     COUNT(companies.name) AS job_postings
FROM 
    job_postings_fact AS jpf
LEFT JOIN company_dim AS companies
    ON jpf.company_id = companies.company_id
WHERE
    jpf.job_health_insurance = 'TRUE'
    AND EXTRACT(MONTH FROM jpf.job_posted_date) BETWEEN 4 AND 6
GROUP BY companies.name, jpf.company_id
ORDER BY job_postings DESC
LIMIT 10;

-- PP6
-- Jan
CREATE TABLE january_jobs AS
    SELECT *
    FROM
        job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
        AND EXTRACT(YEAR FROM job_posted_date) = 2023;

-- Feb
CREATE TABLE february_jobs AS
    SELECT *
    FROM
        job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2
        AND EXTRACT(YEAR FROM job_posted_date) = 2023;

-- Mar
CREATE TABLE march_jobs AS
    SELECT *
    FROM
        job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3
        AND EXTRACT(YEAR FROM job_posted_date) = 2023;

SELECT job_posted_date
FROM march_jobs
