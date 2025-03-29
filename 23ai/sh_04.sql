clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
alter system set max_columns = standard;
drop user jane_doe cascade;
drop domain amex ;
@drop credit_card
@drop emp2
drop table hr.new_table purge;
alter session set group_by_position_enabled = false;
alter table t modify col not reservable;
@drop t
@drop person
@drop seq
@drop myemp
create or replace
function my_plsql_func return number is
begin
  return 10;
end;
/
create sequence seq;
clear screen
set termout on
set echo off
prompt |
prompt |  ___ _____   _______  _____ ____ _____ ____  
prompt | |_ _|  ___| | ____\ \/ /_ _/ ___|_   _/ ___| 
prompt |  | || |_    |  _|  \  / | |\___ \ | | \___ \ 
prompt |  | ||  _|   | |___ /  \ | | ___) || |  ___) |
prompt | |___|_|     |_____/_/\_\___|____/ |_| |____/ 
prompt |                                              
pause
set echo on
clear screen

set echo on
set termout on

set lines 60
clear screen
drop table t purge;
pause
drop table if exists t;
pause
create table t ( x int );
pause;
create table t ( x int );
pause
clear screen
create table if not exists t ( x int );
pause
create table if not exists t ( x int , y int);
pause
desc t
pause

clear screen
set termout on
set echo off
prompt |
prompt | __     ___    _    _   _ _____ ____  
prompt | \ \   / / \  | |  | | | | ____/ ___| 
prompt |  \ \ / / _ \ | |  | | | |  _| \___ \ 
prompt |   \ V / ___ \| |__| |_| | |___ ___) |
prompt |    \_/_/   \_\_____\___/|_____|____/ 
prompt |                                      
pause
set echo on
clear screen
drop table if exists myemp;
pause
create table myemp ( empno int, ename varchar2(10));
pause
insert into myemp values (1,'JOHN');
pause
insert into myemp values (2,'SUE');
pause
insert into myemp values (3,'MARY');
pause
insert into myemp values (4,'JANE');
pause
insert into myemp values (5,'PETE');
pause
roll;
clear screen
insert into myemp
values 
  (1,'JOHN'),
  (2,'SUE'),
  (3,'MARY'),
  (4,'JANE'),
  (5,'PETE');
commit;  
pause

clear screen
select 1 empno, 'JOHN' ename from dual union all
select 2 empno, 'SUE'  ename from dual union all
select 3 empno, 'MARY' ename from dual union all
select 4 empno, 'JANE' ename from dual union all
select 5 empno, 'PETE' ename from dual ;
pause
clear screen
select 1 empno, 'JOHN' ename union all
select 2 empno, 'SUE'  ename union all
select 3 empno, 'MARY' ename union all
select 4 empno, 'JANE' ename union all
select 5 empno, 'PETE' ename ;
pause
clear screen
select *
from ( values 
  (1,'JOHN'),
  (2,'SUE'),
  (3,'MARY'),
  (4,'JANE'),
  (5,'PETE')
) emp ( empno, ename);
pause
with emplist ( empno, ename) as 
 ( values 
  (1,'JOHN'),
  (2,'SUE'),
  (3,'MARY'),
  (4,'JANE'),
  (5,'PETE')
)
select * from emplist;
pause Done
