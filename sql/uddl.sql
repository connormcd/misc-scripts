set long 100000
set longchunksize 100000
select dbms_metadata.get_ddl('USER',upper('&1')) from dual;
