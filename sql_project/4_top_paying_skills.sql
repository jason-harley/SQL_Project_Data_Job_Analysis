/* Question: What are the top paying skills based on salary?
- Look at the average salary associated with each skills for data analyst positions
- Focuses on roles with specififed salaries, regardless of location
- Why? It reveals how different skills impact salary levels for Data Analyst and help identify the most financially rewarding skills to acquire or improve
*/

SELECT
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(salary_year_avg),-3) AS skill_avg_salary -- New line for average salary!
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND job_schedule_type = 'Full-time'
    AND (job_location LIKE '%UK%' OR job_location LIKE '%United Kingdom%')
    AND salary_year_avg IS NOT NULL
GROUP BY
    skills
ORDER BY 
    skill_avg_salary DESC
LIMIT 10;

-- The counts are low, so these are not the most optimal skills to learn!