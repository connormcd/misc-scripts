select 'svrmgrl' || chr(10) || 'connect internal' ||chr(10)||'select to_char(sysdate,''hh24:mi:ss'') from dual;'
from dual
union all
select 'REM '||s.USERNAME||','||s.sid||chr(10)||
       'REM'||chr(10)||
       'oradebug setorapid '||p.pid||chr(10)||
       'oradebug suspend'||chr(10)||
       'REM'
from v$session s, v$process p
where s.PADDR = p.ADDR
and s.status = 'ACTIVE'
and s.program like '%DIS31USR%';
