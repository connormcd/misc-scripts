-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
col name format a50 trunc

select name, PHYRDS, PHYWRTS
from v$filestat, v$datafile
where v$filestat.FILE# = v$datafile.FILE#
order by 2
/
