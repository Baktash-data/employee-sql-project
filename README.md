# Employee SQL Project

This project contains a series of SQL tasks to build and analyze employee and department data using PostgreSQL.

## 📁 Structure

- `schema/`: Scripts to create and alter tables and insert initial data.
- `views/`: Views to summarize and analyze data.
- `queries/`: Analytical queries to compute average salaries, ranks, and rollups.

## 🛠️ Tasks Covered

- Table creation and data normalization
- Constraints and data validation
- Data insertion
- Views creation
- Aggregate analysis
- Window functions (RANK, SUM OVER, etc.)
- ROLLUP and grouping
- Filtering based on dynamic aggregates

## 📦 Requirements

- PostgreSQL or compatible SQL database engine
- Any SQL client (e.g., DBeaver, pgAdmin)

## 📈 Sample Query: Average Salary by Position

```sql
SELECT position_title,
       ROUND(AVG(salary),2) AS average_salary
FROM employees
GROUP BY position_title
ORDER BY average_salary DESC;
