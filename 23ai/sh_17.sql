clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
conn sys/SYS_PASSWORD@db23 as sysdba
set termout off
alter system set max_columns = standard scope=spfile;
shutdown immediate
startup
conn dbdemo/dbdemo@db23
set termout off
drop user jane_doe cascade;
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
@drop bigcol
create sequence seq;
clear screen
set termout on
set echo off
prompt |
prompt |
prompt |
prompt |  __  __    _    __  __    ____ ___  _    _   _ __  __ _   _ ____  
prompt | |  \/  |  / \   \ \/ /   / ___/ _ \| |  | | | |  \/  | \ | / ___| 
prompt | | |\/| | / _ \   \  /   | |  | | | | |  | | | | |\/| |  \| \___ \ 
prompt | | |  | |/ ___ \  /  \   | |__| |_| | |__| |_| | |  | | |\  |___) |
prompt | |_|  |_/_/   \_\/_/\_\   \____\___/|_____\___/|_|  |_|_| \_|____/ 
prompt |                                                                  
pause
set echo on
clear screen

set echo on
set termout off
clear screen
set termout on
set echo on
conn scott/tiger@db23
declare
  l_sql clob :=
    'create table bigcol (c1 int';
begin  
  for i in 2 .. 1000 loop
    l_sql := l_sql ||',c'||i||' int';
  end loop;
  l_sql := l_sql || ')';
  --
  --  create table bigcol(
  --    c1 int,
  --    c2 int,
  --    ...
  --    ...
  --    c1000 int );
  --
  execute immediate l_sql;
end;
/
pause
desc bigcol
pause
alter table bigcol add newcol date;
pause
drop table bigcol purge;
clear screen
conn sys/SYS_PASSWORD@db23 as sysdba
show parameter max_columns
pause
alter system set max_columns = extended scope=spfile;
shutdown immediate
startup
pause
clear screen
set echo on
conn scott/tiger@db23
pause
declare
  l_sql clob :=
    'create table bigcol (c1 int';
begin  
  for i in 2 .. 3000 loop
    l_sql := l_sql ||',c'||i||' int';
  end loop;
  l_sql := l_sql || ')';
  --
  --  create table bigcol(
  --    c1 int,
  --    c2 int,
  --    ...
  --    ...
  --    c3000 int );
  --
  execute immediate l_sql;
end;
/
pause
desc bigcol
pause
drop table bigcol purge;

pause Done
