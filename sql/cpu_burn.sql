set timing on
select count(*) from 
( select rownum from dual connect by level <= 20000 ),
( select rownum from dual connect by level <= 30000 )
/


