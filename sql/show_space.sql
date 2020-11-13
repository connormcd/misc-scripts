-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
Ok, time for an update of this utility!  I had this sitting around already -- it 
does two things 

1) adds partition support
2) makes it so this runs in SQL for anything...  gives a result set instead of 
printing. You can easily make it dbms_output.put_line if you want...


First we start with the types:

create or replace type show_space_type
as object
( owner                 varchar2(30),
  segment_name          varchar2(30),
  partition_name        varchar2(30),
  segment_type          varchar2(30),
  free_blocks           number,
  total_blocks          number,
  unused_blocks         number,
  last_used_ext_fileid  number,
  last_used_ext_blockid number,
  last_used_block       number
)
/
create or replace type show_space_table_type
as table of show_space_type
/


And then the function:

create or replace
function show_space_for
( p_segname   in varchar2,
  p_owner     in varchar2 default user,
  p_type      in varchar2 default 'TABLE',
  p_partition in varchar2 default NULL )
return show_space_table_type
authid CURRENT_USER
as
    pragma autonomous_transaction;
    type rc is ref cursor;
    l_cursor rc;

    l_free_blks                 number;
    l_total_blocks              number;
    l_total_bytes               number;
    l_unused_blocks             number;
    l_unused_bytes              number;
    l_LastUsedExtFileId         number;
    l_LastUsedExtBlockId        number;
    l_last_used_block           number;
    l_sql                       long;
    l_conj                      varchar2(7) default ' where ';
    l_data                      show_space_table_type := 
show_space_table_type();
    l_owner varchar2(30);
    l_segment_name varchar2(30);
    l_segment_type varchar2(30);
    l_partition_name varchar2(30);

    procedure add_predicate( p_name in varchar2, p_value in varchar2 )
    as
    begin
        if ( instr( p_value, '%' ) > 0 )
        then
            l_sql := l_sql || l_conj || p_name || 
                            ' like ''' || upper(p_value) || '''';
            l_conj := ' and ';
        elsif ( p_value is not null )
        then
            l_sql := l_sql || l_conj || p_name || 
                            ' = ''' || upper(p_value) || '''';
            l_conj := ' and ';
        end if;
    end;
begin
    l_sql := 'select owner, segment_name, segment_type, partition_name
                from dba_segments ';

    add_predicate( 'segment_name', p_segname );
    add_predicate( 'owner', p_owner );
    add_predicate( 'segment_type', p_type );
    add_predicate( 'partition', p_partition );

    execute immediate 'alter session set cursor_sharing=force';
    open l_cursor for l_sql;
    execute immediate 'alter session set cursor_sharing=exact';

    loop
        fetch l_cursor into l_owner, l_segment_name, l_segment_type, 
l_partition_name;
        exit when l_cursor%notfound;
        begin
        dbms_space.free_blocks
        ( segment_owner     => l_owner,
          segment_name      => l_segment_name,
          segment_type      => l_segment_type,
          partition_name    => l_partition_name,
          freelist_group_id => 0,
          free_blks         => l_free_blks );

        dbms_space.unused_space
        ( segment_owner     => l_owner,
          segment_name      => l_segment_name,
          segment_type      => l_segment_type,
          partition_name    => l_partition_name,
          total_blocks      => l_total_blocks,
          total_bytes       => l_total_bytes,
          unused_blocks     => l_unused_blocks,
          unused_bytes      => l_unused_bytes,
          LAST_USED_EXTENT_FILE_ID => l_LastUsedExtFileId,
          LAST_USED_EXTENT_BLOCK_ID => l_LastUsedExtBlockId,
          LAST_USED_BLOCK => l_LAST_USED_BLOCK );

        l_data.extend;
        l_data(l_data.count) := 
               show_space_type( l_owner, l_segment_name, l_partition_name,
                  l_segment_type, l_free_blks, l_total_blocks, l_unused_blocks,
                  l_lastUsedExtFileId, l_LastUsedExtBlockId, l_last_used_block 
);
        exception
            when others then null;
        end;
    end loop;
    close l_cursor;

    return l_data;
end;
/




Then we can:

ops$tkyte@ORA817DEV.US.ORACLE.COM> select SEGMENT_NAME, PARTITION_NAME 
SEGMENT_TYPE, FREE_BLOCKS,TOTAL_BLOCKS,UNUSED_BLOCKS
  2    from table( cast( show_space_for( 'HASHED',user,'%' ) as 
show_space_table_type ) )
  3  /

SEGMENT_NA SEGMENT_TYPE      FREE_BLOCKS TOTAL_BLOCKS UNUSED_BLOCKS
---------- ----------------- ----------- ------------ -------------
HASHED     PART_2                      1           64            62
HASHED     PART_3                      1           64            62
HASHED     PART_4                      1           64            62
HASHED     PART_1                      1           64            62

ops$tkyte@ORA817DEV.US.ORACLE.COM> 

And in 9i, we'd change the function to be pipelined:

ops$tkyte@ORA9I.WORLD> create or replace
  2  function show_space_for
  3  ( p_segname   in varchar2,
  4    p_owner     in varchar2 default user,
  5    p_type      in varchar2 default 'TABLE',
  6    p_partition in varchar2 default NULL )
  7  return show_space_table_type
  8  authid CURRENT_USER
  9  PIPELINED
 10  as
 11      pragma autonomous_transaction;
 12      type rc is ref cursor;
 13      l_cursor rc;
 14  
 15      l_free_blks                 number;
 16      l_total_blocks              number;
 17      l_total_bytes               number;
 18      l_unused_blocks             number;
 19      l_unused_bytes              number;
 20      l_LastUsedExtFileId         number;
 21      l_LastUsedExtBlockId        number;
 22      l_last_used_block           number;
 23      l_sql                       long;
 24      l_conj                       varchar2(7) default ' where ';
 25      l_owner varchar2(30);
 26      l_segment_name varchar2(30);
 27      l_segment_type varchar2(30);
 28      l_partition_name varchar2(30);
 29  
 30      procedure add_predicate( p_name in varchar2, p_value in varchar2 )
 31      as
 32      begin
 33          if ( instr( p_value, '%' ) > 0 )
 34          then
 35              l_sql := l_sql || l_conj || p_name || ' like ''' || 
upper(p_value) || '''';
 36              l_conj := ' and ';
 37          elsif ( p_value is not null )
 38          then
 39              l_sql := l_sql || l_conj || p_name || ' = ''' || upper(p_value) 
|| '''';
 40              l_conj := ' and ';
 41          end if;
 42      end;
 43  begin
 44      l_sql := 'select owner, segment_name, segment_type, partition_name
 45                  from dba_segments ';
 46  
 47      add_predicate( 'segment_name', p_segname );
 48      add_predicate( 'owner', p_owner );
 49      add_predicate( 'segment_type', p_type );
 50      add_predicate( 'partition', p_partition );
 51  
 52      execute immediate 'alter session set cursor_sharing=force';
 53      open l_cursor for l_sql;
 54      execute immediate 'alter session set cursor_sharing=exact';
 55  
 56      loop
 57          fetch l_cursor into l_owner, l_segment_name, l_segment_type, 
l_partition_name;
 58                  dbms_output.put_line( l_segment_name || ',' || 
l_segment_type );
 59          exit when l_cursor%notfound;
 60          begin
 61          dbms_space.free_blocks
 62          ( segment_owner     => l_owner,
 63              segment_name      => l_segment_name,
 64              segment_type      => l_segment_type,
 65              partition_name    => l_partition_name,
 66              freelist_group_id => 0,
 67              free_blks         => l_free_blks );
 68  
 69          dbms_space.unused_space
 70          ( segment_owner     => l_owner,
 71              segment_name      => l_segment_name,
 72              segment_type      => l_segment_type,
 73              partition_name    => l_partition_name,
 74              total_blocks      => l_total_blocks,
 75              total_bytes       => l_total_bytes,
 76              unused_blocks     => l_unused_blocks,
 77              unused_bytes      => l_unused_bytes,
 78              LAST_USED_EXTENT_FILE_ID => l_LastUsedExtFileId,
 79              LAST_USED_EXTENT_BLOCK_ID => l_LastUsedExtBlockId,
 80              LAST_USED_BLOCK => l_LAST_USED_BLOCK );
 81  
 82          pipe row ( show_space_type( l_owner, l_segment_name, 
l_partition_name,
 83                     l_segment_type, l_free_blks, l_total_blocks, 
l_unused_blocks,
 84                      l_lastUsedExtFileId, l_LastUsedExtBlockId, 
l_last_used_block ) );
 85          exception
 86              when others then null;
 87          end;
 88      end loop;
 89      close l_cursor;
 90  
 91      return;
 92  end;
 93  /

Function created.

ops$tkyte@ORA9I.WORLD> set arraysize 1

ops$tkyte@ORA9I.WORLD> select SEGMENT_NAME, SEGMENT_TYPE, 
FREE_BLOCKS,TOTAL_BLOCKS,UNUSED_BLOCKS
  2    from table( show_space_for( '%',user,'%' ) )
  3  /

SEGMENT_NAME    SEGMENT_TYPE      FREE_BLOCKS TOTAL_BLOCKS UNUSED_BLOCKS
--------------- ----------------- ----------- ------------ -------------
KEEP_SCN        TABLE                       1           64            62
EMPLOYEES       TABLE                       0           64            63
STINKY          TABLE                       0           64            63
OBJECT_TABLE    TABLE                       1           64            62
RUN_STATS       TABLE                       2           64            53
EMP             TABLE                       0           64            62
PROJ            TABLE                       0           64            62
X               TABLE                       1           64            62
WORDS           TABLE                       0           64            63
DOCS            TABLE                       0           64            63
KEYWORDS        TABLE                       0           64            63
DEPT            TABLE                       2           64            61
C               TABLE                       1           64            62
DSINVLINES      TABLE                       1           64            62
NUM_STR         TABLE                       1           64            23
T               TABLE                       4           64            28
T1              TABLE                       0           64            63
T2              TABLE                       0           64            63
BOM             TABLE                       1           64            62
PARTS           TABLE                       1           64            62
SYS_C001371     INDEX                       0           64            62
SYS_C001372     INDEX                       0           64            62
SYS_C001574     INDEX                       0           64            62
SYS_C001694     INDEX                       0           64            62
SYS_C001695     INDEX                       0           64            62
BOM_PK          INDEX                       0           64            62
PARTS_PK        INDEX                       0           64            62

27 rows selected.
