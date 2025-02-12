REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

5scree
clear screen
@clean
set termout off
conn USER/PASSWORD@MY_PDB
set termout off
undefine trcfile
set termout on
clear screen
set echo on

select *
from ( select deptno,sal
       from   emp
     )
pivot ( sum(sal) as tot_sal 
  for (deptno) in ( 10 as d10, 20 as d20, 30 as d30 )
      );
pause
clear screen
select *
from ( select deptno,job,sal
       from   emp
     )
pivot ( sum(sal) as tot_sal 
  for (deptno) in ( 10 as d10, 20 as d20, 30 as d30 )
      );
pause
clear screen
col value new_value trcfile
select value from v$diag_info
where name = 'Default Trace File';
pause
alter session set events = '10053 trace name context forever, level 1';
pause
explain plan for 
select *
from ( select deptno,sal
       from   emp
     )
pivot ( sum(sal) as tot_sal 
  for (deptno) in ( 10 as d10, 20 as d20, 30 as d30 )
      );
pause
alter session set events = '10053 trace name context off';
pause
disc
pause
host ( awk "/Final query after/, /kkoqbc/" &&trcfile > x:\temp\query.txt )
host ( cat x:\temp\query.txt )
pause
host ( grep -v Final x:\temp\query.txt > x:\temp\query1.txt )
host ( grep -v kkoqbc x:\temp\query1.txt > x:\temp\query2.txt )
pause
clear screen
host x:\bin\sqlformat.cmd
pause
clear screen
@clean
set termout off
conn USER/PASSWORD@MY_PDB
set termout off
@drop t
undefine trcfile
set termout on
clear screen
set echo on
create table t
  ( player varchar2(10),
    goals1  number,
    goals2  number);
insert into t values ('Pele',1,1);
insert into t values ('Messi',2,1);
pause
select * from t;
pause
clear screen
select *
from   t
unpivot (goals for half in (goals1 as 'first', goals2 as 'second'));
pause
clear screen

col value new_value trcfile
select value from v$diag_info
where name = 'Default Trace File';
pause
alter session set events = '10053 trace name context forever, level 1';
pause
explain plan for 
select *
from   t
unpivot (goals for half in (goals1 as 'first', goals2 as 'second'));
pause
alter session set events = '10053 trace name context off';
pause
disc
pause
host ( awk "/Final query after/, /kkoqbc/" &&trcfile > x:\temp\query.txt )
host ( cat x:\temp\query.txt )
pause
host ( grep -v Final x:\temp\query.txt > x:\temp\query1.txt )
host ( grep -v kkoqbc x:\temp\query1.txt > x:\temp\query2.txt )
pause
clear screen
host x:\bin\sqlformat.cmd




