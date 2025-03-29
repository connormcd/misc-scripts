clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
@drop corner_store
drop domain open_day force;
clear screen
set termout on
set echo off
prompt | 
prompt |   _____   ____  __  __          _____ _   _     ______ _   _ _    _ __  __ 
prompt |  |  __ \ / __ \|  \/  |   /\   |_   _| \ | |   |  ____| \ | | |  | |  \/  |
prompt |  | |  | | |  | | \  / |  /  \    | | |  \| |   | |__  |  \| | |  | | \  / |
prompt |  | |  | | |  | | |\/| | / /\ \   | | | . ` |   |  __| | . ` | |  | | |\/| |
prompt |  | |__| | |__| | |  | |/ ____ \ _| |_| |\  |   | |____| |\  | |__| | |  | |
prompt |  |_____/ \____/|_|  |_/_/    \_\_____|_| \_|   |______|_| \_|\____/|_|  |_|
prompt |                                                                            
prompt |                                                                            
pause
set echo on
create domain open_day as enum (
  monday    = 'MON',
  tuesday   = 'TUE',
  wednesday = 'WED',
  thursday  = 'THU',
  friday    = 'FRI'
);
pause  
clear screen
create table corner_store (
  product      varchar2(10),
  sales_person varchar2(10),
  dow          open_day
);
pause
insert into corner_store
values ('Milk','Joe', open_day.monday);
pause
insert into corner_store
values ('Bread','Sue', open_day.wednesday);
pause
clear screen
select *
from corner_store;
pause
select product, sales_person, domain_display(dow)
from corner_store;
pause
select * from open_day;
pause
clear screen
--
-- behind the scenes
--
select constraint_name, constraint_type, search_condition_vc
from user_constraints
where table_name = 'CORNER_STORE'
@pr
pause
clear screen
set echo on
drop table corner_store purge;
drop domain open_day force;
pause
create domain open_day as enum (
  monday,
  tuesday,
  wednesday,
  thursday,
  friday
);
pause
clear screen
create table corner_store (
  product      varchar2(10),
  sales_person varchar2(10),
  dow          open_day
);
pause
insert into corner_store
values ('Milk','Joe', open_day.monday);
pause
insert into corner_store
values ('Bread','Sue', open_day.wednesday);
pause
clear screen
select product, sales_person, domain_display(dow)
from corner_store;
pause
clear screen
drop domain open_day force PRESERVE;
pause
create domain open_day as enum (
  sunday,
  monday,
  tuesday,
  wednesday,
  thursday,
  friday
);
pause
alter table corner_store
  modify ( dow domain open_day );
pause
select product, sales_person, domain_display(dow)
from corner_store;
pause
clear screen
select * from open_day;
pause
--
-- what is really happening
--
-- create domain open_day as enum (
--   monday    = 1,
--   tuesday   = 2,
--   wednesday = 3,
--   thursday  = 4,
--   friday    = 5
-- );
-- 
pause
clear screen
drop domain open_day force preserve;
pause
create domain open_day as enum (
  sunday    = 7,
  monday    = 1,
  tuesday   = 2,
  wednesday = 3,
  thursday  = 4,
  friday    = 5
);
pause
alter table corner_store
  modify ( dow domain open_day );
pause
select product, sales_person, domain_display(dow)
from corner_store;
pause
clear screen
select constraint_name, constraint_type, search_condition_vc
from user_constraints
where table_name = 'CORNER_STORE'
@pr

pause Done
