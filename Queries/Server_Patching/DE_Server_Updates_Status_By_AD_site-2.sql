SELECT

          rs.Netbios_name0 AS 'PC Name',
          SUM(CASE WHEN UCS.status=2 and ctm.ResourceID IS NOT NULL THEN 1 ELSE 0 END) AS TTargeted,
          SUM(CASE WHEN UCS.status=3 THEN 1 ELSE 0 END) AS TInstalled,
	  SUM(CASE WHEN UCS.status=2 THEN 1 ELSE 0 END) AS TRequired,
	  SUM(CASE WHEN ((UCS.status=2) or (UCS.status=3)) THEN 1 ELSE 0 END) AS TTotal,
	  (STR((SUM(CASE WHEN UCS.status=3 THEN 1 ELSE 0 END) *100.0/SUM(CASE WHEN ((UCS.status=2) or (UCS.status=3)) THEN 1 ELSE 0 END) ),5)) + '%' AS 'Percent',
          SUM(CASE WHEN UCS.status=2 THEN 1 ELSE 0 END) AS 'Missing Updates',
          CASE
               	WHEN (SUM(CASE WHEN UCS.status=2 THEN 1 ELSE 0 END))>0 THEN 'Not Compliance'
	        ELSE 'Good Client'
          END AS 'Updates Status',
          SUM(CASE WHEN UCS.status=2 and ctm.ResourceID IS NOT NULL THEN 1 ELSE 0 END) AS 'Approved Updates',
          SUM(CASE WHEN ((UCS.status=2) OR (UCS.status=3))  THEN 1 ELSE 0 END) AS 'Total',
          CASE	
		WHEN gcs.UserName0 IS NULL THEN 'N/A'
	 	ELSE gcs.UserName0
	  END AS 'Last Logged On User',
	  CASE 
		WHEN os.CSDVersion0 IS NULL THEN os.caption0
		WHEN os.caption0 IS NULL THEN 'N/A'
		ELSE os.caption0 + ' ' + os.CSDVersion0
	  END AS OS,
	  rs.Client_Version0 AS 'Client Version',
          ws.lasthwscan AS 'Last Hardware Scan',
          uss.LastScanPackageLocation AS 'Last Scan Location',
          uss.LastScanPackageVersion AS 'Last Scan Pakage',
          st.StateName AS 'Status', 
          DATEDIFF(D, OS.LastBootUpTime0, GETDATE()) 'Last Boot (Days)'

FROM
	v_ClientCollectionMembers ccm
	LEFT JOIN v_R_System rs on rs.ResourceID = ccm.ResourceID
	LEFT JOIN v_UpdateComplianceStatus  UCS on UCS.ResourceID = ccm.ResourceID
	LEFT OUTER JOIN v_CITargetedMachines ctm on ctm.CI_ID=UCS.CI_ID and ctm.ResourceID = rs.ResourceID
	INNER JOIN v_GS_COMPUTER_SYSTEM GCS on GCS.ResourceID = rs.ResourceID 
	JOIN v_UpdateInfo ui on ui.CI_ID=UCS.CI_ID
	JOIN v_CICategories_All catall2 on catall2.CI_ID=ui.CI_ID
	JOIN v_CategoryInfo catinfo2 on catall2.CategoryInstance_UniqueID = catinfo2.CategoryInstance_UniqueID and catinfo2.CategoryTypeName='UpdateClassification'
	INNER JOIN v_gs_workstation_status ws on ws.resourceid=rs.resourceid
	INNER JOIN v_UpdateScanStatus uss on ws.resourceid = uss.ResourceID
	LEFT JOIN v_StateNames st on st.TopicType = 501 and st.StateID = (CASE WHEN (ISNULL(uss.LastScanState, 0)=0 and Left(ISNULL(rs.Client_Version0, '4.0'),
	1)<'4') THEN 7 ELSE ISNULL(uss.LastScanState, 0) END) 
	JOIN v_Gs_Operating_System OS on ws.resourceid = OS.ResourceID
		
WHERE rs.Active0 = 1
	and ccm.CollectionID = 'CAS00234' and (catinfo2.CategoryInstanceName like 'Critical Updates' or catinfo2.CategoryInstanceName like 'Security Updates') and ui.IsDeployed = 1
	-- CAS0023B = [TDS] All Server in DE patch management
	-- CAS0023A = [TDS] All HU Windows Server

GROUP BY
	rs.Netbios_name0,
	gcs.UserName0,
	rs.Client_Version0,
	ws.lasthwscan,
	uss.LastScanPackageLocation,
	uss.LastScanPackageVersion ,
	st.StateName, 
	OS.LastBootUpTime0,
	os.caption0,
	os.CSDVersion0