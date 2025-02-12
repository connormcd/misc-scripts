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
host del /q x:\temp\demo1.dmp
drop user demo1 cascade;
drop user demo2 cascade;
set lines 140
set termout on
clear screen
set echo on
create user demo1 identified by demo1;
create user demo2 identified by demo2;
pause
clear screen
grant
 set container
,create procedure
,create sequence
,create session
,create operator
,create cluster
,create trigger
,create view
,create table
,create type
to demo1;

grant
 set container
,create procedure
,create sequence
,create session
,create operator
,create cluster
,create trigger
,create view
,create table
,create type
to demo2;
pause
clear screen
alter user demo1 quota 200m on users;
alter user demo2 quota 200m on users;
grant read, write on directory temp to demo1;
grant read, write on directory temp to demo2;
pause
clear screen
create table demo1.emp as select * from scott.emp;
pause
create or replace
function demo1.get_modified_sal(p_sal number) 
return number deterministic is
begin
  return p_sal+100;
end;
/
pause
alter table demo1.emp
  add new_sal number generated always as ( get_modified_sal(sal) ) ;
pause
clear screen
select empno, ename, sal, new_sal
from demo1.emp;
pause
host expdp userid=demo1/demo1@DB_SERVICE directory=temp dumpfile=demo1
pause
host impdp userid=demo2/demo2@DB_SERVICE directory=temp dumpfile=demo1.dmp remap_schema=demo1:demo2
pause
clear screen
select object_name, object_type
from dba_objects
where owner = 'DEMO2';
pause
alter table demo2.emp
  add new_sal number generated always as ( get_modified_sal(sal) ) ;
pause
set lines 60
desc demo2.emp
pause
set lines 100
clear screen
select dbms_metadata.get_ddl('TABLE','EMP','DEMO2') from dual;
pause
alter table demo2.emp
  drop column new_sal ;
pause
alter table demo2.emp
  add new_sal number generated always as ( get_modified_sal(sal) ) ;

