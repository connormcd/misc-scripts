CREATE OR REPLACE PACKAGE apex_utils.apex_utils_jobs
IS

/******************************************************************************
 * APEX Utility Jobs
 *
 * Utility jobs for the APEX environment 
 *
 * $Activity:$
 * $Source:$
 ******************************************************************************/

g_log_level      NUMBER := 3;  -- default logging level
c_bkup_job_errno CONSTANT BINARY_INTEGER := -20000;

PROCEDURE backup_apps (p_action         VARCHAR2 DEFAULT 'DEFAULT');

END apex_utils_jobs;
/
