clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
@drop t
set define off
undefine 1
clear screen
col trcfile clear
set define '&'
set verify off
set termout on
set echo off
prompt |
prompt |    _      ____  _   _  _____    _      ____  ____   _____ 
prompt |   | |    / __ \| \ | |/ ____|  | |    / __ \|  _ \ / ____|
prompt |   | |   | |  | |  \| | |  __   | |   | |  | | |_) | (___  
prompt |   | |   | |  | | . ` | | |_ |  | |   | |  | |  _ < \___ \ 
prompt |   | |___| |__| | |\  | |__| |  | |___| |__| | |_) |____) |
prompt |   |______\____/|_| \_|\_____|  |______\____/|____/|_____/ 
prompt |                                                           
pause
set echo on
clear screen
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
--  dbms_rowid.rowid_relative_fno(rowid) file_no
 ( select file_id from dba_extents 
   where segment_name = 'T'
   and owner = user ) file_no
from t ;
pause
col trcfile new_value fname
select substr(value,1+instr(value,'/',-1)) trcfile
from v$diag_info
where name = 'Default Trace File';
pause
alter system dump datafile &&f block &&b;
pause
set termout off
clear screen
conn dbdemo/dbdemo@db23
set termout on
set echo on
select payload
from   v$diag_trace_file_contents
where trace_filename = '&&fname'
and substr(payload,1,3) in (
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
conn dbdemo/dbdemo@db23
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
--  dbms_rowid.rowid_relative_fno(rowid) file_no
 ( select file_id from dba_extents 
   where segment_name = 'T'
   and owner = user ) file_no
from t ;
pause
col trcfile new_value fname
select substr(value,1+instr(value,'/',-1)) trcfile
from v$diag_info
where name = 'Default Trace File';
pause
alter system dump datafile &&f block &&b;
pause
clear screen
select payload
from   v$diag_trace_file_contents
where trace_filename = '&&fname'
and substr(payload,1,3) in (
'blo',
'tab',
'tl:',
'col'
);
pause
clear screen
select payload
from   v$diag_trace_file_contents
where trace_filename = '&&fname'
and ( payload like 'LOB%' 
 or payload like 'Locator%' 
 or payload like '  Leng%' )

pause
/
pause
set termout off
@drop t
clear screen
conn dbdemo/dbdemo@db23
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
--  dbms_rowid.rowid_relative_fno(rowid) file_no
 ( select file_id from dba_extents 
   where segment_name = 'T'
   and owner = user ) file_no
from t ;
col trcfile new_value fname
select substr(value,1+instr(value,'/',-1)) trcfile
from v$diag_info
where name = 'Default Trace File';
alter system dump datafile &&f block &&b;
pause
clear screen
select payload
from   v$diag_trace_file_contents
where trace_filename = '&&fname'
and substr(payload,1,3) in (
'blo',
'tab',
'tl:',
'col'
);
pause
set termout off
@drop t
clear screen
conn dbdemo/dbdemo@db23
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
--  dbms_rowid.rowid_relative_fno(rowid) file_no
 ( select file_id from dba_extents 
   where segment_name = 'T'
   and owner = user ) file_no
from t ;
col trcfile new_value fname
select substr(value,1+instr(value,'/',-1)) trcfile
from v$diag_info
where name = 'Default Trace File';
alter system dump datafile &&f block &&b;
pause
clear screen
select payload
from   v$diag_trace_file_contents
where trace_filename = '&&fname'
and substr(payload,1,3) in (
'blo',
'tab',
'tl:',
'col'
);

pause Done

