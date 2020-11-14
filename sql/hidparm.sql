col name format a40
col descr format a30
select ksppinm name, ksppdesc descr
from sys.x_$ksppi
where  ksppinm like '%'||nvl('&name',ksppinm)||'%'
and substr(ksppinm,1,1) = '_';
