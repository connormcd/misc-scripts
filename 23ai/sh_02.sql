clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
alter system set max_columns = standard;
drop user jane_doe cascade;
drop domain amex ;
@drop credit_card
alter session set plsql_implicit_conversion_bool=false;
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
drop table person purge;
create sequence seq;
clear screen
set termout on
set echo off
prompt |
prompt |
prompt |  ____   ___   ___  _     _____    _    _   _ 
prompt | | __ ) / _ \ / _ \| |   | ____|  / \  | \ | |
prompt | |  _ \| | | | | | | |   |  _|   / _ \ |  \| |
prompt | | |_) | |_| | |_| | |___| |___ / ___ \| |\  |
prompt | |____/ \___/ \___/|_____|_____/_/   \_\_| \_|
prompt |                                              
pause
set echo on
clear screen

set echo on
set termout on
create table person (
  pid     int,
  married boolean);
pause
clear screen
insert into person values (1,true);
pause
insert into person values (2,false);
pause
insert into person values (3,'on');
pause
insert into person values (4,'OFF');
pause
insert into person values (5,1);
pause
insert into person values (6,0);
pause
insert into person values (8,'Y');
pause
insert into person values (9,'Yes');
pause
commit;
clear screen
select * from person;
pause
clear screen
select *
from person
where married 
 or pid = 2;
pause
select exists ( select 1 from emp);
pause
clear screen
create index person_bool_ix 
on person ( married );
pause
alter table person
add constraint person_chk check
 ( married or pid != 0 );
 pause
clear screen
declare
  b boolean;
begin
  select married 
  into b 
  from person 
  where rownum = 1;
end;
/
pause
declare
  b boolean := false;
begin
  insert into person 
  values (2,b);
end;
/
pause
clear screen
declare
  b boolean;
begin
  b := 1;
end;
.
pause
/
pause
clear screen
alter session set plsql_implicit_conversion_bool=true;
pause
declare
  b boolean;
begin
  b := 1;
end;
/
pause
declare
  b boolean;
begin
  b := 'Yes';
end;
/
pause Done
