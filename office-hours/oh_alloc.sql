REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 
clear screen
@clean
set termout off
conn USERNAME/PASSWORD@DATABASE_SERVICE
set termout off
drop tablespace demo including contents and datafiles;
drop table t purge;
set termout on
set echo on
clear screen
create tablespace demo 
  datafile 'X:\ORACLE\ORADATA\DB19\PDB1\DEMO.DBF' size 50m 
  extent management local uniform size 2m;
pause
alter tablespace demo 
   add datafile 'X:\ORACLE\ORADATA\DB19\PDB1\DEMO2.DBF' size 50m;
pause   
clear screen
create table t ( x int, y char(1000)) tablespace demo;
pause
begin
  for i in 1 .. 20000 loop
    insert into t values (i,'x');
  end loop;
  commit;
end;
/
pause
clear screen
select 
  file_id,
  extent_id,
  block_id,
  bytes
from  dba_extents
where owner = user
and   segment_name = 'T'
order by extent_id;
pause

clear screen
drop tablespace demo including contents and datafiles;

create tablespace demo 
  datafile 'X:\ORACLE\ORADATA\DB19\PDB1\DEMO.DBF' size 8m 
  extent management local uniform size 2m;
pause
alter tablespace demo 
   add datafile 'X:\ORACLE\ORADATA\DB19\PDB1\DEMO2.DBF' size 50m;
pause   
clear screen
create table t ( x int, y char(1000)) tablespace demo;
begin
  for i in 1 .. 20000 loop
    insert into t values (i,'x');
  end loop;
  commit;
end;
/

pause
clear screen
select 
  file_id,
  extent_id,
  block_id,
  bytes
from  dba_extents
where owner = user
and   segment_name = 'T'
order by extent_id;
pause


clear screen
drop tablespace demo including contents and datafiles;

create tablespace demo 
  datafile 'X:\ORACLE\ORADATA\DB19\PDB1\DEMO.DBF' size 50m; 
pause
alter tablespace demo 
   add datafile 'X:\ORACLE\ORADATA\DB19\PDB1\DEMO2.DBF' size 50m;
pause   
clear screen
create table t ( x int, y char(1000)) tablespace demo;
begin
  for i in 1 .. 10000 loop
    insert into t values (i,'x');
  end loop;
  commit;
end;
/

pause
clear screen
select 
  file_id,
  extent_id,
  block_id,
  bytes
from  dba_extents
where owner = user
and   segment_name = 'T'
order by extent_id;

