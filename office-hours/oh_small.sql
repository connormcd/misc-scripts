REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

@clean
set termout off
@drop small_emp
create table small_emp pctfree 0 as
select 
rownum+7934 empno,
ENAME,
JOB,
MGR,
HIREDATE+rownum hiredate,
SAL,
COMM,
DEPTNO
from scott.emp, ( select 1 from dual connect by level <= 13 );
exec dbms_stats.gather_table_stats('','small_emp')
set lines 120
clear screen
set echo on
set termout on
desc small_emp
pause
select * from small_emp;
pause
select count(*), count(distinct(dbms_rowid.rowid_block_number(rowid))) blks 
from small_emp;
pause
clear screen
set autotrace traceonly explain
select * from small_emp where empno =  8104;
set autotrace off
pause

clear screen
variable reads number
begin 
  select st.value into :reads
  from v$statname s, v$mystat st
  where st.statistic# = s.statistic#
  and s.name = 'session logical reads';
end;
/
pause

set timing on
declare
  r1 number; r2 varchar2(20); r3 varchar2(20); r4 number;
begin
  for i in 1 .. 200000 loop
    select empno,ename,job,sal 
    into r1,r2,r3,r4 
    from small_emp where empno = 8104;
  end loop;
end;
/
pause

select st.value - :reads  logical_io
from v$statname s, v$mystat st
where st.statistic# = s.statistic#
and s.name = 'session logical reads';
pause

set timing off
clear screen

alter table small_emp add 
  constraint small_emp_pk primary key ( empno );
pause
set autotrace traceonly explain
select * from small_emp where empno =  8104;
set autotrace off
pause

clear screen
variable reads number
begin 
  select st.value into :reads
  from v$statname s, v$mystat st
  where st.statistic# = s.statistic#
  and s.name = 'session logical reads';
end;
/
pause

set timing on
declare
  r1 number; r2 varchar2(20); r3 varchar2(20); r4 number;
begin
  for i in 1 .. 200000 loop
    select empno,ename,job,sal 
    into r1,r2,r3,r4 
    from small_emp where empno = 8104;
  end loop;
end;
/
pause
set timing off

select st.value - :reads  logical_io
from v$statname s, v$mystat st
where st.statistic# = s.statistic#
and s.name = 'session logical reads';
pause

clear screen
create index small_emp_ix on 
  small_emp ( empno,ename,job,sal);
pause

set autotrace traceonly explain
select empno,ename,job,sal  from small_emp where empno =  8104;
set autotrace off
pause

clear screen
variable reads number
begin 
  select st.value into :reads
  from v$statname s, v$mystat st
  where st.statistic# = s.statistic#
  and s.name = 'session logical reads';
end;
/
pause

set timing on
declare
  r1 number; r2 varchar2(20); r3 varchar2(20); r4 number;
begin
  for i in 1 .. 200000 loop
    select empno,ename,job,sal 
    into r1,r2,r3,r4 
    from small_emp where empno = 8104;
  end loop;
end;
/
pause
set timing off

select st.value - :reads  logical_io
from v$statname s, v$mystat st
where st.statistic# = s.statistic#
and s.name = 'session logical reads';
pause


clear screen

set timing on
declare
  r1 number; r2 varchar2(20); r3 varchar2(20); r4 number;
begin
  for i in 1 .. 200000 loop
    for j in ( 
      select empno,ename,job,sal 
      from small_emp 
      where hiredate between date '1983-04-01' and date '1983-04-20'
    ) loop
        null;
      end loop;
  end loop;
end;
/
pause
set timing off
clear screen

create index small_emp_ix2 on 
  small_emp ( hiredate);
  
set timing on
declare
  r1 number; r2 varchar2(20); r3 varchar2(20); r4 number;
begin
  for i in 1 .. 200000 loop
    for j in ( 
      select empno,ename,job,sal 
      from small_emp 
      where hiredate between date '1983-04-01' and date '1983-04-20'
    ) loop
        null;
      end loop;
  end loop;
end;
/
pause
set timing off
clear screen

create index small_emp_ix3 on 
  small_emp ( hiredate,empno,ename,job,sal);

set timing on
declare
  r1 number; r2 varchar2(20); r3 varchar2(20); r4 number;
begin
  for i in 1 .. 200000 loop
    for j in ( 
      select empno,ename,job,sal 
      from small_emp 
      where hiredate between date '1983-04-01' and date '1983-04-20'
    ) loop
        null;
      end loop;
  end loop;
end;
/
set timing off
  