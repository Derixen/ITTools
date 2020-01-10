USE CM_E01

select CASE WHEN CHARINDEX(',OU=',managedBy0) > 0 THEN SUBSTRING(managedBy0,4,CHARINDEX(',OU=',managedBy0)-4) ELSE 'error' END AS 'ffdsaf' from v_r_system


select CASE WHEN CHARINDEX(',OU=',Distinguished_Name0) > 0 THEN SUBSTRING(Distinguished_Name0,4,CHARINDEX(',OU=',Distinguished_Name0)-4) ELSE 'N/A' END AS 'je' from v_r_User