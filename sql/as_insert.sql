-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
create or replace 
function as_insert(p_query varchar2, p_batch int default 10) return sys.odcivarchar2list pipelined as
    l_theCursor     integer default dbms_sql.open_cursor;
    l_columnValue   varchar2(4000);
    l_status        integer;
    l_descTbl       dbms_sql.desc_tab;
    l_colCnt        number;
    n number := 0;
    
    l_tname varchar2(2000) := lower(translate(p_query,chr(10)||chr(13)||',','   '));
    l_collist varchar2(32000);
    l_colval varchar2(32000);
    l_dml varchar2(32000);
    
    l_nls sys.odcivarchar2list := sys.odcivarchar2list();
    
begin
   l_tname := substr(l_tname,instr(l_tname,' from')+6)||' ';
   l_tname := substr(l_tname,1,instr(l_tname,' '));
  
   if l_tname is null then l_tname := '@@TABLE@@'; end if;

   select value
   bulk collect into l_nls
   from v$nls_parameters
   where parameter in (   
      'NLS_DATE_FORMAT',
      'NLS_TIMESTAMP_FORMAT',
      'NLS_TIMESTAMP_TZ_FORMAT')
   order by parameter;

    execute immediate 'alter session set nls_date_format=''yyyy-mm-dd hh24:mi:ss'' ';
    execute immediate 'alter session set nls_timestamp_format=''yyyy-mm-dd hh24:mi:ssff'' ';
    execute immediate 'alter session set nls_timestamp_tz_format=''yyyy-mm-dd hh24:mi:ssff tzr'' ';

    dbms_sql.parse(  l_theCursor,  p_query, dbms_sql.native );
    dbms_sql.describe_columns( l_theCursor, l_colCnt, l_descTbl );

    for i in 1 .. l_colCnt loop
        dbms_sql.define_column(l_theCursor, i, l_columnValue, 4000);
        l_collist := l_collist || l_descTbl(i).col_name||',';
    end loop;
    l_collist := 'into '||l_tname||'('||rtrim(l_collist,',')||')';

    l_status := dbms_sql.execute(l_theCursor);

    pipe row('alter session set cursor_sharing = force;');
    while ( dbms_sql.fetch_rows(l_theCursor) > 0 ) loop
       n := n + 1;
  
       if mod(n,p_batch) = 1 then
          pipe row('insert all ');
       end if;
       
        for i in 1 .. l_colCnt loop
            dbms_sql.column_value( l_theCursor, i, l_columnValue );
            if l_columnValue is null then
              l_colval := l_colval || 'null,';
            elsif l_descTbl(i).col_type in (1,8,9,96,112) then
              l_colval := l_colval || 'q''{'||l_columnValue ||'}''' || ',';
            elsif l_descTbl(i).col_type in (2,100,101) then
              l_colval := l_colval || l_columnValue || ',';
            elsif l_descTbl(i).col_type in (12) then
              l_colval := l_colval || 'to_date('''||l_columnValue||''',''yyyy-mm-dd hh24:mi:ss'')' || ',';
            elsif l_descTbl(i).col_type in (180) then
              l_colval := l_colval || 'to_timestamp('''||l_columnValue||''',''yyyy-mm-dd hh24:mi:ssff'')' || ',';
            elsif l_descTbl(i).col_type in (181) then
              l_colval := l_colval ||'to_timestamp_tz('''||l_columnValue||''',''yyyy-mm-dd hh24:mi:ssff tzr'')' || ',';
            elsif l_descTbl(i).col_type in (231) then
              l_colval := l_colval || 'to_timestamp('''||l_columnValue||''',''yyyy-mm-dd hh24:mi:ssff'')' || ',';
            elsif l_descTbl(i).col_type in (182) then
              l_colval := l_colval || 'to_yminterval('''||l_columnValue||''')' || ',';
            elsif l_descTbl(i).col_type in (183) then
              l_colval := l_colval ||'to_dsinterval('''||l_columnValue||''')'  || ',';
            end if;
        end loop;
        l_colval := rtrim(l_colval,',')||')';
        pipe row( l_collist  );
        pipe row( '  values ('||l_colval );
        if mod(n,p_batch) = 0 then
          pipe row('select * from dual;');
        end if;
        l_colval := null;
    end loop;
    if n = 0 then
      pipe row( 'No data found ');
    elsif mod(n,p_batch) != 0 then
      pipe row('select * from dual;');
    end if;
    pipe row('alter session set cursor_sharing = exact;');

    execute immediate 'alter session set nls_date_format='''||l_nls(1)||''' ';
    execute immediate 'alter session set nls_timestamp_format='''||l_nls(2)||''' ';
    execute immediate 'alter session set nls_timestamp_tz_format='''||l_nls(3)||''' ';
    return;
end;
/


set serverout on size unlimited format wrap
set verify off
set lines 1000
set pages 999

select * from as_insert('select * from scott.emp');

select * from as_insert('select * from scott.emp where rownum <= 10',20);


  