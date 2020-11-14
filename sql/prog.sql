select o.object_name, s.PROGRAM_LINE#
from   dba_objects o, v$sql s
where  s.sql_id = '&1'
and    s.program_id = o.object_id;
