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
conn USERNAME/PASSWORD@SERVICE_NAME
set termout off
@longdate
@drop t
@drop my_proc
exec dbms_scheduler.drop_job('MY_JOB',force=>true);
create or replace
type msg_type is object ( msg varchar2(30));
/

exec    dbms_aqadm.drop_queue( queue_name => 'MY_JOB_QUEUE');
exec    dbms_aqadm.drop_queue_table ( queue_table => 'MY_JOB_QUEUE_TABLE');
begin
dbms_aqadm.create_queue_table (
           queue_table=> 'MY_JOB_QUEUE_TABLE',
           queue_payload_type=>'MSG_TYPE');
    dbms_aqadm.create_queue ( 
           queue_name => 'MY_JOB_QUEUE', 
           queue_table => 'MY_JOB_QUEUE_TABLE');
    dbms_aqadm.start_queue ( 
           queue_name => 'MY_JOB_QUEUE'); 
end;
/



set termout on
set echo on
clear screen
create table t
  ( msg varchar2(30),
    dte date default sysdate
  );
pause
create or replace
procedure my_proc(m varchar2 default 'blah') is
begin
  insert into t(msg) values(m);
  commit;
end;
/
pause
clear screen
variable j number
exec dbms_job.submit(:j,'my_proc;');
pause
select job from user_jobs;
pause
select * from t;
pause
commit;
pause
select * from t;
pause
select * from t;
pause
select job from user_jobs;
pause
clear screen
exec dbms_job.submit(:j,'my_proc;');
pause
select job from user_jobs;
pause
select * from t;
pause
rollback;
pause
select job from user_jobs;
pause
clear screen
-- 
-- create or replace
-- trigger email_when_salary_too_high
-- after insert on emp
-- for each row
-- begin
--   if :new.sal > 1000 then
--      dbms_job.submit('email_alert;');
--   end if;
-- end;
-- 
pause
clear screen
begin
    dbms_scheduler.create_job (
       job_name           =>  'MY_JOB',
       job_type           =>  'PLSQL_BLOCK',
       job_action         =>  'my_proc;',
       start_date         =>  sysdate,
       repeat_interval    =>  null,
       enabled            =>  true);
end;
/
pause
select * from t;
pause
select * from t;
pause
clear screen
-- ---------------------------------
--
-- docs.oracle.com, 12.2+
--
-- "The DBMS_JOB package is deprecated, and may be desupported in a
--  future release. Oracle recommends that developers move to 
--  DBMS_SCHEDULER, which provides a richer set of capabilities."
--
--
-- LETS TALK ABOUT THE "WHY"
--
-- ---------------------------------
pause
clear screen
--
-- Option 1: Keep using DBMS_JOB  (???)
--
pause
exec dbms_job.submit(:j,'my_proc;');
pause
select job from user_jobs;
pause
select job_name
from   user_scheduler_jobs;
pause
select object_name
from   user_objects
where  object_type = 'JOB';
pause
rollback;
pause
select job_name
from   user_scheduler_jobs;
pause
clear screen
--
-- Option 2: Exploit other transactional mechanisms
--
pause
create or replace
procedure do_job_work is
   l_dequeue_options    dbms_aq.dequeue_options_t;
   l_message_properties dbms_aq.message_properties_t;
   l_msgid              raw(16);
   l_message            msg_type;

   e_queue_timeout    exception;
   pragma exception_init(e_queue_timeout,-25228);

begin
   l_dequeue_options.wait := 60;
   l_dequeue_options.navigation  := dbms_aq.first_message;

   dbms_aq.dequeue(queue_name         => 'MY_JOB_QUEUE',
                   dequeue_options    => l_dequeue_options,
                   message_properties => l_message_properties,
                   payload            => l_message,
                   msgid              => l_msgid);

   insert into t (msg) values ( l_message.msg);
   commit;

exception
  when e_queue_timeout then null;
end;
/
pause
clear screen
begin
    dbms_scheduler.create_job (
       job_name           =>  'MY_JOB',
       job_type           =>  'PLSQL_BLOCK',
       job_action         =>  'do_job_work;',
       start_date         =>  sysdate,
       repeat_interval    =>  'FREQ=MINUTELY',
       enabled            =>  true);
end;
/
pause
create or replace
procedure request_job_work is
  l_enqueue_options    dbms_aq.enqueue_options_t;
  l_message_properties dbms_aq.message_properties_t;
  l_msgid              raw(16);
begin
    dbms_aq.enqueue(
        queue_name => 'MY_JOB_QUEUE',
        enqueue_options => l_enqueue_options,
        message_properties => l_message_properties,
        payload =>msg_type('STUFF'),
        msgid => l_msgid);
end;
/
pause
clear screen
exec  request_job_work
pause
select * from t;
pause
commit;
pause
select * from t;
pause
--
-- cleanup
--
set termout off
@drop t
@drop my_proc
exec dbms_scheduler.drop_job('MY_JOB',force=>true);
create or replace
type msg_type is object ( msg varchar2(30));
/

exec    dbms_aqadm.drop_queue( queue_name => 'MY_JOB_QUEUE');
exec    dbms_aqadm.drop_queue_table ( queue_table => 'MY_JOB_QUEUE_TABLE');
begin
dbms_aqadm.create_queue_table (
           queue_table=> 'MY_JOB_QUEUE_TABLE',
           queue_payload_type=>'MSG_TYPE');
    dbms_aqadm.create_queue ( 
           queue_name => 'MY_JOB_QUEUE', 
           queue_table => 'MY_JOB_QUEUE_TABLE');
    dbms_aqadm.start_queue ( 
           queue_name => 'MY_JOB_QUEUE'); 
end;
/
set termout on



