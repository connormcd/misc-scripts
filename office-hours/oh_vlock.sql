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
@drop t
undefine blk
undefine blk1
undefine fno
undefine fno1
undefine trc
undefine trc1
set verify off
set termout off
set termout on
set echo on
create table t as select * from scott.emp;
pause
select * from v$lock
where type in ('TM','TX');
pause
delete from t where rownum = 1;
pause
select * from v$lock
where type in ('TM','TX');
pause
update t
set sal = sal + 10;
pause
select * from v$lock
where type in ('TM','TX');
pause
select xid from v$transaction;
pause
commit;
col undo_sql format a40
select row_id, undo_sql
from flashback_transaction_query
where xid = hextoraw('0900030075180000');
pause
select versions_xid,versions_operation, t.*
from t
versions between scn minvalue and maxvalue
order by empno, versions_xid;
