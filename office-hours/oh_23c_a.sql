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
set termout off
alter session set nls_date_format = 'DD-MON-RR';
alter session set cursor_sharing = exact;
alter session disable parallel dml;
set markup csv off
set markup html off
set autotrace off
set timing off
set sqlprompt 'SQL> '
set echo off
set feedback on
clear screen
set heading on
set termout on
set define '&'
set tab off
set long 50000
set longchunksize 500
set pages 999
undefine 1
undefine 2
undefine 3
undefine 4

set termout off
conn ADMIN_USER/PASSWORD@MY_DB
set termout off
alter system set max_columns = standard;
alter session set group_by_position_enabled = false;
drop sequence seq;
create sequence seq;
create or replace
function my_plsql_func return number is
begin
  return 10;
end;
/
create sequence seq;
clear screen
set echo on
set termout on
select sysdate form dual;
pause
select sysdate;
pause
select 1;
pause
select seq.nextval;
pause
clear screen
select 100/20;
pause
select rownum
connect by level <= 5;
pause
select my_plsql_func();
pause
select sysdate from dual;
pause
set autotrace traceonly explain
pause
select sysdate from dual;
set autotrace off


