set serverout on
exec dbms_output.put_line(dbms_flashback.GET_SYSTEM_CHANGE_NUMBER);
