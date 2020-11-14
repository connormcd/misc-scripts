-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
col COLUMN_NAME format a30
col LOW_VALUE format a12 trunc
col high_value format a12 trunc
set verify off
set lines 120
select *
from dba_sys_privs
where 	grantee = nvl(upper('&user'),grantee)
order by 1,2;
