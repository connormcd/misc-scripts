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
set termout off
drop table stage purge;
drop table t purge;
set termout on
set echo on
clear screen

create table stage as select * from all_objects;
pause
create table t as select * from stage;
pause
clear screen
alter session enable parallel dml;
pause
explain plan for
insert /*+ append parallel */ into t
select *
from stage;
pause
select * from dbms_xplan.display();
pause
rollback;
clear screen
alter session disable parallel dml;
pause
explain plan for
insert /*+ enable_parallel_dml parallel */ into t
select *
from stage;
pause
select * from dbms_xplan.display();
pause

clear screen
insert /*+ enable_parallel_dml parallel */ into t
select *
from stage;
pause
insert /*+ enable_parallel_dml parallel */ into t
select *
from stage;
pause
commit;
pause
clear screen
alter system flush shared_pool;
pause
insert /*+ look_for_me enable_parallel_dml parallel */ into t
select *
from stage;
commit;
pause

insert /*+ look_for_me enable_parallel_dml parallel */ into t
select *
from stage;
commit;
pause

insert /*+ look_for_me enable_parallel_dml parallel */ into t
select *
from stage;
commit;
pause

clear screen
select sql_id,child_number,executions
from v$sql
where lower(sql_text) like 'insert /*+ look_for_me enable_parallel_dml%';

pause
clear screen

alter session enable parallel dml;
pause
explain plan for
insert /*+ append */ into t
select *
from stage;
pause
select * from dbms_xplan.display();
pause
rollback;
clear screen

explain plan for
insert /*+ append parallel */ into t
select *
from stage;
pause
select * from dbms_xplan.display();
pause
rollback;
clear screen


alter session force parallel dml;
pause
explain plan for
insert /*+ append parallel */ into t
select *
from stage;
pause
select * from dbms_xplan.display();
pause
rollback;
clear screen

explain plan for
insert /*+ append */ into t
select *
from stage;
pause
select * from dbms_xplan.display();
