USE CM_E01

SELECT sysValid.Netbios_Name0 AS 'Computer_Name'
	,sysValid.Resource_Domain_OR_Workgr0 AS 'Domain'
	,convert(varchar ,sysAgent.last_Logon_Timestamp0,104) AS 'last_Logon_Timestamp'
	,convert(varchar, cliSumm.LastSW, 104) AS 'Last SW Inventory'
	,convert(varchar, wsStatus.LastHWScan, 104) AS 'Last HW Inventory'
	,convert(varchar, agentDisc.AgentTime, 104) AS 'Last_AD_Discovery'
	,convert(varchar, cliSumm.LastPolicyRequest, 104) AS 'Last Policy Request'
	,convert(varchar, cliSumm.LastStatusMessage, 104) AS 'Last Status Message'
	,sysValid.User_Domain0 + '\' + sysValid.User_Name0 AS 'Last Logged on User'
	,sysagent.siemensResponsible0 AS 'SiemensResponsible'

FROM v_R_System_Valid AS sysValid
	LEFT OUTER JOIN v_GS_WORKSTATION_STATUS AS wsStatus ON sysValid.ResourceID = wsStatus.ResourceID
	LEFT OUTER JOIN v_AgentDiscoveries AS agentDisc ON sysValid.ResourceID = agentDisc.ResourceId 
	LEFT OUTER JOIN v_CH_ClientSummary AS cliSumm ON sysValid.ResourceID = cliSumm.ResourceID 
	LEFT OUTER JOIN v_R_System AS sysAgent ON sysValid.ResourceID = sysAgent.ResourceID

WHERE agentDisc.AgentName = 'SMS_AD_SYSTEM_DISCOVERY_AGENT'

ORDER BY sysValid.Netbios_Name0
