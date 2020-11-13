-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
SELECT LPAD(' ',sa.lvl*2)||u2.name granted_Role
    FROM   ( SELECT grantee#, privilege#, LEVEL lvl
           FROM sysauth$
           START WITH grantee# = ( SELECT USER# FROM USER$ WHERE name = '&user') 
	       CONNECT BY grantee# = PRIOR privilege#	) sa,USER$ u1, USER$ u2
    WHERE u1.USER#=sa.grantee#
      AND u2.USER#=sa.privilege# ;
