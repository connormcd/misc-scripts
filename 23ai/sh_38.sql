clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
@drop emp
create table emp as select * from scott.emp;
clear screen
set termout on
set echo off
prompt | 
prompt |   _____        _____ _____ _   _       _______ _____ ____  _   _ 
prompt |  |  __ \ /\   / ____|_   _| \ | |   /\|__   __|_   _/ __ \| \ | |
prompt |  | |__) /  \ | |  __  | | |  \| |  /  \  | |    | || |  | |  \| |
prompt |  |  ___/ /\ \| | |_ | | | | . ` | / /\ \ | |    | || |  | | . ` |
prompt |  | |  / ____ \ |__| |_| |_| |\  |/ ____ \| |   _| || |__| | |\  |
prompt |  |_| /_/    \_\_____|_____|_| \_/_/    \_\_|  |_____\____/|_| \_|
prompt | 
prompt | 
pause
set echo on
clear screen
conn scott/tiger@db19
select *
from emp
order by sal desc
fetch first 5 rows only;
pause
variable c clob
begin
  dbms_utility.expand_sql_text('
    select *
    from emp
    order by sal desc
    fetch first 5 rows only',:c );
end;
/
pause
print c
pause
set echo off
prompt | 
prompt | select a1.*
prompt | from  
prompt |   (select 
prompt |       emp.*, 
prompt |       emp.sal rowlimit_$_0,
prompt |       row_number() over ( order by emp.sal desc ) rowlimit_$$_rownumber 
prompt |    from emp 
prompt |    ) a1 
prompt | where a1.rowlimit_$$_rownumber<=5 
prompt | order by a1.rowlimit_$_0 desc
prompt | 
pause
set echo on 
clear screen
clear screen
conn scott/tiger@db23
select *
from emp
order by sal desc
fetch first 5 rows only;
pause
variable c clob
begin
  dbms_utility.expand_sql_text('
    select *
    from emp
    order by sal desc
    fetch first 5 rows only',:c );
end;
/
pause
print c
pause
set echo off
prompt | 
prompt | select a1.*
prompt | from  (
prompt |   select emp.*
prompt |   from emp 
prompt |   order by sal desc
prompt |   ) a1 
prompt | where rownum<=5
prompt | 
pause
set echo on 
clear screen
variable c clob
begin
  dbms_utility.expand_sql_text('
    select *
    from emp
    order by sal desc
    offset 5 rows fetch first 5 rows only',:c );
end;
/
pause
print c

pause Done
