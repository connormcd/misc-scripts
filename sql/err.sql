-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
create or replace package d is
  fname varchar2(30);
  use_timestamp varchar2(1);
  procedure set_file_name(pname varchar2,p_use_timestamp varchar2 default 'N');
  procedure o(msg varchar2);
  procedure o(msg number);
  procedure o(msg date);
end;
/

create or replace package body d is

procedure set_file_name(pname varchar2,p_use_timestamp varchar2 default 'N') is
begin
  fname := pname;
  use_timestamp := upper(p_use_timestamp);
end;

procedure o(msg varchar2) is
 v_file_handle  utl_file.file_type;
begin
  if not utl_file.is_open( v_file_handle ) then
    begin
      v_file_handle := utl_file.fopen( '/usr/local/bin/maritz/autosys/data/txdid', nvl(fname,'dri.log'), 'a' );
    exception when utl_file.invalid_operation then
      v_file_handle := utl_file.fopen( '/usr/local/bin/maritz/autosys/data/txdid', nvl(fname,'dri.log'), 'w' );
    end;
  end if;
  if utl_file.is_open( v_file_handle ) then
    if use_timestamp != 'Y' then
      utl_file.put_line(v_file_handle, msg);
    else
      utl_file.put_line(v_file_handle, to_char(sysdate,'DD/MM HH24:MI:SS')||':'||msg);
    end if;
  end if;
  utl_file.fclose(v_file_handle);
  exception 
  when utl_file.invalid_path        then dbms_output.put_line('invalid_path');
  when utl_file.invalid_mode        then dbms_output.put_line('invalid_mode');
  when utl_file.invalid_filehandle  then dbms_output.put_line('invalid_filehandle');
  when utl_file.invalid_operation   then dbms_output.put_line('invalid_operation');
  when utl_file.read_error          then dbms_output.put_line('read_error');
  when utl_file.write_error         then dbms_output.put_line('write_error');
  when utl_file.internal_error      then dbms_output.put_line('internal_error');
end;

procedure o(msg date) is
begin
  o(to_char(msg,'DD/MM/YY HH24:MI:SS'));
end;

procedure o(msg number) is
begin
  o(to_char(msg));
end;

end;
/

/usr/local/bin/maritz/autosys/data/txdid
