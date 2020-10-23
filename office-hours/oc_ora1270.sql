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
drop database link dead;
@drop link_checker
@clean
set echo on
set termout on
host tail -24 "C:\oracle\product\18\network\admin\tnsnames.ora"
pause
host tnsping dead
pause
clear screen
create database link dead using 'dead';
pause
begin
  for i in ( select * from tab@dead ) 
  loop
     null;
  end loop;
end;
/
pause
clear

set serverout on
declare
  cannot_get_there exception;
  pragma exception_init(cannot_get_there,-12154);
begin
  for i in ( select * from tab@dead ) 
  loop
     null;
  end loop;
exception
  when cannot_get_there then 
     dbms_output.put_line('He''s dead Jim');
end;
.
pause
/
clear screen
--
-- GOAL
--   1) tnsping the target
--   2) if good, then proceed
--   3) if not, then bypass
--
-- CHALLENGE - HOW TO TNSPING ?
--
pause

create or replace
procedure set_link_name(p_link varchar2) is
  f utl_file.file_type;
begin
  f := utl_file.fopen('TEMP','linkname.txt','W');
  utl_file.put_line(f,p_link);
  utl_file.fclose(f);
end;
/
pause

exec set_link_name('db18');
pause
host cat c:\temp\linkname.txt
pause

create table link_checker( result varchar2(512) )
organization external
(
  type oracle_loader
  default directory temp
  access parameters
  (
    records delimited by newline
    preprocessor temp:'tns_test.cmd'
    FIELDS ( result (01:512) char(512) )
  )
location ('linkname.txt') 
)
/
pause
host cat c:\temp\tns_test.cmd
pause

clear screen
select * from link_checker

pause
/
pause

exec set_link_name('dead');
pause
select * from link_checker

pause
/





