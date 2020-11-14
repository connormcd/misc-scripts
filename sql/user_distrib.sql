-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
select seg, 
        lpad(case 
           when byt > 1024*1024*1024 then round(byt/1024/1024/1024)||'G'
           when byt > 1024*1024 then round(byt/1024/1024)||'M'
           else round(byt/1024)||'K'
        end,8) sz
from (        
select  coalesce(i.table_name,l.table_name, s.segment_name) seg, sum(s.bytes) byt
from user_segments s,
     user_indexes i,
     user_lobs l
where s.segment_name = i.index_name(+)
and   s.segment_name = l.segment_name(+)     
group by coalesce(i.table_name,l.table_name, s.segment_name)
order by 2 desc
)


