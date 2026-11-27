/*
 PIPELINE RECURRING REFRESH
 
 Run in this order:
 1. priority_roles.sql       - maintains the priority-role lookup
 2. priority_jobs_snapshot.sql - refreshes the destination snapshot
 
 This file performs a merge without recreating the table:
 - UPDATE changes rows that already exist and need new values
 - INSERT adds source rows that do not exist in the snapshot
 - DELETE removes snapshot rows that are no longer in the source result
 
 The snapshot therefore stays in sync with the source while preserving
 main.priority_jobs_snapshot as a persistent table.
 */
-- Build the latest expected snapshot in memory.
-- src_priority_jobs is the source of truth for this refresh:
--   job facts + company names + matching priority-role information.
create
or replace temp table src_priority_jobs as
select
  jpf.job_id,
  jpf.job_title_short,
  cd.name,
  jpf.job_posted_date,
  jpf.salary_year_avg,
  r.priority_lvl,
  current_timestamp as updated_at
from
  data_jobs.job_postings_fact as jpf
  left join data_jobs.company_dim as cd on jpf.company_id = cd.company_id
  inner join staging.priority_roles as r on jpf.job_title_short = r.role_name;


-- UPDATE existing rows when their priority level changed.
-- Matching is performed by job_id; updated_at records the refresh timestamp.
-- update
--   main.priority_jobs_snapshot as tgt
-- set
--   priority_lvl = src.priority_lvl,
--   updated_at = src.updated_at
-- from
--   src_priority_jobs as src
-- where
--   src.job_id = tgt.job_id
--   and tgt.priority_lvl is distinct from src.priority_lvl;
-- -- INSERT source rows whose job_id is not yet in the snapshot.
-- insert into
--   main.priority_jobs_snapshot (
--     job_id,
--     job_title_short,
--     company_name,
--     jobs_posted_date,
--     salary_year_avg,
--     priority_lvl,
--     updated_at
--   )
-- select
--   src.job_id,
--   src.job_title_short,
--   src.name,
--   src.job_posted_date,
--   src.salary_year_avg,
--   src.priority_lvl,
--   src.updated_at
-- from
--   src_priority_jobs as src
-- where
--   not exists(
--     select
--       1
--     from
--       main.priority_jobs_snapshot as tgt
--     where
--       tgt.job_id = src.job_id
--   );
-- -- DELETE snapshot rows that no longer exist in the latest source result.
-- -- This can remove a job or a role that stopped matching priority_roles.
-- delete from
--   main.priority_jobs_snapshot as tgt
-- where
--   not exists(
--     select
--       1
--     from
--       src_priority_jobs as src
--     where
--       tgt.job_id = src.job_id
--   );
MERGE INTO main.priority_jobs_snapshot as tgt 
using src_priority_jobs as src 
on tgt.job_id = src.job_id

    when matched and tgt.priority_lvl is distinct from src.priority_lvl then
    update
    set
    priority_lvl = src.priority_lvl,
    updated_at = src.updated_at

    when not matched then 
    insert (
    job_id,
    job_title_short,
    company_name,
    jobs_posted_date,
    salary_year_avg,
    priority_lvl,
    updated_at
    )
    values
    (
        src.job_id,
        src.job_title_short,
        src.name,
        src.job_posted_date,
        src.salary_year_avg,
        src.priority_lvl,
        src.updated_at
    ) 

    when not matched by source then delete;

-- Verify the refreshed snapshot by summarizing remaining jobs by role.
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