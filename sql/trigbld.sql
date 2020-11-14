set long 10000
select 'create or replace '||TRIGGER_NAME||chr(10)||
replace(replace(trigger_type,'EACH ROW'),'STATEMENT',null)||' '||
TRIGGERING_EVENT||' on '||TABLE_OWNER||'.'||table_name||chr(10)||
decode(instr(trigger_type,'STATEMENT'),0,'FOR EACH ROW'||chr(10),null)||
when_clause||' is'
, TRIGGER_BODY
from user_triggers
where table_name like nvl(upper('&table_name'),table_name)||'%';
