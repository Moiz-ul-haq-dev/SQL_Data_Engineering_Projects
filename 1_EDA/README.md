# 📊 Data Engineer Job Market Analysis | SQL

![Project Overview](./Images/1_1_Project1_EDA.png)

## About the Project

What skills are employers looking for in Data Engineers, which skills offer the highest salaries, and where is the best balance between job demand and earning potential?

This project explores the Data Engineer job market using SQL to analyze real-world job postings. By querying job posting and skills data, I explored hiring trends, salary distributions, and the technologies employers value most.

The goal was to go beyond simply retrieving data and use SQL to extract insights that can help guide career and skill development decisions.

---

## 🎯 Questions I Wanted to Answer

Through this analysis, I focused on three main questions:

- **Skill Demand:** Which technical skills appear most frequently in Data Engineer job postings?
- **Salary Potential:** Which skills are associated with the highest median salaries?
- **Career Priorities:** Which skills offer a strong balance between market demand and salary potential?

These questions form the basis of the three SQL analyses included in this project.

---

## 🗂️ Project Breakdown

| Analysis | Description |
|---|---|
| [01 - Top Demanded Skills](./1_EDA/01_Top_Demanded_Skills.sql) | Explores the 10 most frequently requested skills in remote Data Engineer jobs. |
| [02 - Top Paying Skills](./1_EDA/02_Top_HighPaying_Skills.sql) | Compares median salaries across skills and identifies the highest-paying ones with sufficient job demand. |
| [03 - Optimal Skills](./1_EDA/03_Optimal_Skills.sql) | Combines skill demand and median salary into a calculated score to rank skills based on both factors. |

---

## 🧱 Understanding the Data

The dataset is organized using a relational data warehouse structure, allowing job postings, companies, and skills to be analyzed through connected tables.

![Data Warehouse Schema](./Images/1_2_Data_Warehouse.png)

The analysis primarily uses the following tables:

- **`job_postings_fact`** – Contains job posting information, including job titles, salaries, work arrangements, and other job attributes.
- **`skills_dim`** – Stores skill names and related skill information.
- **`skills_job_dim`** – Connects job postings to their associated skills through a many-to-many relationship.
- **`company_dim`** – Contains company-related information.

By joining these tables, I was able to analyze individual skills across different job postings and compare their demand and salary metrics.

---

## 🛠️ Tools & Technologies

- **SQL** – Data exploration, filtering, aggregation, and analytical queries.
- **DuckDB** – Database engine used to query and analyze the job market dataset.
- **Visual Studio Code** – Writing, organizing, and executing SQL scripts.
- **Git & GitHub** – Version control and project documentation.

---

## 📈 Highlights from the Analysis

Some notable patterns explored throughout the project:

- **SQL & Python:** Among the most frequently requested skills in Data Engineer job postings.
- **Cloud Computing:** AWS, Azure, and GCP highlight the importance of cloud platforms in data infrastructure.
- **Data Processing:** Apache Spark, PySpark, and Kafka reflect the demand for large-scale data processing and distributed systems.
- **Data Orchestration:** Airflow appears frequently, emphasizing the importance of scheduling and managing data pipelines.
- **Infrastructure & Platforms:** Skills such as Terraform, Kubernetes, and Databricks offer insights into modern data engineering environments.

The project also explores how skills with fewer job postings can still offer competitive salary potential.

---

## 💡 SQL Techniques Applied

Throughout this project, I practiced and applied the following SQL concepts:

**Data Retrieval & Relationships**
- Multi-table `INNER JOIN` operations
- Fact, dimension, and bridge table relationships
- Table aliases for readable queries

**Data Analysis**
- `COUNT()`, `MEDIAN()`, and `ROUND()`
- `GROUP BY` and `HAVING`
- Filtering with multiple `WHERE` conditions
- Sorting and Top-N analysis using `ORDER BY` and `LIMIT`

**Advanced Calculations**
- Handling missing salary values using `IS NOT NULL`
- Natural logarithm using `LN()` to scale skill demand
- Creating calculated metrics to combine salary and demand
- Ranking skills using a custom scoring formula

---

## 📁 Repository Contents

```text
1_EDA/
│
├── 01_top_demanded_skills.sql
├── 02_top_paying_skills.sql
├── 03_optimal_skills.sql
├── README.md
│
└── Images/
    ├── 1_1_Project1_EDA.png
    └── 1_2_Data_Warehouse.png
```

---

## 📌 What I Learned

Working through this analysis helped me strengthen my understanding of SQL in a practical context, particularly how to connect relational tables, filter datasets, aggregate information, and derive metrics to answer specific questions.

It also gave me a better perspective on how job market data can be used to evaluate technical skills, compare salary opportunities, and make more informed decisions about what to learn next.

This project is part of my ongoing journey into Data Engineering, where I'm building practical skills through hands-on data analysis and SQL.