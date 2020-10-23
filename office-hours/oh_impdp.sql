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
set echo on

conn scott/tiger@MY_PDB
pause
create or replace procedure scott.my_proc is
begin
  null;
end;
/
pause
select     table_name, num_rows,blocks
from       user_tables;
select text from user_source;
pause
host del /q c:\temp\scott.dmp
host expdp scott/tiger@MY_PDB dumpfile=scott directory=temp
pause
clear screen
drop table BONUS cascade constraints purge;
drop table DEPT cascade constraints purge;
drop table EMP cascade constraints purge;
drop table SALGRADE cascade constraints purge;
drop procedure MY_PROC;
pause
select * from obj;
pause
clear screen
host impdp scott/tiger@MY_PDB dumpfile=scott directory=temp content=metadata_only
pause
select     table_name, num_rows,blocks
from       user_tables;
pause
select text from user_source;
pause
clear screen
drop table BONUS cascade constraints purge;
drop table DEPT cascade constraints purge;
drop table EMP cascade constraints purge;
drop table SALGRADE cascade constraints purge;
drop procedure MY_PROC;
pause

host impdp scott/tiger@MY_PDB dumpfile=scott directory=temp rows=n 
pause

select     table_name, num_rows,blocks
from       user_tables;
select text from user_source;
pause
select * from emp;
pause
clear screen
drop table BONUS cascade constraints purge;
drop table DEPT cascade constraints purge;
drop table EMP cascade constraints purge;
drop table SALGRADE cascade constraints purge;
drop procedure MY_PROC;
pause

host impdp scott/tiger@MY_PDB dumpfile=scott directory=temp rows=n statistics=none
pause
select     table_name, num_rows,blocks
from       user_tables;
pause
clear screen
drop table BONUS cascade constraints purge;
drop table DEPT cascade constraints purge;
drop table EMP cascade constraints purge;
drop table SALGRADE cascade constraints purge;
drop procedure MY_PROC;
pause

host impdp scott/tiger@MY_PDB dumpfile=scott directory=temp rows=n exclude=statistics
pause

select     table_name, num_rows,blocks
from       user_tables;
pause

--
-- cleanup
--
pause
set termout off
drop table BONUS cascade constraints purge;
drop table DEPT cascade constraints purge;
drop table EMP cascade constraints purge;
drop table SALGRADE cascade constraints purge;
drop procedure MY_PROC;
set termout on
host impdp scott/tiger@MY_PDB dumpfile=scott directory=temp 

