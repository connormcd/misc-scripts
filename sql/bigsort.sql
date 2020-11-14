undefine megabytes
undefine sortsize
accept megabytes prompt 'Megabytes '
set termout off
col mbsort new_value sortsize
select &megabytes * 1024 * 1024 mbsort
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
