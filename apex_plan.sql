REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is possible you'll need to edit the script for correct usernames/passwords, missing information etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

create or replace
procedure apex_plan(
             p_sql varchar2,
             b1 varchar2 default null,
             b2 varchar2 default null,
             b3 varchar2 default null,
             b4 varchar2 default null,
             b5 varchar2 default null,
             b6 varchar2 default null,
             b7 varchar2 default null,
             b8 varchar2 default null,
             b9 varchar2 default null,
             b10 varchar2 default null
             ) is
  l_output sys.odcivarchar2list := sys.odcivarchar2list();
  l_sql varchar2(32000) := p_sql;
  l_idx int;
  l_block varchar2(32000) :=
q'{
declare
  l_cur     pls_integer;
  l_col     number;
  l_exec    number;
  l_sql     varchar2(32000) := '~~~~';
  l_bind_pos pls_integer;
  l_bind_name varchar2(200);
  l_char      varchar2(1);
  plan sys.odcivarchar2list := sys.odcivarchar2list();
  binds sys.odcivarchar2list := sys.odcivarchar2list(:b1,:b2,:b3,:b4,:b5,:b6,:b7,:b8,:b9,:b10);
begin
  l_cur := dbms_sql.open_cursor;

  dbms_sql.parse(l_cur,l_sql,dbms_sql.native);
  
  for i in 1 .. 10 loop
    l_bind_pos := instr(l_sql,':',1,i);
    exit when l_bind_pos = 0;
    l_bind_name := null;
    for j in l_bind_pos+1 .. l_bind_pos+200 
    loop
      l_char := substr(l_sql,j,1);
      if l_char between '0' and '9' or
         l_char between 'A' and 'Z' or
         l_char between 'a' and 'z' or
         l_char in ('$','_','#') 
      then
        l_bind_name := l_bind_name || l_char;
      else
        exit;
      end if;
    end loop;
--    dbms_output.put_line(l_bind_name);
    dbms_sql.bind_variable(l_cur,l_bind_name,binds(i));
  end loop;
  
  l_exec := dbms_sql.execute(l_cur);

  while dbms_sql.fetch_rows(l_cur) > 0 loop
    null;
  end loop;
  
  for i in (
  select rownum r, plan_table_output from table(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST +COST +PEEKED_BINDS'))
  ) loop
      plan.extend;
      plan(i.r) := i.plan_table_output;
  end loop;
  :1 := plan;
  dbms_sql.close_cursor(l_cur);
end;
}';
 
begin
  if ltrim(lower(l_sql),' '||chr(10)||chr(13)) not like 'select%' and ltrim(lower(l_sql),' '||chr(10)||chr(13)) not like 'with%select%' then
    dbms_output.put_line('Invalid SQL');
    return;
  end if;
 
  l_idx := instr(lower(l_sql),'select');
  l_sql := substr(l_sql,1,l_idx+6)||' /*+ gather_plan_statistics */ '||substr(l_sql,l_idx+7);
 
  l_block := replace(l_block,'~~~~',l_sql);
 
  execute immediate l_block 
  using in b1, in b2, in b3, in b4, in b5, in b6, in b7, in b8, in b9, in b10, out l_output;
 
  for i in 1 .. l_output.count
  loop
    dbms_output.put_line( l_output(i) );
  end loop;
end;
/
