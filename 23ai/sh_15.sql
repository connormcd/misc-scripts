clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
alter system set max_columns = standard;
drop user jane_doe cascade;
drop domain amex ;
@drop t1
@drop credit_card
@drop emp2
drop table hr.new_table purge;
alter session set group_by_position_enabled = false;
@drop t
@drop person
alter table products modify total_sold not reservable;
@drop products
@drop seq
@drop myemp
@drop customer
@drop orders
@drop orderitems
col journal new_value journal_table
col journal format a30
set verify off
drop view orders_ov;
@dropc order_items
create or replace
function my_plsql_func return number is
begin
  return 10;
end;
/
create sequence seq;

alter index scott.EMP_PK unusable;
alter index scott.DEPT_PK unusable;
alter index scott.EMP_PK rebuild;
alter index scott.DEPT_PK rebuild;

conn dbdemo/dbdemo@db19
set termout off
@drop t1
alter index scott.EMP_PK unusable;
alter index scott.DEPT_PK unusable;
alter index scott.EMP_PK rebuild;
alter index scott.DEPT_PK rebuild;


col EMAIL_ADDRESS    format a18             
col FULL_NAME format a18
set lines 120
col object_name format a20
col delta format 999.99999
col secs format 99999999999

clear screen
set termout on
set echo off
prompt |
prompt |     _    ____  ____    ___ _   _ _____ _____ ______     ___    _     
prompt |    / \  / ___|/ ___|  |_ _| \ | |_   _| ____|  _ \ \   / / \  | |    
prompt |   / _ \| |  _| |  _    | ||  \| | | | |  _| | |_) \ \ / / _ \ | |    
prompt |  / ___ \ |_| | |_| |   | || |\  | | | | |___|  _ < \ V / ___ \| |___ 
prompt | /_/   \_\____|\____|  |___|_| \_| |_| |_____|_| \_\ \_/_/   \_\_____|
prompt |                                                                     
prompt |
pause
set echo on
clear screen

set echo on
set termout on
select banner from v$version;
pause
create table t1 as 
select 
  owner, 
  object_name, 
  created, 
  last_ddl_time
from dba_objects
where owner = 'SCOTT'
and rownum <= 10;
pause
set lines 60
desc t1
set lines 120
pause
clear screen
select 
  object_name,
  last_ddl_time,
  created,
  last_ddl_time-created delta
from t1;
pause
select 
  object_name,
  last_ddl_time,
  created,
  round((last_ddl_time-created)*86400) secs
from t1;
pause

select 86400*sum(last_ddl_time-created) secs
from t1;
pause
col last_ddl_time format a28
col created format a28
col delta format a28
clear screen
drop table t1 purge;

create table t1 as 
select 
  owner, 
  object_name, 
  cast(created as timestamp(3)) created, 
  cast(last_ddl_time as timestamp(3)) last_ddl_time
from dba_objects
where owner = 'SCOTT'
and rownum <= 10;

pause

set lines 60
desc t1
set lines 120
pause
clear screen
select 
  object_name,
  last_ddl_time,
  created,
  last_ddl_time-created delta
from t1;
pause

select 86400*sum(last_ddl_time-created) secs
from t1;
pause
select sum(
  extract(day from last_ddl_time-created)*86400+
  extract(hour from last_ddl_time-created)*3600+
  extract(minute from last_ddl_time-created)*60+
  extract(second from last_ddl_time-created)
) secs
from t1;
pause
set termout off
clear screen
conn dbdemo/dbdemo@db23
set termout off
set echo off
col object_name format a20
set lines 300
set feedback off
set serverout on
set termout on
begin 
  dbms_output.put_line(
'SQL> select banner from v$version;

BANNER
----------------------------------------------------------
Oracle Database 23ai Enterprise Edition Release 23.0.0.0.0

1 row selected.
');
end;
/
set feedback on
set echo on
pause
create table t1 as 
select 
  owner, 
  object_name, 
  cast(created as timestamp(3)) created, 
  cast(last_ddl_time as timestamp(3)) last_ddl_time
from dba_objects
where owner = 'SCOTT'
and rownum <= 10;
pause
set lines 120
pause
select 
  object_name,
  last_ddl_time,
  created,
  last_ddl_time-created delta
from t1;
pause
select sum(last_ddl_time-created) 
from t1;
pause
select 
 object_name,
 sum(last_ddl_time-created) over () as dur
from t1;
pause
set termout off
clear screen
conn dbdemo/dbdemo@db19
set termout off
set echo on
set termout on
select banner from v$version;
pause
alter session set nls_date_format = 'dd/mm/yyyy hh24:mi:ss';
pause
select floor(sysdate) from dual;
pause
select ceil(sysdate) from dual;
pause
set termout off
clear screen
conn dbdemo/dbdemo@db23
set termout off
set echo off
set termout on
set lines 300
set feedback off
set serverout on
set termout on
begin 
  dbms_output.put_line(
'SQL> select banner from v$version;

BANNER
----------------------------------------------------------
Oracle Database 23ai Enterprise Edition Release 23.0.0.0.0

1 row selected.
');
end;
/
set feedback on
set echo on
pause
alter session set nls_date_format = 'dd/mm/yyyy hh24:mi:ss';
pause
select floor(sysdate);
pause
select ceil(sysdate);

pause Done
