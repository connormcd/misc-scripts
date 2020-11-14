SELECT * FROM dba_tab_privs
WHERE table_name = '&object_name'
AND grantee IN (
  SELECT DISTINCT u2.name granted_Role
    FROM   ( SELECT grantee#, privilege#, LEVEL lvl
           FROM sysauth$
           START WITH grantee# = ( SELECT USER# FROM USER$ WHERE name = NVL('&user',USER)) 
	       CONNECT BY grantee# = PRIOR privilege#	) sa,USER$ u1, USER$ u2
    WHERE u1.USER#=sa.grantee#
      AND u2.USER#=sa.privilege#
  UNION ALL
  SELECT USER FROM dual
)   	;
