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
conn sys/SYS_PASSWD@db20cdb as sysdba
set termout off
alter pluggable database db20pdb2 close;
drop pluggable database db20pdb2 including datafiles;
conn sys/SYS_PASSWD@db20cdb as sysdba
clear screen
set echo on
set termout on
create pluggable database db20pdb2 
admin user pdb_admin identified by admin
  file_name_convert=('/u01/oradata/DB20/pdbseed','/u01/oradata/DB20/db20pdb2');
alter pluggable database db20pdb2 open;
alter pluggable database all save state;
alter session set container = db20pdb2;
create tablespace users datafile '/u01/oradata/DB20/db20pdb2/users01.dbf' size 100m autoextend on next 20m;
pause
clear screen
create user demo identified by demo;
grant resource, connect to demo;
alter user demo quota 100m on users;
alter user demo default tablespace users;
pause
clear screen
create blockchain table demo.tmp$bc ( 
      tag varchar2(128), 
      dte date, 
      num number) 
  no drop until 16 days idle 
  no delete locked 
  hashing using "SHA2_512" version "v1"; 
pause
drop table demo.tmp$bc purge;
pause
clear screen
create blockchain table demo.tmp$bc ( 
      tag varchar2(128), 
      dte date, 
      num number) 
  no drop until 16 days idle 
  no delete locked 
  hashing using "SHA2_512" version "v1"; 
pause
insert into demo.tmp$bc values('xx',sysdate,10); 
commit; 
pause
clear screen
show user
pause
drop table demo.tmp$bc purge;
pause
drop user demo cascade; 
pause
clear screen
conn sys/SYS_PASSWD@db20cdb as sysdba
set echo on
alter pluggable database db20pdb2 close;
drop pluggable database db20pdb2 including datafiles;


