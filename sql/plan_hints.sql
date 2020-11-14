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
