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
@drop t
drop table hr.new_table purge;
alter session set group_by_position_enabled = false;
@drop t
@drop person
@drop seq
@drop cars
@drop myemp
create or replace
function my_plsql_func return number is
begin
  return 10;
end;
/
create sequence seq;
clear screen
set termout on
set echo off
prompt |
prompt |       _  _____  ____  _   _       _____  _____ _    _ ______ __  __          
prompt |      | |/ ____|/ __ \| \ | |     / ____|/ ____| |  | |  ____|  \/  |   /\    
prompt |      | | (___ | |  | |  \| |    | (___ | |    | |__| | |__  | \  / |  /  \   
prompt |  _   | |\___ \| |  | | . ` |     \___ \| |    |  __  |  __| | |\/| | / /\ \  
prompt | | |__| |____) | |__| | |\  |     ____) | |____| |  | | |____| |  | |/ ____ \ 
prompt |  \____/|_____/ \____/|_| \_|    |_____/ \_____|_|  |_|______|_|  |_/_/    \_\
prompt |                  
pause
set echo on
clear screen
-- 
-- did somebody say XMLDB? :-)
--
pause
--
--  19c
--
--
-- SQL> create table t ( j json);
-- create table t ( j json)
--                    *
-- ERROR at line 1:
-- ORA-00902: invalid datatype
-- 
pause
--
--  21c
--
--
--
-- SQL> create table t ( j json);
--
-- Table created.
-- 
pause
clear screen
create table t ( j json );
pause
insert into t
values ('{"larry":"ellison"}'),
       ('[{"larry":"ellison"},{"safra":"catz"},{"connor":"mcdonald"}]'),
       ('[3,1,4,1,5,9,2,7]');
pause       
insert into t
values ('{}'),
       ('100');
pause
clear screen
alter table t
  modify j json ( limit 50 );
pause
insert into t
values ('[{"larry":"ellison"},{"safra":"catz"},{"connor":"mcdonald"}]');
pause
delete t;
pause
clear screen
alter table t
  modify j json ( object);
pause
insert into t
values ('{"larry":"ellison"}');
pause
insert into t
values ('[{"larry":"ellison"},{"safra":"catz"}]');
pause
roll;
pause
clear screen
alter table t
  modify j json (array);
pause
insert into t
values ('[3,1,4,1,5,9,2,7]');
pause
roll;
pause
clear screen
alter table t
  modify j json (array (number,*,sort));
pause
insert into t
values ('[3,1,4,1,5,9,2,7]');
pause
select * from t;
pause
set echo on
set termout on
clear screen
create table cars (
  id         number,
  json_data  json validate '{
  "type"       : "object",
  "properties" : {"model"    : {"type"      : "string",
                                "minLength" : 1,
                                "maxLength" : 10},
                  "year" : {"type"      : "number",
                                "minimum"   : 1970,
                                "maximum"   : 2023}},
  "required"   : ["model", "year"]
}',
  constraint cars_pk primary key (id)
);
pause
clear screen
insert into cars (id, json_data) values (1, json('{"model":"toyota","year":2011}'));
pause
insert into cars (id, json_data) values (7, json('{"model":"toyota","year":2021,"fuel":"diesel"}'));
pause
insert into cars (id, json_data) values (2, json('{"model":"toyota"}'));
pause            *
insert into cars (id, json_data) values (3, json('{"year":10}'));
pause
insert into cars (id, json_data) values (3, json('{"model":"toyota", "year":10}'));
pause
column table_name format a10
column column_name format a11
column constraint_name format a15
column json_schema format a40
clear screen
select table_name,
       column_name,
       constraint_name,
       json_schema
from   user_json_schema_columns;
pause 
clear screen
-- 
-- what about existing JSON?
--
pause
drop table cars purge;
create table cars ( pk int generated as identity, details json);
pause
insert into cars ( details) 
values 
  ('{"make": "Toyota", "model": "Camry",  "fuel": "Diesel"}')
, ('{"make": "Honda", "model": "Accord", "year": 2019, "fuel": "Gasoline"}')
, ('{"make": "Ford", "model": "Mustang", "year": 2021, "fuel": "Gasoline"}')
, ('{"make": "Chevrolet", "model": "Malibu", "year": 2018, "fuel": "Gasoline"}')
, ('{"make": "Nissan", "model": "Altima", "year": 2020, "fuel": "Diesel"}')
, ('{"make": "BMW", "model": "3 Series",  "fuel": "Gasoline"}')
, ('{"make": "Mercedes-Benz", "model": "C-Class", "year": 2021, "fuel": "Gasoline"}')
, ('{"make": "Audi", "model": "A4", "year": 2020, "fuel": "Gasoline"}')
, ('{"make": "Volkswagen", "model": "Passat", "year": 2019, "fuel": "Gasoline"}')
, ('{"make": "Hyundai", "model": "Elantra", "year": 2018, "fuel": "Diesel"}')
, ('{"make": "Kia", "model": "Optima", "year": 2020, "fuel": "Gasoline"}')
, ('{"make": "Subaru", "model": "Impreza", "year": 2021, "fuel": "Gasoline"}')
, ('{"make": "Mazda", "model": "Mazda3",  "fuel": "Gasoline"}')
#pause
, ('{"make": "Lexus", "model": "IS", "year": 2020, "fuel": "Gasoline"}')
, ('{"make": "Infiniti", "model": "Q50", "year": 2019, "fuel": "Diesel"}')
, ('{"make": "Acura", "model": "TLX", "year": 2018, "fuel": "Gasoline"}')
, ('{"make": "Cadillac", "model": "CTS", "year": 2020, "fuel": "Gasoline"}')
, ('{"make": "Chrysler", "model": "300", "year": 2021, "fuel": "Gasoline"}')
, ('{"make": "Dodge", "model": "Charger", "year": 2022, "fuel": "Hydrogen"}')
, ('{"make": "Buick", "model": "Regal", "year": 2020, "fuel": "Gasoline"}')
, ('{"make": "Genesis", "model": "G70", "year": 2021, "fuel": "Hybrid"}')
, ('{"make": "Jaguar", "model": "XE",  "fuel": "Gasoline"}')
, ('{"make": "Alfa Romeo", "model": "Giulia", "year": 2021, "fuel": "Gasoline"}')
, ('{"make": "Tesla", "model": "Model 3", "year": 2022, "fuel": "Electric"}')
, ('{"make": "Volvo", "model": "S60", "year": 2020, "fuel": "Gasoline"}')
, ('{"make": "Lincoln", "model": "MKZ", "year": 2019, "fuel": "Gasoline"}')
, ('{"make": "Porsche", "model": "Panamera", "year": 2021, "fuel": "Hybrid"}')
, ('{"make": "Mitsubishi", "model": "Lancer", "year": 2018, "fuel": "Gasoline"}')
, ('{"make": "Mini", "model": "Cooper", "year": 2020, "fuel": "Gasoline"}')
, ('{"make": "Fiat", "model": "500", "year": 2019, "fuel": "Hybrid"}')
commit;
pause
clear screen
select json_dataguide(details, dbms_json.format_flat, dbms_json.pretty) guide
from   cars

pause
/
pause
select json_dataguide(details, dbms_json.FORMAT_SCHEMA, dbms_json.pretty) guide
from   cars

pause
/
pause
alter table cars modify details json validate 
'{
  "type" : "object",
  "properties" :
  {
    "fuel" :
    {
      "type" : "string",
      "o:length" : 8,
      "o:preferred_column_name" : "fuel"
    },
    "make" :
    {
      "type" : "string",
      "o:length" : 16,
      "o:preferred_column_name" : "make"
    },
    "year" :
    {
      "type" : "number",
      "o:preferred_column_name" : "year"
    },
    "model" :
    {
      "type" : "string",
      "o:length" : 8,
      "o:preferred_column_name" : "model"
    }
  }
}';

pause Done

