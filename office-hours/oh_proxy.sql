REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

set termout off
conn / as sysdba
drop user demo cascade;
drop user joe_dba cascade;
drop table scott.meant_to_be_public purge;
create user joe_dba identified by joe_dba;
grant dba to joe_dba;
set termout on
set echo on
clear screen
conn joe_dba/joe_dba
pause
create table scott.meant_to_be_public ( x ) as select 1 from dual;
grant select on scott.meant_to_be_public to connect, resource;
pause

create user demo identified by demo;
grant create session to demo;
pause

conn demo/demo
pause
select * from scott.meant_to_be_public;
pause

conn joe_dba/joe_dba
pause
select * from scott.meant_to_be_public;
pause

alter user demo grant connect through joe_dba;
pause
conn joe_dba[demo]/joe_dba
pause
show user
pause

select * from scott.meant_to_be_public;

