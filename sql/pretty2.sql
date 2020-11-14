-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
set timing off head off termout off

set verify off
set long 32767
set lines 32767
set longchunksize 32767

select sql_fulltext
from v$sql 
where sql_id = '&1'
and rownum = 1;

spool c:/tmp/to_format.sql
/
spool off

host C:\Oracle\12.1\perl\bin\perl c:\oracle\sql\inc\sql_format_standalone.pl c:/tmp/to_format.sql
set timing on head on termout on
