define dba=01012073

col x new_value base10

select to_number('&dba','xxxxxxxxxx') x from dual;

col block new_value b
col file new_value f

SELECT dbms_utility.data_block_address_block(&&base10) "BLOCK",
           dbms_utility.data_block_address_file(&&base10) "FILE"
      FROM dual;
      
select * 
from dba_extents
where file_id = &f
and &b between block_id and block_id+blocks;
