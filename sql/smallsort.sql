-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
undefine kilobytes
undefine sortsize
accept kilobytes prompt 'kilobytes '
set termout off
col mbsort new_value sortsize
select &kilobytes * 1024 mbsort
from dual;
set termout on
set verify off
prompt Setting to &sortsize
set feedback off
begin
  execute immediate 'alter session set workarea_size_policy = manual';
  execute immediate 'alter session set workarea_size_policy = manual';
exception 
  when others then null;
end;
/
alter session set sort_area_size = &sortsize;
alter session set sort_area_retained_size = &sortsize;
set feedback on
alter session set sort_area_size = &sortsize;
alter session set sort_area_retained_size = &sortsize;
set verify on
