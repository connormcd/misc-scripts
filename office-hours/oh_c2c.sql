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
conn USERNAME/PASSWORD@DATABASE_SERVICE
variable input nvarchar2(10)
set termout off
col constraint_name format a30
drop table t_slow;
create table t_slow
as select 
  to_char(rownum) pk, 
  object_name
from dba_objects;  
alter table t_slow add constraint t_slow_pk primary key ( pk );
set termout on
set echo on
clear screen
select *
from   t_slow
where  rownum <= 10;
pause
select count(*) from t_slow;
pause
clear screen
select constraint_name, constraint_type, status
from   user_constraints
where  table_name = 'T_SLOW';
pause
select column_name
from   user_cons_columns
where  table_name = 'T_SLOW';
pause
clear screen
select index_name, status
from   user_indexes
where  table_name = 'T_SLOW';
pause
select column_name
from   user_ind_columns
where  index_name = 'T_SLOW_PK';
pause
delete plan_table;
clear screen
explain plan for 
select *
from t_slow
where pk = 12;
pause
select * from dbms_xplan.display(format=>'BASIC +COST +ROWS');
pause
delete plan_table;
clear screen
explain plan for 
select /*+ index(t_slow) */ *
from t_slow
where pk = 12;
pause
select * from dbms_xplan.display(format=>'BASIC +COST +ROWS');
pause
set lines 60
clear screen
desc t_slow
pause
delete plan_table;
set lines 120
clear screen
explain plan for 
select *
from t_slow
where pk = 12;
pause
select * from dbms_xplan.display(format=>'TYPICAL');
pause
clear screen
drop table t_slow purge;
create table t_slow
as select 'str'||to_char(rownum) pk, object_name 
from dba_objects;
alter table t_slow add constraint t_slow_pk primary key ( pk );
select *
from   t_slow
where  rownum <= 10;
pause
delete plan_table;
clear screen
explain plan for select *
from t_slow
where pk = 'str123';
pause
select * from dbms_xplan.display(format=>'BASIC +COST +ROWS');
pause
delete plan_table;
clear screen
exec :input := 'str123'
explain plan for select *
from t_slow
where pk = :input;
pause
select * from dbms_xplan.display(format=>'BASIC +COST +ROWS');
pause
clear screen
select *
from t_slow
where pk = :input;
select * from dbms_xplan.display_cursor(format=>'BASIC +COST +ROWS');
pause
set echo off
clear screen
pro |
pro | SQL> variable input nvarchar2(10)
pro |
pause
set echo on
select *
from t_slow
where pk = :input;
pause
select * from dbms_xplan.display_cursor(format=>'TYPICAL');
pause
clear screen
create index t_slow_ix on t_slow ( sys_op_c2c(pk));
pause
select *
from t_slow
where pk = :input;
pause
select * from dbms_xplan.display_cursor(format=>'TYPICAL');
