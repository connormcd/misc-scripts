-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
create or replace package update_cascade
as

    procedure on_table( p_table_name      in varchar2,
                        p_preserve_rowid  in boolean default TRUE,
                        p_use_dbms_output in boolean default FALSE );

end update_cascade;
/

create or replace package body update_cascade
as

type cnameArray is table of user_cons_columns.column_name%type
                   index by binary_integer;

sql_stmt           varchar2(32000);
use_dbms_output    boolean default FALSE;
preserve_rowid     boolean default TRUE;

function q( s in varchar2 ) return varchar2
is
begin
    return '"'||s||'"';
end q;

function pkg_name( s in varchar2 ) return varchar2
is
begin
    return q( 'TRG_PKG_' || s );
end pkg_name;


function view_name( s in varchar2 ) return varchar2
is
begin
    return q( 'TRG_VW_' || s );
end view_name;

function trigger_name( s in varchar2, s2 in varchar2 ) return varchar2
is
begin
    return q( 'TRG_' || s || s2 );
end trigger_name;


function strip( s in varchar2 ) return varchar2
is
begin
    return ltrim(rtrim(s));
end strip;

procedure add( s in varchar2 )
is
begin
    if ( use_dbms_output ) then
        dbms_output.put_line( chr(9) || s );
    else
        sql_stmt := sql_stmt || chr(10) || s;
    end if;
end add;



procedure execute_immediate
as
    exec_cursor     integer default dbms_sql.open_cursor;
    rows_processed  number  default 0;
begin
    if ( use_dbms_output ) then
        dbms_output.put_line( '/' );
    else
        dbms_sql.parse(exec_cursor, sql_stmt, dbms_sql.native );
        rows_processed := dbms_sql.execute(exec_cursor);
        dbms_sql.close_cursor( exec_cursor );
        dbms_output.put_line(
        substr( sql_stmt, 2, instr( sql_stmt,chr(10),2)-2 ) );
        sql_stmt := NULL;
    end if;
exception
    when others then
      if dbms_sql.is_open(exec_cursor) then
        dbms_sql.close_cursor(exec_cursor);
      end if;
      raise;
end;

procedure get_pkey_names
( p_table_name      in out user_constraints.table_name%type,
  p_pkey_names         out cnameArray,
  p_constraint_name in out user_constraints.constraint_name%type )
is
begin
    select table_name, constraint_name
      into p_table_name, p_constraint_name
      from user_constraints
     where ( table_name = p_table_name
             or table_name = upper(p_table_name) )
            and constraint_type = 'P' ;

    for x in ( select column_name , position
                 from user_cons_columns
                where constraint_name = p_constraint_name
                order by position ) loop
        p_pkey_names( x.position ) := x.column_name;
    end loop;
end get_pkey_names;


procedure write_spec( p_table_name in user_constraints.table_name%type,
                      p_pkey_names in cnameArray )
is
    l_comma     char(1) default ' ';
begin
    add( 'create or replace package ' || pkg_name(p_table_name) );
    add( 'as' );
    add( '--' );
    add( '    rowCnt    number default 0;' );
    add( '    inTrigger boolean default FALSE;' );
    add( '--' );

    for i in 1 .. 16 loop
        begin
            add( '    type C' || strip(i) || '_type is table of ' ||
                    q(p_table_name) || '.' || q(p_pkey_names(i)) ||
                 '%type index by binary_integer;' );
            add( '--' );
            add( '    empty_C' || strip(i) || ' C' || strip(i) || '_type;' );
            add( '    old_C' || strip(i) || '   C' || strip(i) || '_type;' );
            add( '    new_C' || strip(i) || '   C' || strip(i) || '_type;' );
            add( '--' );
        exception
            when no_data_found then exit;
        end;
    end loop;

    add( '--' );
    add( '    procedure reset;' );
    add( '--' );
    add( '    procedure do_cascade;' );
    add( '--' );

    add( '    procedure add_entry' );
    add( '    ( ' );
    for i in 1 .. 16 loop
        begin
            add( '        ' || l_comma || 'p_old_C' || strip(i) || ' in ' ||
                  q(p_table_name) || '.' || q(p_pkey_names(i)) || '%type ' );
            l_comma := ',';
            add( '        ,p_new_C' || strip(i) || ' in out ' ||
                  q(p_table_name) || '.' || q(p_pkey_names(i)) || '%type ' );
        exception
            when no_data_found then exit;
        end;
    end loop;
    add( '     );' );
    add( '--' );
    add( 'end ' || pkg_name(p_table_name) || ';' );

end write_spec;


procedure write_body
( p_table_name         in user_constraints.table_name%type,
  p_pkey_names      in cnameArray,
  p_constraint_name    in user_constraints.constraint_name%type )
is
    l_col_cnt         number default 0;
    l_comma         char(1) default ' ';
    l_pkey_str      varchar2(2000);
    l_pkey_name_str varchar2(2000);
    l_other_col_str varchar2(2000);
begin
    add( 'create or replace package body ' || pkg_name(p_table_name) );
    add( 'as' );
    add( '--' );

    add( '    procedure reset ' );
    add( '    is' );
    add( '    begin' );
    add( '--' );
    add( '        if ( inTrigger ) then return; end if;' );
    add( '--' );
    add( '        rowCnt := 0;' );
    for i in 1 .. 16 loop
        begin
           if (p_pkey_names(i) = p_pkey_names(i)) then
              l_col_cnt := l_col_cnt+1;
           end if;
           add( '        old_C' || strip(i) || ' := empty_C' || strip(i) || ';' );
           add( '        new_C' || strip(i) || ' := empty_C' || strip(i) || ';' );
        exception
           when no_data_found then exit;
        end;
    end loop;
    add( '    end reset;' );
    add( '--' );

    add( '    procedure add_entry ' );
    add( '    ( ' );
    for i in 1 .. 16 loop
        begin
            add( '        ' || l_comma || 'p_old_C' || strip(i) || ' in ' ||
                q(p_table_name) || '.' || q(p_pkey_names(i)) || '%type ' );
            l_comma := ',';
            add( '        ,p_new_C' || strip(i) || ' in out ' ||
                  q(p_table_name) || '.' || q(p_pkey_names(i)) || '%type ' );
        exception
            when no_data_found then exit;
        end;
    end loop;
    add( '     )' );
    add( '    is' );
    add( '    begin' );
    add( '--' );
    add( '        if ( inTrigger ) then return; end if;' );
    add( '--' );
    add( '        if ( ' );
    for i in 1 .. l_col_cnt loop
        if ( i <> 1 ) then
            add( '            OR' );
        end if;
        add( '             p_old_C' || strip(i) || ' <> ' ||
             'p_new_C' || strip(i) );
    end loop;
    add( '         ) then ' );
    add( '        rowCnt := rowCnt + 1;' );

    for i in 1 .. l_col_cnt loop
        add( '        old_C' || strip(i) ||
             '( rowCnt ) := p_old_C' || strip(i) || ';' );
        add( '        new_C' || strip(i) ||
             '( rowCnt ) := p_new_C' || strip(i) || ';' );
        add( '        p_new_C' || strip(i) ||
             ' := p_old_C' || strip(i) || ';' );
    end loop;

    add( '        end if;' );
    add( '    end add_entry;' );


    add( '--' );

    l_comma := ' ';
    for i in 1 .. l_col_cnt loop
        l_pkey_str      := l_pkey_str||l_comma||'$$_C' || strip(i) || '(i)';
        l_pkey_name_str := l_pkey_name_str || l_comma || q(p_pkey_names(i));
        l_comma := ',';
    end loop;

    for x in ( select column_name
                 from user_tab_columns
                where table_name = p_table_name
                  and column_name not in
                    ( select column_name
                        from user_cons_columns
                       where constraint_name = p_constraint_name )
                order by column_id )
    loop
        l_other_col_str := l_other_col_str || ',' || q(x.column_name);
    end loop;

    add( '    procedure do_cascade' );
    add( '    is' );
    add( '    begin' );
    add( '--' );
    add( '        if ( inTrigger ) then return; end if;' );
    add( '        inTrigger := TRUE;' );
    add( '--' );
    add( '        for i in 1 .. rowCnt loop' );
    add( '            insert into ' || p_table_name || ' ( ' );
    add( '            ' || l_pkey_name_str );
    add( '            ' || l_other_col_str || ') select ');
    add( '            ' || replace( l_pkey_str, '$$', 'new' ) );
    add( '            ' || l_other_col_str );

    add( '            from ' || q(p_table_name) || ' a' );
    add( '            where (' || l_pkey_name_str || ' ) = ' );
    add( '                  ( select ' || replace(l_pkey_str,'$$','old') );
    add( '                      from dual );' );
    add( '--' );
    if ( preserve_rowid ) then
       add( '            update ' || q(p_table_name) || ' set ' );
       add( '            ( ' || l_pkey_name_str || ' ) = ' );
       add( '            ( select ' );
       for i in 1 .. l_col_cnt loop
          if ( i <> 1 ) then add( '                  ,' ); end if;
          add( '                 decode( ' || q(p_pkey_names(i)) ||
          replace(', old_c$$(i), new_c$$(i), old_c$$(i) )', '$$',strip(i)) );
       end loop;
       add( '              from dual )' );
       add( '            where ( ' || l_pkey_name_str || ' ) =' );
       add( '                  ( select ' || replace(l_pkey_str,'$$','new') );
       add( '                      from dual )' );
       add( '               OR ( ' || l_pkey_name_str || ' ) =' );
       add( '                  ( select ' || replace(l_pkey_str,'$$','old') );
       add( '                      from dual );' );
    end if;

    for x in ( select table_name, constraint_name
                 from user_constraints
                where r_constraint_name = p_constraint_name
                  and constraint_type = 'R' ) loop

        l_comma := ' ';
        l_other_col_str := '';
        for y in ( select column_name
                     from user_cons_columns
                    where constraint_name = x.constraint_name
                    order by position ) loop
            l_other_col_str := l_other_col_str || l_comma || q(y.column_name);
            l_comma := ',';
        end loop;

        add( '--' );
        add( '            update ' || q( x.table_name ) || ' set ');
        add( '            ( ' || l_other_col_str || ' ) = ' );
        add( '            ( select  ' || replace( l_pkey_str, '$$', 'new' ) );
        add( '                from dual )' );
        add( '            where ( ' || l_other_col_str || ' ) = ' );
        add( '                  ( select  ' ||
                                replace( l_pkey_str, '$$', 'old' ) );
        add( '                    from dual );' );

    end loop;

    add( '--' );
    add( '            delete from ' || q(p_table_name)  );
    add( '             where ( ' || l_pkey_name_str || ' ) = ' );
    add( '                   ( select ' || 
				replace( l_pkey_str, '$$', 'old' ) );
    add( '                       from dual);' );
    add( '        end loop;' );

    add( '--' );
    add( '        inTrigger := FALSE;' );
    add( '        reset;' );
    add( '   exception' );
    add( '       when others then' );
    add( '          inTrigger := FALSE;' );
    add( '          reset;' );
    add( '          raise;' );
    add( '    end do_cascade;' );
    add( '--' );
    add( 'end ' || pkg_name( p_table_name ) || ';' );

end write_body;


procedure write_bu_trigger( p_table_name in user_constraints.table_name%type,
                            p_pkey_names in cnameArray )
is
    l_comma char(1) default ' ';
begin
    add( 'create or replace trigger ' || trigger_name( p_table_name, '1' ) );
    add( 'before update of ' );
    for i in 1 .. 16 loop
        begin
            add( '   ' || l_comma || q(p_pkey_names(i)) );
            l_comma := ',';
        exception
            when no_data_found then exit;
        end;
    end loop;
    add( 'on ' || q(p_table_name) );
    add( 'begin ' || pkg_name(p_table_name) || '.reset; end;' );
end write_bu_trigger;


procedure write_bufer_trigger
( p_table_name in user_constraints.table_name%type,
  p_pkey_names in cnameArray )
is
    l_comma   char(1) default ' ';
begin
    add( 'create or replace trigger '||trigger_name( p_table_name, '2' ) );
    add( 'before update of ' );

    for i in 1 .. 16 loop
        begin
            add( '   ' || l_comma || q(p_pkey_names(i)) );
            l_comma := ',';
        exception
            when no_data_found then exit;
        end;
    end loop;
    add( 'on ' || q(p_table_name) );
    add( 'for each row' );
    add( 'begin ' );
    add( '   ' || pkg_name(p_table_name) || '.add_entry(' );

    l_comma := ' ';
    for i in 1 .. 16 loop
        begin
            add( '      ' || l_comma || ':old.' || q(p_pkey_names(i)) );
            add( '      ,:new.' || q(p_pkey_names(i)) );
            l_comma := ',';
        exception
            when no_data_found then exit;
        end;
    end loop;
    add( '      );' );
    add( 'end;' );
end write_bufer_trigger;

procedure write_au_trigger( p_table_name in user_constraints.table_name%type,
                            p_pkey_names in cnameArray )
is
    l_comma  char(1) default ' ';
begin
    add( 'create or replace trigger ' || trigger_name( p_table_name, '3' ) );
    add( 'after update of ' );
    for i in 1 .. 16 loop
        begin
            add( '   ' || l_comma || q(p_pkey_names(i)) );
            l_comma := ',';
        exception
            when no_data_found then exit;
        end;
    end loop;
    add( 'on ' || q(p_table_name) );
    add( 'begin ' || pkg_name(p_table_name) || '.do_cascade; end;' );
end write_au_trigger;

procedure on_table( p_table_name      in varchar2,
                    p_preserve_rowid  in boolean default TRUE,
                    p_use_dbms_output in boolean default FALSE )
is
    l_table_name         user_constraints.table_name%type default p_table_name;
    l_constraint_name   user_constraints.constraint_name%type;
    l_pkey_names        cnameArray;
    l_comma                char(1) default ' ';
begin
    use_dbms_output := p_use_dbms_output;
    preserve_rowid  := p_preserve_rowid;

    get_pkey_names( l_table_name, l_pkey_names, l_constraint_name );

    sql_stmt := NULL;
    write_spec( l_table_name, l_pkey_names );
    execute_immediate;
    write_body( l_table_name, l_pkey_names, l_constraint_name );
    execute_immediate;
    write_bu_trigger( l_table_name, l_pkey_names );
    execute_immediate;
    write_bufer_trigger( l_table_name, l_pkey_names );
    execute_immediate;
    write_au_trigger( l_table_name, l_pkey_names );
    execute_immediate;


end on_table;

end update_cascade;
/
show errors
