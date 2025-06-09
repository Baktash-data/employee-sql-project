# 💼 Employee SQL Project

This project showcases a series of SQL tasks to build and analyze employee and department data using **PostgreSQL**. It demonstrates database design, data transformation, and advanced SQL queries.

---

## 📁 Project Structure

```
employee_project/
│
├── schema/     -- Scripts to create tables, define constraints, and insert initial data
├── views/      -- SQL views to organize and summarize information
└── queries/    -- Analytical queries using aggregates, window functions, and grouping
```

---

## 🛠️ Key Features

- 🧱 **Table creation and normalization**
- ✅ **Constraints and data validation**
- 🗃️ **Data insertion and seeding**
- 🔍 **View creation for reporting**
- 📊 **Aggregate functions and grouping**
- 🪟 **Window functions** (e.g., `RANK`, `SUM OVER`)
- 🔄 **ROLLUP and advanced grouping**
- 🔎 **Dynamic filtering based on aggregates**

---

## 📦 Requirements

- **PostgreSQL** (or any compatible SQL engine)
- SQL client of your choice:
  - [DBeaver](https://dbeaver.io/)
  - [pgAdmin](https://www.pgadmin.org/)
  - Command line (`psql`)

---

## 📈 Sample Query: Average Salary by Position

```sql
SELECT position_title,
       ROUND(AVG(salary), 2) AS average_salary
FROM employees
GROUP BY position_title
ORDER BY average_salary DESC;
```

---

## 🚀 How to Use

1. Set up a PostgreSQL database.
2. Run the scripts inside the `schema/` folder to create tables and insert data.
3. Explore the views and analytical queries.
4. Modify or extend queries based on your use case.
