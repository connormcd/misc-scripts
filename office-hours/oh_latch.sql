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
conn USER/PASSWORD@MY_PDB
set termout off
set timing off
@drop latch1
@drop latch2
@drop t
set pages 999
set termout on
clear screen
set echo on

create table t as 
select d.* from dba_objects d,
( select 1 from dual 
  connect by level <= 10 ) ;
  pause
select num_rows 
from user_tables
where table_name = 'T';  
pause
clear screen
declare
  cursor c is select * from t;
  r t%rowtype;
begin
  open c;
  loop
    fetch c into r;
    exit when c%notfound;
  end loop;
  close c;
end;
/
pause
clear screen
create table latch1 as select * from v$latch;
pause
declare
  cursor c is select * from t;
  r t%rowtype;
begin
  open c;
  loop
    fetch c into r;
    exit when c%notfound;
  end loop;
  close c;
end;
/
pause
clear screen

select l2.name, l1.gets, l2.gets - nvl(l1.gets,0) delta
from latch1 l1
full outer join v$latch l2
on (l1.latch# = l2.latch# )
where l2.gets != nvl(l1.gets,0)
order by delta

pause
/
pause
select num_rows*2 
from user_tables
where table_name = 'T';  
pause

drop table latch1 purge;
pause
clear screen
create table latch1 as select * from v$latch;
pause
begin
  for i in ( select * from t ) 
  loop
    null;
  end loop;
end;
/
pause

select l2.name, l1.gets, l2.gets - nvl(l1.gets,0) delta
from latch1 l1
full outer join v$latch l2
on (l1.latch# = l2.latch# )
where l2.gets != nvl(l1.gets,0)
order by delta

pause
/

pause
select blocks*2 
from user_tables
where table_name = 'T';  
