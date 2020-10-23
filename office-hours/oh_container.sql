REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

rem conn / as sysdba
rem alter session set container = pdb1;
rem alter pluggable database containers port reset;
rem alter pluggable database containers host reset;
rem alter session set container = pdb2;
rem alter pluggable database containers port reset;
rem alter pluggable database containers host reset;
rem conn / as sysdba
rem startup force

set termout off
conn system/SYSTEM_PASSWD
set termout off
drop table system.demo purge;
alter session set container = pdb1;
drop table system.demo purge;
alter session set container = pdb2;
drop table system.demo purge;
set termout on

set echo on
clear screen
conn system/SYSTEM_PASSWD
col name format a30
select con_id, name from v$pdbs;
create table system.demo ( x int );
pause
alter session set container = pdb1;
create table system.demo ( x int );
pause
alter session set container = pdb2;
create table system.demo ( x int );
pause

clear screen
conn system/SYSTEM_PASSWD
pause
select * from containers(system.demo);
pause
select con_id, name from v$pdbs;
insert into containers(system.demo) (con_id,x) values (3,10);
pause

host lsnrctl status LISTENER19
pause
host tail -50 "C:\oracle\diag\rdbms\db19\db19\trace\alert_db19.log"
pause
host lsnrctl status LISTENER19
pause

clear screen
conn / as sysdba
pause
alter session set container = pdb1;
alter pluggable database containers port=1519;
alter pluggable database containers host='localhost';
pause
alter session set container = pdb2;
alter pluggable database containers port=1519;
alter pluggable database containers host='localhost';
pause

clear screen
conn system/SYSTEM_PASSWD
pause
insert into containers(system.demo) (con_id,x) values (3,10);
pause

clear screen
conn / as sysdba
alter session set container = pdb1;
alter pluggable database close immediate;
alter pluggable database open;
alter session set container = pdb2;
alter pluggable database close immediate;
alter pluggable database open;
pause
clear screen

conn system/SYSTEM_PASSWD
insert into containers(system.demo) (con_id,x) values (3,10);
pause

conn / as sysdba
startup force
pause
clear screen

conn system/SYSTEM_PASSWD
pause

insert into containers(system.demo) (con_id,x) values (3,10);
insert into containers(system.demo) (con_id,x) values (5,10);
commit;
select * from containers(system.demo);
pause

clear screen
delete from containers(system.demo);
pause
delete from containers(system.demo) where con_id in (3,5);
pause
delete from containers(system.demo) where con_id = 3;
delete from containers(system.demo) where con_id = 5;
commit;
pause

clear screen
insert into containers(system.demo) (con_id,x) values (3,10);
insert into containers(system.demo) (con_id,x) values (5,10);
pause
select * from containers(system.demo);
pause
commit;
pause
select * from containers(system.demo);
pause;

clear screen
delete from containers(system.demo) where con_id = 3;
delete from containers(system.demo) where con_id = 5;
commit;
insert into containers(system.demo) (con_id,x) values (3,10);
commit;
select * from containers(system.demo);
pause

clear screen
declare
  rc sys_refcursor;
begin
  open rc for select * from containers(system.demo);
end;
/
pause
declare
  rc sys_refcursor;
  c1 int;
  c2 int;
begin
  open rc for select * from containers(system.demo);
  fetch rc into c1,c2;
  close rc;
end;
.

pause
/
pause

clear screen
begin
for i in ( select con_id, x from containers(system.demo) )
loop
  null;
end loop;
end;
.

pause
/

pause
clear screen

declare
  res int;
begin
  select x into res 
  from   containers(system.demo)
  where  rownum = 1;
end;
/
pause
clear screen

declare
  rc sys_refcursor;
  c1 int;
  c2 int;
begin
  open rc for 'select * from containers(system.demo)';
  fetch rc into c1,c2;
  close rc;
end;
.

pause
/

pause
clear screen
show con_id
pause
declare
  l_con int := 5;
begin
  insert into containers(system.demo) (con_id,x) values (l_con,20);
  commit;
end;
/
pause
select * from containers(system.demo);


