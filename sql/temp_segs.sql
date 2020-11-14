create or replace view
temp_segs (
 OWNER             ,
 SEGMENT_NAME      ,
 PARTITION_NAME    ,
 SEGMENT_TYPE      ,
 TABLESPACE_NAME   ,
 BYTES             ,
 BLOCKS            ,
 EXTENTS           ,
 INITIAL_EXTENT    ,
 NEXT_EXTENT       ,
 MIN_EXTENTS       ,
 MAX_EXTENTS       ,
 PCT_INCREASE      ,
 BUFFER_POOL       )
as
select u.name, to_char(f.file#) || '.' || to_char(s.block#), NULL,
       'TEMPORARY',
       ts.name, 
       s.blocks * ts.blocksize, s.blocks, s.extents,
       s.iniexts * ts.blocksize, s.extsize * ts.blocksize, s.minexts,
       s.maxexts, s.extpct,
       decode(s.cachehint, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE', NULL)
from sys.user$ u, sys.ts$ ts, sys.seg$ s, sys.file$ f
where s.ts# = ts.ts#
  and s.user# = u.user#
  and s.type# = 3
  and s.ts# = f.ts#
  and s.file# = f.relfile#;
