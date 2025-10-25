clear screen
@clean
set termout off
conn sys/SYSTEM_PASSWORD@db19 
set termout off
grant select on scott.emp to public;
drop user redact_admin cascade;
drop user redact_user  cascade;
conn sys/SYSTEM_PASSWORD@db23 
set termout off
grant select on scott.emp to public;
drop user redact_admin cascade;
drop user redact_user  cascade;
set verify off
set termout on
set echo off
prompt |
prompt |    
prompt |      _____  ______ _____          _____ _______ _____ ____  _   _ 
prompt |     |  __ \|  ____|  __ \   /\   / ____|__   __|_   _/ __ \| \ | |
prompt |     | |__) | |__  | |  | | /  \ | |       | |    | || |  | |  \| |
prompt |     |  _  /|  __| | |  | |/ /\ \| |       | |    | || |  | | . ` |
prompt |     | | \ \| |____| |__| / ____ \ |____   | |   _| || |__| | |\  |
prompt |     |_|  \_\______|_____/_/    \_\_____|  |_|  |_____\____/|_| \_|
prompt |                                                                   
prompt |                                                          
prompt |   
pause
set echo on
clear screen
conn dbdemo/dbdemo@db19
pause
clear screen
conn sys/SYSTEM_PASSWORD@db19 
create user redact_admin identified by redact_admin;
grant resource, connect, create view to redact_admin;
alter user redact_admin quota 100m on users;
pause
create user redact_user identified by redact_user;
grant create session to redact_user;
pause
grant execute on dbms_redact to redact_admin;
pause
conn sys/SYS_PASSWORD@db19 as sysdba
grant execute on dbms_redact to redact_admin;
pause
clear screen
conn redact_admin/redact_admin@db19
pause
create table redact_admin.emp 
as select * from scott.emp;
pause
grant select on emp to redact_user;
pause
clear screen
begin
  dbms_redact.add_policy(
    object_schema => 'redact_admin',
    object_name   => 'emp',
    COLUMN_NAME   => 'SAL',
    policy_name   => 'hide_details',
    FUNCTION_TYPE => DBMS_REDACT.NULLIFY,
    expression    => q'{sys_context('userenv','session_user') != 'REDACT_ADMIN'}'
  );
end;
/
pause
begin
  dbms_redact.alter_policy(
    object_schema => 'redact_admin',
    object_name   => 'emp',
    COLUMN_NAME   => 'ENAME',
    policy_name   => 'hide_details',
    FUNCTION_TYPE => DBMS_REDACT.RANDOM,
    expression    => q'{sys_context('userenv','session_user') != 'REDACT_ADMIN'}'
  );
end;
/
pause
clear screen
show user
pause
select * from emp;
pause
clear screen
conn redact_user/redact_user@db19
pause
select * from redact_admin.emp;
pause
clear screen
conn redact_admin/redact_admin@db19
pause
alter table emp 
 add bonus number as ( sal*1.1 );
pause
create index emp_faster_lookup on emp ( upper(ename));
pause
clear screen
select 
  dbms_stats.create_extended_stats(
    user,
    'emp2',
    '(ENAME,DEPTNO)'
  ) from dual;
pause
create table emp2 as select * from emp;  
pause
clear screen
create view emp_view as
select e.*, sal*0.1 bonus
from emp e;
pause
select * from emp_view;
pause
clear screen
conn redact_user/redact_user@db19
pause
select sum(sal) from redact_admin.emp;
pause
select x
from
( select max(sal) x from redact_admin.emp );  
pause
select deptno, max(sal) sal
from redact_admin.emp
group by deptno;
pause
clear screen
select distinct sal
from
( select deptno, max(sal) sal
  from redact_admin.emp
  group by deptno
);  
pause
select distinct ename
from redact_admin.emp;
pause
select distinct ename
from redact_admin.emp
order by 1;
pause
clear screen
conn sys/SYSTEM_PASSWORD@db23
create user redact_admin identified by redact_admin;
grant db_developer_role to redact_admin;
alter user redact_admin quota 100m on users;
pause
grant administer redaction policy to  redact_admin;
pause
create user redact_user identified by redact_user;
grant create session to redact_user;
pause
grant select any table on schema redact_admin to redact_user;
pause

clear screen
conn redact_admin/redact_admin@db23
pause
create table redact_admin.emp as select * from scott.emp;
pause
begin
  dbms_redact.add_policy(
    object_schema => 'redact_admin',
    object_name   => 'emp',
    COLUMN_NAME   => 'SAL',
    policy_name   => 'hide_details',
    FUNCTION_TYPE => DBMS_REDACT.NULLIFY,
    expression    => q'{sys_context('userenv','session_user') != 'REDACT_ADMIN'}'
  );
end;
/
pause
begin
  dbms_redact.alter_policy(
    object_schema => 'redact_admin',
    object_name   => 'emp',
    COLUMN_NAME   => 'ENAME',
    policy_name   => 'hide_details',
    FUNCTION_TYPE => DBMS_REDACT.RANDOM--,
    --expression    => ...
  );
end;
/
pause
select * from emp;
pause
clear screen
conn redact_user/redact_user@db23
pause
select * from redact_admin.emp;
pause
clear screen
conn redact_admin/redact_admin@db23
pause
alter table emp 
 add bonus number as ( sal*1.1 );
pause
create index emp_faster_lookup on emp ( upper(ename));
pause
select 
  dbms_stats.create_extended_stats(
    user,
    'emp',
    '(ENAME,DEPTNO)'
  ) from dual;
pause
clear screen
create view emp_view as
select e.*, sal*0.1 bonus2
from emp e;
pause
select * from emp_view;
pause
clear screen
conn redact_user/redact_user@db23
pause
select * from redact_admin.emp;
pause
select * from redact_admin.emp_view;
pause
clear screen
select sum(sal) from redact_admin.emp;
pause
select x
from
( select max(sal) x from redact_admin.emp );  
pause
clear screen
select deptno, max(sal) sal
from redact_admin.emp
group by deptno;
pause
select distinct sal
from
( select deptno, max(sal) sal
  from redact_admin.emp
  group by deptno
);  
pause
clear screen
select distinct ename
from redact_admin.emp;
pause
select distinct ename
from redact_admin.emp
order by 1;

pause Done


