USE CM_E01

SELECT sys.Name0
	,sys.Full_Domain_Name0
	,nic.IPAddress0
	,dep.SoftwareName
	,case when app.AppEnforcementState = 1000 then 'Success'
		when app.AppEnforcementState = 1001 then 'Already Compliant'
		when app.AppEnforcementState = 1002 then 'Simulate Success'
		when app.AppEnforcementState = 2000 then 'In Progress'
		when app.AppEnforcementState = 2001 then 'Waiting for Content'
		when app.AppEnforcementState = 2002 then 'Installing'
		when app.AppEnforcementState = 2003 then 'Restart to Continue'
		when app.AppEnforcementState = 2004 then 'Waiting for maintenance window'
		when app.AppEnforcementState = 2005 then 'Waiting for schedule'
		when app.AppEnforcementState = 2006 then 'Downloading dependent content'
		when app.AppEnforcementState = 2007 then 'Installing dependent content'
		when app.AppEnforcementState = 2008 then 'Restart to complete'
		when app.AppEnforcementState = 2009 then 'Content downloaded'
		when app.AppEnforcementState = 2010 then 'Waiting for update'
		when app.AppEnforcementState = 2011 then 'Waiting for user session reconnect'
		when app.AppEnforcementState = 2012 then 'Waiting for user logoff'
		when app.AppEnforcementState = 2013 then 'Waiting for user logon'
		when app.AppEnforcementState = 2014 then 'Waiting to install'
		when app.AppEnforcementState = 2015 then 'Waiting retry'
		when app.AppEnforcementState = 2016 then 'Waiting for presentation mode'
		when app.AppEnforcementState = 2017 then 'Waiting for Orchestration'
		when app.AppEnforcementState = 2018 then 'Waiting for network'
		when app.AppEnforcementState = 2019 then 'Pending App-V Virtual Environment'
		when app.AppEnforcementState = 2020 then 'Updating App-V Virtual Environment'
		when app.AppEnforcementState = 3000 then 'Requirements not met'
		when app.AppEnforcementState = 3001 then 'Host platform not applicable'
		when app.AppEnforcementState = 4000 then 'Unknown'
		when app.AppEnforcementState = 5000 then 'Deployment failed'
		when app.AppEnforcementState = 5001 then 'Evaluation failed'
		when app.AppEnforcementState = 5002 then 'Deployment failed'
		when app.AppEnforcementState = 5003 then 'Failed to locate content'
		when app.AppEnforcementState = 5004 then 'Dependency installation failed'
		when app.AppEnforcementState = 5005 then 'Failed to download dependent content'
		when app.AppEnforcementState = 5006 then 'Conflicts with another application deployment'
		when app.AppEnforcementState = 5007 then 'Waiting retry'
		when app.AppEnforcementState = 5008 then 'Failed to uninstall superseded deployment type'
		when app.AppEnforcementState = 5009 then 'Failed to download superseded deployment type'
		when app.AppEnforcementState = 5010 then 'Failed to updating App-V Virtual Environment'
		ELSE 'Not Installed'
	End as 'State Message'
	,CASE
        WHEN dep.DeploymentIntent = 1 THEN 'Required'
        WHEN dep.DeploymentIntent = 2 THEN 'Optional'
    ELSE 'Unknown' END AS 'Deployment Intent'
	,dep.DeploymentTime
	,dep.EnforcementDeadline

FROM v_R_System AS sys
	JOIN v_RA_System_SystemGroupName AS sgn ON sgn.ResourceID = sys.ResourceID
	LEFT JOIN v_GS_NETWORK_ADAPTER_CONFIGURATION AS nic ON nic.ResourceID = sys.ResourceID
	JOIN vAppDTDeploymentResultsPerClient AS app ON app.ResourceID = sys.ResourceID
	JOIN v_DeploymentSummary AS dep ON dep.AssignmentID = app.AssignmentID
	
WHERE sgn.System_Group_Name0 like '%SCCM_04_Preint_Computers%'
	and nic.IPAddress0 IS NOT NULL
	--and app.AppEnforcementState not in ('1000','1001')

ORDER BY sys.Name0