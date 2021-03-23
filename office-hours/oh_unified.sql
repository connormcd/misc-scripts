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
col object_schema format a20
col object_name format a20
col audit_option format a20
col condition_eval_opt format a20
col event_timestamp format a40
col action_name format a12
col object_name format a20

conn /@DATABASE_SERVICE as sysdba
set termout off
BEGIN
DBMS_AUDIT_MGMT.CLEAN_AUDIT_TRAIL(
AUDIT_TRAIL_TYPE => DBMS_AUDIT_MGMT.AUDIT_TRAIL_UNIFIED,
USE_LAST_ARCH_TIMESTAMP => FALSE,
CONTAINER => dbms_audit_mgmt.container_current);
commit;
END;
/
col object_schema format a20
col object_name format a20
col audit_option format a20
col condition_eval_opt format a20
col event_timestamp format a40
col action_name format a12
col object_name format a20
noaudit policy capture_cust_trans;
drop audit policy capture_cust_trans;

drop table scott.customer_trans purge;
drop context aud_ctx;
set termout on
set echo on
clear screen

create table scott.customer_trans
as select * from scott.emp;
pause
create audit policy capture_cust_trans
actions select on scott.customer_trans
container = current;
pause
audit policy capture_cust_trans;
pause
col object_name format a20
clear screen
select object_schema,
       object_name,
       audit_option,
       condition_eval_opt
from   audit_unified_policies
where  policy_name = 'CAPTURE_CUST_TRANS';
pause
clear screen
conn scott/tiger@DATABASE_SERVICE
select * from customer_trans;
pause
select count(*) from customer_trans;
pause
select max(empno) from customer_trans;
pause
clear screen
conn /@DATABASE_SERVICE as sysdba
exec dbms_audit_mgmt.flush_unified_audit_trail;
pause
select event_timestamp,
       action_name,
       object_name
from   unified_audit_trail
where  dbusername = 'SCOTT'
and    object_name = 'CUSTOMER_TRANS';
pause
clear screen
noaudit policy capture_cust_trans;
drop audit policy capture_cust_trans;
pause
create context aud_ctx using set_ctx accessed globally;
pause
create or replace
package set_ctx is
  procedure table_on(p_table varchar2);
  procedure table_off(p_table varchar2);
end;
/
pause
clear screen
create or replace
package body set_ctx is
  procedure table_on(p_table varchar2) is
  begin
    dbms_output.put_line('Setting '||upper(p_table)||' to already captured');
    dbms_session.set_context('AUD_CTX',upper(p_table),'1');
  end;

  procedure table_off(p_table varchar2) is
  begin
    dbms_session.set_context('AUD_CTX',upper(p_table),'');
  end;
end;
/
pause
clear screen
create audit policy capture_cust_trans
actions select on scott.customer_trans
when 'SYS_CONTEXT(''AUD_CTX'', ''CUSTOMER_TRANS'') is null'
evaluate per statement
container = current;
pause
audit policy capture_cust_trans;
pause
select object_schema,
       object_name,
       audit_option,
       condition_eval_opt
from   audit_unified_policies
where  policy_name = 'CAPTURE_CUST_TRANS';
pause
clear screen
conn scott/tiger@DATABASE_SERVICE
select empno, ename from customer_trans;
pause
clear screen
conn /@DATABASE_SERVICE as sysdba
pause
set serverout on
begin
  for i in (
    select distinct object_name
    from   unified_audit_trail
    where  dbusername = 'SCOTT'
    and    object_name is not null
  )
  loop
    set_ctx.table_on(i.object_name);
  end loop;
end;
/
pause
clear screen
conn scott/tiger@DATABASE_SERVICE
pause
select count(*) from customer_trans;
pause
select max(empno) from customer_trans;
pause
clear screen
conn /@DATABASE_SERVICE as sysdba
exec dbms_audit_mgmt.flush_unified_audit_trail;
pause
select event_timestamp,
       action_name,
       object_name
from   unified_audit_trail
where  dbusername = 'SCOTT'
and    object_name = 'CUSTOMER_TRANS';
pause

noaudit policy capture_cust_trans;
drop audit policy capture_cust_trans;

