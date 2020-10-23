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
conn USER/PASSWORD@MY_PDB
set termout off
@drop t
@clean
set termout on

set echo on

create global temporary table t ( x int, y int )
on commit preserve rows;
pause
insert into t values (1,1);
pause
exec dbms_stats.gather_table_stats('','T');
pause
rollback;
pause
select * from t;
pause

delete t;
commit;
truncate table t;
clear screen

drop table t;
create global temporary table t ( x int, y int )
on commit delete rows;
pause
insert into t values (1,1);

--
-- NOW WHAT DO WE DO ???
--
pause
exec dbms_stats.gather_table_stats('','T');
pause
select * from t;
pause
rollback;
pause
select * from t;
