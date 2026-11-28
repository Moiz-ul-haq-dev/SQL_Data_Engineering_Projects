select
  job_posted_date,
  job_posted_date:: date as date,
  job_posted_date:: time as time,
  job_posted_date:: timestamp as timestamp,
  job_posted_date:: timestamptz as timestamptz
from
  job_postings_fact
limit
  10;


select
  extract(
    year
    from
      job_posted_date
  ) as job_posted_year,
  extract(
    month
    from
      job_posted_date
  ) as job_posted_month,
  count (job_id) as job_count,
  --   extract(
  --     day
  --     from
  --       job_posted_date
  --   ) as job_posted_day
from
  job_postings_fact
where
  job_title_short = 'Data Engineer'
Group by
  extract(
    year
    from
      job_posted_date
  ),
  extract(
    month
    from
      job_posted_date
  )
order by
  job_posted_year,
  job_posted_month;


select
  Date_Trunc('month', job_posted_date) as job_posted_month,
  count (job_id) as job_count
from
  job_postings_fact
where
  job_title_short = 'Data Engineer'
  and extract(
    year
    from
      job_posted_date
  ) = 2024
Group by
  Date_Trunc('month', job_posted_date)
order by
  job_posted_month;


select
  '2026-11-28 00:00:00+00':: timestamptz at time zone 'pst';


select
  job_title_short,
  job_location,
  job_posted_date at time zone 'utc' at time zone 'est'
from
  job_postings_fact
where
  job_location like 'New York, NY';


select
  extract(
    hour
    from
      job_posted_date at time zone 'utc' at time zone 'est'
  ) as job_posted_hour,
  count(job_id)
from
  job_postings_fact
where
  job_location like 'New York, NY'
Group by
  extract(
    hour
    from
      job_posted_date at time zone 'utc' at time zone 'est'
  )
order by
  job_posted_hour;