-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
set termout off
store set x:\temp\_sqlplus_settings replace
clear breaks
clear columns
clear computes
set feedback off
set verify off
set termout on

undefine f
undefine m
undefine u
undefine module_or_blank
undefine userid_or_blank
column filename new_val f nopri
column module new_val m nopri
column userid new_val u nopri
col info format a60 trunc
select module, userid, filename,
  'Processing file '||filename info
from 
( select * from imswaps.all_trace_files
  where ( module = upper('&&module_or_blank') or nvl('&&module_or_blank','*') = '*' )
  and   ( userid = upper('&&userid_or_blank') or userid = nvl('&&userid_or_blank','*') )
  order by dt desc )
where rownum = 1
/
column filename pri
column module pri
column userid pri

exec imswaps.dbpk_trc.retrieve('&m','&u')
set termout off
set heading off
set feedback off
set embedded on
set linesize 4000
set trimspool on
set verify off
spool x:\temp\&f
select text from imswaps.trace_file_text order by id;
spool off
set verify on
set feedback on
set heading on
set termout on
host del x:\temp\tk.prf
host tkprof x:\temp\&f x:\temp\tk.prf
edit x:\temp\tk.prf

set termout off
@x:\temp\_sqlplus_settings
clear breaks
clear columns
clear computes
set termout on



