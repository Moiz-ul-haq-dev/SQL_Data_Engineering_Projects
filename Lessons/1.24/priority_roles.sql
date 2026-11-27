/*
  PIPELINE STEP 1: DEFINE WHICH JOB ROLES ARE PRIORITY ROLES

  data_jobs.job_postings_fact provides the source job postings.
  This table acts as a small lookup (dimension) that maps a role name to a
  priority level. priority_jobs_snapshot.sql joins this lookup to the source
  data before it updates or inserts rows.
*/

-- Create/recreate the lookup table in the staging schema.
create or replace table
  staging.priority_roles(
    role_id integer primary key,
    role_name varchar,
    priority_lvl integer
  );


-- Seed the lookup with the roles and priority levels used by the pipeline.
-- Priority level 1 is the highest-priority level in this example.
insert into
  staging.priority_roles(role_id, role_name, priority_lvl)
values
  (1, 'Data Engineer', 2),
  (2, 'Senior Data Engineer', 1),
  (3, 'Software Engineer', 3);

-- Preview the lookup to verify its role-name values and priority levels.
select *
from staging.priority_roles;