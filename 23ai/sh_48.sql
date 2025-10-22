clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
clear screen
set termout off
col edition_name format a8
col owner format a10
@drop t
clear screen
create table t as
select 
   'SCOTT' OWNER
  ,OBJECT_NAME
  ,' ' SUBOBJECT_NAME
  ,123 OBJECT_ID
  ,456 DATA_OBJECT_ID
  ,'TABLE' OBJECT_TYPE
  ,trunc(CREATED,'YYYY') created
  ,trunc(LAST_DDL_TIME,'YYYY') LAST_DDL_TIME
  ,'2025' TIMESTAMP
  ,'VALID' STATUS
  ,'N' TEMPORARY
  ,'N' GENERATED
  ,'N' SECONDARY
  ,'TABLE' NAMESPACE
  ,EDITION_NAME
  ,'N' SHARING
  ,'Y' EDITIONABLE
  ,'N' ORACLE_MAINTAINED
  ,'YES' APPLICATION
  ,' 'DEFAULT_COLLATION
  ,'N' DUPLICATED
  ,'N' SHARDED
  ,'NO' IMPORTED_OBJECT
  ,'N' SYNCHRONOUS_DUPLICATED
  ,123 CREATED_APPID
  ,456 CREATED_VSNID
from dba_objects;
set termout on
set echo off
prompt |   
prompt |   
prompt |   
prompt |     __  __  ____  _____  ______     _____ _____   ____  _    _ _____     ______     __
prompt |    |  \/  |/ __ \|  __ \|  ____|   / ____|  __ \ / __ \| |  | |  __ \   |  _ \ \   / /
prompt |    | \  / | |  | | |__) | |__     | |  __| |__) | |  | | |  | | |__) |  | |_) \ \_/ / 
prompt |    | |\/| | |  | |  _  /|  __|    | | |_ |  _  /| |  | | |  | |  ___/   |  _ < \   /  
prompt |    | |  | | |__| | | \ \| |____   | |__| | | \ \| |__| | |__| | |       | |_) | | |   
prompt |    |_|  |_|\____/|_|  \_\______|   \_____|_|  \_\\____/ \____/|_|       |____/  |_|   
prompt |                                                                                       
prompt |                                                                                      
prompt |                                                                                     
prompt |   
pause
clear screen
set echo on
clear screen
--
-- We've already seen this
--
select 
  case 
    when job = 'SALES' then trunc(sal/100)
    when hiredate > date '1981-02-01' then trunc(nvl(comm,300)/100)
    else ceil(sal/80)
  end bonus,
  count(*)
from   emp
group by bonus;
pause
clear screen
select 
   owner
  ,object_type
  ,created
  ,last_ddl_time
  ,timestamp
  ,status
  ,temporary
  ,generated
  ,secondary
  ,namespace
  ,edition_name
  ,sharing
  ,editionable
  ,oracle_maintained
  ,application
  ,default_collation
  ,duplicated
  ,sharded
  ,imported_object
  ,synchronous_duplicated
  ,created_appid
  ,created_vsnid
#pause
  ,COUNT(*)
from t
#pause
group by
   owner
  ,subobject_name
  ,object_type
  ,created
  ,last_ddl_time
  ,timestamp
  ,status
  ,temporary
  ,generated
  ,secondary
  ,namespace
  ,edition_name
  ,sharing
  ,editionable
  ,oracle_maintained
  ,application
  ,default_collation
  ,duplicated
  ,sharded
  ,imported_object
  ,synchronous_duplicated
  ,created_appid
  ,created_vsnid
  
pause
/
pause
clear screen
select 
   owner
  ,object_type
  ,created
  ,last_ddl_time
  ,timestamp
  ,status
  ,temporary
  ,generated
  ,secondary
  ,namespace
  ,edition_name
  ,sharing
  ,editionable
  ,oracle_maintained
  ,application
  ,default_collation
  ,duplicated
  ,sharded
  ,imported_object
  ,synchronous_duplicated
  ,created_appid
  ,created_vsnid
  ,count(*)
from t
#pause
--
--
-- wait for it .... wait for it ....
--
--
#pause
GROUP BY ALL

pause
/

pause Done
