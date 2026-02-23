clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
clear screen
set termout off
@drop emp
@drop dept
drop assertion employee_roles_rule ;

create table emp as 
select * from scott.emp
order by deptno;

update emp set job = 'DEPT HEAD' where empno in ( 7839, 7902, 7698 );

create table dept as
select * from scott.dept;

clear screen
set termout on
set echo off
set serverout on
prompt |   
prompt |     _____ _   _ _______ ______ _____ _____  _____ _________     __    ___         ___  
prompt |    |_   _| \ | |__   __|  ____/ ____|  __ \|_   _|__   __\ \   / /   |__ \       / _ \ 
prompt |      | | |  \| |  | |  | |__ | |  __| |__) | | |    | |   \ \_/ /       ) |     | | | |
prompt |      | | | . ` |  | |  |  __|| | |_ |  _  /  | |    | |    \   /       / /      | | | |
prompt |     _| |_| |\  |  | |  | |___| |__| | | \ \ _| |_   | |     | |       / /_   _  | |_| |
prompt |    |_____|_| \_|  |_|  |______\_____|_|  \_\_____|  |_|     |_|      |____| (_)  \___/ 
prompt |                                                                                        
prompt |                                                                                        
prompt |   
prompt |   
pause
clear screen
set echo on
clear screen
select * from emp;
pause
select * from dept;
pause
clear screen
alter table emp modify deptno not null;;
pause
alter table emp
  add constraint emp_pk
  primary key (empno);
pause
alter table dept
  add constraint dept_pk
  primary key (deptno);
pause
alter table emp
  add constraint emp_ck
  check ( sal > 0 );
pause
clear screen
alter table dept
  add constraint dept_uq
  unique (dname );
pause  
alter table emp 
  add constraint emp_fk 
  foreign key (deptno) 
  references dept (deptno);
pause
clear screen
--
-- No-one can have a salary higher than 
-- their department head
--
pause
select * from emp 
order by deptno;
pause
clear screen
create or replace
trigger emp_trg 
after insert on emp
for each row
begin
  for i in ( 
    select  * 
    from emp e
    where job = 'DEPT HEAD'
    and   sal < :new.sal
  )
  loop
     raise_application_error(-20000,'Salary problems with department head');
  end loop;
end;
/
pause
clear screen
select *
from  emp
where deptno = 30
order by sal;
pause
insert into emp (empno,deptno,ename,job,sal)
values (1000,30,'Connor','DEV',3000)
.
pause
/
pause
clear screen
create or replace
trigger emp_trg 
after insert on emp
--for each row
begin
  for i in ( 
    select  * 
    from emp e
    where job = 'DEPT HEAD'
    and exists ( 
      select 1
      from   emp
      where  deptno = e.deptno
      and    sal > e.sal )
  )
  loop
     raise_application_error(-20000,'Salary problems with department head');
  end loop;
end;
/
pause
clear screen
insert into emp (empno,deptno,ename,job,sal)
values (1000,30,'Connor','DEV',1200);
pause
insert into emp (empno,deptno,ename,job,sal)
values (1001,30,'Suzy','DEV',3000);
pause
roll;
pause
clear screen
--
-- One small issue...
--
pause
--
--   IT DOES NOT WORK !!!!
--
pause
clear screen
create or replace
trigger emp_trg 
after insert on emp
begin
  LOCK TABLE EMP IN EXCLUSIVE MODE;

  for i in ( 
    select  * 
    from emp e
    where job = 'DEPT HEAD'
    and exists ( 
      select 1
      from   emp
      where  deptno = e.deptno
      and    sal > e.sal )
  )
  loop
     raise_application_error(-20000,'Salary problems with department head');
  end loop;
end;
/
pause
clear screen
create or replace 
trigger emp_trg
for insert on emp
compound trigger

  l_deptno sys.odcinumberlist := sys.odcinumberlist();
  l_cur    sys_refcursor;
  
  before each row is
  begin
    l_deptno.extend;
    l_deptno(l_deptno.count) := :new.deptno;
  end before each row;
#pause

  after statement is
  begin
    open l_cur for
      select *
      from   dept
      where  deptno in (
        select distinct column_value
        from   table(l_deptno) )
      for update;
#pause
    for i in ( 
      select  * 
      from emp e
      where job = 'DEPT HEAD'
      and deptno in (
          select distinct column_value
          from   table(l_deptno) )
      and exists ( 
        select 1
        from   emp
        where  deptno = e.deptno
        and    sal > e.sal )
    )
    loop
       raise_application_error(-20000,'Salary problems with department head');
    end loop;
  end after statement;
end;
/
pause
clear screen
create or replace 
trigger emp_trg
for insert OR UPDATE on emp
compound trigger

  l_deptno sys.odcinumberlist := sys.odcinumberlist();
  l_cur    sys_refcursor;
  l_cnt    int;
  
  before each row is
  begin
    l_deptno.extend;
    l_deptno(l_deptno.count) := :new.deptno;
    l_deptno.extend;
    l_deptno(l_deptno.count) := :old.deptno;
  end before each row;
#pause
  after statement is
  begin
    open l_cur for
      select *
      from   dept
      where  deptno in (
        select distinct column_value
        from   table(l_deptno) )
      for update;

    for i in ( 
      select  * 
      from emp e
      where job = 'DEPT HEAD'
      and deptno in (
          select distinct column_value
          from   table(l_deptno) )
      and exists ( 
        select 1
        from   emp
        where  deptno = e.deptno
        and    sal > e.sal )
    )
    loop
       raise_application_error(-20000,'Salary problems with department head');
    end loop;
  end after statement;

end;
/
pause
set echo off
clear screen
prompt |   
prompt |   
prompt |     _  _______ _____  _____ _____ _   _  _____     __  __ ______    ___ ___ ___  
prompt |    | |/ /_   _|  __ \|  __ \_   _| \ | |/ ____|   |  \/  |  ____|  |__ \__ \__ \ 
prompt |    | ' /  | | | |  | | |  | || | |  \| | |  __    | \  / | |__        ) | ) | ) |
prompt |    |  <   | | | |  | | |  | || | | . ` | | |_ |   | |\/| |  __|      / / / / / / 
prompt |    | . \ _| |_| |__| | |__| || |_| |\  | |__| |   | |  | | |____    |_| |_| |_|  
prompt |    |_|\_\_____|_____/|_____/_____|_| \_|\_____|   |_|  |_|______|   (_) (_) (_)  
prompt |                                                                                  
prompt |   
set echo on
pause
clear screen
drop trigger emp_trg;
pause
set echo off
prompt   | 
prompt   | What I want is this
prompt   |  
prompt   |    select  'It is bad when...'
prompt   |    from emp e
prompt   |    where job = 'DEPT HEAD'
prompt   |    and exists ( 
prompt   |      select '.. there is too high a salary'
prompt   |      from   emp
prompt   |      where  deptno = e.deptno
prompt   |      and    sal > e.sal )
prompt   |   
prompt   |  
pause
set echo on
clear screen
create assertion employee_roles_rule check
( not exists 
    ( select  'It is bad when...'
      from emp e
      where job = 'DEPT HEAD'
      and exists ( 
        select '.. there is too high a salary'
        from   emp
        where  deptno = e.deptno
        and    sal > e.sal )
     )
)
.
pause
/
pause
insert into emp (empno,deptno,ename,job,sal)
values (1000,30,'Connor','DEV',1200);
pause
insert into emp (empno,deptno,ename,job,sal)
values (1001,30,'Suzy','DEV',3000);

pause Done
set termout off
@demobldu
set termout on