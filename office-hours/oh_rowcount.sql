REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

clear screen
@clean
set termout off
conn scott/tiger@DB_SERVICE
set termout off
set termout on
clear screen
set echo on
sho user
pause
select table_name, num_rows
from   user_tables;
pause
clear screen
spool /tmp/count_all.sql
select  'select '''||table_name||''' tab, count(*) from '||table_name||';'
from user_tables;
spool off
pause
@/tmp/count_all.sql
pause
clear screen
with
  function tcount(tname varchar2) return int is
    c int;
  begin
    execute immediate
      'select count(*) from '||tname
      into c;
    return c;
  end;
select table_name, tcount(table_name)
from user_tables;
.
pause
/
pause
clear screen
with
  function tcount(tname varchar2) return int is
    c int;
  begin
    execute immediate
      'select count(*) from '||tname||' sample block (20)'
      into c;
    return c*5;
  end;
select table_name, tcount(table_name)
from user_tables;
.
pause
/
