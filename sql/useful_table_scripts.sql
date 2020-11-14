create or replace function get_total_blocks
( p_segname in varchar2,
  p_owner   in varchar2 default user,
  p_type    in varchar2 default 'TABLE' ) return number
as
    l_free_blks                 number;

    l_total_blocks              number;
    l_total_bytes               number;
    l_unused_blocks             number;
    l_unused_bytes              number;
    l_LastUsedExtFileId         number;
    l_LastUsedExtBlockId        number;
    l_LAST_USED_BLOCK           number;
begin
    dbms_space.unused_space
    ( segment_owner     => p_owner,
      segment_name      => p_segname,
      segment_type      => p_type,
      total_blocks      => l_total_blocks,
      total_bytes       => l_total_bytes,
      unused_blocks     => l_unused_blocks,
      unused_bytes      => l_unused_bytes,
      LAST_USED_EXTENT_FILE_ID => l_LastUsedExtFileId,
      LAST_USED_EXTENT_BLOCK_ID => l_LastUsedExtBlockId,
      LAST_USED_BLOCK => l_LAST_USED_BLOCK );

    return l_total_blocks;
exception
    when others then return null;
end;
/

create or replace function get_unused_blocks
( p_segname in varchar2,
  p_owner   in varchar2 default user,
  p_type    in varchar2 default 'TABLE' ) return number
as
    l_free_blks                 number;

    l_total_blocks              number;
    l_total_bytes               number;
    l_unused_blocks             number;
    l_unused_bytes              number;
    l_LastUsedExtFileId         number;
    l_LastUsedExtBlockId        number;
    l_LAST_USED_BLOCK           number;
begin
    dbms_space.unused_space
    ( segment_owner     => p_owner,
      segment_name      => p_segname,
      segment_type      => p_type,
      total_blocks      => l_total_blocks,
      total_bytes       => l_total_bytes,
      unused_blocks     => l_unused_blocks,
      unused_bytes      => l_unused_bytes,
      LAST_USED_EXTENT_FILE_ID => l_LastUsedExtFileId,
      LAST_USED_EXTENT_BLOCK_ID => l_LastUsedExtBlockId,
      LAST_USED_BLOCK => l_LAST_USED_BLOCK );

    return l_unused_blocks;
exception
    when others then return null;
end;
/


create or replace function get_free_blocks
( p_segname in varchar2,
  p_owner   in varchar2 default user,
  p_type    in varchar2 default 'TABLE' ) return number
as
    l_free_blks                 number;
begin
    dbms_space.free_blocks
    ( segment_owner     => p_owner,
      segment_name      => p_segname,
      segment_type      => p_type,
      freelist_group_id => 0,
      free_blks         => l_free_blks );

    return l_free_blks;
exception
    when others then return null;
end;
/

and then you can easily:


select table_name, get_total_blocks( table_name ),
                   get_unused_blocks(table_name),
                   get_free_blocks(table_name)
 from user_tables
/