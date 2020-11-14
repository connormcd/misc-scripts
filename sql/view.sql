set verify off
select 	view_name
from 	user_views
where 	view_name like nvl(upper('&view_name'),view_name)||'%';
