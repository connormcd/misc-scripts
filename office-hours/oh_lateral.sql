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
@trc
clear screen
@demobldu
@drop emp_bonus
create table emp_bonus ( empno int, granted date, amount int );
insert into emp_bonus values (7369, '17-DEC-90',100);
insert into emp_bonus values (7499, '20-FEB-91',150);
insert into emp_bonus values (7521, '22-FEB-91',200);
insert into emp_bonus values (7566, '02-APR-91',50);
insert into emp_bonus values (7654, '28-SEP-91',245);
insert into emp_bonus values (7698, '01-MAY-91',900);
insert into emp_bonus values (7782, '09-JUN-91',600);
insert into emp_bonus values (7788, '09-DEC-92',850);
insert into emp_bonus values (7369, '11-DEC-92',300);
insert into emp_bonus values (7499, '12-MAR-92',350);
insert into emp_bonus values (7521, '22-APR-92',100);
insert into emp_bonus values (7566, '13-SEP-92',90);
commit;
@drop company
create table company ( deptno int, emps varchar2(60));
insert into company
select deptno, listagg(ename,',') within group (order by empno) as emps
from emp
group by deptno;
commit;
set termout on
clear screen
set feedback on
set echo on
select empno, ename, job, sal
from emp;
pause
select * from emp_bonus;
pause
clear screen
--
-- "List each employee, and retrieve their bonuses
--  and when the bonuses were granted"
--
pause
select amount, granted 
from emp_bonus
where empno = 7369;
pause
select amount, granted 
from emp_bonus
where empno = :arbitrary_empno

pause
select e.empno, e.ename, b.amount, b.granted
from   emp e,
       ( select amount, granted
         from   emp_bonus
         where  empno = e.empno
       ) b
order by 1,4

pause
/
pause
clear screen
select e.empno, e.ename, b.amount, b.granted
from   emp e,
       lateral
       ( select amount, granted
         from   emp_bonus
         where  empno = e.empno
       ) b
order by 1,4;
pause
clear screen
--
-- Um...isn't that just a join?
--
pause
select e.empno, e.ename, b.amount, b.granted
from   emp e,
       --  lateral
       --  ( select amount, granted
       --    from   emp_bonus
       --    where  empno = e.empno
       --  ) b
       emp_bonus b
where  b.empno = e.empno
order by 1,4

pause
/
pause
clear screen
--
-- "List each employee, and find the LARGEST
--  bonus they received and when it was granted"
--
pause
select * from emp_bonus
where empno = 7369
order by amount desc
fetch first 1 row only;
pause
select * from emp_bonus
where empno = :arbitrary_empno
order by amount desc
fetch first 1 row only

pause
clear sceen
select e.empno, e.ename, b.amount, b.granted
from   emp e,
       LATERAL
       ( select amount, granted
         from   emp_bonus
         where  empno = e.empno
         order by amount desc
         fetch first 1 row only
       ) b
order by 1,4;
pause
clear screen
select * 
from (
  select e.empno, e.ename, b.amount, b.granted,
         row_number() over ( 
            partition by e.empno 
            order by b.amount desc ) as seq
  from   emp e,
         emp_bonus b
  where  b.empno = e.empno
)
where seq = 1
order by 1,4;
pause
clear screen
variable c clob
begin 
  dbms_utility.expand_sql_text('
select e.empno, e.ename, b.amount, b.granted
from   emp e,
       lateral
       ( select amount, granted
         from   emp_bonus
         where  empno = e.empno
       ) b',:c);
end;
/
pause
set long 5000
print c
pause
clear screen
alter session 
  set events = '10053 trace name context forever, level 1';
pause
explain plan for
select e.empno, e.ename, b.amount, b.granted
from   emp e,
       lateral
       ( select amount, granted
         from   emp_bonus
         where  empno = e.empno
       ) b;
disc
pause
host ( gawk "/Final query after/, /kkoqbc/" &&tracefile | grep SELECT )
pause
set termout off
clear screen
conn USER/PASSWORD@MY_PDB
set termout off
@trc
set termout on
set echo on
alter session 
  set events = '10053 trace name context forever, level 1';
pause
explain plan for
select e.empno, e.ename, b.amount, b.granted
from   emp e,
       lateral
       ( select amount, granted
         from   emp_bonus
         where  empno = e.empno
         order by amount desc
         fetch first 1 row only
       ) b
order by 1,4;
disc
pause
host ( gawk "/Final query after/, /kkoqbc/" &&tracefile | grep SELECT )
pause
set termout off
clear screen
conn USER/PASSWORD@MY_PDB
set termout off
col ename format a10
set termout on
set echo on
select * from company;
pause
select c.deptno,
       regexp_substr(c.emps, '[^,]+', 1, indices.idx) as ename
from
   company c,
   lateral(
     select level idx from dual
     connect by level <= 
          length(regexp_replace(c.emps, '[^,]+'))  + 1
  ) indices
  
pause
/


