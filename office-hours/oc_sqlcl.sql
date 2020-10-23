REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

set termout off
col SQL_FULLTEXT format a60 wrap
set long 200
@drop t2
alter system flush shared_pool;
@clean
set echo on
set termout on

create table t2 as
select rownum r, 
       cast(date '2015-01-01' + rownum/100 as timestamp) x
from dual
connect by level <= 10;
pause
select * from t2;
pause
clear screen
select /*+ findme*/ * from t2 
where x >= to_timestamp('20-DEC-2017', 'dd-MON-yyyy');
pause
select sql_fulltext
from   v$sql
where  upper(sql_fulltext) like 'SELECT /*+ FINDME%';
pause
clear screen
alter system flush shared_pool;
begin
  for c_rec in (
     select /*+ findme*/ * from t2 
     where x >= to_timestamp('20-DEC-2017', 'dd-MON-yyyy')
  ) loop
    null;
  end loop;
end;
/
pause
select sql_fulltext
from   v$sql
where  upper(sql_fulltext) like 'SELECT /*+ FINDME%';
pause
clear screen
show secureliterals
pause
set secureliterals off

alter system flush shared_pool;
pause
begin
  for c_rec in (
     select /*+ findme*/ * from t2 
     where x >= to_timestamp('20-DEC-2017', 'dd-MON-yyyy')
  ) loop
    null;
  end loop;
end;
/
pause
select sql_fulltext
from   v$sql
where  upper(sql_fulltext) like 'SELECT /*+ FINDME%';
