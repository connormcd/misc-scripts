clear screen
@clean
set termout off
conn dbdemo/dbdemo@db19
set termout off
@demobldu
@drop mv
@drop mv
@drop t
drop materialized view log on dept;
drop materialized view log on emp;
conn dbdemo/dbdemo@db23
set termout off
@demobldu
@drop mv
set linesize 100
col parname format a30
@drop mv
@drop t
drop materialized view log on dept;
drop materialized view log on emp;
clear screen
conn dbdemo/dbdemo@db19
set termout on
set echo off
prompt | 
prompt | 
prompt |   __  ____      _______ ________          __     _____  ________          _______  _____ _______ ______ 
prompt |  |  \/  \ \    / /_   _|  ____\ \        / /    |  __ \|  ____\ \        / /  __ \|_   _|__   __|  ____|
prompt |  | \  / |\ \  / /  | | | |__   \ \  /\  / /     | |__) | |__   \ \  /\  / /| |__) | | |    | |  | |__   
prompt |  | |\/| | \ \/ /   | | |  __|   \ \/  \/ /      |  _  /|  __|   \ \/  \/ / |  _  /  | |    | |  |  __|  
prompt |  | |  | |  \  /   _| |_| |____   \  /\  /       | | \ \| |____   \  /\  /  | | \ \ _| |_   | |  | |____ 
prompt |  |_|  |_|   \/   |_____|______|   \/  \/        |_|  \_\______|   \/  \/   |_|  \_\_____|  |_|  |______|
prompt |                                                                                                         
prompt |                                                                                                         
pause
set echo on
clear screen
select banner from v$version;
create materialized view MV
refresh complete
enable query rewrite as
select d.dname, sum(e.sal) sal
from emp e, dept d 
where d.deptno = e.deptno(+)
group by d.dname;
pause
clear screen
set autotrace traceonly explain
select d.dname, sum(e.sal) sal
from emp e, dept d 
where d.deptno = e.deptno(+)
group by d.dname;
pause
select d.dname, sum(e.sal) sal
from dept d left outer join emp e
on d.deptno = e.deptno
group by d.dname;
set autotrace off
pause
clear screen
drop materialized view mv;
create materialized view MV
refresh complete
enable query rewrite as
select d.dname, sum(e.sal) sal
from dept d left outer join emp e
on d.deptno = e.deptno
group by d.dname;
pause
clear screen
set autotrace traceonly explain
select d.dname, sum(e.sal) sal
from dept d left outer join emp e
on d.deptno = e.deptno
group by d.dname;
pause
select d.dname, sum(e.sal) sal
from emp e, dept d 
where d.deptno = e.deptno(+)
group by d.dname;
set autotrace off
pause
set termout off
clear screen
conn dbdemo/dbdemo@db23
set termout off
set echo off
set termout on
set lines 300
set feedback off
set serverout on
set termout on

set feedback on
set echo on
select banner from v$version;
pause

create materialized view MV
refresh complete
enable query rewrite as
select d.dname, sum(e.sal) sal
from dept d left outer join emp e
on d.deptno = e.deptno
group by d.dname;
pause
clear screen
set autotrace traceonly explain
select d.dname, sum(e.sal) sal
from emp e, dept d 
where d.deptno = e.deptno(+)
group by d.dname;
pause
select d.dname, sum(e.sal) sal
from dept d left outer join emp e
on d.deptno = e.deptno
group by d.dname;
set autotrace off
pause
drop materialized view mv;
clear screen
--
-- Concurrent refresh
--
create materialized view log on dept with rowid;
create materialized view log on emp with rowid;
pause
create materialized view MV
refresh fast on commit as
select e.rowid erid, d.rowid drid, e.empno, e.ename, d.dname
from dept d , emp e
where d.deptno = e.deptno;
pause
--
-- Session 1
--
insert into dept values (50,'HR','NASHVILLE');
--
-- Session 2
--
update dept set dname = 'SALES' where deptno = 20;
pause
roll;
drop materialized view log on dept;
drop materialized view log on emp;
drop materialized view mv;
clear screen
--
-- logical tracking, aka, 1 row can ruin your day
--
create table t as
select d.*, trunc(created,'MM') mth
from dba_objects d;
pause
clear screen
create materialized view mv
refresh complete
enable query rewrite as
select mth, count(object_id) cnt
from t
group by mth;
pause
clear screen
set autotrace traceonly explain
select mth, count(object_id) cnt
from t
where mth <= date '2023-12-01'
group by mth;
set autotrace off
pause
insert into t ( owner, object_id, created , mth)
values ('CONNOR',123123,sysdate, trunc(sysdate,'MM') );
commit;
pause
set autotrace traceonly explain
select mth, count(object_id) cnt
from t
where mth <= date '2023-12-01'
group by mth;
set autotrace off
pause
clear screen
create logical partition tracking on t
partition by range (mth)
interval(numtoyminterval(1, 'YEAR'))
( partition p21 values less than ( date '2022-01-01' ),
  partition p22 values less than ( date '2023-01-01' ),
  partition p23 values less than ( date '2024-01-01' ),
  partition p24 values less than ( date '2025-01-01' )
);
pause
drop materialized view mv;
create materialized view mv
refresh complete
enable query rewrite as
select mth, count(object_id) cnt
from t
group by mth;
pause
clear screen
set autotrace traceonly explain
select mth, count(object_id) cnt
from t
where mth <= date '2023-12-01'
group by mth;
set autotrace off
pause
insert into t ( owner, object_id, created , mth)
values ('CONNOR',123123,sysdate, trunc(sysdate,'MM') );
commit;
pause
set autotrace traceonly explain
select mth, count(object_id) cnt
from t
where mth <= date '2023-12-01'
group by mth;
set autotrace off
pause
select detail_logical_partition_name as parname,
       detail_logical_partition_number as parno,
       freshness,
       last_refresh_time
from   user_mview_detail_logical_partition
where mview_name = 'MV'
order by 2;


pause Done
