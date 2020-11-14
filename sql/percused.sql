set pages 99
select f.tablespace_name, to_char(round((1-sum(f.bytes)/sum(b.bytes))*100,1),'999.9') perc_used
from sys.dba_free_space f, ( select d.tablespace_name, sum(d.bytes) bytes 
                             from sys.dba_data_files d
                             group by d.tablespace_name ) b
where f.tablespace_name = b.tablespace_name
group by f.tablespace_name;
