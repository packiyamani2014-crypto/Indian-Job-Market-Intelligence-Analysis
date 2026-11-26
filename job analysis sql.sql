CREATE DATABASE job_market_analysis;
USE job_market_analysis;
CREATE TABLE job_data (
    job_id INT,
    job_title VARCHAR(255),
    job_category VARCHAR(100),
    company_name VARCHAR(255),
    company_size VARCHAR(100),
    industry VARCHAR(150),
    location_city VARCHAR(100),
    location_state VARCHAR(100),
    location_country VARCHAR(100),
    work_mode VARCHAR(50),
    salary_minimum INT,
    salary_maximum INT,
    experience_level VARCHAR(100),
    experience_required VARCHAR(100),
    skills_extracted TEXT,
    posted_date DATE,
    probation_period VARCHAR(100),
    career_growth_index FLOAT
);
DESCRIBE job_data;
USE job_market_analysis;
SELECT COUNT(*) FROM clean_jobs_final;
SELECT *
FROM clean_jobs_final
LIMIT 10;
SELECT
    job_title,
    COUNT(*) AS total_jobs
FROM clean_jobs_final
GROUP BY job_title
ORDER BY total_jobs DESC
LIMIT 10;
SELECT
    experience_level,
    COUNT(*) AS total_jobs
FROM clean_jobs_final
GROUP BY experience_level
ORDER BY total_jobs DESC;
SELECT
    work_mode,
    COUNT(*) AS total_jobs
FROM clean_jobs_final
GROUP BY work_mode
ORDER BY total_jobs DESC;
SELECT
    AVG(salary_minimum) AS average_min_salary,
    AVG(salary_maximum) AS average_max_salary,
    MIN(salary_minimum) AS lowest_salary,
    MAX(salary_maximum) AS highest_salary
FROM clean_jobs_final;
SELECT
    location_city,
    COUNT(*) AS total_jobs
FROM clean_jobs_final
GROUP BY location_city
ORDER BY total_jobs DESC
LIMIT 10;
SELECT
    industry,
    COUNT(*) AS total_jobs
FROM clean_jobs_final
GROUP BY industry
ORDER BY total_jobs DESC
LIMIT 10;
SELECT
    experience_level,
    ROUND(AVG(salary_minimum), 2) AS avg_min_salary,
    ROUND(AVG(salary_maximum), 2) AS avg_max_salary
FROM clean_jobs_final
GROUP BY experience_level
ORDER BY avg_min_salary DESC;
SELECT
    experience_level,
    work_mode,
    COUNT(*) AS total_jobs
FROM clean_jobs_final
GROUP BY experience_level, work_mode
ORDER BY experience_level, total_jobs DESC;
SELECT
    company_name,
    COUNT(*) AS total_jobs
FROM clean_jobs_final
GROUP BY company_name
ORDER BY total_jobs DESC
LIMIT 10;
SELECT
    job_category,
    COUNT(*) AS total_jobs
FROM clean_jobs_final
GROUP BY job_category
ORDER BY total_jobs DESC;
SELECT
    skills_extracted,
    COUNT(*) AS total_jobs
FROM clean_jobs_final
WHERE skills_extracted IS NOT NULL
GROUP BY skills_extracted
ORDER BY total_jobs DESC
LIMIT 10;
SELECT
    YEAR(posted_date) AS job_year,
    COUNT(*) AS total_jobs
FROM clean_jobs_final
WHERE posted_date IS NOT NULL
GROUP BY YEAR(posted_date)
ORDER BY job_year;
SELECT
    probation_period,
    COUNT(*) AS total_jobs
FROM clean_jobs_final
GROUP BY probation_period
ORDER BY total_jobs DESC;
SELECT
    ROUND(AVG(career_growth_index), 2) AS average_growth,
    MAX(career_growth_index) AS highest_growth,
    MIN(career_growth_index) AS lowest_growth
FROM clean_jobs_final;
SELECT
    job_title,
    AVG((salary_minimum + salary_maximum) / 2) AS avg_salary
FROM clean_jobs_final
WHERE salary_minimum IS NOT NULL
  AND salary_maximum IS NOT NULL
GROUP BY job_title
HAVING AVG((salary_minimum + salary_maximum) / 2) = (
    SELECT MAX(avg_sal)
    FROM (
        SELECT AVG((salary_minimum + salary_maximum) / 2) AS avg_sal
        FROM clean_jobs_final
        WHERE salary_minimum IS NOT NULL
          AND salary_maximum IS NOT NULL
        GROUP BY job_title
    ) AS salary_table
);
SELECT
    COUNT(*) AS total_rows,
    COUNT(salary_minimum) AS min_salary_count,
    COUNT(salary_maximum) AS max_salary_count
FROM clean_jobs_final;
SELECT
    job_title,
    salary_minimum,
    salary_maximum
FROM clean_jobs_final
WHERE salary_minimum IS NOT NULL
LIMIT 10;
SELECT
    job_title,
    ROUND(AVG((salary_minimum + salary_maximum) / 2), 2) AS avg_salary
FROM clean_jobs_final
WHERE salary_minimum IS NOT NULL
  AND salary_maximum IS NOT NULL
GROUP BY job_title
ORDER BY avg_salary DESC
LIMIT 10;
SELECT
    location_city,
    COUNT(*) AS fresher_jobs
FROM clean_jobs_final
WHERE experience_level = 'Freshers / Entry Level'
GROUP BY location_city
ORDER BY fresher_jobs DESC
LIMIT 10;
SELECT
    location_city,
    COUNT(*) AS remote_jobs
FROM clean_jobs_final
WHERE work_mode = 'Remote'
GROUP BY location_city
ORDER BY remote_jobs DESC
LIMIT 10;
SELECT
    company_size,
    COUNT(*) AS total_jobs
FROM clean_jobs_final
GROUP BY company_size
ORDER BY total_jobs DESC;
SELECT
    location_state,
    COUNT(*) AS total_jobs
FROM clean_jobs_final
GROUP BY location_state
ORDER BY total_jobs DESC
LIMIT 10;
SELECT
    MONTHNAME(posted_date) AS job_month,
    COUNT(*) AS total_jobs
FROM clean_jobs_final
WHERE posted_date IS NOT NULL
GROUP BY MONTH(posted_date), MONTHNAME(posted_date)
ORDER BY MONTH(posted_date);
SELECT
    job_title,
    ROUND(AVG(career_growth_index), 2) AS avg_growth_index
FROM clean_jobs_final
WHERE career_growth_index IS NOT NULL
GROUP BY job_title
ORDER BY avg_growth_index DESC
LIMIT 10;
SHOW TABLES;
CREATE TABLE company_summary (
    company_name VARCHAR(255),
    company_type VARCHAR(100),
    company_location VARCHAR(100)
);
INSERT INTO company_summary
(company_name, company_type, company_location)
VALUES
('TCS', 'IT Services', 'Chennai'),
('Infosys', 'IT Services', 'Bangalore'),
('Wipro', 'IT Services', 'Hyderabad'),
('Accenture', 'Consulting', 'Chennai'),
('Amazon', 'E-commerce', 'Bangalore');
SELECT * FROM company_summary;
SELECT
    j.company_name,
    j.job_title,
    c.company_type,
    c.company_location
FROM clean_jobs_final AS j
INNER JOIN company_summary AS c
ON j.company_name = c.company_name;
SELECT
    j.company_name,
    j.job_title,
    c.company_type,
    c.company_location
FROM clean_jobs_final AS j
LEFT JOIN company_summary AS c
ON j.company_name = c.company_name;
SELECT
    j.company_name,
    j.job_title,
    c.company_type,
    c.company_location
FROM clean_jobs_final AS j
RIGHT JOIN company_summary AS c
ON j.company_name = c.company_name;
SELECT company_name
FROM clean_jobs_final
WHERE work_mode = 'Remote'

UNION

SELECT company_name
FROM clean_jobs_final
WHERE work_mode = 'Hybrid';
SELECT
    job_title,
    ROUND((salary_minimum + salary_maximum) / 2, 2) AS avg_salary,
    CASE
        WHEN (salary_minimum + salary_maximum) / 2 >= 1000000
            THEN 'High Salary'
        WHEN (salary_minimum + salary_maximum) / 2 >= 500000
            THEN 'Medium Salary'
        ELSE 'Low Salary'
    END AS salary_category
FROM clean_jobs_final
WHERE salary_minimum IS NOT NULL
  AND salary_maximum IS NOT NULL
LIMIT 20;
SELECT
    job_title,
    avg_salary,
    RANK() OVER (ORDER BY avg_salary DESC) AS salary_rank
FROM (
    SELECT
        job_title,
        ROUND(AVG((salary_minimum + salary_maximum) / 2), 2) AS avg_salary
    FROM clean_jobs_final
    WHERE salary_minimum IS NOT NULL
      AND salary_maximum IS NOT NULL
    GROUP BY job_title
) AS salary_data
LIMIT 20;
SELECT
    job_title,
    avg_salary,
    DENSE_RANK() OVER (ORDER BY avg_salary DESC) AS salary_rank
FROM (
    SELECT
        job_title,
        ROUND(AVG((salary_minimum + salary_maximum) / 2), 2) AS avg_salary
    FROM clean_jobs_final
    WHERE salary_minimum IS NOT NULL
      AND salary_maximum IS NOT NULL
    GROUP BY job_title
) AS salary_data
LIMIT 20;
SELECT
    job_title,
    avg_salary,
    ROW_NUMBER() OVER (ORDER BY avg_salary DESC) AS row_num
FROM (
    SELECT
        job_title,
        ROUND(AVG((salary_minimum + salary_maximum) / 2), 2) AS avg_salary
    FROM clean_jobs_final
    WHERE salary_minimum IS NOT NULL
      AND salary_maximum IS NOT NULL
    GROUP BY job_title
) AS salary_data
LIMIT 20;
WITH job_salary AS (
    SELECT
        job_title,
        AVG((salary_minimum + salary_maximum) / 2) AS avg_salary
    FROM clean_jobs_final
    WHERE salary_minimum IS NOT NULL
      AND salary_maximum IS NOT NULL
    GROUP BY job_title
)
SELECT
    job_title,
    ROUND(avg_salary, 2) AS avg_salary
FROM job_salary
ORDER BY avg_salary DESC
LIMIT 10;
SELECT
    job_title,
    ROUND(AVG((salary_minimum + salary_maximum) / 2), 2) AS avg_salary
FROM clean_jobs_final
WHERE salary_minimum IS NOT NULL
  AND salary_maximum IS NOT NULL
GROUP BY job_title
HAVING AVG((salary_minimum + salary_maximum) / 2) > (
    SELECT AVG((salary_minimum + salary_maximum) / 2)
    FROM clean_jobs_final
    WHERE salary_minimum IS NOT NULL
      AND salary_maximum IS NOT NULL
)
ORDER BY avg_salary DESC;
SELECT
    work_mode,
    COUNT(*) AS total_jobs,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS job_percentage
FROM clean_jobs_final
GROUP BY work_mode
ORDER BY job_percentage DESC;
SELECT
    experience_level,
    COUNT(*) AS total_jobs,
    ROUND(AVG(salary_minimum), 2) AS avg_min_salary,
    ROUND(AVG(salary_maximum), 2) AS avg_max_salary
FROM clean_jobs_final
WHERE salary_minimum IS NOT NULL
  AND salary_maximum IS NOT NULL
GROUP BY experience_level;
SELECT
    job_id,
    COUNT(*) AS duplicate_count
FROM clean_jobs_final
GROUP BY job_id
HAVING COUNT(*) > 1;
SELECT
    COUNT(*) AS total_records,
    SUM(job_title IS NULL) AS missing_job_title,
    SUM(company_name IS NULL) AS missing_company,
    SUM(location_city IS NULL) AS missing_city,
    SUM(salary_minimum IS NULL) AS missing_min_salary,
    SUM(salary_maximum IS NULL) AS missing_max_salary
FROM clean_jobs_final;
CREATE VIEW top_job_titles AS
SELECT
    job_title,
    COUNT(*) AS total_jobs
FROM clean_jobs_final
GROUP BY job_title
ORDER BY total_jobs DESC;
CREATE OR REPLACE VIEW top_job_titles AS
SELECT
    job_title,
    COUNT(*) AS total_jobs
FROM clean_jobs_final
GROUP BY job_title;
SELECT *
FROM top_job_titles
ORDER BY total_jobs DESC
LIMIT 10;

CREATE INDEX idx_work_mode
ON clean_jobs_final(work_mode(20));
SHOW INDEX FROM clean_jobs_final;
EXPLAIN
SELECT *
FROM clean_jobs_final
WHERE work_mode = 'Remote';
DELIMITER //

CREATE PROCEDURE GetTopJobTitles()
BEGIN
    SELECT
        job_title,
        COUNT(*) AS total_jobs
    FROM clean_jobs_final
    GROUP BY job_title
    ORDER BY total_jobs DESC
    LIMIT 10;
END //

DELIMITER ;
SHOW PROCEDURE STATUS
WHERE Db = 'job_market_analysis';
USE job_market_analysis;

DROP PROCEDURE IF EXISTS GetTopJobTitles;

DELIMITER //

CREATE PROCEDURE GetTopJobTitles()
BEGIN
    SELECT
        job_title,
        COUNT(*) AS total_jobs
    FROM clean_jobs_final
    GROUP BY job_title
    ORDER BY total_jobs DESC
    LIMIT 10;
END //

DELIMITER ;
USE job_market_analysis;

DROP PROCEDURE IF EXISTS GetTopJobTitles;

DELIMITER //

CREATE PROCEDURE GetTopJobTitles()
BEGIN
    SELECT
        job_title,
        COUNT(*) AS total_jobs
    FROM clean_jobs_final
    GROUP BY job_title
    ORDER BY total_jobs DESC
    LIMIT 10;
END //

DELIMITER ;
CALL GetTopJobTitles();
DELIMITER //

CREATE FUNCTION GetTotalJobs()
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;

    SELECT COUNT(*) INTO total
    FROM clean_jobs_final;

    RETURN total;
END //

DELIMITER ;
SELECT GetTotalJobs() AS total_jobs;
SELECT
    MIN(salary_minimum) AS lowest_salary,
    MAX(salary_maximum) AS highest_salary,
    ROUND(AVG(salary_minimum), 2) AS avg_min_salary,
    ROUND(AVG(salary_maximum), 2) AS avg_max_salary
FROM clean_jobs_final;
SELECT
    CASE
        WHEN salary_maximum >= 1000000 THEN 'High Salary'
        WHEN salary_maximum >= 500000 THEN 'Medium Salary'
        ELSE 'Low Salary'
    END AS salary_category,
    COUNT(*) AS total_jobs
FROM clean_jobs_final
GROUP BY salary_category
ORDER BY total_jobs DESC;
