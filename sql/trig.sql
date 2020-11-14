set verify off
select trigger_name, status
from user_triggers
where table_name = upper(nvl('&table_name',table_name));
