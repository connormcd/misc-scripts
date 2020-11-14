undefine mbrc
undefine x
accept mbrc prompt 'Read count (default:128) '
set termout off
col y new_value x
select nvl('&mbrc','128') y from dual;
set termout on
set verify off
prompt Setting to &x
alter session set db_file_multiblock_read_count = &x;
set verify on
