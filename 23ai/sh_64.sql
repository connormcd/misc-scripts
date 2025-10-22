clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
clear screen
set termout off
@drop newemp
clear screen
set termout on
set echo off
set serverout on
prompt |   
prompt |   
prompt |   
prompt |     _   _ ________          __    _____ _   _  _____ ______ _____ _______ 
prompt |    | \ | |  ____\ \        / /   |_   _| \ | |/ ____|  ____|  __ \__   __|
prompt |    |  \| | |__   \ \  /\  / /      | | |  \| | (___ | |__  | |__) | | |   
prompt |    | . ` |  __|   \ \/  \/ /       | | | . ` |\___ \|  __| |  _  /  | |   
prompt |    | |\  | |____   \  /\  /       _| |_| |\  |____) | |____| | \ \  | |   
prompt |    |_| \_|______|   \/  \/       |_____|_| \_|_____/|______|_|  \_\ |_|   
prompt |                                                                           
prompt |                                                                           
prompt |   
pause
clear screen
set echo on
clear screen
create table newemp
as select * from scott.emp
where 1=0;
pause
set lines 60
desc newemp
pause
clear screen
insert into newemp
values (100,'Connor','Geek');
pause
insert into newemp (empno,ename,job)
values (100,'Connor','Geek');
pause
roll;
clear screen
insert into newemp (empno,ename,job,comm)
values (100,'Connor','Geek',10),
       (101,'Martin','PM',20),
       (102,'Shakeeb','APEX',30);
pause
insert into newemp (empno,ename,job,comm)
values (100,'Connor','Geek',10),
       (101,'Martin','PM',null),
       (102,'Shakeeb','',100);
pause
clear screen
insert into newemp
#pause
set (empno=100,ename='Connor',job='Geek',comm=10),
    (empno=101,ename='Martin',job='PM'),
    (empno=102,ename='Shakeeb',comm=100)
.    
pause
/
pause
clear screen
desc newemp
pause
insert into newemp 
select 
   empno   
  ,ename   
  ,job     
  ,mgr     
  ,hiredate
  ,sal     
  ,comm    
  ,deptno  
from scott.emp;
pause
roll;
clear screen
alter table newemp modify mgr invisible;
pause
alter table newemp modify mgr visible;
pause
desc newemp
pause
roll;
clear screen
insert into newemp 
select 
   empno   
  ,ename   
  ,job     
  ,mgr     
  ,hiredate
  ,sal     
  ,comm    
  ,deptno  
from scott.emp;
pause
insert into newemp 
#pause
BY NAME
select hiredate, ename, empno, sal, job
from scott.emp
.
pause
/
pause
set lines 120
select * from newemp;
pause Done
roll;

