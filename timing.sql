REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is possible you'll need to edit the script for correct usernames/passwords, missing information etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

create or replace
package timing is
  procedure tstart(p_name varchar2 default '$DEFAULT$');
  procedure tstop(p_name varchar2 default '$DEFAULT$');
  procedure tshow(p_name varchar2 default '$DEFAULT$');  
  procedure tstopall;
end;
/

create or replace
package body timing is

  type timer_list is table of timestamp
    index by varchar2(128);
  l_timers timer_list;

procedure die(p_msg varchar2) is
begin
  raise_application_error(-20000,p_msg);
end;

function delta(p_name varchar2) return varchar2 is
  l_elapsed interval day to second;
begin
  l_elapsed := localtimestamp - l_timers(p_name);
  return 
    case 
      when p_name != '$DEFAULT$' then p_name||': '||substr(to_char(l_elapsed),5)
      else substr(to_char(l_elapsed),5)
    end;
end;

procedure tstart(p_name varchar2 default '$DEFAULT$') is
begin
  l_timers(p_name) := localtimestamp;
end;

procedure tstop(p_name varchar2 default '$DEFAULT$') is
begin
  if l_timers.exists(p_name) then
    dbms_output.put_line(delta(p_name));
    l_timers.delete(p_name);
  else
    die('Timer '||p_name||' does not exist');
  end if;
end;

procedure tshow(p_name varchar2 default '$DEFAULT$') is
begin
  if l_timers.exists(p_name) then
    dbms_output.put_line(delta(p_name));
  end if;
end;

procedure tstopall is
  l_idx varchar2(128);
begin
  l_idx := l_timers.first;
  while l_idx is not null 
  loop
    tstop(l_idx);
    l_idx := l_timers.next(l_idx);
  end loop;
end;

end;
/
sho err

set serverout on
exec timing.tstart
host sleep 1
exec timing.tshow
host sleep 1
exec timing.tstop

exec timing.tstart('overall')
host sleep 1
exec timing.tstart('inner')
host sleep 1
exec timing.tstop('inner')
host sleep 1
exec timing.tstop('overall')

exec timing.tstart('t1')
exec timing.tstart('t2')
exec timing.tstart('t3')
host sleep 1
exec timing.tstopall;

