Use CM_E01

SELECT DISTINCT sys.Name0 AS 'Name'
	,sys.Full_Domain_Name0 AS 'Domain'
	,CASE 
		WHEN cs.Model0 = '20J9S0DL16' THEN 'ThinkPad L570'
		WHEN cs.Model0 = '20J9S0DL01' THEN 'ThinkPad L570'
		WHEN cs.Model0 = '20HJS0D21F' THEN 'ThinkPad P51'
		WHEN cs.Model0 = '20HJS0D201' THEN 'ThinkPad P51'
		WHEN cs.Model0 = '20HMS17T1Q' THEN 'ThinkPad X270'
		WHEN cs.Model0 = '20HMS17T01' THEN 'ThinkPad X270'
		WHEN cs.Model0 = '30BGS01B0U' THEN 'ThinkStation P320'
		WHEN cs.Model0 = '20JJS13601' THEN 'ThinkPad Yoga 370'
		ELSE cs.Model0 END AS 'Model'
	,os.Caption0 AS 'Operating System'
	,CASE WHEN sys.active0 = 1 THEN 'Active'
		ELSE 'Not Active' END AS 'Status'
	,sf.FileName
	,sf.FileVersion
	,sf.FilePath
	
FROM v_R_System AS sys
	JOIN v_GS_SoftwareFile AS sf ON sf.ResourceID = sys.ResourceID
	LEFT JOIN v_GS_COMPUTER_SYSTEM AS cs ON cs.ResourceID = sys.ResourceID
	LEFT JOIN v_GS_OPERATING_SYSTEM AS os ON os.ResourceID = sys.ResourceID

WHERE sf.FileName = 'PccNTMon.exe' and sf.FilePath = 'C:\Program Files (x86)\Trend Micro\OfficeScan Client\' --and sys.name0 in ('EVG02539NB','EVG01073NB','EVG01241NB','EVG02115NB','EVG02541NB','EVG02561NB','EVG02605NB','EVG02609NB','EVG02621NB','EVG02630NB','EVH03317WS','EVH03449WS','EVH03453WS','EVH03547WS','EVH03747NB','EVH03818NB','EVH03944NB','EVH04231NB','EVH04356NB','EVH04436NB','EVH04448NB','EVH04634NB','EVH04665NB','EVH04718NB','EVH04770WS','EVH04812WS','EVH04955WS','EVH04956NB','EVH04965NB','EVH05074NB','EVH05087NB','EVH05090NB','EVH05093NB','EVH05215NB','EVH05244NB','EVH05259NB','EVH05399WS','EVH05442NB','EVH05456NB','EVH05670WS','EVH05764NB','EVH05775NB','EVH05799NB','EVH05842NB','EVH05843NB','EVH05970NB','EVH06080NB','EVH06226NB','EVH06233WS','EVH06331NB','EVH06332WS','EVH06364NB','EVH06457WS','EVH06653NB','EVH06692WS','EVH06726NB','EVH06768NB','EVH06790NB','EVH06900NB','EVH07372WS','EVH07398NB','EVH07661WS','EVH07728NB','EVH07776NB','EVH07873NB','EVH07900NB','EVH07906NB','EVH07939NB','EVH07969WS','EVH08016WS','EVH08017WS','EVH08023WS','EVH08024WS','EVH08301WS','EVH08327NB','EVH08330NB','EVH08350NB','EVH08483NB','EVH08497WS','EVH08502WS','EVH08503WS','EVH08510WS','EVH08512NB','EVH08527NB','EVH08530WS','EVH08541WS','EVH08550NB','EVH08554NB','EVH08555NB','EVH08556NB','EVH08573NB','EVH08575NB','EVH08578NB','EVH08587WS','EVHPOOL102NB','EVHSCCMTEST01VM','EVHSCCMTEST02VM','EVR01071NB','EVR01294NB','EVT01022SNZ','EVT01031SNZ','EVT01036SNZ','EVT01037SNZ','EVT01039SNZ','EVT01040SNZ','EVT01041SNZ','EVT01042SNZ','EVT01044SNZ','EVT01045SNZ','EVT01046SNZ','EVT01047SNZ','EVT01062NB','EVT01085NB','EVT01104NB','EVT01123NB','EVT01234NB','EVT01431NB','EVT01502NB','EVT01699NB','EVT01717NB','EVT01719NB','EVT01720NB','EVT01721NB','EVT01722NB','EVT01723NB','EVT01724NB','EVT01725NB','EVT01727NB','EVT01728NB','EVT01731NB','EVT01732NB','EVT01733NB','EVT01734NB','EVT01735NB','EVT01737NB','EVT01738NB','EVT01739NB')

ORDER BY sys.Name0