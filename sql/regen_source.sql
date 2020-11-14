-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
set pages 0
set heading off
set lines 1000
set trimspool on
col sortkey nopri
col line nopri
spool /tmp/regen_source.lst
select object_name||decode(object_type,'PACKAGE','0','1') sortkey, 0 line,
       'create or replace ' tlist
from user_objects
where object_type in ('PROCEDURE','FUNCTION','PACKAGE','PACKAGE BODY')
union all
select name||decode(type,'PACKAGE','0','1') sortkey, line,
       text
from user_source
where type in ('PROCEDURE','FUNCTION','PACKAGE','PACKAGE BODY')
union all
select object_name||decode(object_type,'PACKAGE','0','1') sortkey, 99999999999,
       '/'
from user_objects
where object_type in ('PROCEDURE','FUNCTION','PACKAGE','PACKAGE BODY')
order by 1, 2;
spool off
