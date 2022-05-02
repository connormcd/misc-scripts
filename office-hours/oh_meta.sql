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
conn USERNAME/PASSWORD@SERVICE_NAME
set termout off
col granted_role format a40
drop table scott.emp2 purge;
drop table myuser.emp2 purge;
drop user power_user cascade;
set serverout off
set termout on
set echo on
clear screen
create table scott.emp2 as
select * from scott.emp;
pause
create table myuser.emp2 as
select * from scott.emp;
pause
clear screen
conn scott/tiger@SERVICE_NAME
pause
select dbms_metadata.get_ddl('TABLE','EMP2','SCOTT') 
from dual;
pause
clear screen
show user
select dbms_metadata.get_ddl('TABLE','EMP2','MYUSER') 
from dual

pause
/
pause
clear screen

conn /@SERVICE_NAME as sysdba
pause
grant select any table to scott;
pause
clear screen
conn scott/tiger@SERVICE_NAME
pause
select * from myuser.emp2;
pause
select dbms_metadata.get_ddl('TABLE','EMP2','MYUSER') 
from dual;
pause

clear screen
conn /@SERVICE_NAME as sysdba
pause
grant select any dictionary to scott;
pause
clear screen
conn scott/tiger@SERVICE_NAME
pause
select count(*) from dba_users;
select count(*) from dba_tables;
select count(*) from dba_tab_columns;
pause
clear screen
select dbms_metadata.get_ddl('TABLE','EMP2','MYUSER') 
from dual

pause
/
pause


clear screen
conn /@SERVICE_NAME as sysdba
pause
revoke select any table from scott;
revoke select any dictionary from scott;
pause1
grant select_catalog_role to scott;
pause
clear screen
conn scott/tiger@SERVICE_NAME
pause
select * from myuser.emp2;
pause
select dbms_metadata.get_ddl('TABLE','EMP2','MYUSER') 
from dual;
pause
clear screen

conn / as sysdba
pause
select granted_role
from   dba_role_privs
where  grantee = 'SELECT_CATALOG_ROLE';
pause

select granted_role
from   dba_role_privs
where  grantee = 'HS_ADMIN_SELECT_ROLE';
pause

select privilege
from   dba_sys_privs
where  grantee in ('SELECT_CATALOG_ROLE','HS_ADMIN_SELECT_ROLE');
pause
clear screen
select object_name from dba_objects
where object_name like 'KU$%'
order by 1

pause
/
pause
clear screen

select dbms_metadata.get_ddl('VIEW','KU$_PROC_VIEW','SYS') 
from dual;
pause

select dbms_metadata.get_ddl('VIEW','KU$_BASE_PROC_VIEW','SYS') 
from dual;
pause
clear screen

conn scott/tiger@SERVICE_NAME
pause
create or replace
procedure get_the_ddl(p_user varchar2) is
  x clob;
begin
  x := dbms_metadata.get_ddl('TABLE','EMP2',p_user);
end;
/
pause
exec get_the_ddl('SCOTT');
pause
clear screen
select dbms_metadata.get_ddl('TABLE','EMP2','MYUSER') 
from dual;
pause
exec get_the_ddl('MYUSER');
pause
clear screen

create or replace
procedure get_the_ddl(p_user varchar2) AUTHID CURRENT_USER is
  x clob;
begin
  x := dbms_metadata.get_ddl('TABLE','EMP2',p_user);
end;
/
pause
exec get_the_ddl('SCOTT');
pause
exec get_the_ddl('MYUSER');
pause
clear screen


conn /@SERVICE_NAME as sysdba
revoke select_catalog_role from scott;
pause

create user power_user identified by power_user;
grant connect, select_catalog_role to power_user;
pause
create or replace
procedure power_user.get_the_ddl(p_user varchar2) is
  x clob;
begin
  x := dbms_metadata.get_ddl('TABLE','EMP2',p_user);
end;
/
pause
grant execute on power_user.get_the_ddl to scott, asktom;
pause
clear screen


conn scott/tiger@SERVICE_NAME
pause
exec power_user.get_the_ddl('SCOTT');
pause
clear screen

conn /@SERVICE_NAME as sysdba
pause
create or replace
procedure power_user.get_the_ddl(p_user varchar2) AUTHID CURRENT_USER is
  x clob;
begin
  x := dbms_metadata.get_ddl('TABLE','EMP2',p_user);
end;
/
grant execute on power_user.get_the_ddl to scott, asktom;
pause
clear screen

conn scott/tiger@SERVICE_NAME
pause
exec power_user.get_the_ddl('SCOTT');
pause
exec power_user.get_the_ddl('MYUSER');
set echo off
pro ==========================
pro BACK TO SLIDES
pro ==========================
pro
pause
set echo on
clear screen
conn /@SERVICE_NAME as sysdba

create or replace
procedure scott.get_my_ddl is
  x clob;
begin
  x := dbms_metadata.get_ddl('TABLE','EMP2','SCOTT');
end;
/
grant execute on scott.get_my_ddl to asktom;
pause
create or replace
procedure myuser.get_my_ddl is
  x clob;
begin
  x := dbms_metadata.get_ddl('TABLE','EMP2','MYUSER');
end;
/
grant execute on myuser.get_my_ddl to scott;
pause
clear screen
conn scott/tiger@SERVICE_NAME
exec get_my_ddl;
exec myuser.get_my_ddl;
rem
rem cleanup
rem
pause
drop procedure GET_MY_DDL;
drop procedure GET_THE_DDL;

