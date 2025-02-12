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
drop user demo cascade;
drop edition v2;
set termout on
set lines 60
clear screen
set feedback on
set serverout on
set echo on
conn SYSTEM_USER/PASSWORD@DB_SERVICE
create user demo identified by demo;
grant resource, connect , create view to demo;
alter user demo quota 1g on users;
pause
clear screen
conn demo/demo@DB_SERVICE
create table t ( x int, y varchar2(50));
pause
create or replace view my_view as select x, y from t;
pause
alter table t modify y varchar2(100);
pause
select status from user_objects 
where object_name = 'MY_VIEW';
pause
clear screen
drop table t purge;
drop view my_view;
pause
conn SYSTEM_USER/PASSWORD@DB_SERVICE
pause
alter user demo enable editions;
pause
create edition v2;
grant use on edition v2 to demo;
pause
clear screen
conn demo/demo@DB_SERVICE
alter session set edition = ora$base;
pause
create table t ( x int, y varchar2(50));
pause
rename  t to "_T";
pause
create or replace
editioning view t as 
select * from "_T";
pause
clear screen
create or replace
procedure my_proc is
  l_row t%rowtype;
begin
  select *
  into   l_row
  from   t
  where  rownum = 1;
end;
/
pause
select object_name, edition_name, status
from user_Objects_ae;
pause
clear screen
alter session set edition = v2;
pause
alter view t compile;
alter procedure my_proc compile;
pause
select object_name, edition_name, status
from user_Objects_ae;
pause
clear screen
alter table "_T" modify y varchar2(100);
pause
select object_name, edition_name, status
from user_Objects_ae;
pause
alter view t compile;
alter procedure my_proc compile;
pause
alter session set edition = ora$base;
alter view t compile;
alter procedure my_proc compile;
pause
select object_name, edition_name, status
from user_Objects_ae;
pause
clear screen
alter session set edition = v2;
pause
alter table "_T" add new_y varchar2(120);
pause
select object_name, edition_name, status
from user_Objects_ae;
pause
create or replace
editioning view t as 
select x, new_y y from "_T";
pause
update "_T" set new_y = y;
--
-- plus cross-edition triggers etc etc
--
pause
select object_name, edition_name, status
from user_Objects_ae;
pause
alter procedure my_proc compile;
pause
insert into t values (1,rpad('x',120));
pause
exec my_proc
