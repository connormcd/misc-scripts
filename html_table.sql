REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

create or replace
function html_table(p_table dbms_tf.table_t ) return clob sql_macro as
   l_sql           varchar2(32767);
   l_col           varchar2(200);
   l_header        varchar2(32767);
   l_td_separator  varchar2(24):= '||''<td>''||';
   l_col_list      varchar2(32767);
   l_col_typed     varchar2(300);
begin
   for i in 1..p_table.column.count loop
     l_col := p_table.column(i).description.name;

     if p_table.column(i).description.type
                 in (dbms_tf.type_varchar2
                 , dbms_tf.type_char
                 , dbms_tf.type_clob)
     then
         l_col_typed := 'apex_escape.html('||l_col||')';
     elsif p_table.column(i).description.type = dbms_tf.type_number then
       l_col_typed := 'to_char('||l_col||')';
     elsif p_table.column(i).description.type = dbms_tf.type_date then
       l_col_typed := 'to_char('||l_col||',''YYYY-MM-DD'')';
     elsif p_table.column(i).description.type = dbms_tf.type_timestamp then
       l_col_typed := 'to_char('||l_col||',''YYYY-MM-DD"T"HH24:MI:SS.FF6'')';
     end if;
     l_header := l_header || '<td>' || l_col ;
     l_col_list := l_col_list || l_td_separator || l_col_typed;

   end loop;

   l_sql := q'[
   select '<table>' as row_export from dual
   union all
   select '<tr>@@HEADER@@</tr>' as row_export from dual
   union all
   select '<tr>'@@ROWS@@||'</tr>' as row_export from html_table.p_table
   union all
   select '</table>' as row_export from dual
   ]';

   l_sql := replace(replace(l_sql, '@@ROWS@@', l_col_list), '@@HEADER@@' , l_header);
   return l_sql;
end;
/

set serverout on
with my_query as (
  select empno, ename, job, sal, hiredate from scott.emp
)
select * 
from html_table(p_table=>my_query);



