-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
set trimspool on
set timing off
set serverout on
clear buffer
undef dumpfile
undef dumptable
undef dumpowner
var maxcol number
var linelen number
var dumpfile char(40)
col column_id noprint
set pages0 feed off termout on echo off verify off
accept dumpowner char prompt 'Owner of table to dump: '
accept dumptable char prompt 'Table to dump         : '
begin
        select max(column_id) into :maxcol
        from all_tab_columns
        where table_name = rtrim(upper('&dumptable'))
        and owner = rtrim(upper('&dumpowner'));
        select sum(data_length) + ( :maxcol * 3 ) into :linelen
        from all_tab_columns
        where table_name = rtrim(upper('&dumptable'))
        and owner = rtrim(upper('&dumpowner'));
end;
/
print linelen
REM print maxcol
spool ./&dumptable..sql
select 'PROMPT NB: If unload "completes" immediately, then an arraysize' from dual;
select 'PROMPT     has probably occurred, decrease and re-run' from dual;
select 'PROMPT    ' from dual;
select 'PROMPT Unloading records...' from dual;
select 'set arraysize '|| round(15000 / :linelen) from dual;
select 'set trimspool on' from dual;
select 'set termout off pages 0 heading off feedback off echo off' from dual;
select 'set line ' || :linelen from dual;
select 'spool ' || lower('&dumptable') || '.txt' from dual;
select 'select' || chr(10) from dual;
REM
select '   ' || decode(data_type,'VARCHAR2', '''' || chr(255) || '''' || ' || ')
  || decode(data_type,'DATE','to_char('||column_name||',''YYYYMMDDHH24MISS'')',column_name)
        || ' ||' || decode(data_type,'VARCHAR2','''' || chr(255)||',' || '''' || ' || ',''''||','||''''||'||'),
        column_id
from all_tab_columns
where table_name = upper('&dumptable')
and owner = upper('&dumpowner')
and column_id < :maxcol
union
select '   ' || decode(data_type,'VARCHAR2','''' || chr(255)  || '''' || ' || ')
  || decode(data_type,'DATE','to_char('||column_name||',''YYYYMMDDHH24MISS'')',column_name)
        || decode(data_type,'VARCHAR2','||' || '''' || chr(255) || ''''),
        column_id
from all_tab_columns
where table_name = upper('&dumptable')
and owner = upper('&dumpowner')
and column_id = :maxcol
order by 2
/
select 'from &dumpowner..&dumptable' from dual;
select '/' from dual;
select 'spool off' from dual;
spool off
set line 79
-- build a basic control file
spool /tmp/_dtmp.sql
select 'spool ' || lower('&dumptable') || '.par' from dual;
spool off
@@/tmp/_dtmp

select 'userid = /' || chr(10) ||
        'control = ' || lower('&dumptable') || '.ctl' || chr(10) ||
        'log = ' || lower('&dumptable') || '.log' || chr(10) ||
        'bad = ' || lower('&dumptable')|| '.bad' || chr(10)
from dual;
spool /tmp/_dtmp.sql
select 'spool ' || lower('&dumptable') || '.ctl' from dual;
spool off
@@/tmp/_dtmp
select 'load data' || chr(10) ||
        'infile ' || ''''|| lower('&dumptable') || '.txt' || '''' ||
chr(10) ||
        'into table &dumptable' || chr(10) ||
        'truncate' || chr(10) ||
        'fields terminated by ' || '''' || ',' || '''' ||
        'optionally enclosed by ' || 'X''FF''' || chr(10) ||
        'trailing nullcols'|| chr(10)
from dual;
select '(' from dual;
select '   ' || 
  decode(data_type,'DATE',column_name||' date(14) "YYYYMMDDHH24MISS"',column_name) || ',' ,
        column_id
from all_tab_columns
where table_name = upper('&dumptable')
and owner = upper('&dumpowner')
and column_id < :maxcol
union
select '   ' || column_name, column_id
from all_tab_columns
where table_name = upper('&dumptable')
and owner = upper('&dumpowner')
and column_id = :maxcol
order by 2
/
select ')' from dual;
spool off
!rm -f /tmp/_dtmp.sql
PROMPT
PROMPT
PROMPT The following scripts can be used to unload and
PROMPT reload the data. 
PROMPT
PROMPT
PROMPT
PROMPT
PROMPT  =================================================
PROMPT  Unload sql:      &dumptable..sql
PROMPT  SQLLDR Parfile:  &dumptable..par
PROMPT  SQLLDR Ctlfile:  &dumptable..ctl
PROMPT  =================================================
