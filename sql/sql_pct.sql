select sql_text, round(100*buffer_gets/totbuf) pct
from v$sql, 
  ( select sum(buffer_gets) totbuf
    from v$sql
    where parsing_user_id > 0 
    and upper(substr(sql_text,1,3)) in ('SEL','INS','UPD','DEL')) s
where buffer_gets > 1000000
and parsing_user_id > 0
and upper(substr(sql_text,1,3)) in ('SEL','INS','UPD','DEL')
order by buffer_gets