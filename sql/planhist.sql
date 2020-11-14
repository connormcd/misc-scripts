
undefine sql_id 
undefine hash

select plan_hash_value, timestamp from dba_hist_sql_plan where  sql_id = '&&sql_id' and id = 1;

create or replace view tmp$planhist as
select SQL_ID  STATEMENT_ID,PLAN_HASH_VALUE PLAN_ID,TIMESTAMP ,REMARKS ,OPERATION ,OPTIONS ,OBJECT_NODE ,OBJECT_OWNER  ,OBJECT_NAME ,OBJECT_ALIAS  ,1 OBJECT_INSTANCE,OBJECT_TYPE ,OPTIMIZER ,SEARCH_COLUMNS  ,ID  ,PARENT_ID ,DEPTH ,POSITION  ,COST  ,CARDINALITY ,BYTES ,OTHER_TAG ,PARTITION_START ,PARTITION_STOP  ,PARTITION_ID  ,OTHER ,OTHER_XML ,DISTRIBUTION  ,CPU_COST  ,IO_COST ,TEMP_SPACE  ,ACCESS_PREDICATES ,FILTER_PREDICATES ,PROJECTION  ,TIME  ,QBLOCK_NAME from dba_hist_sql_plan
where plan_hash_value = &&hash and sql_id = '&&sql_id'
/
 
col id format 999
col pid format 999
col plan format a80
set lines 500
set long 5000
undefine parms 
accept parms char prompt 'parms '
SELECT * 
from table(dbms_xplan.display('tmp$planhist','&&sql_id',nvl2('&&parms','typical &&parms','typical')));
 set lines 120
undefine sql_id 
