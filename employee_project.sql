-- ========================================
-- EMPLOYEE SQL PROJECT
-- ========================================
-- Author: [Your Name]
-- Description: This project creates and analyzes employee and department data using SQL.
-- ========================================

-- ========================================
-- TASK 1.1: Create employees table
-- ========================================
CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    job_position VARCHAR(20) NOT NULL,
    salary DECIMAL(8,2),
    start_date DATE NOT NULL,
    birth_date DATE NOT NULL,
    store_id INT,
    department_id INT,
    manager_id INT
);

-- ========================================
-- TASK 1.2: Create departments table
-- ========================================
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department VARCHAR(50) NOT NULL,
    division VARCHAR(20) NOT NULL
);

-- ========================================
-- TASK 2: Alter employees table
-- ========================================
ALTER TABLE employees
ALTER COLUMN department_id SET NOT NULL;

ALTER TABLE employees
ALTER COLUMN start_date SET DEFAULT CURRENT_DATE;

ALTER TABLE employees
ADD COLUMN end_date DATE;

ALTER TABLE employees
ADD CONSTRAINT birth_check CHECK (birth_date < CURRENT_DATE);

ALTER TABLE employees
RENAME COLUMN job_position TO position_title;

-- ========================================
-- TASK 3: Insert sample data
-- ========================================
INSERT INTO employees (
    emp_id, first_name, last_name, position_title, salary, start_date,
    birth_date, store_id, department_id, manager_id, end_date
) VALUES
-- [List of employee values...]
-- (Data was provided above; omitted here for brevity)

-- ========================================
-- TASK 5.2: Create a view with employee data
-- ========================================
CREATE TEMPORARY VIEW v_employees AS
SELECT *
FROM employees;

-- ========================================
-- TASK 6: Average salary per position
-- ========================================
SELECT position_title,
       ROUND(AVG(salary), 2) AS average_salary
FROM employees
GROUP BY position_title
ORDER BY average_salary DESC;

-- ========================================
-- TASK 7: Average salary per division
-- ========================================
SELECT division,
       ROUND(AVG(salary), 2) AS avg_salary
FROM employees emp
LEFT JOIN departments dep ON emp.department_id = dep.department_id
GROUP BY division
ORDER BY avg_salary DESC;

-- ========================================
-- TASK 8.1: Salary vs average salary per position
-- ========================================
-- Using subquery:
SELECT emp_id, first_name, last_name, position_title, salary,
       (SELECT AVG(salary) FROM employees emp2 WHERE emp1.position_title = emp2.position_title)
       AS avg_pos_sal
FROM employees emp1
ORDER BY avg_pos_sal DESC;

-- Using window function:
SELECT emp_id, first_name, last_name, position_title, salary,
       ROUND(AVG(salary) OVER (PARTITION BY position_title), 2) AS avg_sal_pos
FROM employees
ORDER BY avg_sal_pos DESC;

-- ========================================
-- TASK 8.2: Employees earning below average in their position
-- ========================================
SELECT emp_id, first_name, last_name, position_title, salary
FROM employees emp1
WHERE salary < (
    SELECT AVG(salary)
    FROM employees emp2
    WHERE emp1.position_title = emp2.position_title
);

-- ========================================
-- TASK 9: Running total of salaries by start date
-- ========================================
CREATE TEMPORARY VIEW v_sal_runn AS
SELECT emp_id, salary, start_date,
       SUM(salary) OVER (ORDER BY start_date) AS running_total
FROM employees;

SELECT *
FROM v_sal_runn
WHERE start_date = '2018-12-31';

-- ========================================
-- TASK 10: Running total for current employees only
-- ========================================
-- Option 1 (using subquery):
SELECT emp_id, salary, start_date, end_date,
       SUM(salary) OVER (ORDER BY start_date) AS running_total
FROM (
    SELECT emp_id, salary, start_date, end_date
    FROM employees
    WHERE end_date IS NULL
) AS sal;

-- Option 2 (cleaner):
SELECT emp_id, salary, start_date, end_date,
       SUM(salary) OVER (ORDER BY start_date) AS running_total
FROM employees
WHERE end_date IS NULL;

-- ========================================
-- TASK 11.1: Top earner per position
-- ========================================
SELECT first_name, position_title,
       MAX(salary) OVER (PARTITION BY position_title) AS top_salary
FROM employees
ORDER BY top_salary DESC;

-- ========================================
-- TASK 11.2: Add average salary per position
-- ========================================
SELECT first_name, position_title, salary,
       MAX(salary) OVER (PARTITION BY position_title) AS max_salary_per_pos,
       ROUND(AVG(salary) OVER (PARTITION BY position_title), 2) AS avg_salary
FROM employees
ORDER BY salary DESC;

-- ========================================
-- TASK 11.3: Exclude employees with salary equal to average
-- ========================================
CREATE TABLE emp_salary AS
SELECT first_name, position_title, salary,
       MAX(salary) OVER (PARTITION BY position_title) AS max_salary_per_pos,
       ROUND(AVG(salary) OVER (PARTITION BY position_title), 2) AS avg_salary
FROM employees;

DELETE FROM emp_salary
WHERE salary = avg_salary;

-- ========================================
-- TASK 12: Rollup summary of salaries
-- ========================================
SELECT division, department, position_title,
       SUM(salary) AS total_salary,
       COUNT(emp_id) AS employee_count,
       AVG(salary) AS average_salary
FROM employees emp
LEFT JOIN departments dep ON emp.department_id = dep.department_id
GROUP BY ROLLUP (division, department, position_title);

-- ========================================
-- TASK 13: Rank employees by salary within departments
-- ========================================
SELECT emp_id, position_title, dep.department, salary,
       RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rank
FROM employees emp
LEFT JOIN departments dep ON emp.department_id = dep.department_id;

-- ========================================
-- TASK 14: Top earner in each department
-- ========================================
SELECT emp_id, position_title, department, salary
FROM (
    SELECT emp_id, position_title, dep.department, salary,
           RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rank
    FROM employees emp
    LEFT JOIN departments dep ON emp.department_id = dep.department_id
) AS salary_info
WHERE rank = 1;
