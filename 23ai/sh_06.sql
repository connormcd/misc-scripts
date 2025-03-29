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
prompt |   ___  _   _ _____    _     ___ _   _ _____    ____  _______     __
prompt |  / _ \| \ | | ____|  | |   |_ _| \ | | ____|  |  _ \| ____\ \   / /
prompt | | | | |  \| |  _|    | |    | ||  \| |  _|    | | | |  _|  \ \ / / 
prompt | | |_| | |\  | |___   | |___ | || |\  | |___   | |_| | |___  \ V /  
prompt |  \___/|_| \_|_____|  |_____|___|_| \_|_____|  |____/|_____|  \_/   
prompt |                                                                  
prompt |
pause
set echo on
clear screen

set echo on
set termout on

set termout off
clear screen
conn dbdemo/dbdemo@db23
set termout on
set echo on

create user jane_doe identified by jane_doe;
pause
conn jane_doe/jane_doe@db23
pause
set termout off
clear screen
conn dbdemo/dbdemo@db23
set termout on
set echo on
grant create session to jane_doe;
pause
conn jane_doe/jane_doe@db23
pause
create table stuff ( x int );
pause

set termout off
clear screen
conn dbdemo/dbdemo@db23
set termout on
set echo on
grant db_developer_role to jane_doe;
pause

conn jane_doe/jane_doe@db23
pause
select *
from  session_privs;
pause
set echo off
clear screen
pro |
pro | What about existing scripts?
pro |
pause
pro |
pro | GRANT RESOURCE, CONNECT TO JANE_DOE
pro |
pause
set termout off
conn dbdemo/dbdemo@db23
set termout off
set echo on
set termout on
clear screen
select privilege 
from dba_sys_privs
where grantee = 'RESOURCE';
pause
set termout off
set echo off
clear screen
conn dbdemo/dbdemo@db23
set termout on
set echo off
prompt |     _____  _____ _    _ ______ __  __             _____  _____  _______      __
prompt |    / ____|/ ____| |  | |  ____|  \/  |   /\      |  __ \|  __ \|_   _\ \    / /
prompt |   | (___ | |    | |__| | |__  | \  / |  /  \     | |__) | |__) | | |  \ \  / / 
prompt |    \___ \| |    |  __  |  __| | |\/| | / /\ \    |  ___/|  _  /  | |   \ \/ /  
prompt |    ____) | |____| |  | | |____| |  | |/ ____ \   | |    | | \ \ _| |_   \  /   
prompt |   |_____/ \_____|_|  |_|______|_|  |_/_/    \_\  |_|    |_|  \_\_____|   \/    
prompt |                                                                                
pause
set echo on
clear screen
select table_name
from   dba_tables
where  owner = 'HR'
order by 1;
pause
clear screen
grant select on HR.COUNTRIES   to jane_doe;
pause
grant select on HR.REGIONS     to jane_doe;
pause
grant select on HR.LOCATIONS   to jane_doe;
grant select on HR.DEPARTMENTS to jane_doe;
grant select on HR.JOBS        to jane_doe;
grant select on HR.EMPLOYEES   to jane_doe; 
grant select on HR.JOB_HISTORY to jane_doe; 
pause
clear screen
grant select any table
  on schema hr
  to jane_doe;
pause
create table hr.new_table as
select * from scott.emp;
pause
conn jane_doe/jane_doe@db23
pause
select * from hr.new_table;

pause Done
