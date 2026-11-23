/*
 
 OBJECTIVE
 
 Identify the top 10 most in-demand skills for remote Data
 Engineer jobs by counting how frequently each skill appears
 across remote Data Engineer job postings.
 
 This analysis helps understand which technical skills are
 most commonly required in remote Data Engineering roles.
 
 */


select
  sd.skills,
  count(jpf.*) as demand_count
from
  job_postings_fact as jpf
  inner join skills_job_dim as sjd on jpf.job_id = sjd.job_id
  inner join skills_dim as sd on sjd.skill_id = sd.skill_id
where
  jpf.job_title_short = 'Data Engineer'
  and jpf.job_work_from_home = true
group by
  sd.skills
order by
  demand_count desc
limit
  10;


/* 

 KEY NOTES & OBSERVATIONS


 A single job posting can require multiple skills. 
 Therefore, one job can contribute to the demand count
 of several different skills.

 demand_count represents the number of job postings
 associated with a skill, not the number of candidates
 possessing that skill.

 The analysis focuses exclusively on remote Data Engineer
 positions, so the results may differ from onsite or
 hybrid job postings.

 The results can help identify market-demanded skills
 and prioritize learning accordingly.

*/

/*

 QUERY RESULTS

 ┌────────────┬──────────────┐
 │   skills   │ demand_count │
 │  varchar   │    int64     │
 ├────────────┼──────────────┤
 │ sql        │        29221 │
 │ python     │        28776 │
 │ aws        │        17823 │
 │ azure      │        14143 │
 │ spark      │        12799 │
 │ airflow    │         9996 │
 │ snowflake  │         8639 │
 │ databricks │         8183 │
 │ java       │         7267 │
 │ gcp        │         6446 │
 └────────────┴──────────────┘
   10 rows         2 columns

*/