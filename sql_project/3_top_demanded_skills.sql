/* 
Count the total skills mentioned, using joints to combine all the tables. Grouping by skills.
*/

SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
GROUP BY 
    skills
ORDER BY demand_count DESC
LIMIT 5 

--SQL #1, Excel#2, Python #3, Tableau #4, Power BI #5