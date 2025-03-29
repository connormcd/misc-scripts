clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
alter system set max_columns = standard;
purge recyclebin;
drop user jane_doe cascade;
@drop credit_card
@drop DEPT_DOC
@drop CARS
drop domain amex ;
drop domain bigcase;
@drop emp_contractors
drop domain emp_contract;
@drop emp2
drop table hr.new_table purge;
alter session set group_by_position_enabled = false;
@drop t
@drop person
@drop seq
@drop myemp
@drop people
create or replace
function my_plsql_func return number is
begin
  return 10;
end;
/
create sequence seq;

col first_lob new_value address_lob format a30
col second_lob new_value headshot_lob format a30

clear screen
set termout on
set echo off
prompt |
prompt |  _      ____  ____      _____  ______ _   _          __  __ ______ 
prompt | | |    / __ \|  _ \    |  __ \|  ____| \ | |   /\   |  \/  |  ____|
prompt | | |   | |  | | |_) |   | |__) | |__  |  \| |  /  \  | \  / | |__   
prompt | | |   | |  | |  _ <    |  _  /|  __| | . ` | / /\ \ | |\/| |  __|  
prompt | | |___| |__| | |_) |   | | \ \| |____| |\  |/ ____ \| |  | | |____ 
prompt | |______\____/|____/    |_|  \_\______|_| \_/_/    \_\_|  |_|______|
prompt |                                                                    
pause
set echo on
clear screen
create table people 
( pk       int,
  name     varchar2(20),
  address  clob,
  gender   varchar2(20),
  headshot blob
);
pause
insert into people
values (1,'Bailey','100 Oracle Way',
          'Not Specified',hextoraw('FF1267347612'));
commit;
pause
clear screen
select segment_name
from   user_segments
where  segment_name like 'SYS%$$';
pause
clear screen
select column_name, segment_name first_lob
from   user_lobs
where  table_name = 'PEOPLE'
and    column_name = 'ADDRESS';
pause
select column_name, segment_name second_lob
from   user_lobs
where  table_name = 'PEOPLE'
and    column_name = 'HEADSHOT';
pause
select object_id
from   user_objects
where  object_name = 'PEOPLE';
pause
set verify off
clear screen
alter table people
  rename lob(address) &&address_lob to people_col_clob_address;
pause
alter table people
  rename lob(headshot) &&headshot_lob to people_col_blob_headshot;
pause  
clear screen
select column_name, segment_name first_lob
from   user_lobs
where  table_name = 'PEOPLE'
and    column_name = 'ADDRESS';
pause
select column_name, segment_name second_lob
from   user_lobs
where  table_name = 'PEOPLE'
and    column_name = 'HEADSHOT';
pause

pause Done

