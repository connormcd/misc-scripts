REM
REM
REM Simple package to convert IP addresses from string to numbers and back
REM
REM 
REM Sample output
REM 
REM select ip_util.ip_num_from_str('192.168.1.2') from dual;
REM 
REM IL.IP_NUM_FROM_STR('192.168.1.2')
REM ---------------------------------
REM                        3232235778
REM 
REM select ip_util.ip_str_from_num(3232235778) from dual;
REM 
REM IL.IP_STR_FROM_NUM(3232235778)
REM ------------------------------------------------------------------------------------------------------------
REM 68.1.2
REM 
REM select ip_util.ip_num_from_str('2001:db8:0:0:0:ff00:42:8329') ip from dual;
REM 
REM                                      IP
REM ---------------------------------------
REM  42540766411282592856904265327123268393
REM 
REM select ip_util.ip_str_from_num(42540766411282592856904265327123268393) from dual;
REM 
REM IL.IP_STR_FROM_NUM(42540766411282592856904265327123268393)
REM ------------------------------------------------------------------------------------------------------------
REM db8:0:0:0:ff00:42:8329
REM 


create or replace
package ip_util is
   
function ip_num_from_str(p_ip_str varchar2) return number deterministic;
function ip_str_from_num(p_ipnum number) return varchar2 deterministic;
   
end;
/

create or replace
package body ip_util is
   
  --
  -- constants need to be fixed, not expressions if you want to avoid ora-4068
  --
  l_ip41 constant number(12)  := 256;        -- power(256,1);
  l_ip42 constant number(12)  := 65536;      -- power(256,2);
  l_ip43 constant number(12)  := 16777216;   -- power(256,3);
  l_ip44 constant number(12)  := 4294967296; -- power(256,4);
    
  l_ip61 constant number(38)  := 65536;                              --power(65536,1);
  l_ip62 constant number(38)  := 4294967296;                         --power(65536,2);
  l_ip63 constant number(38)  := 281474976710656;                    --power(65536,3);
  l_ip64 constant number(38)  := 18446744073709551616;               --power(65536,4);
  l_ip65 constant number(38)  := 1208925819614629174706176;          --power(65536,5);
  l_ip66 constant number(38)  := 79228162514264337593543950336;      --power(65536,6);
  l_ip67 constant number(38)  := 5192296858534827628530496329220096; --power(65536,7);
   
   
function ip_num_from_str(p_ip_str varchar2) return number deterministic is
  l_ip_num     number;
  l_dot1       pls_integer;
  l_dot2       pls_integer;
  l_dot3       pls_integer;
  l_dot4       pls_integer;
    
  l_colon      pls_integer;
  l_colon_cnt  pls_integer;
  l_hex        varchar2(32);
  l_ip_str     varchar2(64);
begin
  if p_ip_str like '%.%' then
    l_dot1   := instr(p_ip_str,'.');
    l_dot2   := instr(p_ip_str,'.',l_dot1+1);
    l_dot3   := instr(p_ip_str,'.',l_dot2+1);
    l_dot4   := instr(p_ip_str,'.',l_dot3+1);
    if l_dot4 > 0 then
       raise_application_error(-20000,'Cannot be resolved to an IP4 address');
    end if;
   
    l_ip_num :=  l_ip43*to_number(substr(p_ip_str,1,l_dot1-1)) +
                 l_ip42*to_number(substr(p_ip_str,l_dot1+1,l_dot2-l_dot1-1)) +
                 l_ip41*to_number(substr(p_ip_str,l_dot2+1,l_dot3-l_dot2-1)) +
                 to_number(substr(p_ip_str,l_dot3+1));
   
  elsif p_ip_str like '%:%' then
    --
    -- Note: The abbreviation of "Consecutive sections of zeroes are replaced with a double colon (::)" is not implemented.
    --
    l_colon_cnt := length(p_ip_str)-length(replace(p_ip_str,':'));
    if l_colon_cnt != 7 then
       raise_application_error(-20000,'Cannot be resolved to an IP6 address');
    end if;
   
    l_ip_str := p_ip_str||':';
    loop
      l_colon := instr(l_ip_str,':');
      l_hex := l_hex || lpad(substr(l_ip_str,1,l_colon-1),4,'0');
      l_ip_str := substr(l_ip_str,l_colon+1);
      exit when l_ip_str is null;
    end loop;
    l_ip_num := to_number(l_hex,'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
  end if;
   
  return l_ip_num;
end;
   
   
function ip_str_from_num(p_ipnum number) return varchar2 deterministic is
begin
  if p_ipnum < l_ip44 then
    return  mod(trunc(p_ipnum/l_ip43),l_ip41) ||'.'||
            mod(trunc(p_ipnum/l_ip42),l_ip41) ||'.'||
            mod(trunc(p_ipnum/l_ip41),l_ip41) ||'.'||
            mod(p_ipnum,l_ip41);
  else
    --
    -- Note: The abbreviation of "Consecutive sections of zeroes are replaced with a double colon (::)" is not implemented.
    --
    return  to_char(mod(trunc(p_ipnum/l_ip67),l_ip61),'fmxxxx') ||':'||
            to_char(mod(trunc(p_ipnum/l_ip66),l_ip61),'fmxxxx') ||':'||
            to_char(mod(trunc(p_ipnum/l_ip65),l_ip61),'fmxxxx') ||':'||
            to_char(mod(trunc(p_ipnum/l_ip64),l_ip61),'fmxxxx') ||':'||
            to_char(mod(trunc(p_ipnum/l_ip63),l_ip61),'fmxxxx') ||':'||
            to_char(mod(trunc(p_ipnum/l_ip62),l_ip61),'fmxxxx') ||':'||
            to_char(mod(trunc(p_ipnum/l_ip61),l_ip61),'fmxxxx') ||':'||
            to_char(mod(p_ipnum,l_ip61),'fmxxxx');
  end if;
end;
   
end;
/

