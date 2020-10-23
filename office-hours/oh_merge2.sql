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
drop table emps;
drop table fixes;
clear screen
set echo on
set termout on

create table emps (
   pk      number primary key, 
   ename   varchar2(10),
   deptno  number)
partition by list (deptno)
 (
  partition p1 values(10),
  partition p2 values(20),
  partition p3 values(30)
 )
enable row movement;
pause

insert into emps values (1, 'Connor',10);
commit;
select * from emps;
pause
clear screen
create table fixes 
 ( emp_pk   int, 
   new_dept int,
   applied  date );

insert into fixes values (1,20,sysdate-10);
insert into fixes values (1,30,sysdate-5);
commit;
select * from fixes;
pause
clear screen

merge into emps 
using (select emp_pk, new_dept 
       from fixes ) u
on (emps.pk = u.emp_pk)
when matched then
  update set deptno=new_dept

pause
/

  
  
