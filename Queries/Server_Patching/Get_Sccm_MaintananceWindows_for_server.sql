SELECT distinct sys.name0 AS 'Name'
	,sys.Resource_Domain_OR_Workgr0 AS Domain
	,os.Caption0 AS 'OS'
	,cs.Manufacturer0 AS 'Manufacturer'
	,cs.Model0 AS 'Model'
	,SUBSTRING(left(sys.managedBy0, charindex(',', sys.managedBy0)-1),4,len(sys.managedBy0)) as 'ManagedBy'
	--,ip.IP_Addresses0 AS IPv4
--	,sys.Distinguished_Name0 As DN_name
	,mw.Description
	,mw.Duration/60 as 'Duration (hour)'
	---kiírja a következõ patch szombat vagy vasárnap dátumát
	---ha a futtatás dátuma nagyobb mint az hónap utolsó szombatja vagy vasárnapja akkor a következõ hónap elsõ utolsó szombatja vagy vasárnapja lesz az eredmény
	,CASE WHEN mw.Description like '%Saturday%' 
			THEN (case when ( Convert (date, DATEADD(dy, DATEDIFF(dy, getdate(), DATEADD(mm, DATEDIFF(mm, 0, getdate()), 30)) / 7 * 7+1, getdate()))) > GETDATE () 
then (Convert (date, DATEADD(dy, DATEDIFF(dy, getdate(), DATEADD(mm, DATEDIFF(mm, 0, getdate()), 30)) / 7 * 7+1, getdate()))) 
else (Convert (date, DATEADD(dd,(7 - (DATEPART(dw,DATEADD(month,DATEDIFF(mm,0,getdate())+1,0)) + @@DATEFIRST) % 7) % 7,DATEADD(month,DATEDIFF(mm,0,getdate())+1,0)))) end)
			ELSE (case when ( Convert (date, DATEADD(dd,-(DATEPART( WEEKday , DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,convert(datetime,GETDATE(),112))+1,0)))-1),DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,convert(datetime,GETDATE(),112))+1,0))))) > GETDATE () 
then ( Convert (date, DATEADD(dd,-(DATEPART( WEEKday , DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,convert(datetime,GETDATE(),112))+1,0)))-1),DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,convert(datetime,GETDATE(),112))+1,0))))) 
else (Convert (date, DATEADD(dd,(7 - (DATEPART(dw,DATEADD(month,DATEDIFF(mm,0,getdate())+1,0)) + @@DATEFIRST) % 7) % 7,DATEADD(month,DATEDIFF(mm,0,getdate())+1,1)))) end) 
			END as 'Next Maintanence window date'




FROM v_R_System AS sys
	LEFT JOIN v_GS_COMPUTER_SYSTEM AS cs ON cs.ResourceID = sys.resourceID
	LEFT JOIN v_GS_OPERATING_SYSTEM AS os ON os.ResourceID = sys.ResourceID
	JOIN v_FullCollectionMembership AS fcm on fcm.ResourceID = sys.ResourceID
	join v_RA_System_IPAddresses AS Ip on ip.ResourceID = sys.ResourceID
	left join v_ServiceWindow as MW on mw.CollectionID = fcm.CollectionID


WHERE sys.Active0 = 1
	and (fcm.CollectionID = 'E01003DE' or fcm.CollectionID = 'E01003DF' or fcm.CollectionID = 'E01006D7')
    and sys.Name0 like 'DENBGMAEPC06SRV'
	-----CAS0023A HU, CAS00234   DE----- -CAS000A8 test servers