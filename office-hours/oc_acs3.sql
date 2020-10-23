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
alter session set cursor_sharing = exact;
alter session set "_optimizer_adaptive_cursor_sharing" = true;
alter session set "_optim_peek_user_binds" = true;
alter session set optimizer_features_enable='18.1.0';

col max_data format a30 trunc
set feedback on
set termout on
clear screen
set echo on
alter system flush shared_pool;
pause
alter session set cursor_sharing = force;

select max(data) max_data from t where pk = 10;
pause

select 
  sql_id, sql_text,
  is_bind_sensitive,
  is_bind_aware,
  is_shareable
from 
 v$sql
where sql_id = '8gq4c1vt24aga';
pause

clear screen
alter system flush shared_pool;
pause

select max(data) max_data,count(*) 
from  t 
where pk  = 10
and   c02 = 'x'
and   c03 = 'x'
and   c04 = 'x'
and   c05 = 'x'
and   c06 = 'x'
and   c07 = 'x'
and   c08 = 'x'
and   c09 = 'x'
and   c10 = 'x'
and   c11 = 'x'
/
pause
select 
  sql_id, sql_text,
  is_bind_sensitive,
  is_bind_aware,
  is_shareable
from 
 v$sql
where sql_id = 'caymshspcztrg';
pause

exit
