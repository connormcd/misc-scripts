create or replace 
function Black(p_str varchar2) return varchar2 is 
begin return  chr(27)||'[30m'||p_str||chr(27)||'[0m'; 
end;
/
create or replace 
function Red(p_str varchar2) return varchar2 is 
begin return  chr(27)||'[31m'||p_str||chr(27)||'[0m'; 
end;
/
create or replace 
function Green(p_str varchar2) return varchar2 is 
begin return  chr(27)||'[32m'||p_str||chr(27)||'[0m'; 
end;
/
create or replace 
function Yellow(p_str varchar2) return varchar2 is 
begin return  chr(27)||'[33m'||p_str||chr(27)||'[0m'; 
end;
/
create or replace 
function Blue(p_str varchar2) return varchar2 is 
begin return  chr(27)||'[34m'||p_str||chr(27)||'[0m'; 
end;
/
create or replace 
function Magenta(p_str varchar2) return varchar2 is 
begin return  chr(27)||'[35m'||p_str||chr(27)||'[0m'; 
end;
/
create or replace 
function Cyan(p_str varchar2) return varchar2 is 
begin return  chr(27)||'[36m'||p_str||chr(27)||'[0m'; 
end;
/
create or replace 
function White(p_str varchar2) return varchar2 is 
begin return  chr(27)||'[37m'||p_str||chr(27)||'[0m'; 
end;
/


create or replace 
function Bright_Red(p_str varchar2) return varchar2 is 
begin return  chr(27)||'[31;1m'||p_str||chr(27)||'[0m'; 
end;
/
create or replace 
function Bright_Green(p_str varchar2) return varchar2 is 
begin return  chr(27)||'[32;1m'||p_str||chr(27)||'[0m'; 
end;
/
create or replace 
function Bright_Yellow(p_str varchar2) return varchar2 is 
begin return  chr(27)||'[33;1m'||p_str||chr(27)||'[0m'; 
end;
/
create or replace 
function Bright_Blue(p_str varchar2) return varchar2 is 
begin return  chr(27)||'[34;1m'||p_str||chr(27)||'[0m'; 
end;
/
create or replace 
function Bright_Magenta(p_str varchar2) return varchar2 is 
begin return  chr(27)||'[35;1m'||p_str||chr(27)||'[0m'; 
end;
/
create or replace 
function Bright_Cyan(p_str varchar2) return varchar2 is 
begin return  chr(27)||'[36;1m'||p_str||chr(27)||'[0m'; 
end;
/
create or replace 
function Bright_White(p_str varchar2) return varchar2 is 
begin return  chr(27)||'[37;1m'||p_str||chr(27)||'[0m'; 
end;
/

