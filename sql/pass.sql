col name format a16
set lines 200
set feedback on
select name, password
from  sys.user$
where name like upper(nvl('&username',name))||'%'
order by 1;
