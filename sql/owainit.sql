-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
declare
nm owa.vc_arr;
vl owa.vc_arr;
begin
nm(1) := 'REMOTE_ADDR';
vl(1) := '1.2.3.4';
owa.init_cgi_env( nm.count, nm, vl );
end;
/ 
