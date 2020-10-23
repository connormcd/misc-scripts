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
@clean
set termout off
drop trigger system.my_trigger;
drop table system.my_results purge;
drop table system.t purge;
conn system/SYSTEM_PASSWD@MY_DB
@clean
set echo on

create table system.my_results (dt timestamp, msg varchar2(20));

alter session set plsql_ccflags = 'foobar:true';

create or replace 
trigger system.my_trigger after logon on database enable
begin
   $if $$foobar $then
      insert into system.my_results 
      values (systimestamp, 'foobar is true');
   $else
      insert into system.my_results 
      values (systimestamp, 'foobar is false');
   $end
end;
/
pause
clear screen

select PLSQL_CCFLAGS 
from dba_plsql_object_settings 
where name = 'MY_TRIGGER';
set serveroutput on size unlimited
begin
  dbms_preprocessor.print_post_processed_source (
    object_type => 'TRIGGER',
    schema_name => 'SYSTEM',
    object_name => 'MY_TRIGGER');
end;
/
pause
clear screen

select plsql_ccflags 
from dba_plsql_object_settings 
where name = 'MY_TRIGGER';

connect system/SYSTEM_PASSWD@MY_DB
set echo on
pause
select msg from system.my_results;
