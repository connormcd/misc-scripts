clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
@drop t1
clear screen
set termout on
set echo off
prompt | 
prompt |   _____   ______          __    _______ _____            _____ _  _______ _   _  _____ 
prompt |  |  __ \ / __ \ \        / /   |__   __|  __ \     /\   / ____| |/ /_   _| \ | |/ ____|
prompt |  | |__) | |  | \ \  /\  / /       | |  | |__) |   /  \ | |    | ' /  | | |  \| | |  __ 
prompt |  |  _  /| |  | |\ \/  \/ /        | |  |  _  /   / /\ \| |    |  <   | | | . ` | | |_ |
prompt |  | | \ \| |__| | \  /\  /         | |  | | \ \  / ____ \ |____| . \ _| |_| |\  | |__| |
prompt |  |_|  \_\\____/   \/  \/          |_|  |_|  \_\/_/    \_\_____|_|\_\_____|_| \_|\_____|
prompt |                                                                                        
prompt |                                                                                        
pause
set echo on
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
delete t1 
where object_id between 70 and 80;
commit;
pause
variable scn number;
exec :scn := sys.dbms_flashback.get_system_change_number();
pause 
select *
from dbms_row_change_tracking.get_rowid_ranges(user, 'T1', :scn, 16);
 
pause Done
