set verify off
select synonym_name, table_owner, table_name
from dba_synonyms
where synonym_name like '%'||upper('&1')||'%';
