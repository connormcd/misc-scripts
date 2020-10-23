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
set secureliterals default
pause

create table t2 as
select rownum r, 
       cast(date '2015-01-01' + rownum/5000 as timestamp) x,
       rpad('c',100,'c') c
from ( select 1 from dual connect by level <= 500 ),
     ( select 1 from dual connect by level <= 10000 );
create index ix2a on t2 ( x ) ;
pause
clear screen
alter system flush shared_pool;
set timing on
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
begin
  for c_rec in (
     select /*+ findme*/ * from t2 
     where x >= to_timestamp('20-JAN-2015', 'dd-MON-yyyy')
  ) loop
    null;
  end loop;
end;
/
set timing off
pause
clear screen
select sql_fulltext, sql_id
from   v$sql
where  upper(sql_fulltext) like 'SELECT /*+ FINDME%';
pause
select * from dbms_xplan.display_cursor(sql_id=>'cz86w3ssagvyk');
pause

clear screen
explain plan for 
  select * from t2 
  where x >= to_timestamp('20-JAN-2015', 'dd-MON-yyyy');
pause
select * from dbms_xplan.display();
pause
clear screen
set secureliterals off
set timing on
begin
  for c_rec in (
     select * from t2 
     where x >= to_timestamp('20-JAN-2015', 'dd-MON-yyyy')
  ) loop
    null;
  end loop;
end;
/
set timing off
