.

set termout off
def _pr_tmpfile=x:\tmp\pr.out

store set &_pr_tmpfile.set replace
set termout on

set serverout on size 1000000 termout off echo off
save &_pr_tmpfile replace
set termout on

0 c clob := q'\
0 declare

999999      \';;
999999      l_theCursor     integer default dbms_sql.open_cursor;;
999999      l_columnValue   varchar2(4000);;
999999      l_status        integer;;
999999      l_descTbl       dbms_sql.desc_tab2;;
999999      l_colCnt        number;;
999999  begin
999999      dbms_sql.parse(  l_theCursor, c, dbms_sql.native );;
999999      dbms_sql.describe_columns2( l_theCursor, l_colCnt, l_descTbl );;
999999      for i in 1 .. l_colCnt loop
999999          dbms_sql.define_column( l_theCursor, i,
999999                                  l_columnValue, 4000 );;
999999      end loop;;
999999      l_status := dbms_sql.execute(l_theCursor);;
999999      while ( dbms_sql.fetch_rows(l_theCursor) > 0 ) loop
999999          dbms_output.put_line( '==============================' );;
999999          for i in 1 .. l_colCnt loop
999999                  dbms_sql.column_value( l_theCursor, i,
999999                                         l_columnValue );;
999999                  dbms_output.put_line
999999                      ( rpad( l_descTbl(i).col_name,
999999                        30 ) || ': ' || l_columnValue );;
999999          end loop;;
999999      end loop;;
999999  exception
999999      when others then
999999          dbms_output.put_line(dbms_utility.format_error_backtrace);;
999999          raise;;
999999 end;;
/

set termout off
@&_pr_tmpfile.set

get &_pr_tmpfile nolist
host del &_pr_tmpfile 
set termout on
