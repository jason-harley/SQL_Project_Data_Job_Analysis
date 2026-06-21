-- Find the most in-demand skills
-- We do this by counting the number of job postings (that meet our other criteria) per skill
-- This is important to ensure we spend time learning the most valuable skills


WITH in_demand_skills AS (
-- Count of each skill's appearances in the job postings of interest
    SELECT
        skill_id,
        COUNT(*) AS skill_count
    FROM 
        skills_job_dim
    INNER JOIN job_postings_fact
    ON skills_job_dim.job_id = job_postings_fact.job_id
    WHERE
        job_title_short = 'Data Analyst'
        AND job_schedule_type = 'Full-time'
        AND salary_year_avg IS NOT NULL
        AND (job_location LIKE '%UK%' OR job_location LIKE '%United Kingdom%')
    GROUP BY
        skill_id
)

SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    skill_count
FROM in_demand_skills
INNER JOIN skills_dim
ON skills_dim.skill_id = in_demand_skills.skill_id
ORDER BY
    skill_count DESC
LIMIT 5;

-- We can be more efficient!
-- Notes from course...
/*
Question: What are the most in-deman skills for data analysts?
- Join job postings to inner join table (similar to query 2)
- Identify the top 5 in-demand skills for a data analyst
- Why? Retrieves the top 5 skills with the highest demand in the job market,
providing insights into the most valuable skills for job seekers.
*/

SELECT
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND job_schedule_type = 'Full-time'
    AND (job_location LIKE '%UK%' OR job_location LIKE '%United Kingdom%')
--    AND salary_year_avg IS NOT NULL -- requires listed salary
GROUP BY
    skills
ORDER BY 
    demand_count DESC
LIMIT 5

