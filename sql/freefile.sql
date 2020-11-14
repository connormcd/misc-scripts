select f.tablespace_name, f.file_id, sum(f.bytes) "TOT_FREE", max(f.bytes) "LARGEST_SEG", 
                   max(d.totspace) total_size, round(100-sum(f.bytes)/max(d.totspace)*100) pct_used
from sys.dba_free_space f, ( select tablespace_name, file_id, sum(bytes) totspace
                           from dba_data_Files 
                            group by tablespace_name , file_id ) d
where f.tablespace_name like nvl(upper('&tablespace_prefix'),f.tablespace_name)||'%'
and f.tablespace_name = d.tablespace_name
and f.file_id = d.file_id
group by f.tablespace_name, f.file_id;
