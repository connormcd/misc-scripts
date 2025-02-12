REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

clear screen
@clean
set termout off
conn USER/PASSWORD@MY_PDB
set termout off
clear screen
set timing off
set time off
set pages 999
@drop my_excel_file
@drop my_excel_file2
@drop t
set lines 200
set termout on
clear screen
set feedback on
set echo on
create table t ( b blob);
pause
insert into t 
values ( to_blob(bfilename('TEMP','large50k.xlsx')));
commit;
pause
select dbms_lob.getlength(b) from t;
pause
clear screen
set timing on
select count(*)
from t f, table( apex_data_parser.parse(
                     p_content=>f.b,
                     p_file_name=>'large50k.xlsx'
                     ) ) p
WHERE p.col001='SYS'

-- Note: set this running 
--
-- segue: the 50m issue
--
-- create or replace 
-- function create_cached_blob( p_file in blob ) return blob is
--     l_blob blob;
-- begin
--     dbms_lob.createtemporary(l_blob,true);
--     dbms_lob.copy(l_blob,p_file,dbms_lob.lobmaxsize);
--     return l_blob;
-- end;
-- 
-- select count(*)
-- from t f, table( apex_data_parser.parse(
--                      p_content=>CREATE_CACHED_BLOB(F.B),
--                      p_file_name=>'large50k.xlsx'
--                      ) ) p
-- where p.col001='sys';
pause
/
set timing off
pause
clear screen
host cat x:\bin\excel2csv.bat
pause
host cat X:\bin\Python37\excel2csv.py
pause
clear screen
create table my_excel_file 
(  owner                     varchar2(128)
  ,object_name               varchar2(128)
  ,subobject_name            varchar2(128)
  ,object_id                 number
  ,data_object_id            number
  ,object_type               varchar2(23)
  ,created                   date
#pause
  ,last_ddl_time             date
  ,timestamp                 varchar2(19)
  ,status                    varchar2(7)
  ,temporary                 varchar2(1)
  ,generated                 varchar2(1)
  ,secondary                 varchar2(1)
  ,namespace                 number
  ,edition_name              varchar2(128)
  ,sharing                   varchar2(18)
  ,editionable               varchar2(1)
  ,oracle_maintained         varchar2(1)
  ,application               varchar2(1)
  ,default_collation         varchar2(100)
  ,duplicated                varchar2(1)
  ,sharded                   varchar2(1)
  ,imported_object           varchar2(1)
  ,created_appid             number
  ,created_vsnid             number
  ,modified_appid            number
  ,modified_vsnid            number
)
#pause
organization external
( type oracle_loader
  default directory ctmp
  access parameters
  ( records delimited by newline
    preprocessor bin2: 'excel2csv.bat'
    fields terminated by ',' missing field values are null
#pause
   ( owner
    ,object_name
    ,subobject_name
    ,object_id
    ,data_object_id
    ,object_type
    ,created        date "yyyy-mm-dd hh24:mi:ss"
    ,last_ddl_time  date "yyyy-mm-dd hh24:mi:ss"
    ,"TIMESTAMP"
    ,status
    ,temporary
    ,generated
    ,secondary
    ,namespace
    ,edition_name
    ,sharing
    ,editionable
    ,oracle_maintained
    ,application
    ,default_collation
    ,duplicated
    ,sharded
    ,imported_object
    ,created_appid
    ,created_vsnid
    ,modified_appid
    ,modified_vsnid )
 ) location('large50k.xlsx')
) reject limit unlimited;
pause
set timing on
select count(*)
from my_excel_file
WHERE owner='SYS';
set timing off
pause
clear screen
host cat x:\bin\excel2csv2.bat
pause
create table my_excel_file2 
(  owner                     varchar2(128)
  ,object_name               varchar2(128)
  ,subobject_name            varchar2(128)
  ,object_id                 number
  ,data_object_id            number
  ,object_type               varchar2(23)
  ,created                   date
  ,last_ddl_time             date
  ,timestamp                 varchar2(19)
  ,status                    varchar2(7)
  ,temporary                 varchar2(1)
  ,generated                 varchar2(1)
  ,secondary                 varchar2(1)
  ,namespace                 number
  ,edition_name              varchar2(128)
  ,sharing                   varchar2(18)
  ,editionable               varchar2(1)
  ,oracle_maintained         varchar2(1)
  ,application               varchar2(1)
  ,default_collation         varchar2(100)
  ,duplicated                varchar2(1)
  ,sharded                   varchar2(1)
  ,imported_object           varchar2(1)
  ,created_appid             number
  ,created_vsnid             number
  ,modified_appid            number
  ,modified_vsnid            number
)
#pause
organization external
( type oracle_loader
  default directory ctmp
  access parameters
  ( records delimited by newline
    preprocessor bin2: 'excel2csv2.bat'
    fields terminated by ',' missing field values are null
#pause
   ( owner
    ,object_name
    ,subobject_name
    ,object_id
    ,data_object_id
    ,object_type
    ,created        date "yyyymmdd"
    ,last_ddl_time  date "yyyymmdd"
    ,"TIMESTAMP"
    ,status
    ,temporary
    ,generated
    ,secondary
    ,namespace
    ,edition_name
    ,sharing
    ,editionable
    ,oracle_maintained
    ,application
    ,default_collation
    ,duplicated
    ,sharded
    ,imported_object
    ,created_appid
    ,created_vsnid
    ,modified_appid
    ,modified_vsnid )
 ) location('large50k.xlsx')
) reject limit unlimited;
pause
set timing on
select count(*)
from my_excel_file2
WHERE owner='SYS';
set timing off
