drop table F1DELT_CIRCUITS purge;
drop table F1DELT_CONSTRUCTORRESULTS purge;
drop table F1DELT_CONSTRUCTORS purge;
drop table F1DELT_CONSTRUCTORSTANDINGS purge;
drop table F1DELT_DRIVERS purge;
drop table F1DELT_DRIVERSTANDINGS purge;
drop table F1DELT_LAPTIMES purge;
drop table F1DELT_PITSTOPS purge;
drop table F1DELT_QUALIFYING purge;
drop table F1DELT_RACES purge;
drop table F1DELT_RESULTS purge;
drop table F1DELT_SEASONS purge;
drop table F1DELT_STATUS purge;

alter session set cursor_sharing = force;
alter session set nls_date_format = 'yyyy-mm-dd';
set feedback off
set define off
pro Populating tables
@f1delt_build.sql
commit;
alter session set cursor_sharing = exact;
set feedback on
set define '&'
alter session set nls_date_format = 'DD-MON-YY';

exec dbms_stats.gather_table_stats('','F1DELT_CIRCUITS');
exec dbms_stats.gather_table_stats('','F1DELT_CONSTRUCTORRESULTS');
exec dbms_stats.gather_table_stats('','F1DELT_CONSTRUCTORS');
exec dbms_stats.gather_table_stats('','F1DELT_CONSTRUCTORSTANDINGS');
exec dbms_stats.gather_table_stats('','F1DELT_DRIVERS');
exec dbms_stats.gather_table_stats('','F1DELT_DRIVERSTANDINGS');
exec dbms_stats.gather_table_stats('','F1DELT_LAPTIMES');
exec dbms_stats.gather_table_stats('','F1DELT_PITSTOPS');
exec dbms_stats.gather_table_stats('','F1DELT_QUALIFYING');
exec dbms_stats.gather_table_stats('','F1DELT_RACES');
exec dbms_stats.gather_table_stats('','F1DELT_RESULTS');
exec dbms_stats.gather_table_stats('','F1DELT_SEASONS');
exec dbms_stats.gather_table_stats('','F1DELT_STATUS');

set serverout on
declare
  l_sql clob := '';
begin 
for i in 
(
      with fastcons as
      ( 
      select /*+ materialize */
        dc.owner,
        dcc.constraint_name,
        dcc.table_name,
        dcc.column_name,
        dcc.position,
        dc.constraint_type
      from all_cons_columns dcc,
           all_constraints dc
      where dcc.owner = user 
      and   dcc.table_name like 'F1%'
      and   dc.owner = dcc.owner
      and   dc.table_name = dcc.table_name
      and   dc.constraint_name = dcc.constraint_name
      and   dc.constraint_type = 'P'
      )
      select 0 sort_key, table_name, 999 column_id, 'declare' plsql_block
      from all_tables
      where owner = user and table_name like 'F1DELT%'
      --
      --
      union all
      select 6 sort_key, table_name, 999 column_id, '  l_rows                          pls_integer;'
      from all_tables
      where owner = user and table_name like 'F1DELT%'
      --
      --
      union all
      select 7 sort_key, table_name, 999 column_id, 'begin'
      from all_tables
      where owner = user and table_name like 'F1DELT%'
      --
      --
      union all
      select 8 sort_key, table_name, 999 column_id, '  merge into '||replace(table_name,'F1DELT','F1')||' w'
      from all_tables
      where owner = user and table_name like 'F1DELT%'
      --
      --
      union all
      select 9 sort_key, table_name, 999 column_id, '  using ( select '
      from all_tables
      where owner = user and table_name like 'F1DELT%'
      --
      --
      union all
      select 10 sort_key, table_name, column_id, 
      case 
        when row_number() over ( partition by table_name order by column_id ) = 1 then '             '||column_name
        else '            ,'||column_name end
      from all_tab_columns
      where owner = user and table_name like 'F1DELT%'
      --
      --
      union all
      select 11, table_name, 999, '          from MCDONAC.'||table_name||' ) p'
      from all_tables
      where owner = user and table_name like 'F1DELT%'
      --
      --
      union all
      select 15 sort_key, table_name, position, 
      case when position = 1 then '   on ( ' else '    and ' end || ' p.'||rpad(column_name,30)||' = w.'||column_name
      from fastcons
      --from all_cons_columns
      where owner = user and table_name like 'F1DELT%'
      and constraint_type = 'P'
      --and constraint_name = ( select constraint_name from all_constraints where owner = user and table_name = all_cons_columns.table_name and constraint_type = 'P' ) 
      --
      --
      union all
      select 20, table_name, 999, '  )'
      from all_tables
      where owner = user and table_name like 'F1DELT%'
      --
      --
      union all
      select 21, table_name, 999, '  when matched then'
      from all_tables
      where owner = user and table_name like 'F1DELT%'
      --
      --
      union all
      select 22, table_name, 999, '  update set'
      from all_tables
      where owner = user and table_name like 'F1DELT%'
      --
      --
      union all
      select 25 sort_key, table_name, column_id, 
      case  when row_number() over ( partition by table_name order by column_id ) = 1 then '   ' else '  ,' end ||'   w.'||rpad(column_name,30)||' = p.'||column_name
      from all_tab_columns dtc
      where owner = user and table_name like 'F1DELT%'
      and not exists ( select null
          from fastcons
      -- from all_cons_columns
       where owner = user 
          and constraint_type = 'P'
      -- and constraint_name = ( select constraint_name from all_constraints where owner = user and table_name = all_cons_columns.table_name and constraint_type = 'P' ) 
       and table_name = dtc.table_name
       and column_name = dtc.column_name )
      --
      union all
      select 26 sort_key, table_name, column_id, 
      case  when row_number() over ( partition by table_name order by column_id ) = 1 then '  where  ' else '     or  ' end ||'   decode(w.'||rpad(column_name,31)||',p.'||column_name||',0,1) = 1'||
      case when column_id = max(column_id) over ( partition by table_name) then ';' end
      from all_tab_columns dtc
      where owner = user and table_name like 'F1DELT%'
      --
      --
      and not exists ( select null
          from fastcons
      -- from all_cons_columns 
       where owner = user 
          and constraint_type = 'P'
      -- and constraint_name = ( select constraint_name from all_constraints where owner = user and table_name = all_cons_columns.table_name and constraint_type = 'P' ) 
       and table_name = dtc.table_name
       and column_name = dtc.column_name )
      --
      union all
      select 52, table_name, 999, '  '
      from all_tables
      where owner = user and table_name like 'F1DELT%'
      --
      union all
      select 55, table_name, 999, '  l_rows := sql%rowcount;'
      from all_tables
      where owner = user and table_name like 'F1DELT%'
      --
      --
      union all
      select 60, table_name, 999, '  dbms_output.put_line('''||rpad(replace(table_name,'F1DELT','F1'),30)||'Merge phase 1 complete, updated rows=''||l_rows);'
      from all_tables
      where owner = user and table_name like 'F1DELT%'
      --
      union all
      select 65, table_name, 999, ' '
      from all_tables
      where owner = user and table_name like 'F1DELT%'
      --
      union all
      --
      select 100 sort_key, table_name, 999 column_id, '  merge into '||replace(table_name,'F1DELT','F1')||' w'
      from all_tables
      where owner = user and table_name like 'F1DELT%'
      --
      --
      union all
      select 101 sort_key, table_name, 999 column_id, '  using ( select '
      from all_tables
      where owner = user and table_name like 'F1DELT%'
      --
      --
      union all
      select 1010 sort_key, table_name, column_id, 
      case 
        when row_number() over ( partition by table_name order by column_id ) = 1 then '             '||column_name
        else '            ,'||column_name end
      from all_tab_columns
      where owner = user and table_name like 'F1DELT%'
      --
      --
      union all
      select 1011, table_name, 999, '          from MCDONAC.'||table_name||' ) p'
      from all_tables
      where owner = user and table_name like 'F1DELT%'
      --
      --
      union all
      select 1015 sort_key, table_name, position, 
      case when position = 1 then '   on ( ' else '    and ' end || '   p.'||rpad(column_name,30)||' = w.'||column_name
      from fastcons
      --from all_cons_columns
      where owner = user and table_name like 'F1DELT%'
      --and constraint_name = ( select constraint_name from all_constraints where owner = user and table_name = all_cons_columns.table_name and constraint_type = 'P' )
      and constraint_type = 'P'
      --
      --
      union all
      select 1020, table_name, 999, '  )'
      from all_tables
      where owner = user and table_name like 'F1DELT%'
      --
      --
      union all
      select 1021, table_name, 999, '  when not matched then'
      from all_tables
      where owner = user and table_name like 'F1DELT%'
      --
      --
      union all
      select 1022, table_name, 999, '  insert'
      from all_tables
      where owner = user and table_name like 'F1DELT%'
      --
      --
      union all
      select 1025 sort_key, table_name, column_id, 
      case  when row_number() over ( partition by table_name order by column_id ) = 1 then '    (' else '    ,' end ||'   w.'||column_name
      from all_tab_columns dtc
      where owner = user and table_name like 'F1DELT%'
      --
      --
      union all
      select 1030, table_name, 999, '  )'
      from all_tables
      where owner = user and table_name like 'F1DELT%'
      --
      --
      union all
      select 1040 sort_key, table_name, column_id, 
      case  when row_number() over ( partition by table_name order by column_id ) = 1 then '  values (' else '         ,' end ||'p.'||column_name
      from all_tab_columns dtc
      where owner = user and table_name like 'F1DELT%'
      --
      --
      union all
      select 1050, table_name, 999, '  );'
      from all_tables
      where owner = user and table_name like 'F1DELT%'
      --
      union all
      select 1055 sort_key, table_name, 999 column_id, '  l_rows := sql%rowcount;'
      from all_tables
      where owner = user and table_name like 'F1DELT%'
      --
      union all
      select 1060 sort_key, table_name, 999 column_id, '  dbms_output.put_line('''||rpad(replace(table_name,'F1DELT','F1'),30)||'Merge phase 2 complete, inserted rows=''||l_rows);'
      from all_tables
      where owner = user and table_name like 'F1DELT%'
      --
      union all
      select 1065 sort_key, table_name, 999 column_id, '  --commit;'
      from all_tables
      where owner = user and table_name like 'F1DELT%'
      --
      union all
      select 9999 sort_key, table_name, 999 column_id, 'end;'||chr(10)||chr(10) plsql_block
      from all_tables
      where owner = user and table_name like 'F1DELT%'
      order by 2,1, 3
)
loop
  if i.sort_key = 0 then
    if l_sql is null then 
       l_sql := i.plsql_block;
    else
       execute immediate l_sql;
       l_sql := i.plsql_block;
    end if;
  else
    l_sql := l_sql||chr(10)||i.plsql_block;
  end if;
end loop;
execute immediate l_sql;
dbms_output.put_line('Changes not committed yet - don''t forget to COMMIT or ROLLBACK');
end;
/
