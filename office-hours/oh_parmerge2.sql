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
col high_value format a20
set timing off
set time off
set pages 999
set lines 200
set termout on
clear screen
set feedback on
set echo on
merge into 
 ( select /*+ enable_parallel_dml parallel(2) */* from t where x = 2 ) tgt
using
  ( select/*+ enable_parallel_dml parallel(2) */ * from t1 where x = 20 ) src
on ( tgt.object_id = src.object_id )
when matched
then update set
  tgt.owner = src.owner;
commit;
pause
merge into 
 ( select /*+ enable_parallel_dml parallel(2) */* from t partition for ( 2 ) ) tgt
using
  ( select/*+ enable_parallel_dml parallel(2) */ * from t1 partition for ( 20 ) ) src
on ( tgt.object_id = src.object_id )
when matched
then update set
  tgt.owner = src.owner;
pause  
commit;
--
-- back to session 1
--