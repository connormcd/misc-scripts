-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
col seg format a40
select owner, seg, 
        lpad(case 
           when byt > 1024*1024*1024 then round(byt/1024/1024/1024)||'G'
           when byt > 1024*1024 then round(byt/1024/1024)||'M'
           else round(byt/1024)||'K'
        end,8) sz
from (        
select s.owner, coalesce(i.table_name,l.table_name, s.segment_name) seg, sum(s.bytes) byt
from dba_segments s,
     dba_indexes i,
     dba_lobs l
where s.owner = i.owner(+)
and   s.segment_name = i.index_name(+)
and   s.owner = l.owner(+)
and   s.segment_name = l.segment_name(+)     
and   s.tablespace_name like upper(nvl('&tablespace_name'||'%',s.tablespace_name))
group by s.owner, coalesce(i.table_name,l.table_name, s.segment_name)
order by 3 desc
)
where byt/1024/1024 >= nvl('&threshold_mb',byt/1024/1024)
/
