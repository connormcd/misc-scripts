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
variable v01 number
variable v01 number
variable v02 varchar2(30)
variable v03 varchar2(30)
variable v04 varchar2(30)
variable v05 varchar2(30)
variable v06 varchar2(30)
variable v07 varchar2(30)
variable v08 varchar2(30)
variable v09 varchar2(30)
variable v09 varchar2(30)
variable v10 varchar2(30)
variable v11 varchar2(30)
variable v12 varchar2(30)
variable v13 varchar2(30)
variable v14 varchar2(30)
variable v15 varchar2(30)
alter session set cursor_sharing = exact;
alter session set "_optimizer_adaptive_cursor_sharing" = true;
alter session set "_optim_peek_user_binds" = true;
alter session set optimizer_features_enable='18.1.0';

set feedback on
col max_data format a30 trunc
set termout on
clear screen
alter system flush shared_pool;
pause
clear screen
exec :v01 := 10;
pause

select max(data) max_data,count(*) 
from  t 
where pk  = :v01
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
select * from table(dbms_xplan.display_cursor(format=>'-predicate -note'));
pause

select 
  sql_id, sql_text,
  is_bind_sensitive,
  is_bind_aware,
  is_shareable
from 
 v$sql
where sql_id = '9sn7ccu8mak08';
pause
clear screen

alter system flush shared_pool;
pause
clear screen
exec :v01 := 10;
pause


select max(data) max_data,count(*) from t where pk = :v01
and   c02 = :v02
and   c03 = :v03
and   c04 = :v04
and   c05 = :v05
and   c06 = :v06
and   c07 = :v07
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
where sql_id = '6s8ssfw5vdqbu';
pause
clear screen

alter system flush shared_pool;
pause
clear screen
exec :v01 := 10;
pause

select max(data) max_data,count(*) from t where pk = :v01
and   c02 = :v02
and   c03 = :v03
and   c04 = :v04
and   c05 = :v05
and   c06 = :v06
and   c07 = :v07
and   c08 = :v08
and   c09 = :v09
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
where sql_id = '1fc0qm88chtfw';