set verify off
col text format a80
set lines 120
select line, text
from user_errors
where line between &1-20 and &1+20;
