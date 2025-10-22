clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
set long 1000
clear screen
@drop t
set termout on
set echo off
prompt | 
prompt | 
prompt |  __      _______ _____ _______ _    _         _      
prompt |  \ \    / /_   _|  __ \__   __| |  | |  /\   | |     
prompt |   \ \  / /  | | | |__) | | |  | |  | | /  \  | |     
prompt |    \ \/ /   | | |  _  /  | |  | |  | |/ /\ \ | |     
prompt |     \  /   _| |_| | \ \  | |  | |__| / ____ \| |____ 
prompt |      \/   |_____|_|  \_\ |_|   \____/_/    \_\______|
prompt |                                                      
prompt |                                                      
prompt | 
set echo on
pause
create table t ( x int, y as ( x + 1 )  );
pause
insert into t (x) values (10);
pause
select * from t;
pause
clear screen
create or replace
function my_virtual_col(n number) return number deterministic is
begin
  return n+1;
end;
/
pause
drop table t purge;
create table t ( x int, y generated always as ( my_virtual_col(x)) );
pause
insert into t (x)
select rownum
connect by level <= 10;
commit;
pause
select  * from t;
pause
clear screen
create or replace
function my_virtual_col(n number) return number deterministic is
begin
  dbms_session.sleep(0.5);
  return n+1;
end;
/
pause
set arraysize 1
select  * from t;
pause
clear screen
drop table t purge;
pause
create table t ( x int, y as ( my_virtual_col(x)) materialized );
pause
set timing on
insert into t (x) values (1);
pause
insert into t(x) 
values (2),(3),(4),(5),(6),(7),(8);
pause
select * from t;
pause
clear screen
update t
set x = 10
where x = 6;
pause
select * from t;
pause
set timing off
clear screen
drop table t purge;
create table t ( x int, y as ( my_virtual_col(x)) materialized immutable);
pause
insert into t(x) 
values (2),(3),(4);
pause
select * from t;
pause
update t set x = x + 1
where x = 3;
pause
alter table t add created_on as ( sysdate ) materialized immutable
.
pause
/

pause Done
