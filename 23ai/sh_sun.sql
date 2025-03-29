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
prompt |      _ _   _ ____ _____   ____  _____ _     _____ ____ _____ 
prompt |     | | | | / ___|_   _| / ___|| ____| |   | ____/ ___|_   _|
prompt |  _  | | | | \___ \ | |   \___ \|  _| | |   |  _|| |     | |  
prompt | | |_| | |_| |___) || |    ___) | |___| |___| |__| |___  | |  
prompt |  \___/ \___/|____/ |_|   |____/|_____|_____|_____\____| |_|  
prompt |                                                              
pause
set echo on
clear screen
set echo on
set termout on
select sysdate from dual;
pause
select sysdate;
pause
select 1;
pause
select seq.nextval;
pause

clear screen
set termout on
set echo off
prompt |
prompt |
prompt |  ____   ___   ___  _     _____    _    _   _ 
prompt | | __ ) / _ \ / _ \| |   | ____|  / \  | \ | |
prompt | |  _ \| | | | | | | |   |  _|   / _ \ |  \| |
prompt | | |_) | |_| | |_| | |___| |___ / ___ \| |\  |
prompt | |____/ \___/ \___/|_____|_____/_/   \_\_| \_|
prompt |                                              
pause
set echo on
clear screen

set echo on
set termout on
create table person (
  pid     int,
  married boolean);
pause
clear screen
insert into person values (1,true);
insert into person values (2,false);
pause
insert into person values (3,'on');
insert into person values (4,'OFF');
pause
insert into person values (5,1);
insert into person values (6,0);
pause
insert into person values (8,'Y');
insert into person values (9,'Yes');
pause
commit;
clear screen
select * from person;
pause
clear screen
select *
from person
where married 
 or pid = 2;
pause
select exists ( select 1 from emp);
pause
clear screen
create index person_bool_ix 
on person ( married );
pause
alter table person
add constraint person_chk check
 ( married or pid != 0 );
 pause
clear screen
declare
  b boolean;
begin
  select married 
  into b 
  from person 
  where rownum = 1;
end;
/
pause
declare
  b boolean := false;
begin
  insert into person 
  values (2,b);
end;
/
pause
clear screen
declare
  b boolean;
begin
  b := 1;
end;
.
pause
/
pause
clear screen
alter session set plsql_implicit_conversion_bool=true;
pause
declare
  b boolean;
begin
  b := 1;
end;
/
pause
declare
  b boolean;
begin
  b := 'Yes';
end;
/
pause
clear screen
set termout on
set echo off
prompt |
prompt |   ____ ____   ___  _   _ ____    ______   __
prompt |  / ___|  _ \ / _ \| | | |  _ \  | __ ) \ / /
prompt | | |  _| |_) | | | | | | | |_) | |  _ \\ V / 
prompt | | |_| |  _ <| |_| | |_| |  __/  | |_) || |  
prompt |  \____|_| \_\\___/ \___/|_|     |____/ |_|  
prompt |                                             
pause
set echo on
clear screen

set echo on
set termout on

clear screen
select deptno, count(*)
from   emp
group by deptno;
pause
select 
  case 
    when job = 'SALES' then trunc(sal/100)
    when hiredate > date '1981-02-01' then trunc(nvl(comm,300)/100)
    else ceil(sal/80)
  end bonus,
  count(*)
from   emp
#pause
group by 
  case 
    when job = 'SALES' then trunc(sal/100)
    when hiredate > date '1981-02-01' then trunc(nvl(comm,300)/100)
    else ceil(sal/80)
  end  -- make sure I remove 'bonus'
/  
pause
clear screen
select 
  case 
    when job = 'SALES' then trunc(sal/100)
    when hiredate > date '1981-02-01' then trunc(nvl(comm,300)/100)
    else ceil(sal/80)
  end bonus,
  count(*)
from   emp
group by bonus;
pause
select 
  case 
    when job = 'SALES' then trunc(sal/100)
    when hiredate > date '1981-02-01' then trunc(nvl(comm,300)/100)
    else ceil(sal/80)
  end bonus,
  count(*)
from   emp
group by bonus
having bonus != 5;
pause
clear screen
alter session set group_by_position_enabled = true;
pause
select 
  case 
    when job = 'SALES' then trunc(sal/100)
    when hiredate > date '1981-02-01' then trunc(nvl(comm,300)/100)
    else ceil(sal/80)
  end bonus,
  count(*)
from   emp
group by 1;
pause
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
pause

set termout off
clear screen
@drop myemp
create table myemp ( empno int, ename varchar2(10));
insert into myemp
values 
  (1,'JOHN'),
  (2,'SUE'),
  (3,'MARY'),
  (4,'JANE'),
  (5,'PETE');
commit;  

clear screen
set termout on
set echo off
prompt |
prompt |  ____  _____ _____ _   _ ____  _   _ ___ _   _  ____ 
prompt | |  _ \| ____|_   _| | | |  _ \| \ | |_ _| \ | |/ ___|
prompt | | |_) |  _|   | | | | | | |_) |  \| || ||  \| | |  _ 
prompt | |  _ <| |___  | | | |_| |  _ <| |\  || || |\  | |_| |
prompt | |_| \_\_____| |_|  \___/|_| \_\_| \_|___|_| \_|\____|
prompt |                                                      
prompt |
pause
set echo on
clear screen

set echo on
set termout on

select * from myemp;
pause
clear screen
variable newval varchar2(10);

update myemp
set ename = 'CONNOR'
where empno = 3
returning ename into :newval;
pause
print newval
pause
roll;
pause
clear screen
variable oldval varchar2(10);
update myemp
set ename = 'CONNOR'
where empno = 3
returning old ename, new ename
into :oldval, :newval;
pause
print newval
print oldval
pause
roll;
pause

clear screen
set termout on
set echo off
prompt |
prompt |  __  __ _____ ____ ____    _    ____ _____ ____  
prompt | |  \/  | ____/ ___/ ___|  / \  / ___| ____/ ___| 
prompt | | |\/| |  _| \___ \___ \ / _ \| |  _|  _| \___ \ 
prompt | | |  | | |___ ___) |__) / ___ \ |_| | |___ ___) |
prompt | |_|  |_|_____|____/____/_/   \_\____|_____|____/ 
prompt |                                                  
set echo on
pause
clear screen
conn scott/tiger@db19
pause
select deptno, job,  count(*)
from  emp
group by deptno;
pause

conn scott/tiger@db23
pause
select deptno, job,  count(*)
from  emp
group by deptno;
pause

clear screen
drop table if exists t purge;
create table t ( 
  x int, 
  constraint t_pk primary key ( x )
);
pause
insert into t values (1);
pause
insert into t values (1);
pause
