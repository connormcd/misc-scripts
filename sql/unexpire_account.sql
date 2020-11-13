-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
SELECT 'ALTER USER '|| name ||' IDENTIFIED BY VALUES '''|| spare4 ||';'|| password ||''';' FROM sys.user$ WHERE name like 'AP%';


SELECT 'ALTER USER '|| name ||' IDENTIFIED BY VALUES '''|| spare4 ||';'|| password ||''';' FROM sys.user$ WHERE name like 'OR%';
