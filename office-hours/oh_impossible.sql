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
clear screen
@clean
conn SYSTEM_USER/PASSWORD@DB_SERVICE11G 
set termout off
drop user demo cascade;
drop user demo1 cascade;
set termout on
conn USER/PASSWORD@MY_PDB
set termout off
drop user demo cascade;
drop user demo1 cascade;
set termout on
col name format a30
col password format a60
col spare4 format a40 wrap
col ddl format a72 wrap
clear screen
set feedback on
set echo on
conn SYS_USER/PASSWORD@MY_PDB as sysdba
create user demo identified by demo;
pause
alter user demo account lock;
pause
conn demo/demo@DB_SERVICE
pause
clear screen
conn SYS_USER/PASSWORD@DB_SERVICE11G  as sysdba
select banner from v$version
where rownum = 1;
pause
create user demo identified by demo;
pause
select password from dba_users
where username ='DEMO';
pause
select password from sys.user$
where name ='DEMO';
pause
clear screen
alter user demo identified by values 'impossiblehash';
pause
conn demo/demo@DB_SERVICE11G
pause
clear screen
conn SYS_USER/PASSWORD@MY_PDB as sysdba
select banner from v$version
where rownum = 1;
pause
alter user demo identified by values 'impossiblehash';
pause
clear screen
clear screen
select name,password
from sys.user$
where name in (
  'DEMO',
  'APEX_240100',
  'APEX_PUBLIC_USER');
pause
desc sys.user$
pause
clear screen
select name,spare4
from sys.user$
where name in (
  'DEMO',
  'APEX_240100',
  'APEX_PUBLIC_USER');
pause
clear screen
set long 5000
select dbms_metadata.get_ddl('USER','APEX_PUBLIC_USER') ddl from dual;
pause
select dbms_metadata.get_ddl('USER','DEMO') ddl from dual;
pause
clear screen
alter user demo account unlock;
alter user demo identified by values 
  'S:000000000000000000000000000000000000000000000000000000000000;T:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000';
pause
conn demo/demo@DB_SERVICE
pause
clear screen
conn SYSTEM_USER/PASSWORD@DB_SERVICE
drop user demo cascade;
pause
create user demo no authentication;
pause
alter user demo no authentication;
pause
conn demo/demo@DB_SERVICE
pause
clear screen
conn SYSTEM_USER/PASSWORD@DB_SERVICE
create user demo1;
pause
grant create session to demo1;
pause
alter user demo1 grant connect through scott;
pause
conn scott[demo1]/tiger@DB_SERVICE
show user

