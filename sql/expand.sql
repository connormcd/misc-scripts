-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
set feedback off
set serveroutput on size 999999

undefine sqlid
set serverout on
variable c1 clob
variable c2 clob

declare
  prev_txt varchar2(1999);
  this_line varchar2(1999);
  last_space number;
  too_long number;
  sql_text varchar2(200);
begin
--  select sql_fulltext into :c1 from v$sql where sql_id = '&&sqlid' and rownum = 1;
  
  select sql_fulltext into :c1 from v$sql where sql_id = '3pgx32sbv806u' and rownum = 1;
  
  
  DBMS_UTILITY.EXPAND_SQL_TEXT (:c1,:c2);
  
  for i in 0 .. 9999 loop
    sql_text := dbms_lob.substr(:c2,100,i*100+1);

    exit when sql_text is null;
    last_space := greatest(instr(prev_txt||sql_text,' ',-1),
                           instr(prev_txt||sql_text,',',-1));
    if last_space > 0 then
      this_line := substr(prev_txt||sql_text,1,last_space);
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
      prev_txt := substr(prev_txt||sql_text,last_space+1);
    else
      prev_txt := prev_txt||sql_text;
    end if;
  end loop;    
  dbms_output.put_line(prev_txt); 
  
end;
/

