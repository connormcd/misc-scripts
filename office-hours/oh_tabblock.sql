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
conn USER/PASSWORD@MY_PDB
set termout off
@drop tab4k
@drop tab8k
col trc new_value trace_file
clear screen
set termout on
set echo on
create table tab4k tablespace ts4k
as select * from dba_objects;
pause
create table tab8k 
as select * from dba_objects;
pause
clear screen
alter system flush buffer_cache;
pause
select value , substr(value,1+instr(value,'\',1,7)) trc
from v$diag_info
where name = 'Default Trace File';
pause
exec dbms_monitor.session_trace_enable(waits=>true);
pause
select * from tab8k
where owner = 'x';
pause
disc
set termout off
clear screen
conn USER/PASSWORD@MY_PDB
set termout on
set echo on
select col
from   external (
      ( col varchar2(4000) )
      type oracle_loader
      default directory tracedir
      access parameters
      ( records delimited by newline
        nobadfile
        nologfile
        nodiscardfile
       )
       location ( '&&trace_file' )
reject limit unlimited ) ext
where col like '%db file scattered read%'

pause
/
pause
clear screen
select value , substr(value,1+instr(value,'\',1,7)) trc
from v$diag_info
where name = 'Default Trace File';
pause
clear screen
alter system flush buffer_cache;
pause
exec dbms_monitor.session_trace_enable(waits=>true);
pause
select * from tab4k
where owner = 'x';
pause
disc
pause
set termout off
clear screen
conn USER/PASSWORD@MY_PDB
set termout on
set echo on
select col
from   external (
      ( col varchar2(4000) )
      type oracle_loader
      default directory tracedir
      access parameters
      ( records delimited by newline
        nobadfile
        nologfile
        nodiscardfile
       )
       location ( '&&trace_file' )
reject limit unlimited ) ext
where col like '%db file scattered read%'

pause
/
