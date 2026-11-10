-- ============================================================
-- EMPLOYEE PERFORMANCE & SALARY ANALYSIS
-- MySQL 8.0+
-- Tagged SQL practice queries from the user's uploaded file
-- Note: The source file contains 29 SQL statements. The extra
-- DENSE_RANK statement is tagged as Additional Practice 1.
-- ============================================================

-- Q1. Count employees in each department
SELECT
    d.department_name,
    COUNT(e.department_id) AS Employers
FROM Employees AS e
JOIN Departments AS d
    ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name;

-- Additional Practice 1. Rank employees by salary within each department
SELECT
    e.employee_name,
    d.department_name,
    e.salary,
    DENSE_RANK() OVER (
        PARTITION BY d.department_name
        ORDER BY e.salary DESC
    ) AS salary_rank
FROM Employees AS e
JOIN Departments AS d
    ON d.department_id = e.department_id;

-- Q2. Gender distribution by department
SELECT
    d.department_name,
    e.gender AS gender,
    COUNT(e.department_id) AS Employers
FROM Employees AS e
JOIN Departments AS d
    ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name, e.gender;

-- Q3. Minimum, maximum and average salary by department
SELECT
    d.department_name,
    MAX(e.salary) AS Max_salary,
    MIN(e.salary) AS Min_salary,
    AVG(e.salary) AS Avg_salary
FROM Employees AS e
JOIN Departments AS d
    ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name;

-- Q4. Employees earning more than 60000 using a CTE
WITH EmployeesDept AS (
    SELECT
        e.employee_id,
        e.employee_name,
        e.gender,
        e.salary,
        e.country,
        d.department_name
    FROM Employees AS e
    JOIN Departments AS d
        ON d.department_id = e.department_id
)
SELECT
    employee_name,
    department_name,
    salary,
    country
FROM EmployeesDept
WHERE salary > 60000;

-- Q5. Employees earning above the company average salary
SELECT
    e.employee_id,
    e.employee_name,
    e.gender,
    e.salary,
    e.country,
    d.department_name
FROM Employees AS e
JOIN Departments AS d
    ON d.department_id = e.department_id
WHERE salary > (
    SELECT AVG(salary)
    FROM Employees
);

-- Q6. Classify employees into salary categories
SELECT
    employee_name,
    salary,
    CASE
        WHEN salary >= 80000 THEN 'High Salary'
        WHEN salary >= 60000 AND salary < 80000 THEN 'Medium Salary'
        ELSE 'Low Salary'
    END AS salary_category
FROM Employees;

-- Q7. Employees earning above their department's average salary
WITH DeptByEmployees AS (
    SELECT
        d.department_id,
        d.department_name,
        AVG(e.salary) AS Avg_salary
    FROM Employees AS e
    JOIN Departments AS d
        ON d.department_id = e.department_id
    GROUP BY e.department_id, d.department_name
)
SELECT
    e.employee_name,
    de.department_name,
    e.salary,
    de.Avg_salary
FROM Employees AS e
JOIN DeptByEmployees AS de
    ON e.department_id = de.department_id
WHERE e.salary > de.Avg_salary;

-- Q8. Rank employees by salary within each department
SELECT
    e.employee_name,
    d.department_name,
    e.salary,
    DENSE_RANK() OVER (
        PARTITION BY d.department_name
        ORDER BY e.salary DESC
    ) AS salary_rank
FROM Employees AS e
JOIN Departments AS d
    ON d.department_id = e.department_id;

-- Q9. Find the latest performance review for each employee
WITH LatestReviews AS (
    SELECT
        employee_id,
        review_date,
        performance_score,
        ROW_NUMBER() OVER (
            PARTITION BY employee_id
            ORDER BY review_date DESC
        ) AS Row_order
    FROM Performance_Reviews
)
SELECT
    employee_id,
    review_date,
    performance_score
FROM LatestReviews
WHERE Row_order = 1;

-- Q10. Compare each employee's performance score with their previous review
SELECT
    employee_id,
    review_date,
    performance_score AS current_score,
    LAG(performance_score) OVER (
        PARTITION BY employee_id
        ORDER BY review_date ASC
    ) AS previous_score,
    performance_score - LAG(performance_score) OVER (
        PARTITION BY employee_id
        ORDER BY review_date ASC
    ) AS score_difference
FROM Performance_Reviews;

-- Q11. Calculate running total salary within each department
SELECT
    e.employee_name,
    d.department_name,
    e.salary,
    SUM(e.salary) OVER (
        PARTITION BY d.department_id
        ORDER BY e.salary DESC
    ) AS running_total_salary
FROM Employees AS e
JOIN Departments AS d
    ON d.department_id = e.department_id;

-- Q12. Show each employee's department average salary
SELECT
    e.employee_name,
    d.department_name,
    e.salary,
    AVG(e.salary) OVER (
        PARTITION BY d.department_id
    ) AS avg_salary
FROM Employees AS e
JOIN Departments AS d
    ON d.department_id = e.department_id;

-- Q13. Find the second-highest salary in each department
WITH SalaryRank AS (
    SELECT
        e.employee_name,
        d.department_name,
        e.salary,
        DENSE_RANK() OVER (
            PARTITION BY d.department_id
            ORDER BY e.salary DESC
        ) AS salary_ranking
    FROM Employees AS e
    JOIN Departments AS d
        ON d.department_id = e.department_id
)
SELECT
    employee_name,
    department_name,
    salary,
    salary_ranking
FROM SalaryRank
WHERE salary_ranking = 2;

-- Q14. Find employees whose performance score improved in 2025
WITH ScoreDiff AS (
    SELECT
        employee_id,
        performance_score,
        review_date,
        LAG(performance_score) OVER (
            PARTITION BY employee_id
            ORDER BY review_date ASC
        ) AS previous_score,
        performance_score - LAG(performance_score) OVER (
            PARTITION BY employee_id
            ORDER BY review_date ASC
        ) AS score_diff
    FROM Performance_Reviews
)
SELECT
    employee_id,
    previous_score AS score_2024,
    performance_score AS score_2025,
    score_diff
FROM ScoreDiff
WHERE YEAR(review_date) = 2025
  AND score_diff > 0
ORDER BY score_diff DESC;

-- Q15. Department-wise average salary and employee count
SELECT
    d.department_name,
    AVG(e.salary) AS dept_avg_salary,
    COUNT(e.employee_id) AS total_employees
FROM Departments AS d
JOIN Employees AS e
    ON d.department_id = e.department_id
GROUP BY d.department_name, d.department_id
ORDER BY dept_avg_salary DESC;

-- Q16. Country with average performance score in 2025
SELECT
    e.country,
    AVG(pr.performance_score) AS countries_avg_performance_score,
    COUNT(DISTINCT e.employee_id) AS total_employees
FROM Performance_Reviews AS pr
JOIN Employees AS e
    ON e.employee_id = pr.employee_id
WHERE YEAR(pr.review_date) = 2025
GROUP BY e.country
ORDER BY countries_avg_performance_score DESC;

-- Q17. Employees earning above their department average using a CTE
WITH DeptAvgSalary AS (
    SELECT
        d.department_id,
        d.department_name,
        AVG(e.salary) AS avg_salary
    FROM Employees AS e
    JOIN Departments AS d
        ON d.department_id = e.department_id
    GROUP BY d.department_id, d.department_name
)
SELECT
    e.employee_name,
    ds.department_name,
    e.salary,
    ds.avg_salary
FROM DeptAvgSalary AS ds
JOIN Employees AS e
    ON e.department_id = ds.department_id
WHERE e.salary > ds.avg_salary
ORDER BY ds.avg_salary DESC;

-- Q18. Find the top two highest-paid employees in each department
WITH DeptSalary AS (
    SELECT
        d.department_id,
        d.department_name,
        e.employee_name,
        e.salary,
        DENSE_RANK() OVER (
            PARTITION BY d.department_id
            ORDER BY e.salary DESC
        ) AS salary_ranking
    FROM Employees AS e
    JOIN Departments AS d
        ON d.department_id = e.department_id
)
SELECT
    employee_name,
    department_name,
    salary,
    salary_ranking
FROM DeptSalary
WHERE salary_ranking <= 2;

-- Q19. Find the second-highest salary in the entire company
WITH SalaryRank AS (
    SELECT
        employee_name,
        salary,
        DENSE_RANK() OVER (
            ORDER BY salary DESC
        ) AS salary_ranking
    FROM Employees
)
SELECT
    employee_name,
    salary,
    salary_ranking
FROM SalaryRank
WHERE salary_ranking = 2;

-- Q20. Find the third-highest salary in each department
WITH SalaryRank AS (
    SELECT
        d.department_id,
        d.department_name,
        e.employee_name,
        e.salary,
        DENSE_RANK() OVER (
            PARTITION BY d.department_id
            ORDER BY e.salary DESC
        ) AS salary_ranking
    FROM Employees AS e
    JOIN Departments AS d
        ON d.department_id = e.department_id
)
SELECT
    employee_name,
    department_name,
    salary,
    salary_ranking
FROM SalaryRank
WHERE salary_ranking = 3;

-- Q21. Calculate running total salary per department
WITH SalaryRunning AS (
    SELECT
        d.department_id,
        d.department_name,
        e.employee_name,
        e.salary,
        SUM(e.salary) OVER (
            PARTITION BY d.department_id
            ORDER BY e.salary DESC
        ) AS running_salary
    FROM Employees AS e
    JOIN Departments AS d
        ON d.department_id = e.department_id
)
SELECT
    employee_name,
    department_name,
    salary,
    running_salary
FROM SalaryRunning;

-- Q22. Compare each employee's salary with their department average
WITH SalaryVSDept AS (
    SELECT
        d.department_id,
        d.department_name,
        e.employee_name,
        e.salary,
        AVG(e.salary) OVER (
            PARTITION BY d.department_id
        ) AS avg_salary
    FROM Employees AS e
    JOIN Departments AS d
        ON d.department_id = e.department_id
)
SELECT
    employee_name,
    department_name,
    salary,
    avg_salary,
    ROUND(salary - avg_salary, 2) AS salary_difference
FROM SalaryVSDept;

-- Q23. Classify employees as high, average or low salary within their department
WITH SalaryVSDept AS (
    SELECT
        d.department_id,
        d.department_name,
        e.employee_name,
        e.salary,
        AVG(e.salary) OVER (
            PARTITION BY d.department_id
        ) AS avg_salary
    FROM Employees AS e
    JOIN Departments AS d
        ON d.department_id = e.department_id
)
SELECT
    employee_name,
    department_name,
    salary,
    avg_salary,
    CASE
        WHEN salary > avg_salary THEN 'High Salary'
        WHEN salary = avg_salary THEN 'Average Salary'
        ELSE 'Low Salary'
    END AS salary_category
FROM SalaryVSDept;

-- Q24. Department salary expenditure, employee count and average salary
SELECT
    d.department_name,
    SUM(e.salary) AS total_salary,
    COUNT(e.department_id) AS total_employees,
    AVG(e.salary) AS avg_salary
FROM Employees AS e
JOIN Departments AS d
    ON d.department_id = e.department_id
GROUP BY d.department_name, d.department_id
ORDER BY total_salary DESC;

-- Q25. Find the highest-paid employee(s) in each department
WITH HighSalary AS (
    SELECT
        d.department_name,
        e.employee_name,
        e.salary,
        DENSE_RANK() OVER (
            PARTITION BY d.department_id
            ORDER BY e.salary DESC
        ) AS salary_rank
    FROM Employees AS e
    JOIN Departments AS d
        ON d.department_id = e.department_id
)
SELECT
    employee_name,
    department_name,
    salary,
    salary_rank
FROM HighSalary
WHERE salary_rank = 1;

-- Q26. Compare each employee's salary with the previous hire in their department
SELECT
    e.employee_name,
    d.department_name,
    e.hire_date,
    e.salary,
    LAG(e.salary) OVER (
        PARTITION BY e.department_id
        ORDER BY e.hire_date
    ) AS previous_employees_salary,
    e.salary - LAG(e.salary) OVER (
        PARTITION BY e.department_id
        ORDER BY e.hire_date
    ) AS salary_difference
FROM Employees AS e
JOIN Departments AS d
    ON d.department_id = e.department_id;

-- Q27. Calculate each department's contribution to company salary expenditure
SELECT DISTINCT
    d.department_name,
    SUM(e.salary) OVER (
        PARTITION BY d.department_id
    ) AS depart_salary,
    SUM(e.salary) OVER () AS company_total_salary,
    ROUND(
        SUM(e.salary) OVER (PARTITION BY d.department_id)
        * 100.0 / SUM(e.salary) OVER (),
        2
    ) AS depart_salary_contribution
FROM Employees AS e
JOIN Departments AS d
    ON d.department_id = e.department_id;

-- Q28. Calculate employee performance improvement from 2024 to 2025
WITH DeptEmp AS (
    SELECT
        e.employee_id,
        e.employee_name,
        d.department_name
    FROM Employees AS e
    JOIN Departments AS d
        ON d.department_id = e.department_id
),
PerformanceChange AS (
    SELECT
        dp.employee_id,
        dp.employee_name,
        dp.department_name,
        pr.review_date,
        pr.performance_score AS current_score,
        LAG(pr.performance_score) OVER (
            PARTITION BY dp.employee_id
            ORDER BY pr.review_date
        ) AS previous_score
    FROM DeptEmp AS dp
    JOIN Performance_Reviews AS pr
        ON dp.employee_id = pr.employee_id
)
SELECT
    employee_name,
    department_name,
    previous_score AS score_2024,
    current_score AS score_2025,
    current_score - previous_score AS score_difference,
    ROUND(
        (current_score - previous_score) * 100.0
        / NULLIF(previous_score, 0),
        2
    ) AS percentage_improvement
FROM PerformanceChange
WHERE YEAR(review_date) = 2025
  AND current_score > previous_score;

-- ============================================================
-- END OF TAGGED SQL PRACTICE FILE
-- ============================================================
