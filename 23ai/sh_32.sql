clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
drop table customers purge;
set termout on
set echo off
clear screen
prompt |
prompt |       _  _____  ____  _   _            _______ _____            _   _  _____ ______ ____  _____  __  __ 
prompt |      | |/ ____|/ __ \| \ | |          |__   __|  __ \     /\   | \ | |/ ____|  ____/ __ \|  __ \|  \/  |
prompt |      | | (___ | |  | |  \| |             | |  | |__) |   /  \  |  \| | (___ | |__ | |  | | |__) | \  / |
prompt |  _   | |\___ \| |  | | . ` |             | |  |  _  /   / /\ \ | . ` |\___ \|  __|| |  | |  _  /| |\/| |
prompt | | |__| |____) | |__| | |\  |             | |  | | \ \  / ____ \| |\  |____) | |   | |__| | | \ \| |  | |
prompt |  \____/|_____/ \____/|_| \_|             |_|  |_|  \_\/_/    \_\_| \_|_____/|_|    \____/|_|  \_\_|  |_|
prompt |                               ______                                                                    
prompt |                              |______|                                                                   
prompt |
pause
clear screen
set echo on
create table customers(
  id      number,
  created timestamp,
  cdata   json);
pause
insert into customers
values (1, systimestamp, 
'{"name":"Conner", "address":{"city":"Perth"}}');
pause
update customers
  set cdata =
    json_transform(cdata,
      set '$.lastUpdated' = systimestamp,
      set '$.address.zip'    = 6001,
      set '$.name'        = 'Connor',
      rename '$.name'     = 'firstname',
      append '$.friends'  = json('{"name":"Tom","age":20}') create on missing
      )
  where id = 1;
pause
select json_serialize(cdata pretty) from customers;
pause
clear screen
update customers
  set cdata =
    json_transform(cdata,
      prepend '$.friends'  = json('{"name":"Melanie","age":21}')
      )
  where id = 1;
pause  
select json_serialize(cdata pretty) from customers;
pause
clear screen
update customers
  set cdata =
    json_transform(cdata,
      copy '$.friends' = path '$names[*]'
      passing json('[{"name":"Maria","age":22},{"name":"Dom","age":23}]') as "names"
      )
  where id = 1;
pause
select json_serialize(cdata pretty) from customers;
pause
clear screen 
update customers
  set cdata =
    json_transform(cdata,
      union '$.friends' = path '$names[*]'
      passing json('[{"name":"Dom","age":23},{"name":"Jennifer","age":24}]') as "names"
      )
  where id = 1;
pause  
select json_serialize(cdata pretty) from customers;
pause
set long 5000
clear screen
select
   json_transform(cdata,
       set '$.friend_count' = path '$.friends[*].count()'
       returning clob pretty )
from customers       
   where id = 1

pause
/
pause
select
   json_transform(cdata,
       set '$.friend_avg' = path '$.friends[*].age.avg()',
       set '$.friend_old' = path '$.friends[*].age.max()'
       returning clob pretty )
from customers       
   where id = 1

pause
/

pause Done

  