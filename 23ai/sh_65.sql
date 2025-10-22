clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
clear screen
set termout off
@drop newemp
@drop my_uuid_table
clear screen
set termout on
set echo off
set serverout on
prompt |   
prompt |   
prompt |   
prompt |   
prompt |     _    _ _    _ _____ _____  
prompt |    | |  | | |  | |_   _|  __ \ 
prompt |    | |  | | |  | | | | | |  | |
prompt |    | |  | | |  | | | | | |  | |
prompt |    | |__| | |__| |_| |_| |__| |
prompt |     \____/ \____/|_____|_____/ 
prompt |                                
prompt |                                
prompt |   
prompt |   
pause
clear screen
set echo on
clear screen
select sys_guid();
select sys_guid();
pause
conn dbdemo/dbdemo@db19
select sys_guid() from dual;
select sys_guid() from dual;
pause
clear screen
conn dbdemo/dbdemo@db23
select uuid(4);
pause
--
--
-- V1 - Time-based
-- V2 - DCE Security
-- V3 - Name-based (MD5)
-- V4 - Random
-- V5 - Name-based (SHA-1)
-- V6 - Reordered Time-based (Draft)
-- V7 - Unix Epoch + Random (Draft)
-- 
pause
select uuid(7);
pause
select json_id('OID');
pause
select json_id('UUID');
pause
select json_id('oid');
pause
clear screen
create table my_uuid_table (
    id raw(16) default uuid(4) primary key not null,
    y int
)

pause
/
pause
create table my_uuid_table (
    id raw(16) primary key not null,
    y int
);
alter table my_uuid_table modify id default  uuid();
pause
insert into my_uuid_table (y) values (1);
pause
select * from my_uuid_table;

pause Done
