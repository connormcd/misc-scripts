REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 
@clean
set termout off
conn USERNAME/PASSWORD@DATABASE_SERVICE
set termout off
alter table fda_demo no flashback archive;
@drop fda_demo
drop flashback archive FDA;
clear screen
set termout on
set echo on
conn /@DATABASE_SERVICE as sysdba
shutdown immediate
startup
pause
set termout off
conn USERNAME/PASSWORD@DATABASE_SERVICE
clear screen
set termout on
set echo on
alter system flush shared_pool;
pause
create flashback archive FDA tablespace users retention 1 day;
pause
create table fda_demo as select * from dba_objects;
pause
alter table fda_demo flashback archive fda;
pause

clear screen
--
-- sample DML's to kick the archive into action
--
begin
  delete from fda_demo where rownum < 10;
  commit;
end;
/
pause

begin
  insert into fda_demo select * from dba_objects
  where rownum <= 10;
  commit;
end;
/
pause

begin
  update fda_demo set object_id = -object_id
  where mod(object_id,20000) = 0;
  commit;
end;
/
pause

begin
  update fda_demo set object_id = -object_id
  where mod(object_id,13123) = 0;
  commit;
  end;
/
pause
clear screen
begin
  delete from fda_demo where rownum < 10;
  commit;
end;
/
begin
  insert into fda_demo select * from dba_objects
  where rownum <= 10;
  commit;
end;
/
begin
  update fda_demo set object_id = -object_id
  where mod(object_id,20000) = 0;
  commit;
end;
/
begin
  update fda_demo set object_id = -object_id
  where mod(object_id,13123) = 0;
  commit;
  end;
/
begin
  delete from fda_demo where rownum < 10;
  commit;
end;
/
begin
  insert into fda_demo select * from dba_objects
  where rownum <= 10;
  commit;
end;
/
begin
  update fda_demo set object_id = -object_id
  where mod(object_id,20000) = 0;
  commit;
end;
/
begin
  update fda_demo set object_id = -object_id
  where mod(object_id,13123) = 0;
  commit;
  end;
/
begin
  delete from fda_demo where rownum < 10;
  commit;
end;
/
begin
  insert into fda_demo select * from dba_objects
  where rownum <= 10;
  commit;
end;
/
begin
  update fda_demo set object_id = -object_id
  where mod(object_id,20000) = 0;
  commit;
end;
/
begin
  update fda_demo set object_id = -object_id
  where mod(object_id,13123) = 0;
  commit;
  end;
/
begin
  delete from fda_demo where rownum < 10;
  commit;
end;
/
begin
  insert into fda_demo select * from dba_objects
  where rownum <= 10;
  commit;
end;
/
begin
  update fda_demo set object_id = -object_id
  where mod(object_id,20000) = 0;
  commit;
end;
/
begin
  update fda_demo set object_id = -object_id
  where mod(object_id,13123) = 0;
  commit;
  end;
/

pause
clear screen
select sql_text
from   v$sql
where  sql_text like 'delete%FBA%TCRV%';
