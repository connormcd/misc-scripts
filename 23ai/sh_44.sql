clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
@drop t1
clear screen
set termout on
set echo off
clear screen
set termout on
set echo off
prompt |
prompt |  __  __ _____ ____ ____    _    ____ _____ ____  
prompt | |  \/  | ____/ ___/ ___|  / \  / ___| ____/ ___| 
prompt | | |\/| |  _| \___ \___ \ / _ \| |  _|  _| \___ \ 
prompt | | |  | | |___ ___) |__) / ___ \ |_| | |___ ___) |
prompt | |_|  |_|_____|____/____/_/   \_\____|_____|____/ 
prompt |                                                  
set echo on
pause
clear screen
conn scott/tiger@db19
pause
select deptno, job,  count(*)
from  emp
group by deptno;
pause

conn scott/tiger@db23
pause
select deptno, job,  count(*)
from  emp
group by deptno;
pause

clear screen
drop table if exists t purge;
create table t ( 
  x int, 
  constraint t_pk primary key ( x )
);
pause
insert into t values (1);
pause
insert into t values (1);

pause Done
