select text
from user_source
where name = upper('&name_full_req')
order by type, line;
