-- Aggregate: count all rows in the table as one overall result.
select
  count(*)
from
  job_postings_fact;


-- Window count: count all table rows while preserving every job_id row.
select
  job_id,
  count(*) over ()
from
  job_postings_fact;


-- Partition average: calculate the average hourly salary for each job title and company.
select
  job_id,
  job_title_short,
  company_id,
  salary_hour_avg,
  AVG(salary_hour_avg) over (partition by job_title_short, company_id)
from
  job_postings_fact
where
  salary_hour_avg is not null
order by
  random()
limit
  10;


-- Ranking: rank rows by hourly salary in descending order across all job postings.
select
  job_id,
  job_title_short,
  salary_hour_avg,
  RANK() OVER (
    ORDER BY
      salary_hour_avg desc
  )
from
  job_postings_fact
where
  salary_hour_avg is not null -- order by
  --   salary_hour_avg desc
limit
  10;


-- Running average: calculate each Data Engineer's cumulative average hourly salary over time.
select
  job_posted_date,
  job_title_short,
  salary_hour_avg,
  AVG(salary_hour_avg) over (
    partition by job_title_short
    order by
      job_posted_date
  ) as running_avg_hourly_by_title
from
  job_postings_fact
where
  salary_hour_avg is not null and job_title_short = 'Data Engineer'
order by
  job_title_short,
  job_posted_date
limit
  10;


-- Partitioned ranking: rank salaries from highest to lowest within each job title.
select
  job_id,
  job_title_short,
  salary_hour_avg,
  RANK() OVER (
    partition by job_title_short
    ORDER BY
      salary_hour_avg desc
  )
from
  job_postings_fact
where
  salary_hour_avg is not null 
  order by
    salary_hour_avg desc,
    job_title_short
limit
  10;