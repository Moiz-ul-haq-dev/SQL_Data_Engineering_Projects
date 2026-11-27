/*
  PIPELINE INITIAL/ONE-TIME LOAD

  Run this file after priority_roles.sql.

  Flow:
    1. priority_roles.sql creates staging.priority_roles.
    2. This file joins that lookup to the source job-posting data.
    3. The join creates the first complete copy of priority jobs in
       main.priority_jobs_snapshot.

  Use this file for initial setup or to rebuild the snapshot from scratch.
  For later recurring refreshes, use priority_jobs_snapshot.sql instead.
*/

-- Create or replace the destination table.
-- This resets any existing snapshot and defines the stored columns.

create
or replace table main.priority_jobs_snapshot (
  job_id integer primary key,
  job_title_short varchar,
  company_name varchar,
  jobs_posted_date timestamp,
  salary_year_avg double,
  priority_lvl integer,
  updated_at timestamp
);


-- Read source jobs and insert only roles found in staging.priority_roles.
-- The result also stores company name, salary, priority level and refresh time.

insert into
  main.priority_jobs_snapshot (
    job_id,
    job_title_short,
    company_name,
    jobs_posted_date,
    salary_year_avg,
    priority_lvl,
    updated_at
  )
select
  jpf.job_id,
  jpf.job_title_short,
  cd.name,
  jpf.job_posted_date,
  jpf.salary_year_avg,
  r.priority_lvl,
  current_timestamp
from
  data_jobs.job_postings_fact as jpf
  left join data_jobs.company_dim as cd on jpf.company_id = cd.company_id
  inner join staging.priority_roles as r on jpf.job_title_short = r.role_name;


-- Verify the initial load by summarizing jobs by role.
-- updated_at shows when the snapshot records were last refreshed.

select
  job_title_short,
  count(*) as job_count,
  min(priority_lvl) as priority_lvl,
  min(updated_at) as updated_at
from
  main.priority_jobs_snapshot
group by
  job_title_short
order by
  job_count desc;