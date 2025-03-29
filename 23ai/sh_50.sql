drop table t purge;
create table t ( j json);
begin
  insert into t values (
  '{ "name"     : "Connor",
     "email"    : "connor@oracle.com",
     "salary"   : 0,
     "location" : ["Perth","Sydney","Melbourne"]
   }');
end;
/

select jsontoxml(j) from t;



@drop cars
create table cars ( pk int generated as identity, details json);


insert into cars ( details) values ('{"make": "Toyota", "model": "Camry",  "fuel": "Diesel"}');
insert into cars ( details) values ('{"make": "Honda", "model": "Accord", "year": 2019, "fuel": "Gasoline"}');
insert into cars ( details) values ('{"make": "Ford", "model": "Mustang", "year": 2021, "fuel": "Gasoline"}');
insert into cars ( details) values ('{"make": "Chevrolet", "model": "Malibu", "year": 2018, "fuel": "Gasoline"}');
insert into cars ( details) values ('{"make": "Nissan", "model": "Altima", "year": 2020, "fuel": "Diesel"}');
insert into cars ( details) values ('{"make": "BMW", "model": "3 Series",  "fuel": "Gasoline"}');
insert into cars ( details) values ('{"make": "Mercedes-Benz", "model": "C-Class", "year": 2021, "fuel": "Gasoline"}');
insert into cars ( details) values ('{"make": "Audi", "model": "A4", "year": 2020, "fuel": "Gasoline"}');
insert into cars ( details) values ('{"make": "Volkswagen", "model": "Passat", "year": 2019, "fuel": "Gasoline"}');
insert into cars ( details) values ('{"make": "Hyundai", "model": "Elantra", "year": 2018, "fuel": "Diesel"}');
insert into cars ( details) values ('{"make": "Kia", "model": "Optima", "year": 2020, "fuel": "Gasoline"}');
insert into cars ( details) values ('{"make": "Subaru", "model": "Impreza", "year": 2021, "fuel": "Gasoline"}');
insert into cars ( details) values ('{"make": "Mazda", "model": "Mazda3",  "fuel": "Gasoline"}');
insert into cars ( details) values ('{"make": "Lexus", "model": "IS", "year": 2020, "fuel": "Gasoline"}');
insert into cars ( details) values ('{"make": "Infiniti", "model": "Q50", "year": 2019, "fuel": "Diesel"}');
insert into cars ( details) values ('{"make": "Acura", "model": "TLX", "year": 2018, "fuel": "Gasoline"}');
insert into cars ( details) values ('{"make": "Cadillac", "model": "CTS", "year": 2020, "fuel": "Gasoline"}');
insert into cars ( details) values ('{"make": "Chrysler", "model": "300", "year": 2021, "fuel": "Gasoline"}');
insert into cars ( details) values ('{"make": "Dodge", "model": "Charger", "year": 2022, "fuel": "Hydrogen"}');
insert into cars ( details) values ('{"make": "Buick", "model": "Regal", "year": 2020, "fuel": "Gasoline"}');
insert into cars ( details) values ('{"make": "Genesis", "model": "G70", "year": 2021, "fuel": "Hybrid"}');
insert into cars ( details) values ('{"make": "Jaguar", "model": "XE",  "fuel": "Gasoline"}');
insert into cars ( details) values ('{"make": "Alfa Romeo", "model": "Giulia", "year": 2021, "fuel": "Gasoline"}');
insert into cars ( details) values ('{"make": "Tesla", "model": "Model 3", "year": 2022, "fuel": "Electric"}');
insert into cars ( details) values ('{"make": "Volvo", "model": "S60", "year": 2020, "fuel": "Gasoline"}');
insert into cars ( details) values ('{"make": "Lincoln", "model": "MKZ", "year": 2019, "fuel": "Gasoline"}');
insert into cars ( details) values ('{"make": "Porsche", "model": "Panamera", "year": 2021, "fuel": "Hybrid"}');
insert into cars ( details) values ('{"make": "Mitsubishi", "model": "Lancer", "year": 2018, "fuel": "Gasoline"}');
insert into cars ( details) values ('{"make": "Mini", "model": "Cooper", "year": 2020, "fuel": "Gasoline"}');
insert into cars ( details) values ('{"make": "Fiat", "model": "500", "year": 2019, "fuel": "Hybrid"}');


select json_dataguide(details, dbms_json.format_flat, dbms_json.pretty) guide
from   cars;

select json_dataguide(details, dbms_json.format_schema, dbms_json.pretty) guide
from   cars;

select json_dataguide(details, dbms_json.format_schema) guide
from   cars;

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
}'

pause Done
