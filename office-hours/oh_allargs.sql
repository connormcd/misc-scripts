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
set echo on
select dbms_metadata.get_ddl('VIEW','ALL_ARGUMENTS','SYS')
from dual;
pause
clear screen
conn / as sysdba
pause
select dbms_metadata.get_ddl('VIEW','ALL_ARGUMENTS','SYS')
from dual;
pause
clear screen
select dbms_metadata.get_ddl('VIEW','INT$DBA_ARGUMENTS','SYS')
from dual;
pause
clear screen
variable b1 varchar2(100)
variable b2 varchar2(100)
variable b3 varchar2(100)
exec :b1 := 'DBMS_LOB'; :b2 := 'COMPARE'; :b3 := '%';
pause
set autotrace traceonly stat
select a.owner, a.package_name, a.object_name, a.argument_name, a.object_id
from   all_arguments a
where  a.argument_name is not null
and    package_name = :b1
and    object_name = :b2
and    argument_name like :b3;
set autotrace off
pause
clear screen
desc all_arguments
pause
clear screen
set autotrace traceonly stat
select  a.owner, a.package_name, a.object_name, a.argument_name, a.object_id
from   all_arguments a,
      all_objects o
where  a.argument_name is not null
and a.package_name = :b1
and a.object_name = :b2
and a.argument_name like :b3
and a.object_id = o.object_id
and o.owner = a.owner
and o.object_name = :b1
and o.object_type = 'PACKAGE';
set autotrace off


