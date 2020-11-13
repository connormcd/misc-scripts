-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
select *
from (
select owner, table_name, blocks
from dba_tables
where owner not in (
  select username 
  from dba_users
  where oracle_maintained = 'Y' )
and blocks is not null  
order by blocks desc
)
where rownum <= 20;
