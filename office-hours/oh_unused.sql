REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

set termout off
@drop my_trigger
@drop messages 
@drop t
@clean
set echo on
create table t as 
select * 
from dba_procedures;
pause
select blocks, empty_blocks
from   user_tables
where  table_name = 'T';
pause
clear screen
alter table T set unused column object_name;
pause
select count(*)
from   user_unused_col_tabs
where  table_name = 'T';
pause

clear screen
select column_name, hidden_column
from   user_tab_cols
where  table_name = 'T';
pause
clear screen
exec dbms_stats.gather_table_stats('','T');
select blocks, empty_blocks
from   user_tables
where  table_name = 'T';
pause
alter table T drop unused columns;
pause
select count(*)
from   user_unused_col_tabs
where  table_name = 'T';
pause
clear screen

select column_name, hidden_column
from   user_tab_cols
where  table_name = 'T';
pause
clear screen
exec dbms_stats.gather_table_stats('','T');
pause

select blocks, empty_blocks
from   user_tables
where  table_name = 'T';
pause
clear screen
alter table T move;
pause

exec dbms_stats.gather_table_stats('','T');
pause

select blocks, empty_blocks
from   user_tables
where  table_name = 'T';
pause
set echo off
pro 
pro Now back to the slides and the question!
pro
pause
set echo on
clear screen
alter table T move compress;
pause

exec dbms_stats.gather_table_stats('','T');
pause

select blocks
from   user_tables
where  table_name = 'T';
pause
clear screen
alter table T set unused column object_type;
pause

select count(*)
from   user_unused_col_tabs
where  table_name = 'T';
pause
clear screen

select column_name, hidden_column
from   user_tab_cols
where  table_name = 'T';
pause

clear screen
alter table T drop unused columns

pause
/
pause

alter table t move nocompress;
pause
alter table T drop unused columns;
pause
alter table t move compress;
pause


clear screen
drop table t purge;
pause

create table T 
partition by list ( x )
( partition p1 values (0),
  partition p2 values (1)
)
as select mod(rownum,2) x, d.* from dba_procedures d;
pause

alter table t modify partition p1 compress;
alter table t move partition p1;
pause

clear screen
alter table T set unused column object_name;
pause

select count(*)
from   user_unused_col_tabs
where  table_name = 'T';
pause
clear screen
select column_name, hidden_column
from   user_tab_cols
where  table_name = 'T';
pause

clear screen
pro
select banner from v$version where rownum = 1;
pause
alter table t drop unused columns;;
pause
select count(*)
from   user_unused_col_tabs
where  table_name = 'T';
pause
clear screen
select banner from v$version where rownum = 1;
pause

alter table t drop unused columns;
pause
set echo off
pro
pro Now back to slides ...
pro
pause
set echo on
clear screen
drop table T purge;
create table t as 
select * 
from dba_procedures;
pause
set lines 60
clear screen
desc T
set lines 120
pause
create table messages ( m varchar2(50));
clear screen
create or replace
trigger my_trigger 
after insert or update on T
for each row
begin
  if :new.pipelined is not null then
     insert into messages values ( :new.object_id||','||:new.pipelined);
  end if;
end;
/
pause
clear screen
insert into t ( object_id,parallel,pipelined) values (1,'XX','YES');
pause
select * from messages;
pause
insert into t ( object_id,parallel,pipelined) values (2,'XX',null);
pause
select * from messages;
pause
clear screen

alter table T set unused (owner,object_name);
alter table t drop unused columns;
pause
insert into t ( object_id,parallel,pipelined) values (3,'XX','YES');
pause
select * from messages;
pause
clear screen
select status
from   user_objects
where  object_name = 'MY_TRIGGER';
pause
alter trigger MY_TRIGGER compile;
pause
insert into t ( object_id,parallel,pipelined) values (3,'XX','YES');
pause
select * from messages;
