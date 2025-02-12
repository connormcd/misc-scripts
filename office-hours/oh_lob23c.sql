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
conn SYS_USER/PASSWORD@MY_PDB
set termout off
@drop t
set define off
undefine 1
clear screen
set define '&'
set verify off
set termout on
set echo on
clear screen
create or replace directory tracedir 
as '/u01/app/oracle/diag/rdbms/db234/db234/trace';
pause
create table t ( pk int, c clob )
lob (c) store as ( enable storage in row );
pause
insert into t 
values (1, rpad('x',512,'x'));
commit;
pause
clear screen
alter system flush buffer_cache;
alter system checkpoint global;
pause
col block_no new_value b
col file_no  new_value f
select 
  dbms_rowid.rowid_block_number(rowid) block_no,
  dbms_rowid.rowid_relative_fno(rowid) file_no
from t;
pause
col trcfile new_value fname nopri
col trace_file new_value trc
select value trace_file, substr(value,1+instr(value,'/',1,9)) trcfile
from v$diag_info
where name = 'Default Trace File';
pause
alter system dump datafile &&f block &&b;
pause
set termout off
clear screen
conn SYS_USER/PASSWORD@MY_PDB
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
       location ( '&&fname' )
reject limit unlimited ) ext
where substr(col,1,3) in (
'blo',
'tab',
'tl:',
'col'
)

pause
/
pause
set termout off
@drop t
clear screen
conn SYS_USER/PASSWORD@MY_PDB
set termout on
set echo on
create table t ( pk int, c clob )
lob (c) store as ( enable storage in row );
insert into t 
values (1, rpad('x',2000,'x'));
commit;
pause
alter system flush buffer_cache;
alter system checkpoint global;
pause
clear screen
col block_no new_value b
col file_no  new_value f
select 
  dbms_rowid.rowid_block_number(rowid) block_no,
  dbms_rowid.rowid_relative_fno(rowid) file_no
from t;
pause
col trace_file new_value trc
select value trace_file, substr(value,1+instr(value,'/',1,9)) trcfile
from v$diag_info
where name = 'Default Trace File';
pause
alter system dump datafile &&f block &&b;
pause
clear screen
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
       location ( '&&fname' )
reject limit unlimited ) ext
where substr(col,1,3) in (
'blo',
'tab',
'tl:',
'col'
);
pause
clear screen
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
       location ( '&&fname' )
reject limit unlimited ) ext
where col like 'LOB%' or col like 'Locator%' or col like '  Leng%'

pause
/
pause
set termout off
@drop t
clear screen
conn SYS_USER/PASSWORD@MY_PDB
set termout on
set echo on
create table t ( pk int, c clob )
lob (c) store as ( enable storage in row 8000 );
pause
insert into t 
values (1, rpad('x',2000,'x'));
commit;
pause
alter system flush buffer_cache;
alter system checkpoint global;
col block_no new_value b
col file_no  new_value f
select 
  dbms_rowid.rowid_block_number(rowid) block_no,
  dbms_rowid.rowid_relative_fno(rowid) file_no
from t;
col trace_file new_value trc
select value trace_file, substr(value,1+instr(value,'/',1,9)) trcfile
from v$diag_info
where name = 'Default Trace File';
alter system dump datafile &&f block &&b;
pause
clear screen
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
       location ( '&&fname' )
reject limit unlimited ) ext
where substr(col,1,3) in (
'blo',
'tab',
'tl:',
'col'
);
pause
set termout off
@drop t
clear screen
conn SYS_USER/PASSWORD@MY_PDB
set termout on
set echo on

create table t ( pk int, c clob )
lob (c) store as ( enable storage in row 8000 );
insert into t 
values (1, rpad('x',3900,'x'));
commit;
pause
alter system flush buffer_cache;
alter system checkpoint global;
col block_no new_value b
col file_no  new_value f
select 
  dbms_rowid.rowid_block_number(rowid) block_no,
  dbms_rowid.rowid_relative_fno(rowid) file_no
from t;
col trace_file new_value trc
select value trace_file, substr(value,1+instr(value,'/',1,9)) trcfile
from v$diag_info
where name = 'Default Trace File';
alter system dump datafile &&f block &&b;
pause
clear screen
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
       location ( '&&fname' )
reject limit unlimited ) ext
where substr(col,1,3) in (
'blo',
'tab',
'tl:',
'col'
);



