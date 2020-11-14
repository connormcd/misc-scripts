analyze cluster C_COBJ# compute statistics;
analyze cluster C_FILE#_BLOCK# compute statistics;
analyze cluster C_MLOG# compute statistics;
analyze cluster C_OBJ# compute statistics;
analyze cluster C_OBJ#_INTCOL# compute statistics;
analyze cluster C_RG# compute statistics;
analyze cluster C_TOID_VERSION# compute statistics;
analyze cluster C_TS# compute statistics;
analyze cluster C_USER# compute statistics;

select CLUSTER_NAME, AVG_BLOCKS_PER_KEY 
from dba_clusters
where owner = 'SYS';

analyze cluster C_COBJ# delete statistics;
analyze cluster C_FILE#_BLOCK# delete statistics;
analyze cluster C_MLOG# delete statistics;
analyze cluster C_OBJ# delete statistics;
analyze cluster C_OBJ#_INTCOL# delete statistics;
analyze cluster C_RG# delete statistics;
analyze cluster C_TOID_VERSION# delete statistics;
analyze cluster C_TS# delete statistics;
analyze cluster C_USER# delete statistics;
