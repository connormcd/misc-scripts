create tablespace "TABLESPACE_NAME" datafile '...' size 20m;
create user "OWNER" identified by tiger;
alter user "OWNER" quota 10m on "TABLESPACE_NAME";
create table "OWNER"."TABLE_NAME" ( "COLUMN_NAME" int ) tablespace "TABLESPACE_NAME";
grant create session to "OWNER";
