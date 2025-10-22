clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
alter system set max_columns = standard;
drop user jane_doe cascade;
alter session set read_only = false;
drop domain amex ;
@drop credit_card
@drop emp2
drop table hr.new_table purge;
alter session set group_by_position_enabled = false;
@drop t
@drop person
@drop seq
@drop myemp
create or replace
function my_plsql_func return number is
begin
  return 10;
end;
/
@drop t1
@drop t2
@drop t3
@drop t4
@drop t5
undefine prefix

col pfx new_value prefix
select substr(name,1,instr(name,'/',-1)-1) pfx
from v$datafile
where rownum = 1;

drop tablespace frag_ts including contents and datafiles;
create bigfile tablespace frag_ts 
datafile '&&prefix/frag_ts.dbf' size 100m;
undefine prefix
create table t5 tablespace frag_ts
as select d.* from dba_objects d;
create table t4 tablespace frag_ts as select * from t5;
create table t3 tablespace frag_ts as select * from t4;
create table t2 tablespace frag_ts as select * from t3;
create table t1 tablespace frag_ts as select * from t2;
@drop t2
@drop t3
@drop t4
@drop t5
create sequence seq;
clear screen
set termout on
set echo off
pro | 
pro |    _____ _    _ _____  _____ _   _ _  __      _______       ____  _      ______  _____ _____        _____ ______ 
pro |   / ____| |  | |  __ \|_   _| \ | | |/ /     |__   __|/\   |  _ \| |    |  ____|/ ____|  __ \ /\   / ____|  ____|
pro |  | (___ | |__| | |__) | | | |  \| | ' /         | |  /  \  | |_) | |    | |__  | (___ | |__) /  \ | |    | |__   
pro |   \___ \|  __  |  _  /  | | | . ` |  <          | | / /\ \ |  _ <| |    |  __|  \___ \|  ___/ /\ \| |    |  __|  
pro |   ____) | |  | | | \ \ _| |_| |\  | . \         | |/ ____ \| |_) | |____| |____ ____) | |  / ____ \ |____| |____ 
pro |  |_____/|_|  |_|_|  \_\_____|_| \_|_|\_\        |_/_/    \_\____/|______|______|_____/|_| /_/    \_\_____|______|
pro |                                                                                                                  
pro |                                                                                                                  
pause
set echo on
clear screen
select tablespace_name, round(bytes/1024/1024) mb
from   dba_data_files
where  tablespace_name = 'FRAG_TS';
pause
select round(sum(bytes)/1024/1024) mb
from   dba_segments
where  tablespace_name = 'FRAG_TS';
pause
clear screen
alter tablespace frag_ts resize 20m;
pause
select round(max(block_id+blocks)*8192/1024/1024) hwm
from   dba_extents
where  tablespace_name = 'FRAG_TS';
pause
clear screen
set serverout on
execute dbms_space.shrink_tablespace('FRAG_TS');
pause
select tablespace_name, round(bytes/1024/1024) mb
from   dba_data_files
where  tablespace_name = 'FRAG_TS';
pause
execute dbms_space.tablespace_shrink('FRAG_TS');

pause Done

