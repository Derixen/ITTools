SELECT Distinct sys.Name0 AS 'Name'
	--,prc.Name0 as Processor
	--,prc.NumberOfCores0 as CpuCores
	,os.Caption0 AS 'OS'
	,diskvol.Caption0 As DriveLetter
	,DiskVol.Size0 As DriveSize
	,Diskvol.FreeSpace0 as DriveFreespace
	,usr.Full_User_Name0 as ManagedBy

	
FROM v_R_System AS sys
	 left JOIN v_GS_COMPUTER_SYSTEM as cs ON cs.ResourceID = sys.resourceID
	 left JOIN v_GS_DISK As Disk On disk.ResourceID = sys.resourceID
	 left join v_GS_LOGICAL_DISK as DiskVol On DiskVol.ResourceID = sys.resourceID
	 LEFT JOIN v_r_user AS usr on usr.Distinguished_Name0 = sys.managedBy0
	 LEFT JOIN v_GS_OPERATING_SYSTEM AS os ON os.ResourceID = sys.ResourceID
	 JOIN v_FullCollectionMembership AS fcm on fcm.ResourceID = sys.ResourceID


WHERE   fcm.CollectionID = 'E01006DD' --CAS0023A CAS00234         --sys.name0 like  'PATCHTEST2016'
		and diskvol.Caption0 not like 'null'
		and disk.Size0 not like 'null'
		and diskvol.Caption0 like 'C:'
		and Diskvol.FreeSpace0 < 11240


ORDER BY 'os'