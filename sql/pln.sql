col id format 999
col pid format 999
col plan format a80
set lines 500
set long 50000
set longchunksize 1000
undefine sql_id
undefine child
SELECT *  from table(dbms_xplan.display_cursor('&1', ( select child_number from v$sql where sql_id = '&1' and rownum = 1 ),format=>'ALL'));
set lines 100
