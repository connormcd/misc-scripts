set lines 120
col directory_name format a32
col directory_path format a80
select directory_name, directory_path
from dba_directories
order by 1;
