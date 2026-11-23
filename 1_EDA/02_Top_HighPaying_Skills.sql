/*

 OBJECTIVE

 Identify the top 25 highest-paying skills for remote Data Engineer
 jobs, using median annual salary, while only considering skills
 appearing in more than 100 job postings.

 This analysis helps identify skills that offer a strong combination
 of market demand and earning potential.

 */

select
  sd.skills,
  count(jpf.*) as demand_count,
  round(median(jpf.salary_year_avg), 0) as median_salary
from
  job_postings_fact as jpf
  inner join skills_job_dim as sjd on jpf.job_id = sjd.job_id
  inner join skills_dim as sd on sjd.skill_id = sd.skill_id
where
  jpf.job_title_short = 'Data Engineer'
  and jpf.job_work_from_home = true
group by
  sd.skills
having
  count(jpf.*) > 100
order by
  median_salary desc
limit
  25;


/*

 KEY NOTES & OBSERVATIONS

 Median salary represents the middle salary value for job postings
 associated with each skill, making it less affected by unusually
 high or low salaries than an average.

 HAVING filters aggregated results, retaining only skills appearing
 in more than 100 job postings.

 The results are sorted by median salary rather than demand,
 highlighting higher-paying skills first.

 Rust has the highest median salary ($210,000), followed by Golang
 and Terraform ($184,000).

 Some skills combine strong demand with high median salaries.
 For example, Airflow has 9,996 job postings with a median salary
 of $150,000, while Kubernetes has 4,202 postings with a median
 salary of $150,500.

 Skills with fewer than 101 job postings are excluded from this analysis.

*/


/*

 QUERY RESULTS

 ┌────────────┬──────────────┬───────────────┐
 │   skills   │ demand_count │ median_salary │
 │  varchar   │    int64     │    double     │
 ├────────────┼──────────────┼───────────────┤
 │ rust       │          232 │      210000.0 │
 │ golang     │          912 │      184000.0 │
 │ terraform  │         3248 │      184000.0 │
 │ spring     │          364 │      175500.0 │
 │ neo4j      │          277 │      170000.0 │
 │ gdpr       │          582 │      169616.0 │
 │ zoom       │          127 │      168438.0 │
 │ graphql    │          445 │      167500.0 │
 │ mongo      │          265 │      162250.0 │
 │ fastapi    │          204 │      157500.0 │
 │ django     │          265 │      155000.0 │
 │ bitbucket  │          478 │      155000.0 │
 │ crystal    │          129 │      154224.0 │
 │ atlassian  │          249 │      151500.0 │
 │ c          │          444 │      151500.0 │
 │ typescript │          388 │      151000.0 │
 │ kubernetes │         4202 │      150500.0 │
 │ css        │          262 │      150000.0 │
 │ airflow    │         9996 │      150000.0 │
 │ ruby       │          736 │      150000.0 │
 │ node       │          179 │      150000.0 │
 │ redis      │          605 │      149000.0 │
 │ vmware     │          136 │      148798.0 │
 │ ansible    │          475 │      148798.0 │
 │ jupyter    │          400 │      147500.0 │
 └────────────┴──────────────┴───────────────┘
  25 rows                         3 columns

*/