clear screen
@clean
set termout off
conn sys/admin@db23 as sysdba
set termout off
grant create mle to dbdemo;
grant EXECUTE DYNAMIC MLE to dbdemo;
grant execute on javascript to dbdemo;

conn dbdemo/dbdemo@db23
set termout off
alter system reset txn_auto_rollback_high_priority_wait_target;
clear screen
@drop images
create or replace directory JSONDOCS   as '/home/oracle/json';
create table images ( b blob);
insert into images values (to_blob(bfilename('JSONDOCS','aths.jpg')));
commit;
set termout on
set echo off
prompt |
prompt | 
prompt |  
prompt |         _      __      __        _____   _____  _____   _____  _____  _______ 
prompt |        | |   /\\ \    / //\     / ____| / ____||  __ \ |_   _||  __ \|__   __|
prompt |        | |  /  \\ \  / //  \   | (___  | |     | |__) |  | |  | |__) |  | |   
prompt |    _   | | / /\ \\ \/ // /\ \   \___ \ | |     |  _  /   | |  |  ___/   | |   
prompt |   | |__| |/ ____ \\  // ____ \  ____) || |____ | | \ \  _| |_ | |       | |   
prompt |    \____//_/    \_\\//_/    \_\|_____/  \_____||_|  \_\|_____||_|       |_|   
prompt |                                                                               
prompt |                                                                               
prompt |  
pause
clear screen
set termout on
set echo on
set serveroutput on;
declare
  l_ctx dbms_mle.context_handle_t;
  l_script clob := q'~
    console.log('Hello World!');
  ~';
begin
  l_ctx := dbms_mle.create_context();
  dbms_mle.eval(l_ctx, 'JAVASCRIPT', l_script);
  dbms_mle.drop_context(l_ctx);
exception
  when others then
    dbms_mle.drop_context(l_ctx);
    raise;
end;
/
pause
clear screen
declare
   l_ctx dbms_mle.context_handle_t := dbms_mle.create_context();
   l_script clob ;
begin
   l_script := q'~
    const sql = `select empno,ename from scott.emp` ;
    const result = session.execute(sql);
    for (const row of result.rows) {
      console.log(JSON.stringify(row))
    }
       ~';
   dbms_mle.eval(l_ctx, 'JAVASCRIPT', l_script);
   dbms_mle.drop_context(l_ctx);
end;
/
pause
--
--
-- Um....why?
--
--
pause
clear screen
create or replace 
mle module validator 
language javascript 
using bfile(JSONDOCS, 'validator.min.js');
/
pause
create or replace 
package validator_pkg as

  function isEmail(p_email_address varchar2) return boolean as 
    mle module validator
    signature 'default.isEmail(string)';

end;
/
pause
clear screen
select validator_pkg.isEmail('user@somewhere.org');
pause
select validator_pkg.isEmail('user@somewhere');
pause
select validator_pkg.isEmail('user~qwe@somewhere.org')

pause
/
pause
clear screen
create or replace
mle module exifr language javascript
version '7.1.3'
using bfile(JSONDOCS, 'full.esm.js')
/
pause
create or replace mle env exifr_env imports (
    'exifr' module exifr
);
pause
clear screen
create or replace 
mle module mle_exifr language javascript as

import exifr from 'exifr';

export async function GetExif() {

  const query = "SELECT B FROM IMAGES";
  const options = { 
    fetchInfo: { B: { type: oracledb.UINT8ARRAY } }
  };
  
  const queryResult = session.execute(query, [], options);
  const output = await exifr.parse(queryResult.rows[0].B.buffer);

  return JSON.stringify(output);
}
/
pause
create or replace package exif_pkg as

    function get_exif
      return varchar2
      as mle module mle_exifr
      env exifr_env
      signature 'GetExif()';

end;
/
pause
clear screen
select json_serialize(treat(exif_pkg.get_exif as json) pretty)

pause
/
pause Done

