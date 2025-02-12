REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

clear screen
@clean
set termout off
conn USER/PASSWORD@MY_PDB
set termout off
@drop t
set timing off
set time off
set pages 999
set termout on
clear screen
set echo on
create table t
as select * from dba_objects;
pause
insert into t ( object_id, owner, object_name)
values (-1,'BAD','BAD');
commit;
pause
clear screen
select count(object_name)
from t
where object_id > 100000 
and sqrt(object_id) between 1 and 10

pause
/
pause
select count(object_name)
from t
where object_id > 0 
and sqrt(object_id) between 1 and 10

pause
/
pause
clear screen
select count(object_name)
from 
 ( select *
   from   t
   where  object_id > 0 
 )
where sqrt(object_id) between 1 and 10

pause
/
pause
clear screen
select count(object_name)
from 
 ( select /*+ NO_MERGE */ *
   from   t
   where  object_id > 0 
 ) pos
where sqrt(object_id) between 1 and 10

pause
/
pause
clear screen
with pos as
 ( select *
   from   t
   where  object_id > 0 
 ) 
select  count(object_name)
from    pos
where sqrt(object_id) between 1 and 10

pause
/
pause
clear screen
with pos as
 ( select /*+ materialize */ *
   from   t
   where  object_id > 0 
 ) 
select  count(object_name)
from    pos
where sqrt(object_id) between 1 and 10

pause
/
pause
clear screen
with pos as
 ( select /*+ materialize */ *
   from   t
   where  object_id > 0 
   and rownum > 0
 ) 
select  count(object_name)
from    pos
where sqrt(object_id) between 1 and 10

pause
/
pause
clear screen
select /*+ ordered_predicates */ count(object_name)
from t
where object_id > 0 
and sqrt(object_id) between 1 and 10

pause
/
pause
clear screen
select  count(object_name)
from t
where ( object_id > 0 and sqrt(object_id) between 1 and 10 )

pause
/
pause
clear screen
select  count(object_name)
from t
where ( case when object_id > 0 and sqrt(object_id) between 1 and 10 then 1 end ) = 1

pause
/
pause
clear screen
select  count(object_name)
from t
where object_id > 0
and  ( case when object_id > 0 then sqrt(object_id) end ) between 1 and 10 

pause
/
pause
clear screen
create index ix on t ( object_name );
pause
select /*+ ordered_predicates */ count(owner)
from  t 
where sqrt(object_id) between 1 and 10   -- first (will fail)
and object_id > 0                        -- second
and object_name = 'QWQWQW'               -- third

pause
/

