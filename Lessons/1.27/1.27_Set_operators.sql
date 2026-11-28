-- UNION combines both result sets and removes duplicate rows.
select
  unnest([1, 1, 1, 2])
union
select
  unnest([1, 1, 3]);


-- UNION ALL combines both result sets and keeps every duplicate row.
select
  unnest([1, 1, 1, 2])
union all
select
  unnest([1, 1, 3]);


-- INTERSECT returns only distinct rows that exist in both result sets.
select
  unnest([1, 1, 1, 2])
intersect
select
  unnest([1, 1, 3]);


-- INTERSECT ALL returns matching rows with the smaller number of duplicates from both result sets.
select
  unnest([1, 1, 1, 2])
intersect all
select
  unnest([1, 1, 3]);


-- EXCEPT returns distinct rows that exist in the first result set but not the second.
select
  unnest([1, 1, 1, 2])
except
select
  unnest([1, 1, 3]);


-- EXCEPT ALL removes one matching row from the first result set for each matching duplicate in the second.
select
  unnest([1, 1, 1, 2])
except all
select
  unnest([1, 1, 3]);


create temp table jobs_2023 as
select
  * exclude (job_id, job_posted_date)
from
  job_postings_fact
where
  extract(
    year
    from
      job_posted_date
  ) = 2023;


-- Select all job records created for 2023.
select
  *
from
  jobs_2023;


create temp table jobs_2024 as
select
  * exclude (job_id, job_posted_date)
from
  job_postings_fact
where
  extract(
    year
    from
      job_posted_date
  ) = 2024;


-- Select all job records created for 2024.
select
  *
from
  jobs_2024;


-- UNION returns all distinct job records found in 2023 or 2024.
select
  *
from
  jobs_2023
union
select
  *
from
  jobs_2024;

-- UNION combines the record counts from both years into distinct table_name rows.
select
  'jobs_2023' as table_name,
  count(*) as record_count
from
  jobs_2023
union
select
  'jobs_2024' as table_name,
  count(*) as record_count
from
  jobs_2024;


-- UNION ALL combines all 2023 and 2024 job records, keeping duplicates.
select
  *
from
  jobs_2023
union all
select
  *
from
  jobs_2024;

-- EXCEPT returns distinct 2023 job records that do not appear in 2024.
select
  *
from
  jobs_2023
except
select
  *
from
  jobs_2024;

-- EXCEPT ALL removes matching 2024 duplicates from the 2023 result, preserving unmatched 2023 duplicates.
select
  *
from
  jobs_2023
except all
select
  *
from
  jobs_2024;

-- INTERSECT returns distinct job records that appear in both 2023 and 2024.
select
  *
from
  jobs_2023
intersect
select
  *
from
  jobs_2024;

-- INTERSECT ALL returns duplicate matching job records using the smaller duplicate count found in 2023 and 2024.
select
  *
from
  jobs_2023
intersect all
select
  *
from
  jobs_2024;