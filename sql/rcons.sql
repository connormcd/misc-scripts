-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
set verify off
select  table_name, constraint_name, ( select table_name from dba_constraints
                                       where constraint_name = d.r_constraint_name
                                       and owner = d.r_owner ) r_table, status
from 	dba_constraints d
where (r_owner,r_constraint_name) in 
  ( select owner, constraint_name
    from   dba_constraints
    where  table_name = upper('&table_name_req')
    and constraint_type in ('P','U')
  );
