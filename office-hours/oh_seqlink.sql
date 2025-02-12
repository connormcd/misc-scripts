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
undefine seq
col has_identity format a14
@drop t1
@drop t2
@drop t3
drop sequence blah;
set termout on
set echo on
create sequence blah;
pause
create table t1( x int default blah.nextval, y int);
pause
select * 
from   user_tables
where  table_name = 'T1'
@pr
pause
clear screen
select * 
from   user_sequences
where  sequence_name = 'BLAH'
@pr
pause
clear screen
create table t2( x int default blah.nextval, y int);
pause
create table t3( x int default blah.nextval, y int);
pause
clear screen
insert into t2 (y) values (10);
pause
select * from t2;
pause
drop sequence blah;
pause
insert into t3 (y) values (20);
pause
insert into t2 ( x,y) values (100,100);
pause
set termout off
clear screen
drop table t2 purge;
drop table t3 purge;
clear screen
set termout on
drop table t1 purge;
create table t1( x int generated as identity, y int);
pause
select table_name, has_identity
from   user_tables
where  table_name = 'T1';
pause
select object_id 
from user_objects
where object_name = 'T1';
pause
col sequence_name new_value seq
select sequence_name
from   user_sequences
where sequence_name =  
( select 'ISEQ$$_'||object_id 
  from user_objects
  where object_name = 'T1' );
pause
drop sequence &&seq;
pause
clear screen
select * 
from   user_sequences
where  sequence_name = '&&seq'
@pr
pause
create sequence blah;
pause
select o.object_name, s.flags
from   user_objects o, sys.seq$ s
where  o.object_id = s.obj#
and    o.object_name in ('&&seq','BLAH');
pause
create sequence ISEQ$$_7771036;
pause
drop sequence ISEQ$$_7771036;