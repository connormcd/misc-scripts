set lines 130
set pages 999
col log_message format a110 trunc
select to_char(log_time,'DD/MM HH24:MI:SS') log_time, log_message
from data_maint_log
where log_time > trunc(sysdate-to_number(nvl('&days','0')));
