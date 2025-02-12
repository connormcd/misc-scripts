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
@clean
set termout off
conn USER/PASSWORD@MY_PDB
set termout off
noaudit not exists;
drop trigger audit_not_exists;
clear screen
col high_value format a20
set timing off
noaudit policy ua_alter_table;
noaudit policy ua_hr_select by hr;
noaudit policy ua_scott_select by scott;
drop audit policy ua_alter_table;
drop audit policy ua_hr_select;
drop audit policy ua_scott_select;

set time off
set pages 999
set lines 200
set termout on
clear screen
set feedback on
set echo on
conn SYSTEM_USER/PASSWORD@DB_SERVICE
audit select table by scott;
pause
audit select on hr.employees;
pause
audit select on hr.employees_seq;
pause
audit alter table whenever successful;
pause
audit not exists by access;
pause
clear screen
--
-- MOS 2909718.1
--
-- @audconvert.sql
--
pause
create audit policy ua_scott_select actions select;
create audit policy ua_hr_select actions 
  select on hr.employees, select on hr.employees_seq;
create audit policy ua_alter_table actions alter table;
pause
clear screen
audit policy ua_alter_table except sys,syskm,sysbackup,sysdg;
audit policy ua_hr_select by hr;
audit policy ua_scott_select by scott;
pause
noaudit select table by scott;
noaudit select on hr.employees;
noaudit select on hr.employees_seq;
pause
clear screen
--
--
--
-- (1) audit select table by scott;
-- (2) audit select on hr.employees;
-- (3) audit select on hr.employees_seq;
-- (4) audit alter table whenever successful;
-- (5) audit not exists;
--
pause
--
-- create audit policy ua_scott_select actions select; (1)
-- create audit policy ua_hr_select actions 
--   select on hr.employees, select on hr.employees_seq;  (2),(3)
-- create audit policy ua_alter_table actions alter table;  (4)
--
pause
clear screen
audit not exists by access;
pause
conn scott/tiger@DB_SERVICE
select * from dept;
select * from qweqweqwe;
pause
clear screen
conn SYSTEM_USER/PASSWORD@DB_SERVICE
noaudit not exists;
pause
select * 
from dba_audit_exists 
where extended_timestamp > sysdate - 600/86400
order by extended_timestamp
@pr
pause
clear screen
conn SYS_USER/PASSWORD as sysdba
set long 5000
select dbms_metadata.get_ddl('VIEW','DBA_AUDIT_EXISTS','SYS')
from dual;
pause
clear screen
conn SYSTEM_USER/PASSWORD@DB_SERVICE
create or replace 
trigger audit_not_exists
after servererror on database
begin
  if is_servererror(942)  or
     is_servererror(942)  or
     is_servererror(959)  or
     is_servererror(1418) or
     is_servererror(1432) 
  then
    null;
    -- insert into my_audit_trail 
    -- values ( .... );
  end if;
end;
/
pause
drop trigger audit_not_exists;

