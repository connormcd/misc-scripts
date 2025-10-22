clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
alter system set max_columns = standard;
drop user jane_doe cascade;
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
prompt |      _ _   _ ____ _____   ____  _____ _     _____ ____ _____ 
prompt |     | | | | / ___|_   _| / ___|| ____| |   | ____/ ___|_   _|
prompt |  _  | | | | \___ \ | |   \___ \|  _| | |   |  _|| |     | |  
prompt | | |_| | |_| |___) || |    ___) | |___| |___| |__| |___  | |  
prompt |  \___/ \___/|____/ |_|   |____/|_____|_____|_____\____| |_|  
prompt |                                                              
pause
set echo on
clear screen
set echo on
set termout on
select sysdate form dual;
pause
select sysdate frmo dual;
pause
clear screen
select sysdate;
pause
select 1;
pause
select seq.nextval;
pause Done
set echo off
clear screen
--pro SQL> select sysdate from dual;
--pro select sysdate from dual
--pro                     *
--pro ERROR at line 1:
--pro ORA-00942: table or view does not exist
--pro SQL> 
--pause
--set echo on
--select sysdate from dual;
--pause Done
