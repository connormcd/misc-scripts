clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
clear screen
col LAST_ACCESSED_TIME format a30
set lines 90
set termout on
set echo off
prompt | 
prompt |   _______       ____  _      ______       _____ _______    _______ _____ 
prompt |  |__   __|/\   |  _ \| |    |  ____|     / ____|__   __|/\|__   __/ ____|
prompt |     | |  /  \  | |_) | |    | |__       | (___    | |  /  \  | | | (___  
prompt |     | | / /\ \ |  _ <| |    |  __|       \___ \   | | / /\ \ | |  \___ \ 
prompt |     | |/ ____ \| |_) | |____| |____      ____) |  | |/ ____ \| |  ____) |
prompt |     |_/_/    \_\____/|______|______|    |_____/   |_/_/    \_\_| |_____/ 
prompt |                                                                          
prompt |                                                                          
pause
set echo on
clear screen
select *
from v$table_access_stats
order by read_count desc
fetch first 10 rows only;
pause
select o.object_name, s.read_count, s.last_accessed_time
from   user_objects o,
       v$table_access_stats s
where  o.object_id = s.object_id 
order by s.read_count desc
fetch first 10 rows only

pause
/
pause
clear screen
desc dba_table_access_stats
pause Done
