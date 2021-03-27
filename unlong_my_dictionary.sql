REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 


--
-- Note: user you run this as my have CREATE VIEW privilege granted directly
--
create or replace
procedure UNLONG_MY_DICTIONARY is

  procedure UNLONG_MY_VIEW(p_owner varchar2, p_table_name varchar2) is
    cursor c_cols is
      select cols.column_name,
             cols.data_type,
             cols.data_precision,
             cols.data_scale,
             cols.data_type_owner,
             cols.data_length,
             cols.column_id,
             case 
               when regexp_replace(cols.data_type,'\(.*\)') in ('CLOB','NCLOB','DATE','TIMESTAMP','ROWID',
                                                        'BLOB','INTERVAL DAY','INTERVAL YEAR TO MONTH',
                                                        'TIMESTAMP WITH TIME ZONE','TIMESTAMP WITH LOCAL TIME ZONE','LONG RAW') 
                 then cols.data_type
               when cols.data_type in ('RAW','CHAR','VARCHAR2','NCHAR','NVARCHAR2') 
                 then cols.data_type||'('||cols.data_length||')'
               when (cols.data_type in ('NUMBER') and cols.data_precision is not null) 
                 then cols.data_type||'('||cols.data_precision||','||cols.data_scale||')'
               when (cols.data_type in ('NUMBER','BINARY_DOUBLE','BINARY_FLOAT','FLOAT') and cols.data_precision is null) 
                 then cols.data_type||case when cols.data_scale is not null then '(*,'||cols.data_scale||')' end
               when cols.data_type in ('FLOAT') 
                 then cols.data_type||case when cols.data_precision < 126 then '('||cols.data_precision||')' end
               when cols.data_type in ('LONG') 
                 then 'VARCHAR2(4000)'
             end new_data_type
      from   dba_tab_columns cols
      where  owner = p_owner
      and    table_name = p_table_name 
      order by cols.column_id;

    type col_list is table of c_cols%rowtype;
    l_cols col_list;

    l_sql1 clob := 'select ';
    l_sql2 clob := 'columns ';
  begin
    open c_cols; 
    fetch c_cols bulk collect into l_cols;
    close c_cols;

    for i in 1 .. l_cols.count loop
      l_sql1 := l_sql1 || case when i > 1 then ',' end || 'x.'||l_cols(i).column_name||chr(10);
      l_sql2 := l_sql2 || case when i > 1 then ',' end || l_cols(i).column_name||' '||l_cols(i).new_data_type||chr(10);
    end loop;

    l_sql1 := l_sql1 || q'{FROM   XMLTABLE('/ROWSET/ROW' }'||chr(10);
    l_sql1 := l_sql1 || q'{PASSING (SELECT DBMS_XMLGEN.GETXMLTYPE( }'||chr(10);
    l_sql1 := l_sql1 || '''select * from '||p_table_name||''''||chr(10);
    l_sql1 := l_sql1 || q'{) FROM dual)}'||chr(10);
    l_sql2 := l_sql2 || ') x';

    --dbms_output.put_line(l_sql1||l_sql2);
    execute immediate 'create or replace view Z$'||p_table_name||' as '||l_sql1||l_sql2;
    execute immediate 'grant select on Z$'||p_table_name||' to public';
    dbms_output.put_line('Created view: Z$'||p_table_name);
  end;

begin
  for i in ( 
    select table_name
    from dba_tab_columns
    where data_type = 'LONG'
    and substr(table_name,1,4) in ('ALL_','USER')
    and owner = 'SYS'
    order by 1
  )
  loop
    --dbms_output.put_line(i.table_name);
    unlong_my_view('SYS',i.table_name);
  end loop;
end;
/

set serverout on
exec UNLONG_MY_DICTIONARY

