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
conn USERNAME/PASSWORD@DATABASE_SERVICE
set termout off
@drop t
set termout on
set echo on
clear screen
create table t as 
 select owner col, d.* from dba_objects d
 union all
 select 'SYSTEM' col, d.* from dba_objects d where rownum <= 15000;
pause 
create index ix on t ( col );
pause
exec dbms_stats.gather_table_stats('','T',method_opt=>'for all columns size 255');
pause
clear screen
explain plan for select * from t where col = 'SYSTEM';
pause
select * from dbms_xplan.display();
pause
clear screen
explain plan for select /*+ parallel(t 2) */ * from t where col = 'SYSTEM';
pause
select * from dbms_xplan.display();
pause
clear screen
explain plan for select /*+ full(t) */ * from t where col = 'SYSTEM';
pause
select * from dbms_xplan.display();
pause
clear screen
explain plan for select /*+ opt_param('optimizer_index_cost_adj',200) */ * from t where col = 'SYSTEM';
pause
select * from dbms_xplan.display();
pause
clear screen
explain plan for select /*+ opt_param('optimizer_index_cost_adj',1) parallel(t 2) */ * from t where col = 'SYSTEM';
pause
select * from dbms_xplan.display();
pause
clear screen
explain plan for select col from t where col = 'SYSTEM';
pause
select * from dbms_xplan.display();
pause
clear screen
explain plan for select /*+ parallel_index(t ix 2) */ col from t where col = 'SYSTEM';
pause
select * from dbms_xplan.display();
pause
clear screen
explain plan for select /*+ index_ffs(t ix) parallel_index(t ix 2) */ col from t where col = 'SYSTEM';
pause
select * from dbms_xplan.display();



