USE CM_E01

DECLARE @ComputerName nvarchar(30)
DECLARE @ComputerID nvarchar(30)

--Itt add meg keresett gép nevét evh05463ws EVH04267WS
SET @ComputerName = 'ROCLUG1045NB'

--Név konvertálás ID-vá, mert a v_UpdateInfo nézet képtelen subquery-vel dolgozni...
SELECT @ComputerID = ResourceID FROM v_r_system where name0 = @ComputerName and active0 = 1

SELECT DISTINCT sys.Name0 AS 'Hostname'
	,sys.ResourceID
	,sys.Full_Domain_Name0 AS 'Domain'
	,os.Caption0 AS 'OS'
	,UI.ArticleID AS 'ArticleID'
	,UI.BulletinID AS 'BulletinID'
	,UI.Title AS 'Title'
	,sn.StateName
	,SN.StateDescription AS 'State'
	,UCSA.LastStatusChangeTime AS 'Install Date'
	,ucs.LastErrorCode
	,CASE WHEN CONCAT('KB',UI.ArticleID) in (select HotFixID0 from v_GS_QUICK_FIX_ENGINEERING where ResourceID = @ComputerID) THEN 'Installed'
	ELSE 'Not Installed' END AS 'WMI Compliance'
	,CASE WHEN CONCAT('KB',UI.ArticleID) in (select HotFixID0 from v_GS_QUICK_FIX_ENGINEERING where ResourceID = @ComputerID) THEN CAST((select InstalledOn0 from v_GS_QUICK_FIX_ENGINEERING where ResourceID = @ComputerID and HotFixID0 = CONCAT('KB',UI.ArticleID) ) AS VARCHAR(30) )
	ELSE 'N/A' END AS 'WMI Compliance Date'
	,CASE WHEN UI.IsDeployed = 1 THEN 'Yes'
		ELSE 'No' END AS 'Deployed'
	,cust.CollectionName
	,CASE WHEN fcm.CollectionID IS NULL and cust.CollectionName IS NULL THEN 'N/A' 
	WHEN fcm.CollectionID IS NULL and cust.CollectionName IS NOT NULL THEN 'Not a Member'
	ELSE 'Member' END AS 'Membership'

FROM v_Update_ComplianceStatusAll AS UCSA
	LEFT JOIN v_UpdateState_Combined AS UCS ON UCS.CI_ID = UCSA.CI_ID and UCS.ResourceID = UCSA.ResourceID and UCS.StateType = 500
	JOIN v_UpdateInfo AS UI ON UCSA.CI_ID = UI.CI_ID
	JOIN v_R_System AS sys ON sys.ResourceID = UCSA.ResourceID AND sys.Active0 = 1
	JOIN v_StateNames AS SN ON sn.StateID = UCSA.Status and  SN.TopicType = 500
	LEFT JOIN v_GS_OPERATING_SYSTEM as os ON os.ResourceID = sys.ResourceID
	LEFT JOIN (SELECT v_CIAssignment.AssignmentID
		,v_CIAssignment.AssignmentName
		,v_UpdateInfo.ArticleID
		,v_UpdateInfo.BulletinID
		,v_UpdateInfo.Title
		,v_CIAssignment.CollectionName
		,v_CIAssignment.CollectionID
		FROM v_UpdateInfo 
			INNER JOIN v_CIAssignmentToCI ON v_UpdateInfo.CI_ID = v_CIAssignmentToCI.CI_ID 
			INNER JOIN v_CIAssignment ON v_CIAssignmentToCI.AssignmentID = v_CIAssignment.AssignmentID) AS cust ON cust.Title = ui.Title
	LEFT JOIN v_FullCollectionMembership as fcm ON fcm.CollectionID = cust.CollectionID  and UCSA.ResourceID = fcm.ResourceID

WHERE sys.ResourceID = @ComputerID
	--sys.name0 in ('conman','evh01026ws','evh01162ws','evh01165sv','evh01332sv','evh01333sv','evh01336sv','evh01351sv','evh01499ws','evh01565vm','evh01661vm','evh01688vm','evh01785ws','evh01835ws','evh01945ws','evh01977sv','evh01978sv','evh01980sv','evh01981sv','evh01982sv','evh01984sv','evh01986sv','evh02066sv','evh02227vm','evh02228vm','evh02229vm','evh02322ws','evh02662ws','evh02796ws','evh02807ws','evh02876ws','evh03026ws','evh03222ws','evh03226ws','evh03233vm','evh03254sv','evh03325vm','evh03389vm','evh03454vm','evh03560ws','evh03580ws','evh03581ws','evh03621ws','evh03781ws','evh03794vm','evh03867vm','evh03951vm','evh04029ws','evh04089ws','evh04267ws','evh04396ws','evh04480ws','evh04625ws','evh04627sv','evh04628sv','evh04682ws','evh04751vm','evh04932ws','evh05463ws','evh05568vm','evh05673ws','evh05805vm','evh05824vm','evh05825vm','evh05963vm','evh06186ws','evhbu1022','evhentegros','evhrestore','evo01571','evo01572','hubudadmaster','hubudadmintool','hubuddfsmed1','hubuddrudpsrv','hubudfilen05','hubudhorizon01','hubudibmralic1','hubudisb2jump','hubudmdl01','hubudo4tfsproxy','hubudofscxgsrv','hubudprintmgmt','hubudqasrv','hubudrestore2','hubudrestore3','hubudsccm2msrv','hubudsccmdpsrv','hubudsmmgt2','hubudsqltest3','hubudssdrpssrv','hubudsspsrv','hubudtdosql','hubududpsrv','hubudweb004','hubudweb004_t','hubudxpbuild','huevhax09erp2','huevhbodrog','huevhbudcc02','huevhbuddns','huevhbudhubcas4','huevhbudhubcas5','huevhbudmbxdag1','huevhbudmbxdag2','huevhbudscnsrv2','huevhbudtstfil2','huevhcserta','huevhfilec2','huevhfilec3','huevhfilec4','huevhhorka','huevhkmraktar','huevhmed219srv','huevhmesszelato','huevhmscalm','huevhmsccas01','huevhmscitsrv02','huevhmscmbx01','huevhmscmbx02','huevhmsctstfil2','huevhnexonerp','huevhocs01','huevhpreintvm2','huevhpreintvm3','huevhpreintvm4','huevhpreintvm5','huevhpreintvm6','huevhqdsp','huevhqdsp2','huevhqsp2','huevhqspwfm','huevhqtfs','huevhquest8','huevhscomgt1','huevhscommsn01','huevhscvmmmgt1','huevhsharepapp1','huevhsharepdbs','huevhsmdwh1','huevhsmmgtdev1','huevhspowa','huevhspwfm','huevhsql1','huevhsql2','huevhsqltest1','huevhsqltest2','huevhsugovica','huevhszefilec1','huevhszetstfile','huevhtfs2015','huevhunicorn','huevhwusrv','humsco4repodfs','humsco4tfsproxy','humscprintsrv','humscsccmdpsrv','humscudpsrv','huszeprintsrv','huszesccmdpsrv','huszeudpsrv','isb2jenkins01','isb2jenkins02','isb2jenkins03','isb2jenkins04','isb2jenkins05','isb2jenkins06','isb2jenkinsmom2')
	
	and sn.StateDescription not in ('Update is not required','Detection state unknown','Update is installed')
	--and ui.Title like '%KB4038779%'
	and ui.IsUserDefined = 0
	--and ui.IsSuperseded = 0
	--and ui.Title in (select title from v_UpdateInfo where IsDeployed = 1 )

SELECT sys.name0 AS 'Name'
	,SUM(CASE WHEN sn.StateName = 'Detection state unknown' THEN 1 ELSE 0 END) AS 'Detection state unknown'
	,SUM(CASE WHEN sn.StateName = 'Update is not required' THEN 1 ELSE 0 END) AS 'Update is not required'
	,SUM(CASE WHEN sn.StateName = 'Update is required' THEN 1 ELSE 0 END) AS 'Update is required'
	,SUM(CASE WHEN sn.StateName = 'Update is installed' THEN 1 ELSE 0 END) AS 'Update is installed'
	,SUM(CASE WHEN sn.StateName = 'Update is required' and ui.IsDeployed = 1 THEN 1 ELSE 0 END) AS 'Update is required (Deployed)'
	,COUNT(*) AS 'Total'

FROM v_R_System AS sys
	JOIN v_Update_ComplianceStatusAll AS UCS ON sys.ResourceID = UCS.ResourceID
	join v_UpdateInfo ui on UCS.CI_ID = ui.CI_ID and ui.IsUserDefined = 0
	JOIN v_StateNames AS SN ON SN.TopicType = 500 and sn.StateID = UCS.Status

WHERE sys.name0 = @ComputerName
	--sys.name0 in ('evh04657ws','evh03556ws','evh03200ws','evr01057nb')

	AND sys.Active0 = 1
	--and ui.IsSuperseded = 0
	--and ui.Title in (select title from v_UpdateInfo where IsDeployed = 1 )

GROUP BY sys.name0