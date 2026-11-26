-- describe
-- drop table
--   if exists staging.job_postings_flat;
create
or replace table staging.job_postings_flat as
select
  job_id,
  job_title_short,
  job_location,
  job_schedule_type,
  job_posted_date,
  search_location,
  job_no_degree_mention,
  job_country,
  salary_year_avg,
  salary_hour_avg,
  -- company_id,
  link,
  thumbnail,
  cd.name
from
  data_jobs.job_postings_fact as jpf
  left join data_jobs.company_dim as cd on jpf.company_id = cd.company_id;


-- limit
--   10;
select
  *
from
  staging.job_postings_flat
limit
  10;


select
  count(*)
from
  staging.job_postings_flat;


select
  *
from
  staging.priority_roles;


update
  staging.priority_roles
set
  role_name = 'Data Engineer'
where
  role_id = 1;


-- drop view if exists staging.priority_jobs_flat_view;
create
or replace view staging.priority_jobs_flat_view as
select
  jpf.*
from
  staging.job_postings_flat as jpf
  join staging.priority_roles as r on jpf.job_title_short = r.role_name
where
  r.priority_lvl = 1;


-- limit 10;
select
  job_title_short,
  count(*) as job_count
from
  staging.priority_jobs_flat_view
group by
  job_title_short
order by
  job_count desc;


-- limit 10;
-- drop table if exists senior_jobs_flat_temp;
create or replace temporary table senior_jobs_flat_temp as
select
  *
from
  staging.priority_jobs_flat_view
where
  job_title_short = 'Senior Data Engineer';


select
  job_title_short,
  count(*) as job_count
from
  senior_jobs_flat_temp
group by
  job_title_short
order by
  job_count desc;

select count(*) from staging.job_postings_flat;
select count(*) from staging.priority_jobs_flat_view;
select count(*) from senior_jobs_flat_temp;

delete from staging.job_postings_flat
where job_posted_date < '2024-01-01';

select count(*) from staging.job_postings_flat;
select count(*) from staging.priority_jobs_flat_view;
select count(*) from senior_jobs_flat_temp;