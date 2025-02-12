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
conn USER/PASSWORD@MY_PDB
set termout off
clear screen
@drop t
@drop t1
col high_value format a20
set timing off
set time off
set pages 999
set lines 200
set termout on
clear screen
set feedback on
set echo on
create table t 
partition by list (x ) automatic
( partition p0 values (0) ) as
select mod(object_id,10) x, d.* from dba_objects d;
pause
select distinct x from t order by 1;
pause
select partition_name , high_value
from user_tab_partitions
where table_name = 'T';
pause
clear screen
create table t1 
partition by list (x ) automatic
( partition p0 values (0) ) as
select 10*mod(object_id,10) x, d.* from dba_objects d;
pause
select distinct x from t1 order by 1;
pause
select partition_name , high_value
from user_tab_partitions
where table_name = 'T1';
pause
clear screen
merge into 
 ( select /*+ enable_parallel_dml parallel(2) */ * from t where x = 1 ) tgt
using
  ( select /*+ enable_parallel_dml parallel(2) */* from t1 where x = 10 ) src
on ( tgt.object_id = src.object_id )
when matched
then update set
  tgt.owner = src.owner;
pause
merge into 
 ( select /*+ enable_parallel_dml parallel(2) */* from t where x = 2 ) tgt
using
  ( select/*+ enable_parallel_dml parallel(2) */ * from t1 where x = 20 ) src
on ( tgt.object_id = src.object_id )
when matched
then update set
  tgt.owner = src.owner

pause
/
pause
commit;
pause
clear screen
explain plan for 
select * from t where x = 1;
pause
select * from dbms_xplan.display();
pause
clear screen
explain plan for 
select * from t1 where x = 10;
pause
select * from dbms_xplan.display();
pause
clear screen
explain plan for 
merge into 
 ( select * from t where x = 1 ) tgt
using
  ( select * from t1 where x = 10 ) src
on ( tgt.object_id = src.object_id )
when matched
then update set
  tgt.owner = src.owner;
pause
select * from dbms_xplan.display();
pause
clear screen
explain plan for
merge into 
 ( select /*+ enable_parallel_dml parallel(2) */ * from t where x = 1 ) tgt
using
  ( select /*+ enable_parallel_dml parallel(2) */* from t1 where x = 10 ) src
on ( tgt.object_id = src.object_id )
when matched
then update set
  tgt.owner = src.owner;
pause
select * from dbms_xplan.display();
pause
clear screen
merge into 
 ( select /*+ enable_parallel_dml parallel(2) */ * from t where x = 1 ) tgt
using
  ( select /*+ enable_parallel_dml parallel(2) */* from t1 where x = 10 ) src
on ( tgt.object_id = src.object_id )
when matched
then update set
  tgt.owner = src.owner;
--
-- over to session 2
--
pause
commit;
pause
clear screen
merge into 
 ( select /*+ enable_parallel_dml parallel(2) */ * from t partition for ( 1 ) ) tgt
using
  ( select /*+ enable_parallel_dml parallel(2) */* from t1 partition for ( 10 ) ) src
on ( tgt.object_id = src.object_id )
when matched
then update set
  tgt.owner = src.owner;
--
-- over to session 2
--
pause
commit;
pause
clear screen
explain plan for
merge into 
 ( select /*+ enable_parallel_dml parallel(2) */ * from t partition for ( 1 ) ) tgt
using
  ( select /*+ enable_parallel_dml parallel(2) */* from t1 partition for ( 10 ) ) src
on ( tgt.object_id = src.object_id )
when matched
then update set
  tgt.owner = src.owner;
pause
select * from dbms_xplan.display();
