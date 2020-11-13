-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
create or replace view OBJECT_USAGE as
select /*+ LEADING(ou) */ io.name index_name, t.name table_name,
       decode(bitand(i.flags, 65536), 0, 'NO', 'YES') monitoring,
       decode(bitand(ou.flags, 1), 0, 'NO', 'YES') used,
       ou.start_monitoring,
       ou.end_monitoring
from sys.obj$ io, sys.obj$ t, sys.ind$ i, sys.object_usage ou
where i.obj# = ou.obj#
  and io.obj# = ou.obj#
  and t.obj# = i.bo#

