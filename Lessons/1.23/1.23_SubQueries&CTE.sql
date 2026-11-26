select
  *
from
  (
    select
      *
    from
      staging.job_postings_flat
    where
      salary_year_avg is not null
      or salary_hour_avg is not null
  ) as valid_salaries
limit
  10;


with
  valid_salaries as (
    select
      *
    from
      staging.job_postings_flat
    where
      salary_year_avg is not null
      or salary_hour_avg is not null
  )
select
  *
from
  valid_salaries;


-- Show each job's annual salary alongside the overall market median.
select
  job_title_short,
  salary_year_avg,
  (
    select
      median(salary_year_avg)
    from
      job_postings_fact
  ) as market_median_salary
from
  job_postings_fact
where
  salary_year_avg is not null
limit
  10;


-- Calculate the median salary for each remote job title and show the overall remote-job median.
select
  job_title_short,
  median(salary_year_avg) as median_salary_per_remote_job,
  (
    select
      median(salary_year_avg)
    from
      job_postings_fact
      where job_work_from_home = true
  ) as market_median_salary
from
  (
    select
      job_title_short,
      salary_year_avg
    from
      job_postings_fact
    where
      job_work_from_home = true
) as clean_jobs
where
  salary_year_avg is not null
group by
  job_title_short
limit
  10;


-- Return remote job titles whose median salary is above the overall remote-job median.
select
  job_title_short,
  median(salary_year_avg) as median_salary_per_remote_job,
  (
    select
      median(salary_year_avg)
    from
      job_postings_fact
      where job_work_from_home = true
  ) as market_median_salary
from
  (
    select
      job_title_short,
      salary_year_avg
    from
      job_postings_fact
    where
      job_work_from_home = true
) as clean_jobs
where
  salary_year_avg is not null
group by
  job_title_short
having median(salary_year_avg) > (
    select
      median(salary_year_avg)
    from
      job_postings_fact
      where job_work_from_home = true
)
limit
  10;