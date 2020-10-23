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
conn / as sysdba
set termout off
clear screen
alter system flush shared_pool;
set termout off
clear screen
conn USER/PASSWORD@MY_DB
set termout off
clear screen
@drop pkg
drop context ctx;
@drop t
@drop t1
@drop t2
@drop ix
@drop ix1
@drop ix2
col stub format a20
@clean
set echo on

create table t as
select * from dba_objects;
create index ix on t (owner );
pause

variable rc refcursor
exec open :rc for select count(status) s1 from t where owner = 'SYS';
pause
print rc
pause

select executions, cpu_time, buffer_gets
from v$sql
where sql_text like 'SELECT%S1 FROM T WHERE%';
pause

clear screen
variable rc refcursor
exec open :rc for select count(status) s2 from t where owner = 'SYS';
pause
begin
    update t 
    set object_id = object_id + 1;
    commit;

    update t 
    set owner = lower(owner);
    commit;

    update t 
    set created = trunc(created);
    commit;

end;
/
pause
clear screen
print rc
pause
select executions, cpu_time, buffer_gets
from v$sql
where sql_text like 'SELECT%S2 FROM T WHERE%';
pause
clear screen
variable rc refcursor
exec open :rc for select count(status) s3 from t where owner = 'SYS';
pause
truncate table t;
pause
clear screen
insert /*+ APPEND */ 
into t (owner,object_name,subobject_name,object_id,created)
select lower(owner),object_name,subobject_name,object_id+1,trunc(created)
from dba_objects;
commit;
pause
print rc
pause
clear screen
create table t1 as
select * from dba_objects;
create index ix1 on t1 (owner );
pause
create or replace 
view user_data
as select * from t1;
pause
clear screen
variable rc refcursor
exec open :rc for select count(status) c1 from user_data where owner = 'SYS';
pause
create table t2
as select * from t1;
pause
exec update t2 set status = null; commit;
pause
create index ix2 on t2 ( owner );
pause
clear screen
create or replace 
view user_data
as select * from t2;
pause
print rc
pause
variable rc refcursor
exec open :rc for select count(status) c2 from user_data where owner = 'SYS';
pause
print rc
pause
clear screen
select substr(sql_text,8,16) stub, child_number, parse_calls, invalidations
from v$sql
where lower(sql_text) like 'select count(status) c%'
order by 1;
pause
select substr(sql_text,8,16) stub, parse_calls, invalidations
from v$sqlstats
where lower(sql_text) like 'select count(status) c%'
order by 1;
pause
clear screen
create context CTX using pkg accessed globally;
pause
create or replace
package pkg is
  procedure setver(p_ver varchar2);
end;
/
pause
create or replace
package body pkg is
  procedure setver(p_ver varchar2) is
  begin
    dbms_session.set_context('CTX','VER',p_ver);
  end;
end;
/
pause
clear screen
create or replace view USER_DATA as
select * from t1
where sys_context('CTX','VER') = '1'
union all
select * from t2
where sys_context('CTX','VER') = '2';
pause
clear screen
exec pkg.setver('1');
select count(status) c3 from user_data where owner = 'SYS';
pause
exec pkg.setver('2');
select count(status) c3 from user_data where owner = 'SYS';
pause
clear screen
select substr(sql_text,8,16) stub, child_number, parse_calls, invalidations
from v$sql
where lower(sql_text) like 'select count(status) c%'
order by 1;
pause
clear screen
explain plan for
select count(status) from user_data where owner = 'SYS';
pause
select * from dbms_xplan.display(format=>'BASIC +PREDICATE');
pause
clear screen
alter table t1 move tablespace demo;
pause
alter tablespace demo offline;
pause
select count(status) c3 from user_data where owner = 'SYS'

pause
/
pause
alter tablespace demo online;

