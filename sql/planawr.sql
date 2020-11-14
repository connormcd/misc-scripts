col id format 999
col pid format 999
col plan format a80
set lines 500
set long 50000
set longchunksize 1000
undefine sql_id
SELECT *  from table(dbms_xplan.display_awr('&&sql_id',format=>'ALL'));
set lines 100
undefine sql_id 
