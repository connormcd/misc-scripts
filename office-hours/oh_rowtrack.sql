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
conn SYS_USER/PASSWORD@MY_PDB
set termout off
@drop t1
clear screen
set echo on
set termout on
--
-- create index MY_INDEX on MY_TABLE ( col1, col2 ) ONLINE;
--                                                    ^^
--                                                    ||
-- How are they doing this? ==========================||
--
pause
clear screen
create table t1 as 
select object_id, owner, object_name
from dba_objects;
pause 
alter table t1 enable row change tracking;
pause
clear screen
insert into t1 values (2000,'CONNOR','DEMO');
commit;
pause
update t1 set owner = 'XXX' 
where object_id = 1234;
commit;
pause
delete from t1
where object_id = 2345;
commit;
pause
clear screen
variable scn number;
exec :scn := sys.dbms_flashback.get_system_change_number();
pause
select *
from dbms_row_change_tracking.get_rowid_ranges(user, 'T1', :scn, 16);
pause
select *
from dbms_row_change_tracking.get_rows(user, 'T1', :scn);
pause 
exec dbms_row_change_tracking.consume(user, 'T1', :scn);
commit;
pause 
select *
from dbms_row_change_tracking.get_rowid_ranges(user, 'T1', :scn, 16);
pause
clear screen
delete t1 
where object_id between 70 and 80;
commit;
pause
variable scn number;
exec :scn := sys.dbms_flashback.get_system_change_number();
pause 
select *
from dbms_row_change_tracking.get_rowid_ranges(user, 'T1', :scn, 16);
