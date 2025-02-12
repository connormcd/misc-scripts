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
@drop t
undefine blk
undefine blk1
undefine fno
undefine fno1
undefine trc
undefine trc1
set verify off
set termout off
set termout on
set echo on

select chr(9702 using nchar_cs) white_bullet
from dual;
pause

select dump(chr(9702 using nchar_cs)) bytes
from dual;
pause

select trunc(9702/256) upper
from dual;
pause
select mod(9702,256) upper
from dual;
pause
clear screen
select 
  to_char(37,'fmxx') b1, 
  to_char(230,'fmxx') b2
from dual;
pause

select dump(convert(chr(9702 using nchar_cs), 'al16utf16le' ), 1016) little_endian 
from dual;
pause
select dump(chr(9702 using nchar_cs), 1016) big_endian 
from dual;
pause
clear screen

create table t as
select chr(9702 using nchar_cs) white_bullet
from dual;
pause
col fno new_value fno1
col blk new_value blk1
select 
  dbms_rowid.rowid_block_number(rowid) blk,
  dbms_rowid.rowid_relative_fno(rowid) fno
from t;
pause
alter system dump datafile &&fno1 block &&blk1;
pause
select 'egrep "^col" '||value cmd
from  v$diag_info
where  name = 'Default Trace File';
pause
disc
host
pause
clear screen

set termout off
conn USER/PASSWORD@MY_PDB
set termout on
col platform_name format a40
set echo on
clear screen
select platform_name, endian_format
from  v$transportable_platform
order by 2,1;


