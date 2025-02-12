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
col high_value format a20
set lines 200
set timing off
set time off
set pages 999
col partition_name new_value last_par_name
set lines 200
set termout on
clear screen
set feedback on
set echo on
create table t ( x int)
partition by range (x)
interval (10) 
(partition p1 values less than (100),
 partition p2 values less than (200)
) tablespace users;
pause
select partition_name, high_value, tablespace_name
from user_tab_partitions 
where table_name = 'T';
pause
clear screen
insert into t values (450);
pause
select partition_name, high_value, tablespace_name
from user_tab_partitions 
where table_name = 'T'
order by partition_position;
pause
roll;
pause
alter table T move partition &&last_par_name tablespace asktom;
pause
select partition_name, high_value, tablespace_name
from user_tab_partitions 
where table_name = 'T'
order by partition_position;
pause
clear screen
lock table t partition for ( 550 ) in exclusive mode nowait;
pause
select partition_name, high_value, tablespace_name
from user_tab_partitions 
where table_name = 'T'
order by partition_position;
pause
alter table T move partition &&last_par_name tablespace largets;
pause
select partition_name, high_value, tablespace_name
from user_tab_partitions 
where table_name = 'T'
order by partition_position;
pause
clear screen
drop table t purge;
create table t ( x int)
partition by range (x)
interval (10) 
(partition p1 values less than (100),
 partition p2 values less than (200)
) tablespace users;
pause
alter table t modify default attributes tablespace asktom;
pause
lock table t partition for ( 550 ) in exclusive mode nowait;
pause
alter table t modify default attributes tablespace users;
pause
select partition_name, high_value, tablespace_name
from user_tab_partitions 
where table_name = 'T'
order by partition_position;
pause
clear screen
--
-- over to session 2
--
pause
alter table t modify default attributes tablespace largets;
pause
lock table t partition for ( 750 ) in exclusive mode nowait;
pause
alter table t modify default attributes tablespace users;
pause
select partition_name, high_value, tablespace_name
from user_tab_partitions 
where table_name = 'T'
order by partition_position;
--
-- to session 2
--
pause
clear screen
drop table t purge;
create table t ( x int)
partition by range (x)
interval (10) store in (largets,asktom,users)
(partition p1 values less than (100),
 partition p2 values less than (200),
 partition p3 values less than (300),
 partition p4 values less than (400)
) tablespace users;
pause
select partition_name, high_value, tablespace_name
from user_tab_partitions 
where table_name = 'T'
order by partition_position;
pause
clear screen
lock table t partition for ( 550 ) in exclusive mode nowait;
lock table t partition for ( 650 ) in exclusive mode nowait;
lock table t partition for ( 750 ) in exclusive mode nowait;
lock table t partition for ( 850 ) in exclusive mode nowait;
lock table t partition for ( 950 ) in exclusive mode nowait;
pause
select partition_name, high_value, tablespace_name
from user_tab_partitions 
where table_name = 'T'
order by partition_position;
pause
clear screen
alter table t modify default attributes tablespace asktom;
pause
lock table t partition for ( 1050 ) in exclusive mode nowait;
lock table t partition for ( 1150 ) in exclusive mode nowait;
lock table t partition for ( 1250 ) in exclusive mode nowait;
lock table t partition for ( 1350 ) in exclusive mode nowait;
pause
select partition_name, high_value, tablespace_name
from user_tab_partitions 
where table_name = 'T'
order by partition_position;
pause
clear screen
alter table t set store in ( asktom);
pause
lock table t partition for ( 1450 ) in exclusive mode nowait;
lock table t partition for ( 1550 ) in exclusive mode nowait;
lock table t partition for ( 1650 ) in exclusive mode nowait;
lock table t partition for ( 1750 ) in exclusive mode nowait;
pause
select partition_name, high_value, tablespace_name
from user_tab_partitions 
where table_name = 'T'
order by partition_position;





