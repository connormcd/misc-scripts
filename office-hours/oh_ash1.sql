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
conn / as sysdba
set termout off
alter system set "_ash_disk_filter_ratio" = 1;
@clean
set termout on
set echo on
clear screen
conn scott/tiger@DATABASE_SERVICE
pause
alter session set nls_date_format = 'dd/mm/yyyy hh24:mi:ss';
select uid from dual;
select sysdate from dual;
pause
clear screen
set echo off
pro
pro When we press ENTER, check the time and then we immediately
pro will start a long running SQL
pro
pro Get session 2 ready!
pro
set echo on
pause
select sysdate from dual;
select count(*) from
  all_objects a,
 ( select rownum x from dual connect by level <= 50 )
where a.object_id > x;

