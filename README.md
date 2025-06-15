# Employee Database Analysis Project

![SQL](https://img.shields.io/badge/SQL-PostgreSQL-blue)
![License](https://img.shields.io/badge/License-MIT-green)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen)

Comprehensive SQL project for managing and analyzing employee and department data. Features schema design, data manipulation, and advanced analytical queries.

## Project Overview

This project demonstrates:
- Database schema design with constraints
- Data manipulation operations
- Advanced SQL techniques (window functions, CTEs, subqueries)
- Analytical queries for business insights
- Performance optimization approaches

## Database Schema

### Employees Table
```sql
CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    position_title VARCHAR(20) NOT NULL,
    salary DECIMAL(8,2),
    start_date DATE NOT NULL DEFAULT CURRENT_DATE,
    birth_date DATE NOT NULL,
    store_id INT,
    department_id INT NOT NULL,
    manager_id INT,
    end_date DATE,
    CONSTRAINT birth_check CHECK (birth_date < CURRENT_DATE)
);

CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department VARCHAR(50) NOT NULL,
    division VARCHAR(20) NOT NULL
);

Relationship: Employees belong to departments (one-to-many)

Key Features:

1. Data Analysis

    - Salary distribution by position and division

    - Employee comparison to position averages

    - Departmental salary rankings

    - Running salary totals

2. Advanced SQL Techniques

    - Window functions for rankings and aggregates

    - Common Table Expressions (CTEs)

    - Subqueries for comparative analysis

    - ROLLUP for multi-level summaries

3. Data Management

    - Constraints for data integrity

    - Temporary views for analysis

    - Derived tables for complex reporting

    - Schema optimization techniques

SQL Query Highlights:

- Salary Analysis by Position:

SELECT position_title,
       ROUND(AVG(salary), 2) AS average_salary
FROM employees
GROUP BY position_title
ORDER BY average_salary DESC;

SELECT emp_id, first_name, last_name, position_title, salary
FROM employees emp1
WHERE salary < (
    SELECT AVG(salary)
    FROM employees emp2
    WHERE emp1.position_title = emp2.position_title
);

SELECT emp_id, position_title, dep.department, salary,
       RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rank
FROM employees emp
LEFT JOIN departments dep ON emp.department_id = dep.department_id;

SELECT division, department, position_title,
       SUM(salary) AS total_salary,
       COUNT(emp_id) AS employee_count,
       AVG(salary) AS average_salary
FROM employees emp
LEFT JOIN departments dep ON emp.department_id = dep.department_id
GROUP BY ROLLUP (division, department, position_title);

Getting Started:

Prerequisites:

    - PostgreSQL 12+

    - Basic SQL knowledge

Installation:

1. Clone repository

  git clone https://github.com/baktash-data/employee-sql-project.git

2. Create database:

  createdb employee_db

3. Run schema setup:

  psql -d employee_db -f schema.sql

4. Load sample data:

  psql -d employee_db -f data_load.sql

Running Queries

Execute analytical queries:

  psql -d employee_db -f analysis_queries.sql

Sample Outputs

Salary by Division:

division     | avg_salary
-------------+------------
Corporate    | 105000.00
Technology   | 85000.00
HR           | 65000.00

Top Earners by Department:

emp_id | position_title       | department  | salary
-------+----------------------+-------------+---------
102    | Chief Technology Officer | Technology | 150000.00
205    | HR Director          | HR          | 95000.00

employee-sql-project/

├── schema.sql            # Database schema definition
├── data_load.sql         # Sample data insertion
├── analysis_queries.sql  # All analytical queries
├── views.sql             # Database views
├── README.md             # Project documentation
└── .gitignore            # Ignore unnecessary files

Contributing

Contributions welcome! Please:

    Fork the repository

    Create your feature branch (git checkout -b feature/improvement)

    Commit your changes (git commit -am 'Add new feature')

    Push to the branch (git push origin feature/improvement)

    Open a pull request

License

Distributed under the MIT License. See LICENSE for more information.

Created by Baktash Hamidi
View my GitHub profile https://github.com/Baktash-data/





