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
@drop t2

create table t2 
( owner not null,
  object_name,
  object_type,
  object_id,
  constraint t2_pk primary key ( object_id )
) organization index as 
select owner, 
       object_name, 
       object_type, 
       object_id
from dba_objects
where object_id is not null;
exec dbms_stats.gather_table_stats('','T2')
set termout on

set lines 200
set echo on
set autotrace traceonly explain
select *
from  scott.emp e,
      scott.dept d
where e.deptno = d.deptno
and   d.dname = 'SALES'

pause
/
pause
clear screen
select /*+ use_hash(d) */ *
from  scott.emp e,
      scott.dept d
where e.deptno = d.deptno
and   d.dname = 'SALES'

pause
/
pause

clear screen
set echo off
set serverout on format wrapped
set feedback off
begin
dbms_output.put_line(q'{SQL> select /*+ use_hash(d) */ *}');
dbms_output.put_line(q'{             ^^^^^^^^^^^^^}');
dbms_output.put_line(q'{             }');
dbms_output.put_line(q'{             If joining INTO dept, then}');
dbms_output.put_line(q'{             it must be a HASH JOIN}');
dbms_output.put_line(q'{             }');
dbms_output.put_line(q'{  2  from  scott.emp e,}');
dbms_output.put_line(q'{  3        scott.dept d}');
dbms_output.put_line(q'{  4  where e.deptno = d.deptno}');
dbms_output.put_line(q'{  5  and   d.dname = 'SALES'}');
dbms_output.put_line(q'{  6  /}');
end;
/
pause

begin
dbms_output.put_line(q'{             }');
dbms_output.put_line(q'{Execution Plan}');
dbms_output.put_line(q'{----------------------------------------------------------}');
dbms_output.put_line(q'{Plan hash value: 2125045483}');
dbms_output.put_line(q'{ }');
dbms_output.put_line(q'{----------------------------------------------------------------------------------------}');
dbms_output.put_line(q'{| Id  | Operation                    | Name    | Rows  | Bytes | Cost (%CPU)| Time     |}');
dbms_output.put_line(q'{----------------------------------------------------------------------------------------}');
dbms_output.put_line(q'{|   0 | SELECT STATEMENT             |         |     5 |   285 |     6  (17)| 00:00:01 |}');
dbms_output.put_line(q'{|   1 |  MERGE JOIN                  |         |     5 |   285 |     6  (17)| 00:00:01 |}');
dbms_output.put_line(q'{|*  2 |   TABLE ACCESS BY INDEX ROWID| DEPT    |     1 |    20 |     2   (0)| 00:00:01 |}');
dbms_output.put_line(q'{                                       ^^^^^^}');
dbms_output.put_line(q'{                                     We are STARTING with DEPT,}');
dbms_output.put_line(q'{             }');
dbms_output.put_line(q'{|   3 |    INDEX FULL SCAN           | DEPT_PK |     4 |       |     1   (0)| 00:00:01 |}');
dbms_output.put_line(q'{|*  4 |   SORT JOIN                  |         |    14 |   518 |     4  (25)| 00:00:01 |}');
dbms_output.put_line(q'{|   5 |    TABLE ACCESS FULL         | EMP     |    14 |   518 |     3   (0)| 00:00:01 |}');
dbms_output.put_line(q'{                                       ^^^^^^}');
dbms_output.put_line(q'{                                      and joining INTO EMP}');
dbms_output.put_line(q'{             }');
dbms_output.put_line(q'{----------------------------------------------------------------------------------------}');
dbms_output.put_line(q'{             }');
dbms_output.put_line(q'{Predicate Information (identified by operation id):}');
dbms_output.put_line(q'{---------------------------------------------------}');
dbms_output.put_line(q'{ }');
dbms_output.put_line(q'{   2 - filter("D"."DNAME"='SALES')}');
dbms_output.put_line(q'{   4 - access("E"."DEPTNO"="D"."DEPTNO")}');
dbms_output.put_line(q'{       filter("E"."DEPTNO"="D"."DEPTNO")}');
dbms_output.put_line(q'{ }');
dbms_output.put_line(q'{SQL> }');
end;
/
pause

set feedback on
set echo on

clear screen
select /*+ leading(e) use_hash(d) */ *
from  scott.emp e,
      scott.dept d
where e.deptno = d.deptno
and   d.dname = 'SALES'

pause
/
pause

clear screen
select /*+ ordered */
  e1.last_name,
  j.job_title,
  e1.salary,
  v.avg_salary
from
  hr.employees   e1,
  hr.jobs        j,
  ( select e2.department_id,
           avg(e2.salary)avg_salary
    from hr.employees     e2,
         hr.departments   d
    where d.location_id = 1700
      and e2.department_id = d.department_id
    group by e2.department_id
  ) v
where e1.job_id = j.job_id
  and e1.department_id = v.department_id
  and e1.salary > v.avg_salary
order by e1.last_name

pause
/
pause

set echo off
set serverout on format wrapped
set feedback off
clear screen

begin
dbms_output.put_line(q'{             }');
dbms_output.put_line(q'{C:\>cat 10053.trc             }');
dbms_output.put_line(q'{             }');
dbms_output.put_line(q'{ Final query after transformations:}');
dbms_output.put_line(q'{ }');
dbms_output.put_line(q'{ select}');
dbms_output.put_line(q'{   e1.last_name   last_name,}');
dbms_output.put_line(q'{   j.job_title    job_title,}');
dbms_output.put_line(q'{   e1.salary      salary,}');
dbms_output.put_line(q'{   avg(e2.salary) avg_salary}');
dbms_output.put_line(q'{ from hr.employees     e1,}');
dbms_output.put_line(q'{      hr.jobs          j,}');
dbms_output.put_line(q'{      hr.employees     e2,}');
dbms_output.put_line(q'{      hr.departments   d}');
dbms_output.put_line(q'{ where e1.job_id = j.job_id}');
dbms_output.put_line(q'{   and e1.department_id = e2.department_id}');
dbms_output.put_line(q'{   and d.location_id = 1700}');
dbms_output.put_line(q'{   and e2.department_id = d.department_id}');
dbms_output.put_line(q'{ group by}');
dbms_output.put_line(q'{   e2.department_id,}');
dbms_output.put_line(q'{   j.rowid,}');
dbms_output.put_line(q'{   e1.rowid,}');
dbms_output.put_line(q'{   e1.salary,}');
dbms_output.put_line(q'{   j.job_title,}');
dbms_output.put_line(q'{   e1.last_name}');
dbms_output.put_line(q'{ having e1.salary > avg(e2.salary)}');
dbms_output.put_line(q'{ order by e1.last_name}');
dbms_output.put_line(q'{             }');
dbms_output.put_line(q'{SQL>}');
end;
/

set echo on
pause

clear screen
select /*+ no_merge(v) ordered */
  e1.last_name,
  j.job_title,
  e1.salary,
  v.avg_salary
from
  hr.employees   e1,
  hr.jobs        j,
  ( select e2.department_id,
           avg(e2.salary)avg_salary
    from hr.employees     e2,
         hr.departments   d
    where d.location_id = 1700
      and e2.department_id = d.department_id
    group by e2.department_id
  ) v
where e1.job_id = j.job_id
  and e1.department_id = v.department_id
  and e1.salary > v.avg_salary
order by e1.last_name

pause
/
pause

set autotrace off
clear screen

explain plan for
select /*+ qb_name(q1) */
  e1.last_name,
  j.job_title,
  e1.salary,
  v.avg_salary
from
  hr.employees   e1,
  hr.jobs        j,
  ( select  /*+ qb_name(q2) */
           e2.department_id,
           avg(e2.salary)avg_salary
    from hr.employees     e2,
         hr.departments   d
    where d.location_id = 1700
      and e2.department_id = d.department_id
    group by e2.department_id
  ) v
where e1.job_id = j.job_id
  and e1.department_id = v.department_id
  and e1.salary > v.avg_salary
order by e1.last_name;
pause
clear screen
select * from dbms_xplan.display(format=>'typical alias');

pause
clear screen
set lines 80
desc t2
select count(*) from t2;
pause
set autotrace traceonly explain
select /*+ full(t2) */ max(lower(owner))
from   t2

pause
/
set autotrace off
