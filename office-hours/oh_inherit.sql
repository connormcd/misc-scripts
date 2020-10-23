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
conn USER/PASSWORD
grant dba to sysadmin identified by sysadmin;
grant inherit privileges on user sysadmin to public;
clear screen
set echo on
set termout on
conn scott/tiger
show user
drop table t purge;
create table t ( x int );
grant select on t to public;
pause
clear screen
create or replace
procedure MY_PROC authid current_user is
  v int;
begin
  select 1/count(*) into v from scott.t;
end;
/
pause
exec scott.my_proc
pause
clear screen

set echo off
clear screen
set pages 0
select q'{               _.===========================._ }'from dual union all
select q'{            .'`  .-  - __- - - -- --__--- -.  `'.}'from dual union all
select q'{        __ / ,'`     _|--|_________|--|_     `'. \}'from dual union all
select q'{      /'--| ;    _.'\ |  '         '  | /'._    ; |}'from dual union all
select q'{     //   | |_.-' .-'.'    -  -- -    '.'-. '-._| |}'from dual union all
select q'{    (\)   \"` _.-` /                     \ `-._ `"/}'from dual union all
select q'{    (\)    `-`    /      .---------.      \    `-`}'from dual union all
select q'{    (\)           |      ||1||2||3||      |}'from dual union all
select q'{   (\)            |      ||4||5||6||      |}'from dual union all
select q'{  (\)             |      ||7||8||9||      |}'from dual union all
select q'{ (\)           ___|      ||*||0||#||      |}'from dual union all
select q'{ (\)          /.--|      '---------'      |}'from dual union all
select q'{  (\)        (\)  |\_  _  __   _   __  __/|}'from dual union all
select q'{ (\)        (\)   |                       |}'from dual union all
select q'{(\)_._._.__(\)    |                       |}'from dual union all
select q'{ (\\\\   \\\)      '.___________________.'}'from dual union all
select q'{  '-'-'-'--'}'from dual;
set pages 999
set echo on
pause
clear screen
conn sysadmin/sysadmin
pause
exec scott.my_proc
pause
clear screen
conn scott/tiger
pause
create or replace
procedure MY_PROC authid current_user is
  v int;
begin
  execute immediate 'grant dba to scott';
  select 1/count(*) into v from scott.t;
end;
/
pause
clear screen
set echo off
clear screen
set pages 0
select q'{               _.===========================._ }'from dual union all
select q'{            .'`  .-  - __- - - -- --__--- -.  `'.}'from dual union all
select q'{        __ / ,'`     _|--|_________|--|_     `'. \}'from dual union all
select q'{      /'--| ;    _.'\ |  '         '  | /'._    ; |}'from dual union all
select q'{     //   | |_.-' .-'.'    -  -- -    '.'-. '-._| |}'from dual union all
select q'{    (\)   \"` _.-` /                     \ `-._ `"/}'from dual union all
select q'{    (\)    `-`    /      .---------.      \    `-`}'from dual union all
select q'{    (\)           |      ||1||2||3||      |}'from dual union all
select q'{   (\)            |      ||4||5||6||      |}'from dual union all
select q'{  (\)             |      ||7||8||9||      |}'from dual union all
select q'{ (\)           ___|      ||*||0||#||      |}'from dual union all
select q'{ (\)          /.--|      '---------'      |}'from dual union all
select q'{  (\)        (\)  |\_  _  __   _   __  __/|}'from dual union all
select q'{ (\)        (\)   |                       |}'from dual union all
select q'{(\)_._._.__(\)    |                       |}'from dual union all
select q'{ (\\\\   \\\)      '.___________________.'}'from dual union all
select q'{  '-'-'-'--'}'from dual;
set pages 999
set echo on
pause
clear screen

conn sysadmin/sysadmin
pause
exec scott.my_proc
pause
clear screen

conn scott/tiger
pause
select * from session_roles;
pause
clear screen

conn sysadmin/sysadmin
pause
revoke dba from scott;
pause

revoke inherit privileges on user sysadmin from public;
pause

exec scott.my_proc

