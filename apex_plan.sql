create or replace
procedure apex_plan(p_sql varchar2) is
  l_output sys.odcivarchar2list := sys.odcivarchar2list();
  l_sql varchar2(32000) := p_sql;
  l_idx int;
  l_block varchar2(32000) :=
q'{
declare
  plan sys.odcivarchar2list := sys.odcivarchar2list();
begin
  for i in (
    ~~~~
  ) loop
    null;
  end loop;
 
  for i in (
  select rownum r, plan_table_output from table(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST +COST +PEEKED_BINDS'))
  ) loop
      plan.extend;
      plan(i.r) := i.plan_table_output;
  end loop;
  :1 := plan;
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
 
  execute immediate l_block using out l_output;
 
  for i in 1 .. l_output.count
  loop
    dbms_output.put_line( l_output(i) );
  end loop;
end;
/

