REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

@drop t
set termout off
clear screen
conn USER/PASSWORD@MY_DB
set echo on
set termout on

set echo on
create table t as select * from dba_objects;
pause
create index ix on t ( object_id );
pause
variable rc refcursor
exec open :rc for select /*+ index(t) */ * from t where object_id > 0;
pause
clear screen

delete from t;
pause
commit;
pause
clear screen

select s.name, st.value
from v$statname s, v$mystat st
where st.statistic# = s.statistic#
and s.name like '%- undo records applied';
pause

set feedback only
print rc
pause

set feedback on
select s.name, st.value
from v$statname s, v$mystat st
where st.statistic# = s.statistic#
and s.name like '%- undo records applied';
pause

set termout off
clear screen
conn USER/PASSWORD@MY_DB
set echo on
set termout on
drop table t purge;

create table t as select 'ONEROW' tag, 10 numcol from dual;
variable rc refcursor
exec open :rc for select * from t;
pause
begin
for i in 1 .. 25000
loop
  update t
  set numcol = numcol + 1;
  commit;
end loop;
end;
/
pause
select s.name, st.value
from v$statname s, v$mystat st
where st.statistic# = s.statistic#
and s.name like '%- undo records applied';
pause

print rc
pause

set feedback on
select s.name, st.value
from v$statname s, v$mystat st
where st.statistic# = s.statistic#
and s.name like '%- undo records applied';

pause

set termout off
clear screen
conn USER/PASSWORD@MY_DB
set echo on
set termout on

drop table t purge;
create table t as select * from dba_objects;
pause
variable rc refcursor
exec open :rc for select * from t;
pause
clear screen

delete from t;
pause
commit;
pause
alter system flush buffer_cache;
pause
clear screen

select s.name, st.value
from v$statname s, v$mystat st
where st.statistic# = s.statistic#
and s.name like '%- undo records applied';
pause

set feedback only
print rc
pause

set feedback on
select s.name, st.value
from v$statname s, v$mystat st
where st.statistic# = s.statistic#
and s.name like '%- undo records applied';
pause

select blocks
from   user_tables
where  table_name = 'T';



