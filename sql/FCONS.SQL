-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
set verify off
select 	constraint_name,table_name,r_owner,r_constraint_name
from 	user_constraints
where 	r_constraint_name = upper('&primary_key_name_req');
