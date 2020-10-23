REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

set termout off
@drop t
undefine myquery
@clean
set termout on
clear screen
set echo on

declare
    p_query varchar2(32767) := q'{&&myquery}';

    l_theCursor     integer default dbms_sql.open_cursor;
    l_columnValue   varchar2(4000);
    l_status        integer;
    l_descTbl       dbms_sql.desc_tab;
    l_colCnt        number;
    n number := 0;
begin
    dbms_sql.parse(  l_theCursor,  p_query, dbms_sql.native );
    dbms_sql.describe_columns( l_theCursor, l_colCnt, l_descTbl );

    for i in 1 .. l_colCnt loop
        dbms_sql.define_column(l_theCursor, i, l_columnValue, 4000);
    end loop;

    l_status := dbms_sql.execute(l_theCursor);

    while ( dbms_sql.fetch_rows(l_theCursor) > 0 ) loop
        for i in 1 .. l_colCnt loop
            dbms_sql.column_value( l_theCursor, i, l_columnValue );
            dbms_output.put_line( rpad( l_descTbl(i).col_name, 30 )
              || ': ' || 
              l_columnValue );
        end loop;
        dbms_output.put_line( '-----------------' );
        n := n + 1;
    end loop;
end;
.
pause
set serverout on
/
pause

set verify on
clear screen

declare
    p_query varchar2(32767) := q'{&&myquery}';

    l_theCursor     integer default dbms_sql.open_cursor;
    l_columnValue   varchar2(4000);
    l_status        integer;
    l_descTbl       dbms_sql.desc_tab;
    l_colCnt        number;
    n number := 0;
begin
    dbms_sql.parse(  l_theCursor,  p_query, dbms_sql.native );
.

pause
clear screen
declare
    l_query varchar2(32767) := q'{select * from user_objects}';
    l_theCursor     integer default dbms_sql.open_cursor;
begin
    dbms_sql.parse(  l_theCursor,  l_query, dbms_sql.native );
end;
.
pause
/
pause



clear screen
declare
    l_query varchar2(32767) := q'{select * from the_wrong_name}';
    l_theCursor     integer default dbms_sql.open_cursor;
begin
    dbms_sql.parse(  l_theCursor,  l_query, dbms_sql.native );
end;
.
pause
/
pause


clear screen
create table t ( x int );
pause
declare
    l_query varchar2(32767) := q'{drop table t}';
    l_theCursor     integer default dbms_sql.open_cursor;
begin
    dbms_sql.parse(  l_theCursor,  l_query, dbms_sql.native );
end;
.
pause
/
pause
select * from t;
pause


clear screen
pause
declare
    l_query varchar2(32767) := q'{declare x int; begin x := 10; end;}';
    l_theCursor     integer default dbms_sql.open_cursor;
begin
    dbms_sql.parse(  l_theCursor,  l_query, dbms_sql.native );
end;
.
pause
/
pause


clear screen
pause
declare
    l_query varchar2(32767) := q'{begin gibberish; end;}';
    l_theCursor     integer default dbms_sql.open_cursor;
begin
    dbms_sql.parse(  l_theCursor,  l_query, dbms_sql.native );
end;
.
pause
/
pause


clear screen
pause
declare
    l_query varchar2(32767) := q'{begin :x := 10; end;}';
    l_theCursor     integer default dbms_sql.open_cursor;
begin
    dbms_sql.parse(  l_theCursor,  l_query, dbms_sql.native );
end;
.
pause
/
pause


clear screen
pause
declare
    l_query varchar2(32767) := q'{begin :x := ; end;}';
    l_theCursor     integer default dbms_sql.open_cursor;
begin
    dbms_sql.parse(  l_theCursor,  l_query, dbms_sql.native );
end;
.
pause
/
pause


clear screen
pause
declare
    l_query varchar2(32767) := q'{begin gibberish(:x); end;}';
    l_theCursor     integer default dbms_sql.open_cursor;
begin
    dbms_sql.parse(  l_theCursor,  l_query, dbms_sql.native );
end;
.
pause
/
pause


clear screen
pause
declare
    l_query varchar2(32767) := q'{declare x int := :x; begin junk; more_junk; gibberish(x); end;}';
    l_theCursor     integer default dbms_sql.open_cursor;
begin
    dbms_sql.parse(  l_theCursor,  l_query, dbms_sql.native );
end;
.
pause
/
pause



clear screen
pause
declare
    l_query varchar2(32767) := q'{select gibberish(:x) from dual}';
    l_theCursor     integer default dbms_sql.open_cursor;
begin
    dbms_sql.parse(  l_theCursor,  l_query, dbms_sql.native );
end;
.
pause
/
pause


