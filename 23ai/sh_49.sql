clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
clear screen
set termout off
drop table t purge;
col edition_name format a8
col owner format a10
set termout on
set echo off
prompt |   
prompt |   
prompt |      ____  ____       _ ______ _____ _______  _  _       _____  ______ _    _  _____ ______ 
prompt |     / __ \|  _ \     | |  ____/ ____|__   __|| || |_    |  __ \|  ____| |  | |/ ____|  ____|
prompt |    | |  | | |_) |    | | |__ | |       | | |_  __  _|   | |__) | |__  | |  | | (___ | |__   
prompt |    | |  | |  _ < _   | |  __|| |       | |  _| || |_    |  _  /|  __| | |  | |\___ \|  __|  
prompt |    | |__| | |_) | |__| | |___| |____   | | |_  __  _|   | | \ \| |____| |__| |____) | |____ 
prompt |     \____/|____/ \____/|______\_____|  |_|   |_||_|     |_|  \_\______|\____/|_____/|______|
prompt |                                                                                             
prompt |                                                                                             
prompt |                                                                                     
prompt |   
pause
clear screen
set echo on
select * 
from sys.con$recycle
where rownum <= 10;
pause
select max(object_id)
from   user_objects;
pause
clear screen
create table t ( x int , 
  constraint t_pk primary key (x));
pause
select object_id
from   user_objects
where  object_name = 'T_PK';
pause
conn sys/admin@db23 as sysdba
col name format a40
col value format a20
select
    x.ksppinm  name,
    y.kspftctxvl  value
  from
    sys.x$ksppi  x,
    sys.x$ksppcv2  y
 where
   x.indx+1 = y.kspftctxpn and
   x.ksppinm like '%con_number%'
 order by 1;
 
pause Done


