--
-- space distribution in a schema, rolling up things like
-- indexes, LOBs, secondary tables etc to the parent table
-- to get a better view of distribution
--
with 
  indexes_with_secondary as
      ( --
        -- normal indexes
        --
        select index_name, table_name
        from   user_indexes
        where  table_name not in ( select secondary_object_name from user_secondary_objects)
        union all
        --
        -- secondary tables
        --
        select uso.secondary_object_name, ui.table_name
        from   user_secondary_objects uso,
               user_tables ut,
               user_indexes ui
        where  ut.table_name = uso.secondary_object_name
        and    uso.index_name = ui.index_name
        union all
        --
        -- indexes on secondary tables
        --
        select ui.index_name, ui_parent.table_name
        from   user_indexes ui,
               user_secondary_objects uso,
               user_tables ut,
               user_indexes ui_parent
        where  ut.table_name = uso.secondary_object_name
        and    ut.table_name = ui.table_name
        and    uso.index_name = ui_parent.index_name
      ),  
  lobs_with_secondary as
      ( --
        -- normal lobs
        --
        select segment_name, table_name
        from   user_lobs
        where  table_name not in ( select secondary_object_name from user_secondary_objects)
        union all
        --
        -- secondary tables
        --
        select ul.segment_name, ut.table_name
        from   user_lobs ul,
               user_secondary_objects uso,
               user_tables ut,
               user_indexes ui
        where  ul.table_name = uso.secondary_object_name
        and    uso.index_name = ui.index_name
        and    ui.table_name = ut.table_name
      ),
  seg_space as
      (
        select 
          coalesce(
             i.table_name,
             l.table_name, 
            case when s.segment_name like 'BIN$%' then '$RECYCLE_BIN$' else s.segment_name end) seg, 
        sum(s.bytes) byt
        from user_segments s,
             indexes_with_secondary i,
             lobs_with_secondary l
        where s.segment_name = i.index_name(+)
        and   s.segment_name = l.segment_name(+)     
        group by coalesce(i.table_name,l.table_name, 
            case when s.segment_name like 'BIN$%' then '$RECYCLE_BIN$' else s.segment_name end)
      )  
select seg, 
        lpad(case 
           when byt > 1024*1024*1024 then round(byt/1024/1024/1024)||'G'
           when byt > 1024*1024 then round(byt/1024/1024)||'M'
           else round(byt/1024)||'K'
        end,8) sz
from  seg_space s
order by byt desc;



