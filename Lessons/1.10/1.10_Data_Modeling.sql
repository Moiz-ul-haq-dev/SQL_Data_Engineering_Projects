select * 
from information_schema.tables
where table_catalog = 'data_jobs';

select constraint_name, constraint_type, table_name 
from information_schema.table_constraints
where table_catalog = 'data_jobs';