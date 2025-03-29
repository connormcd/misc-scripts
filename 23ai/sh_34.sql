clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
alter system set max_columns = standard;
drop user jane_doe cascade;
alter session set read_only = false;
drop domain amex ;
@drop credit_card
@drop emp2
drop table hr.new_table purge;
alter session set group_by_position_enabled = false;
@drop t
@drop person
@drop seq
@drop myemp
create or replace
function my_plsql_func return number is
begin
  return 10;
end;
/
create sequence seq;
clear screen
set termout on
set echo off
prompt |
prompt |
prompt |  _____  ____  __  __  _____    _    _  _____ _    _ ______ _____ _  __
prompt | |  __ \|  _ \|  \/  |/ ____|  | |  | |/ ____| |  | |  ____/ ____| |/ /
prompt | | |  | | |_) | \  / | (___    | |__| | |    | |__| | |__ | |    | ' / 
prompt | | |  | |  _ <| |\/| |\___ \   |  __  | |    |  __  |  __|| |    |  <  
prompt | | |__| | |_) | |  | |____) |  | |  | | |____| |  | | |___| |____| . \ 
prompt | |_____/|____/|_|  |_|_____/   |_|  |_|\_____|_|  |_|______\_____|_|\_\
prompt |                                                                      
pause
set echo on
clear screen
set echo on
set termout on
set serveroutput on size unlimited
execute sys.dbms_hcheck.critical
pause
REM
REM  s/dbms_hcheck/dbms_dictionary_check
REM
pause
execute sys.dbms_dictionary_check.critical

pause Done
