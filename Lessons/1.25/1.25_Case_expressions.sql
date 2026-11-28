select
  job_title_short,
  salary_hour_avg,
  CASE
    WHEN salary_hour_avg < 25 then 'Low'
    when salary_hour_avg < 50 then 'Medium'
    else 'High'
  end as salary_category
from
  job_postings_fact
where
  salary_hour_avg is not null
limit
  10;


select
  job_title_short,
  salary_hour_avg,
  CASE
    when salary_hour_avg is null then 'Missing'
    WHEN salary_hour_avg < 25 then 'Low'
    when salary_hour_avg < 50 then 'Medium'
    else 'High'
  end as salary_category
from
  job_postings_fact -- where
  --   salary_hour_avg is not null
limit
  10;


select
  job_title,
  Case
    when job_title like '%Data%'
    and job_title like '%Analyst%' then 'Data Analyst'
    when job_title like '%Data%'
    and job_title like '%Engineer%' then 'Data Engineer'
    when job_title like '%Data%'
    and job_title like '%Scientist%' then 'Data Scientist'
    else 'Other'
  end as job_title_category,
  job_title_short
from
  job_postings_fact
order by
  random()
limit
  20;


select
  job_title_short,
  count(*) as total_postings,
  median(
    case
      when salary_year_avg < 100000 then salary_year_avg
    end
  ) as median_low_salaries,
  median(
    case
      when salary_year_avg >= 100000 then salary_year_avg
    end
  ) as median_high_salaries
from
  job_postings_fact
where
  salary_year_avg is not null
group by
  job_title_short;


select
  job_title_short,
  salary_hour_avg,
  salary_year_avg,
  case
    when salary_year_avg is not null then salary_year_avg
    when salary_hour_avg is not null then salary_hour_avg * 2080
  end as standardized_salary
from
  job_postings_fact
where
  salary_year_avg is not null
  or salary_hour_avg is not null
limit
  10;


with
  salaries as (
    select
      job_title_short,
      salary_hour_avg,
      salary_year_avg,
      case
        when salary_year_avg is not null then salary_year_avg
        when salary_hour_avg is not null then salary_hour_avg * 2080
      end as standardized_salary
    from
      job_postings_fact -- where
      --   salary_year_avg is not null or salary_hour_avg is not null
  )
select
  *,
  case
    when standardized_salary is null then 'Missing'
    when standardized_salary < 75000 then 'Low'
    when standardized_salary < 150000 then 'Medium'
    else 'High'
  end as salary_bucket
from salaries
-- order by standardized_salary
limit 10;