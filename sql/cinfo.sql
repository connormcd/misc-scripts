select sid, client_info
from v$session
where client_info is not null;
