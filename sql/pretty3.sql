set timing off head off feedback off
col qtext format a150
set termout off
spool /tmp/to_format.sql
select
    coalesce(
        (select sql_fulltext from v$sqlarea a where a.sql_id='&1')
    ,   (select sql_text from dba_hist_sqltext a where a.sql_id='&1' and dbid=(select dbid from v$database))
    ) qtext
from dual
;
spool off
 
host C:\oracle\product\19\perl\bin\perl.exe c:\oracle\sql\sql_format_standalone.pl /tmp/to_format.sql
set termout on head on feedback on
