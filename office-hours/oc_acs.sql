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

col  is_bind_sensitive format a18
col  is_bind_aware format a14
col  is_shareable format a14
col sql_text format a42 wrap

alter session set cursor_sharing = exact;
alter session set "_optimizer_adaptive_cursor_sharing" = true;
alter session set "_optim_peek_user_binds" = true;
alter session set optimizer_features_enable='18.1.0';
col max_data format a30 trunc
@drop t
@clean
col plan_table_output format a100
set termout on
clear screen
set echo on
create table t 
( pk int,
  c01 varchar2(10),
  c02 varchar2(10),
  c03 varchar2(10),
  c04 varchar2(10),
  c05 varchar2(10),
  c06 varchar2(10),
  c07 varchar2(10),
  c08 varchar2(10),
  c09 varchar2(10),
  c10 varchar2(10),
  c11 varchar2(10),
  c12 varchar2(10),
  c13 varchar2(10),
  c14 varchar2(10),
  c15 varchar2(10),
  c16 varchar2(10),
  c17 varchar2(10),
  c18 varchar2(10),
  c19 varchar2(10),
  c20 varchar2(10),
  data char(100)
);

pause
clear screen

--
-- 500k rows, almost all of them pk=20
--
insert into t
select 
  case when rownum < 20 then rownum else 20 end, 
       'x','x','x','x','x','x','x','x','x','x',
       'x','x','x','x','x','x','x','x','x','x', rownum
from dual
connect by level <= 500000;

pause
create index ix on t ( pk );

exec dbms_stats.gather_table_stats('','T');
exec dbms_stats.gather_table_stats('','T',method_opt=>'for columns pk size 200');

pause
clear screen
select histogram 
from user_tab_col_statistics
where   table_name = 'T'
and column_name = 'PK';
pause
clear screen
select
      endpoint_value,
      endpoint_number -
         nvl(lag(endpoint_number) over ( order by endpoint_number),0) freq
    from user_histograms
    where   table_name = 'T'
    and column_name = 'PK'
order by 1

pause
/
pause
clear screen
alter system flush shared_pool;
pause
select max(data) max_data from t where pk = 10;
pause
select * from table(dbms_xplan.display_cursor(format=>'-predicate -note'));
pause
clear screen
select max(data) max_data from t where pk = 20;
pause
select * from table(dbms_xplan.display_cursor(format=>'-predicate -note'));
pause
clear screen
alter system flush shared_pool;
pause
--
-- setup for later
--
set verify off
set echo on
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
pause

begin
 :v02 := 'x';
 :v03 := 'x';
 :v04 := 'x';
 :v05 := 'x';
 :v06 := 'x';
 :v07 := 'x';
 :v08 := 'x';
 :v09 := 'x';
 :v10 := 'x';
 :v11 := 'x';
 :v12 := 'x';
 :v13 := 'x';
 :v14 := 'x';
 :v15 := 'x';
end;
/
pause
clear screen
exec :v01 := 10;

select max(data) max_data,count(*) 
from   t 
where  pk = :v01
and    c02 in (:v02,:v03)
and    c10 = 'x'
and    c11 = 'x';
pause
select * from table(dbms_xplan.display_cursor(format=>'-predicate -note'));
pause
select max(data) max_data,count(*) 
from   t 
where  pk = :v01
and    c02 in (:v02,:v03)
and    c10 = 'x'
and    c11 = 'x';
pause


select 
  sql_id, sql_text,
  is_bind_sensitive,
  is_bind_aware,
  is_shareable
from 
 v$sql
where sql_id = '2wy3uh24cgt13';
pause
clear screen
exec :v01 := 20;

pause
select max(data) max_data,count(*) 
from   t 
where  pk = :v01
and    c02 in (:v02,:v03)
and    c10 = 'x'
and    c11 = 'x';
pause
select * from table(dbms_xplan.display_cursor(format=>'-predicate -note'));
pause

select max(data) max_data,count(*) 
from   t 
where  pk = :v01
and    c02 in (:v02,:v03)
and    c10 = 'x'
and    c11 = 'x';
pause
/
pause
/
pause


select 
  sql_id, sql_text,
  is_bind_sensitive,
  is_bind_aware,
  is_shareable
from 
 v$sql
where sql_id = '2wy3uh24cgt13';
pause


select max(data) max_data,count(*) 
from   t 
where  pk = :v01
and    c02 in (:v02,:v03)
and    c10 = 'x'
and    c11 = 'x';
pause
select * from table(dbms_xplan.display_cursor(format=>'-predicate -note'));
pause

clear screen
alter system flush shared_pool;
pause
clear screen
exec :v01 := 10;

select max(data) max_data,count(*) 
from t where pk = :v01
and   c02 in (:v02,:v03,:v04,:v05,:v06,:v07,:v08,:v09,:v10,:v11,:v12,:v13,:v14,:v15)
and   c10 = 'x'
and   c11 = 'x';

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
where sql_id = 'fs0gdg86npf77';
pause

select max(data) max_data,count(*) 
from t where pk = :v01
and   c02 in (:v02,:v03,:v04,:v05,:v06,:v07,:v08,:v09,:v10,:v11,:v12,:v13,:v14,:v15)
and   c10 = 'x'
and   c11 = 'x';
pause
/
pause
/
pause
/
pause
/

select 
  sql_id, sql_text,
  is_bind_sensitive,
  is_bind_aware,
  is_shareable
from 
 v$sql
where sql_id = 'fs0gdg86npf77';
pause
clear screen

exec :v01 := 20;

select max(data) max_data,count(*) 
from t where pk = :v01
and   c02 in (:v02,:v03,:v04,:v05,:v06,:v07,:v08,:v09,:v10,:v11,:v12,:v13,:v14,:v15)
and   c10 = 'x'
and   c11 = 'x';
pause
/
pause
/
pause
/
pause

select 
  sql_id, sql_text,
  is_bind_sensitive,
  is_bind_aware,
  is_shareable
from 
 v$sql
where sql_id = 'fs0gdg86npf77';
