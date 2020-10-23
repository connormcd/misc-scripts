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
grant execute on dbms_cq_notification to my_user;
drop table NOTIFY_LOG purge;
@drop cqn
@clean
set termout on
set echo on
create table my_user.CQN as 
select owner, object_name, object_type, created from all_objects;
create index my_user.CQN_IX 
on my_user.CQN ( owner, object_name);
pause

create table NOTIFY_LOG
  (t timestamp default systimestamp,
   m varchar2(100));
pause

CREATE OR REPLACE 
PROCEDURE my_user.callback(ntfnds IN CQ_NOTIFICATION$_DESCRIPTOR) IS
 BEGIN
  insert into NOTIFY_LOG ( m ) values ('Got a notification');
  commit;
END;
/
pause
clear screen

declare
  reginfo   cq_notification$_reg_info;
  v_cursor  sys_refcursor;
  regid     number;
begin
  reginfo := cq_notification$_reg_info (
    'callback',
    dbms_cq_notification.qos_query,
    0, 0, 0
  );
  regid := dbms_cq_notification.new_reg_start(reginfo);
  open v_cursor for
    select dbms_cq_notification.cq_notification_queryid, 
           owner, object_name, object_type
    from my_user.cqn
    WHERE owner = 'SCOTT';
  close v_cursor;
  dbms_cq_notification.reg_end;
end;
/
pause
clear screen
select systimestamp from dual;
delete from my_user.cqn 
WHERE owner = 'SCOTT' and rownum = 1;
select systimestamp from dual;
commit;
pause

col t format a32
col m format a40
select * from notify_log;

pause
clear screen

set termout off
grant execute on dbms_cq_notification to my_user;
drop table NOTIFY_LOG purge;
@drop cqn
@clean
set termout on
set echo on
create table my_user.CQN as 
select owner, object_name, object_type, created from all_objects;
create index my_user.CQN_IX 
on my_user.CQN ( owner, object_name);
create table NOTIFY_LOG
  (t timestamp default systimestamp, 
   m varchar2(100));
CREATE OR REPLACE 
PROCEDURE my_user.callback(ntfnds IN CQ_NOTIFICATION$_DESCRIPTOR) IS
 BEGIN
  insert into NOTIFY_LOG ( m ) values ('Got a notification');
  commit;
END;
/
pause
clear screen

declare
  reginfo   cq_notification$_reg_info;
  v_cursor  sys_refcursor;
  regid     number;
begin
  reginfo := cq_notification$_reg_info (
    'callback',
    dbms_cq_notification.qos_query,
    0, 0, 0
  );
  regid := dbms_cq_notification.new_reg_start(reginfo);
  open v_cursor for
    select dbms_cq_notification.cq_notification_queryid, 
            count(*) c
    from my_user.cqn
    WHERE owner = 'SCOTT';
  close v_cursor;
  dbms_cq_notification.reg_end;
end;
.

pause
/
pause
clear screen
declare
  reginfo   cq_notification$_reg_info;
  v_cursor  sys_refcursor;
  regid     number;
begin
  reginfo := cq_notification$_reg_info (
    'callback',
    dbms_cq_notification.QOS_BEST_EFFORT,
    0, 0, 0
  );
  regid := dbms_cq_notification.new_reg_start(reginfo);
  open v_cursor for
    select dbms_cq_notification.cq_notification_queryid, 
           count(*) c
    from my_user.cqn
    WHERE owner = 'SCOTT';
  close v_cursor;
  dbms_cq_notification.reg_end;
end;
/
pause

clear screen
select count(*) from my_user.cqn  
WHERE owner = 'SCOTT'; 
pause
delete from my_user.cqn 
WHERE owner = 'SCOTT' and rownum = 1;
insert into my_user.cqn 
values ('SCOTT','DUMMY','TABLE',sysdate);
commit;
pause
select count(*) from my_user.cqn  
WHERE owner = 'SCOTT';
pause

col t format a32
col m format a40
select * from notify_log;

