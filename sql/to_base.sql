Here is a set of routines that do all the common base conversions.  Syntax is
similar to using to_number, to_date, etc.  So, now you can select to_hex,
to_bin, to_oct, to_dec of various numbers (or just call from pl/sql)


create or replace function to_base( p_dec in number, p_base in number ) 
return varchar2
is
	l_str	varchar2(255) default NULL;
	l_num	number	default p_dec;
	l_hex	varchar2(16) default '0123456789ABCDEF';
begin
	if ( trunc(p_dec) <> p_dec OR p_dec < 0 ) then
		raise PROGRAM_ERROR;
	end if;
	loop
		l_str := substr( l_hex, mod(l_num,p_base)+1, 1 ) || l_str;
		l_num := trunc( l_num/p_base );
		exit when ( l_num = 0 );
	end loop;
	return l_str;
end to_base;
/


create or replace function to_dec
( p_str in varchar2, 
  p_from_base in number default 16 ) return number
is
	l_num   number default 0;
	l_hex   varchar2(16) default '0123456789ABCDEF';
begin
	for i in 1 .. length(p_str) loop
		l_num := l_num * p_from_base + instr(l_hex,upper(substr(p_str,i,1)))-1;
	end loop;
	return l_num;
end to_dec;
/
show errors

create or replace function to_hex( p_dec in number ) return varchar2
is
begin
	return to_base( p_dec, 16 );
end to_hex;
/
create or replace function to_bin( p_dec in number ) return varchar2
is
begin
	return to_base( p_dec, 2 );
end to_bin;
/
create or replace function to_oct( p_dec in number ) return varchar2
is
begin
	return to_base( p_dec, 8 );
end to_oct;
/


