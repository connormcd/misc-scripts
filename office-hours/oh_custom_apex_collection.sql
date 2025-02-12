REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

@drop t

create table t(vc1 varchar2(100), d1 date, n1 number);
begin
for i in 2 .. 100 loop
  execute immediate 'alter table t add  vc'||i||' varchar2(100)';
  execute immediate 'alter table t add  d'||i||' date';
  execute immediate 'alter table t add  n'||i||' number';
end loop;
end;
/

create or replace
procedure my_collection_generator(p_query varchar2) is
  l_theCursor integer default dbms_sql.open_cursor;
  l_columnValue varchar2(4000);
  l_status integer;
  l_descTbl dbms_sql.desc_tab;
  l_colCnt number;
  l_cs varchar2(255);
  l_date_fmt varchar2(255);

  l_row t%rowtype;
  
  l_char_arr sys.odcivarchar2list := sys.odcivarchar2list();
  l_date_arr sys.odcidatelist := sys.odcidatelist();
  l_num_arr  sys.odcinumberlist := sys.odcinumberlist();
begin
 
  execute immediate 'alter session set nls_date_format = ''yyyymmddhh24miss''';

  dbms_sql.parse( l_theCursor, p_query, dbms_sql.native );
  dbms_sql.describe_columns( l_theCursor, l_colCnt, l_descTbl );

  for i in 1 .. l_colCnt loop
    if ( l_descTbl(i).col_type not in ( 113 ) )
    then
      dbms_sql.define_column(l_theCursor, i, l_columnValue, 4000);
    end if;
  end loop;

  l_status := dbms_sql.execute(l_theCursor);

  while ( dbms_sql.fetch_rows(l_theCursor) > 0 )
  loop
    l_char_arr := sys.odcivarchar2list();
    l_date_arr := sys.odcidatelist();
    l_num_arr  := sys.odcinumberlist();  
    for i in 1 .. l_colCnt loop
      if l_descTbl(i).col_type in ( 2,100,101 ) then
        dbms_sql.column_value( l_theCursor, i, l_columnValue );
        l_num_arr.extend;
        l_num_arr(l_num_arr.count) := l_columnValue;
      elsif l_descTbl(i).col_type in ( 12,13 ) then
        dbms_sql.column_value( l_theCursor, i, l_columnValue );
        l_date_arr.extend;
        l_date_arr(l_date_arr.count) := l_columnValue;
      else         
        dbms_sql.column_value( l_theCursor, i, l_columnValue );
        l_char_arr.extend;
        l_char_arr(l_char_arr.count) := l_columnValue;
      end if;
    end loop;
    
    if l_date_arr.exists(1) then l_row.d1 := l_date_arr(1); end if;
    if l_date_arr.exists(2) then l_row.d2 := l_date_arr(2); end if;
    if l_date_arr.exists(3) then l_row.d3 := l_date_arr(3); end if;
    if l_date_arr.exists(4) then l_row.d4 := l_date_arr(4); end if;
    --
    if l_date_arr.exists(100) then l_row.d100 := l_date_arr(100); end if;

    if l_num_arr.exists(1) then l_row.n1 := l_num_arr(1); end if;
    if l_num_arr.exists(2) then l_row.n2 := l_num_arr(2); end if;
    if l_num_arr.exists(3) then l_row.n3 := l_num_arr(3); end if;
    if l_num_arr.exists(4) then l_row.n4 := l_num_arr(4); end if;

    if l_num_arr.exists(100) then l_row.n4 := l_num_arr(100); end if;
    
    if l_char_arr.exists(1) then l_row.vc1 := l_char_arr(1); end if;
    if l_char_arr.exists(2) then l_row.vc2 := l_char_arr(2); end if;
    if l_char_arr.exists(3) then l_row.vc3 := l_char_arr(3); end if;
    if l_char_arr.exists(4) then l_row.vc4 := l_char_arr(4); end if;

    if l_char_arr.exists(100) then l_row.vc4 := l_char_arr(100); end if;
    
    insert into t values l_row;
  end loop;

  dbms_sql.close_cursor( l_theCursor);
exception
  when others then
    dbms_sql.close_cursor( l_theCursor);
    raise;
end;
/
sho err


exec my_collection_generator('select * from emp');


decode(c.type#, 1, decode(c.charsetform, 2, 'NVARCHAR2', 'VARCHAR2'),
                2, decode(c.scale, null,
                          decode(c.precision#, null, 'NUMBER', 'FLOAT'),
                          'NUMBER'),
                8, 'LONG',
                9, decode(c.charsetform, 2, 'NCHAR VARYING', 'VARCHAR'),
                12, 'DATE',
                23, 'RAW', 24, 'LONG RAW',
                58, nvl2(ac.synobj#, (select o.name from obj$ o
                         where o.obj#=ac.synobj#), ot.name),
                69, 'ROWID',
                96, decode(c.charsetform, 2, 'NCHAR', 'CHAR'),
                100, 'BINARY_FLOAT',
                101, 'BINARY_DOUBLE',
                105, 'MLSLABEL',
                106, 'MLSLABEL',
                111, nvl2(ac.synobj#, (select o.name from obj$ o
                          where o.obj#=ac.synobj#), ot.name),
                112, decode(c.charsetform, 2, 'NCLOB', 'CLOB'),
                113, 'BLOB', 114, 'BFILE', 115, 'CFILE',
                119, 'JSON',
                121, nvl2(ac.synobj#, (select o.name from obj$ o
                          where o.obj#=ac.synobj#), ot.name),
                122, nvl2(ac.synobj#, (select o.name from obj$ o
                          where o.obj#=ac.synobj#), ot.name),
                123, nvl2(ac.synobj#, (select o.name from obj$ o
                          where o.obj#=ac.synobj#), ot.name),
                178, 'TIME(' ||c.scale|| ')',
                179, 'TIME(' ||c.scale|| ')' || ' WITH TIME ZONE',
                180, 'TIMESTAMP(' ||c.scale|| ')',
                181, 'TIMESTAMP(' ||c.scale|| ')' || ' WITH TIME ZONE',
                231, 'TIMESTAMP(' ||c.scale|| ')' || ' WITH LOCAL TIME ZONE',
                182, 'INTERVAL YEAR(' ||c.precision#||') TO MONTH',
                183, 'INTERVAL DAY(' ||c.precision#||') TO SECOND(' ||
                      c.scale || ')',
                208, 'UROWID',
                'UNDEFINED'),