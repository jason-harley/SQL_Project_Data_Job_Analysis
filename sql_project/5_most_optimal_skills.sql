-- Query 5
-- Most optimal skills! High demand AND high paying

/*
Answer: What are the most optimal skills to learn (in-demand and high-paying)?
 - Identify skills in high demand and associayted with high salaries for Data Analyst roles
 - Concentrates on positions in the UK with specified salaries
 - Why? Targets skills that offer job securiy (high demand) and financial benefits (high salaries),
    offering strategic insights for career development in data analysis
*/

-- Use previous query with CTE
WITH skill_demand AS (
    SELECT
        skills_dim.skill_id,
        skills,
        COUNT(skills_job_dim.job_id) AS skill_count
    FROM
        job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'
        AND job_schedule_type = 'Full-time'
        AND (job_location LIKE '%UK%' OR job_location LIKE '%United Kingdom%')
        AND salary_year_avg IS NOT NULL -- requires listed salary
    GROUP BY
        skills_dim.skill_id
), skill_salary AS ( -- Multiple CTEs, we group them like this
    SELECT
        skills_dim.skill_id,
        skills,
        ROUND(AVG(salary_year_avg),-3) AS skill_avg_salary -- New line for average salary!
    FROM
        job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'
        AND job_schedule_type = 'Full-time'
        AND (job_location LIKE '%UK%' OR job_location LIKE '%United Kingdom%')
        AND salary_year_avg IS NOT NULL -- requires listed salary
    GROUP BY
        skills_dim.skill_id
)

SELECT
    skill_demand.skill_id,
    skill_demand.skills,
    skill_count,
    skill_avg_salary
FROM 
    skill_demand
INNER JOIN skill_salary
ON skill_salary.skill_id = skill_demand.skill_id
WHERE
    skill_count > 5
ORDER BY
    skill_avg_salary DESC
LIMIT 10

-- See adapted query 4, it's more efficient!