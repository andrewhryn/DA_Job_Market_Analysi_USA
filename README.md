
# 📊 :us: Data Analyst Jobs Analysis Using SQL 

# 🚀 Introduction 
Welcome to the Job Analysis Project! In this project, we explore Data Analyst positions across the USA. By diving into job postings data, we uncover valuable insights into the top-paying jobs, in-demand skills, and key trends shaping the Data Analyst job market.
[View SQL Code Here](sql_project)

# 🛠️ Tools I used 



- **SQL**: 

- **PostgreSQL**

- **GitHub, Git**

- **VS Code**




# 🗄️ Database Schema: 
![image](https://github.com/MadGrib/DA_Job_Market_AnalysisUSA/assets/93443868/f18208b8-1773-4dd3-9e16-a1b1be625994)

* This diagram illustrates the structure of the database tables and their relationships.

# 🔍 The Analysis 
### 1) Top Paying Jobs 💰 
We kick-started our analysis by identifying the top-paying Data Analyst jobs in the USA. By querying the database, we uncovered insights into job titles, locations, salaries, and top employers.
```sql
/*
Finding top paying DA jobs in Anywhere in the USA, 
joining 'company_dim' table to see company names
*/

SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type, 
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM 
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10

```

### 2) Top Paying Job Skills 💼
Next, we delved into the specific skills that correlate with higher salaries for Data Analyst positions. Understanding these key skills is crucial for individuals aiming to maximize their earning potential in the field.
```sql
/* 
Using the previous result as CTE, join 2 tables (skills_dim and skills_job_dim)
to find the skills required.
*/

WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,

        salary_year_avg,
        name AS company_name
    FROM 
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY 
    salary_year_avg DESC
)

SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY 
    salary_year_avg DESC
```

### 3) Top Demanded Skills 📈
We also examined the most in-demand skills for Data Analyst roles by counting their mentions in job postings. This analysis provides valuable insights into the skills that employers prioritize when hiring Data Analysts.
```sql
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
```

### 4) Top Paying Skills 💵
By analyzing the average salary based on specific skills, we gained deeper insights into the monetary value associated with different skillsets. This information is invaluable for both job seekers and employers alike.
```sql
/* 
Modifying the third query so we can see the available salary
from a data analyst role (ignoring postings where salary is not mentioned).
We can observe that people with more specific skills are paid more.
*/

SELECT 
    skills,
    ROUND(AVG(salary_year_avg),0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
GROUP BY 
    skills
ORDER BY
    avg_salary DESC
LIMIT 25
```
### 5) Optimal Skills 🎯
Through advanced analysis techniques like Common Table Expressions (CTE), we combined demand and salary data to identify the most optimal skills for Data Analysts. These insights empower individuals to strategically enhance their skillset for maximum impact.
```sql

/*

Using queries 3 and 4 as CTE, remove the limit to see the whole
result set, grouping by skill_id, and adding skills_id so we
can use it as a key for joining

*/

WITH skills_demand AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' 
        AND salary_year_avg IS NOT NULL
    GROUP BY
        skills_dim.skill_id
), 

average_salary AS (
    SELECT 
        skills_job_dim.skill_id,
        ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
    GROUP BY
        skills_job_dim.skill_id
)

--Combining both CTE into one table, limiting to top 25
SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM
    skills_demand
INNER JOIN  average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE  
    demand_count > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;
```
## What I Learned 📚 
This project was not just about analyzing data; it was a journey of discovery. Along the way, we gained valuable insights into the intricacies of the Data Analyst job market, the importance of skill proficiency, and the evolving trends shaping the industry.

## Conclusion 🌟
By understanding the key factors influencing job opportunities and salaries, individuals can chart their career path strategically, while employers can optimize their recruitment strategies to attract top talent.
