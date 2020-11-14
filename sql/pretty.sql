set feedback off
set serveroutput on size 999999
declare
  cursor x is
    select replace(sql_text,chr(13),' ') sql_text
    from v$sqltext
    where ( address = '&1' or sql_id = '&1') 
    order by piece;
  prev_txt varchar2(1999);
  this_line varchar2(1999);
  last_space number;
  too_long number;
begin
  for i in x loop
    last_space := greatest(instr(prev_txt||i.sql_text,' ',-1),
                           instr(prev_txt||i.sql_text,',',-1));
    if last_space > 0 then
      this_line := substr(prev_txt||i.sql_text,1,last_space);
      if length(this_line) > 80 then
        too_long := instr(substr(this_line,40),'to_date');
        if too_long > 0 then
          dbms_output.put_line(substr(this_line,1,too_long+38));
          dbms_output.put_line(substr(this_line,39+too_long));
        else
          dbms_output.put_line(this_line);
        end if;
      else
        dbms_output.put_line(this_line);
      end if;
      prev_txt := substr(prev_txt||i.sql_text,last_space+1);
    else
      prev_txt := prev_txt||i.sql_text;
    end if;
  end loop;
  dbms_output.put_line(prev_txt); 
end;
/
set feedback off
