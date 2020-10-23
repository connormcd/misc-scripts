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
conn USER/PASSWORD@MY_DB
set termout off
clear screen
col owner format a20
set lines 200
set long 500000
set longchunksize 1000
set pages 999
col ddl format a90 wrap
set lines 80
set echo on
set termout on
show user
pause
desc DBA_SOURCE
pause
set lines 200
clear screen
select dbms_metadata.get_ddl('VIEW','DBA_SOURCE','SYS') ddl from dual

pause
/
pause
select owner, object_name, object_type
from dba_objects
where object_name = 'DBA_SOURCE'
and owner = 'SYS';
pause
clear screen
select object_type, sharing
from dba_objects
where object_name = 'DBA_SOURCE'
and owner = 'SYS';
pause

conn /@MY_DB as sysdba
pause
clear screen
select dbms_metadata.get_ddl('VIEW','DBA_SOURCE','SYS') ddl from dual;
pause

clear screen
conn / as sysdba
pause
set termout off
set lines 200
set long 500000
set longchunksize 1000
set pages 999
col ddl format a90 wrap
set termout on
select dbms_metadata.get_ddl('VIEW','DBA_SOURCE','SYS') ddl from dual;
pause
clear screen
select dbms_metadata.get_ddl('VIEW','INT$DBA_SOURCE','SYS') ddl from dual;
pause

clear screen
set termout on
create or replace
view MY_VIEW sharing=metadata as 
select username, created
from   dba_users

pause
/
pause
alter session set "_oracle_script"=true;
pause
create or replace
view MY_VIEW sharing=metadata as 
select username, created
from   dba_users;
pause
clear screen
alter session set container = pdb1;
pause
desc sys.my_view
pause
create or replace
view MY_VIEW sharing=metadata as 
select username, created
from   dba_users;
pause
clear screen
select dbms_metadata.get_ddl('VIEW','MY_VIEW','SYS') ddl from dual

pause
/
pause
select object_type, sharing
from dba_objects
where object_name = 'MY_VIEW'
and owner = 'SYS';
pause
select * from MY_VIEW
where rownum <= 10;
pause
clear screen
create or replace
view MY_VIEW sharing=metadata as 
select username, created
from   dba_users
where  username like 'S%';
pause
select object_type, sharing
from dba_objects
where object_name = 'MY_VIEW'
and owner = 'SYS';
pause
clear screen
create or replace
view MY_VIEW sharing=metadata as 
select username, created
from   dba_users;
pause
select object_type, sharing
from dba_objects
where object_name = 'MY_VIEW'
and owner = 'SYS';
pause
clear screen
alter session set container = cdb$root;
pause
drop view my_view;
pause
alter session set container = pdb1;
pause
desc my_view
pause
drop view my_view;


