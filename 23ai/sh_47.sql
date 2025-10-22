clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
@drop t
conn dbdemo/dbdemo@db19
set termout off
@drop t
clear screen
set lines 120
set termout on
set echo off
prompt |  
prompt |  
prompt |  
prompt |    _____ _   _ _____  ________   __     _____ _____ ____________ 
prompt |   |_   _| \ | |  __ \|  ____\ \ / /    / ____|_   _|___  /  ____|
prompt |     | | |  \| | |  | | |__   \ V /    | (___   | |    / /| |__   
prompt |     | | | . ` | |  | |  __|   > <      \___ \  | |   / / |  __|  
prompt |    _| |_| |\  | |__| | |____ / . \     ____) |_| |_ / /__| |____ 
prompt |   |_____|_| \_|_____/|______/_/ \_\   |_____/|_____/_____|______|
prompt |                                                                  
prompt |                                                                  
prompt |                                                                          
pause
set echo on
clear screen
select banner_full from v$version;
pause
create table t (
  c1 varchar2(10000),
  c2 varchar2(100)
);
pause
create index ix on t ( c1 );
pause
set echo off
clear screen
conn dbdemo/dbdemo@db23
set lines 300
set feedback off
set serverout on
set termout on

set feedback on
set echo on
select banner from v$version;
pause

create table t (
  c1 varchar2(10000),
  c2 varchar2(100)
);
pause
create index ix on t ( c1 );
pause
clear screen
insert into t 
values ('x','y');
pause
insert into t 
values (rpad('x',4000,'x'),'y');
pause
insert into t 
values (rpad('x',4000,'x')||rpad('x',4000,'x'),'y');
pause
clear screen
drop table t purge;
pause
alter session set "_runtime_index_key_length_check" = 0;
pause
create table t ( x varchar2(8000));
create index ix on t ( x );
pause
clear screen
drop table t purge;
alter session set "_runtime_index_key_length_check" = 1;
pause
create table t ( x varchar2(8000));
create index ix on t ( x );

pause Done
