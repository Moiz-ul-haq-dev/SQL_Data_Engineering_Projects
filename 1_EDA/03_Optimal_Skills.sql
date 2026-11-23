/*

 OBJECTIVE

 Identify the top 25 optimal skills for remote Data Engineer
 jobs by combining median salary and job demand into a single
 score.

 Logarithmic demand is used to balance job demand and salary,
 helping identify skills that offer a strong combination of
 earning potential and market demand.

 */

select
  sd.skills,
--   count(jpf.salary_year_avg) as demand_count,
  ROUND(median(jpf.salary_year_avg), 0) as median_salary,
  ROUND(ln(count(jpf.salary_year_avg)), 1) as ln_demand_count,
  ROUND((ln(count(jpf.salary_year_avg)) * median(jpf.salary_year_avg)) / 1_000_000, 2)  as optimal_score
from
  job_postings_fact as jpf
  inner join skills_job_dim as sjd on jpf.job_id = sjd.job_id
  inner join skills_dim as sd on sjd.skill_id = sd.skill_id
where
  jpf.job_title_short = 'Data Engineer'
  and jpf.job_work_from_home = true
  and jpf.salary_year_avg is not null
group by
  sd.skills
having
  count(jpf.*) > 100
order by
  optimal_score desc
limit
  25;


/*

 KEY NOTES & OBSERVATIONS

 The query considers only remote Data Engineer job postings
 with non-null annual salaries.

 Median salary represents the typical earning potential
 associated with each skill.

 ln_demand_count uses the natural logarithm (ln) of the
 number of job postings to reduce the impact of very high
 demand counts.

 optimal_score combines logarithmic demand and median salary,
 allowing skills to be ranked based on both factors rather
 than salary or demand alone.

 Terraform ranks first with an optimal score of 0.97,
 followed by Python (0.95), AWS (0.91), and SQL (0.91).

 Python and SQL have relatively high demand, while Terraform
 combines a high median salary with strong job demand.

 A minimum threshold of more than 100 job postings is used
 to exclude skills with limited representation.


*/


/*

 QUERY RESULTS

 ┌────────────┬───────────────┬─────────────────┬───────────────┐
 │   skills   │ median_salary │ ln_demand_count │ optimal_score │
 │  varchar   │    double     │     double      │    double     │
 ├────────────┼───────────────┼─────────────────┼───────────────┤
 │ terraform  │      184000.0 │             5.3 │          0.97 │
 │ python     │      135000.0 │             7.0 │          0.95 │
 │ aws        │      137320.0 │             6.7 │          0.91 │
 │ sql        │      130000.0 │             7.0 │          0.91 │
 │ airflow    │      150000.0 │             6.0 │          0.89 │
 │ spark      │      140000.0 │             6.2 │          0.87 │
 │ snowflake  │      135500.0 │             6.1 │          0.82 │
 │ kafka      │      145000.0 │             5.7 │          0.82 │
 │ azure      │      128000.0 │             6.2 │          0.79 │
 │ java       │      135000.0 │             5.7 │          0.77 │
 │ scala      │      137290.0 │             5.5 │          0.76 │
 │ git        │      140000.0 │             5.3 │          0.75 │
 │ kubernetes │      150500.0 │             5.0 │          0.75 │
 │ databricks │      132750.0 │             5.6 │          0.74 │
 │ redshift   │      130000.0 │             5.6 │          0.73 │
 │ gcp        │      136000.0 │             5.3 │          0.72 │
 │ nosql      │      134415.0 │             5.3 │          0.71 │
 │ hadoop     │      135000.0 │             5.3 │          0.71 │
 │ pyspark    │      140000.0 │             5.0 │           0.7 │
 │ mongodb    │      135750.0 │             4.9 │          0.67 │
 │ docker     │      135000.0 │             5.0 │          0.67 │
 │ go         │      140000.0 │             4.7 │          0.66 │
 │ r          │      134775.0 │             4.9 │          0.66 │
 │ github     │      135000.0 │             4.8 │          0.65 │
 │ bigquery   │      135000.0 │             4.8 │          0.65 │
 └────────────┴───────────────┴─────────────────┴───────────────┘
  25 rows                                            4 columns

*/