-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
select extractvalue(value(d),'/hint') as outline_lints
from 
xmltable('/*/outline_data/hint'
passing (
  select xmltype(other_xml) as xmlval
from v$sql_plan
where sql_id = '&sql_id'
and   child_number = nvl('&child',0)
and other_xml is not null
)
) d;
