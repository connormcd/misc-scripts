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
clear screen
@clean
conn USER/PASSWORD@MY_PDB
set termout off
col name format a20
col text format a60
col type format a20
alter session set plscope_settings='identifiers:none, statements:none';
drop package pkg;
begin
for i in 1 .. 50 loop
  begin
    execute immediate 'drop package pkg'||i;
  exception
    when others then null;
  end;
end loop;
end;
/
set termout on
clear screen
set feedback on
set echo on
create or replace
package my_old_pkg is
  procedure procA;
  procedure procB;
end;
/
pause
clear screen
create or replace
package body my_old_pkg is
  procedure procA is
    x int;
  begin
    select count(*)
    into   x
    from   user_objects;
  end;
  
  --
  -- no longer should be used
  --
  procedure procB is
    y date;
  begin
    select max(created)
    into   y
    from   user_objects;
  end;
end;
/
pause
clear screen
create or replace
package pkg1 is
  procedure p1;
  procedure p2;
end;
/
pause
create or replace
package body pkg1 is
  procedure p1 is
  begin
    null;
  end;
    
  procedure p2 is
  begin
    my_old_pkg.procb;
  end;
end;
/
pause
clear screen
select name, type
from user_dependencies
where referenced_name = 'MY_OLD_PKG';
pause
clear screen
begin
for i in 2 .. 50 loop
  execute immediate 
     'create or replace package pkg'||i||
     ' is   procedure p1;   procedure p2; end;';

  execute immediate 
     'create or replace package body pkg'||i||
     ' is procedure p1 is begin null;  end; '||
     '  procedure p2 is  begin    my_old_pkg.proca;  end;end;';
end loop;
end;
/
pause
clear screen
select name, type
from user_dependencies
where referenced_name = 'MY_OLD_PKG'

pause
/
pause
clear screen
create or replace
package my_old_pkg is
  procedure procA;
  procedure procB;
    pragma deprecate(procB,'this proc is deprecrated');
end;
/
pause
alter session set plsql_warnings = 'enable:(6019,6020,6021,6022)';
pause
exec pkg1.p2
pause
clear screen
alter package pkg1 compile;
pause
select text from user_errors
where name = 'PKG1';
pause
select object_type,status
from   user_objects
where  object_name = 'PKG1';
pause
clear screen
select name, text
from user_source
where lower(text) like '%my_old_pkg.procb%';
pause
select *
from user_identifiers;
pause
clear screen
alter session set plscope_settings='identifiers:all, statements:all';
pause
alter package pkg1 compile;
pause
alter package MY_OLD_PKG compile;
pause
select name, type, object_name
from user_identifiers
order by 3,2,1;
pause
clear screen
alter session set plsql_warnings = 'error:(6019,6020,6021,6022)';
pause
alter package pkg1 compile;
alter package MY_OLD_PKG compile;
pause
select object_type,status
from   user_objects
where  object_name = 'PKG1';

