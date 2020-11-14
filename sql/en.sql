-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
set arraysize 200
set lines 200
set trimspool on
set pages 0
spool nomtest
set long 10000000
set termout off
spool en_test.lst
select '<MessageNumber>' || rownum || '</MessageNumber>',message_set.*
from
(select message
  from interface_log
  where created_userid = 'TrelisToIdm'
  and log_id between 90163293 and 90163665
  order by log_id asc) message_set
/
exit
