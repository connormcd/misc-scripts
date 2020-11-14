-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
select 'DIFFERING COLUMNS', p.table_Name, p.column_name
from 
 (
   ( select table_name, column_name from dba_tab_columns
     where owner = 'SCHEMA1'
     minus
     select table_name, column_name from dba_tab_columns
     where owner = 'SCHEMA2' )
   union all
   ( select table_name, column_name from dba_tab_columns
     where owner = 'SCHEMA2'
     minus
     select table_name, column_name from dba_tab_columns
     where owner = 'SCHEMA1' )
 ) p,
 ( select d1.table_name
   from dba_tables d1,
        dba_tables d2
   where d1.owner = 'SCHEMA1'
   and   d2.owner = 'SCHEMA2'
   and   d1.table_name = d2.table_name ) q
where p.table_name = q.table_name
union all
select 'IN SCHEMA1, NOT IN SCHEMA2', table_name, null
from 
( select table_name from dba_tables
  where owner = 'SCHEMA1'
  minus
  select table_name from dba_tables
  where owner = 'SCHEMA2' )
union all
select 'IN SCHEMA2, NOT IN SCHEMA1', table_name, null
from 
( select table_name from dba_tables
  where owner = 'SCHEMA2'
  minus
  select table_name from dba_tables
  where owner = 'SCHEMA1' )
