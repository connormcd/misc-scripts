-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
set serverout on size 999999
set verify off
declare
p_query varchar2(32767) := q'{&1}';

    l_theCursor     integer default dbms_sql.open_cursor;
    l_columnValue   varchar2(4000);
    l_status        integer;
    l_descTbl       dbms_sql.desc_tab;
    l_colCnt        number;
    n number := 0;
  procedure p(msg varchar2) is
    l varchar2(4000) := msg;
  begin
    while length(l) > 0 loop
      dbms_output.put_line(substr(l,1,80));
      l := substr(l,81);
    end loop;
  end;
begin
    execute immediate
    'alter session set nls_date_format=''dd-mon-yyyy hh24:mi:ss'' ';

    dbms_sql.parse(  l_theCursor,  p_query, dbms_sql.native );
    dbms_sql.describe_columns( l_theCursor, l_colCnt, l_descTbl );

    for i in 1 .. l_colCnt loop
        dbms_sql.define_column(l_theCursor, i, l_columnValue, 4000);
    end loop;

    l_status := dbms_sql.execute(l_theCursor);

    while ( dbms_sql.fetch_rows(l_theCursor) > 0 ) loop
        for i in 1 .. l_colCnt loop
            dbms_sql.column_value( l_theCursor, i, l_columnValue );
            p( rpad( l_descTbl(i).col_name, 30 )
              || ': ' || 
              l_columnValue );
        end loop;
        dbms_output.put_line( '-----------------' );
        n := n + 1;
    end loop;
    if n = 0 then
      dbms_output.put_line( chr(10)||'No data found '||chr(10) );
    end if;
end;
/

set verify on
