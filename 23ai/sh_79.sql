clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
clear screen
set termout off
alter session set "_partition_by_expression" = true ;
@drop person
clear screen
col high_value format a30
set termout on
set echo off
set serverout on
prompt |   
prompt |   
prompt |     _____        _____ _______ _____ _______ _____ ____  _   _     ________   _______  _____  
prompt |    |  __ \ /\   |  __ \__   __|_   _|__   __|_   _/ __ \| \ | |   |  ____\ \ / /  __ \|  __ \ 
prompt |    | |__) /  \  | |__) | | |    | |    | |    | || |  | |  \| |   | |__   \ V /| |__) | |__) |
prompt |    |  ___/ /\ \ |  _  /  | |    | |    | |    | || |  | | . ` |   |  __|   > < |  ___/|  _  / 
prompt |    | |  / ____ \| | \ \  | |   _| |_   | |   _| || |__| | |\  |   | |____ / . \| |    | | \ \ 
prompt |    |_| /_/    \_\_|  \_\ |_|  |_____|  |_|  |_____\____/|_| \_|   |______/_/ \_\_|    |_|  \_\
prompt |                                                                                               
prompt |                                                                                               
prompt |  
prompt |   
pause
clear screen
set echo on
clear screen
create table person (
  pid     int primary key,
  name    varchar2(100),
  email   varchar2(100)
)
partition by list ( "EMAIL DOMAIN" )

pause
--
-- alter table person add email_domain 
--     generated as ( ... )
--
pause
clear screen
create table person (
  pid     int primary key,
  name    varchar2(100),
  email   varchar2(100)
)
partition by 
  list ( substr(email,1+instr(email,'@')) ) automatic
( 
  partition p_oracle values ('oracle.com')
);
pause
insert into person 
values (1,'Connor','connor@oracle.com');
pause
insert into person 
values (2,'Suzy','suzy@gmail.com');
pause
select partition_name, high_value
from   user_tab_partitions
where  table_name = 'PERSON';


pause Done
