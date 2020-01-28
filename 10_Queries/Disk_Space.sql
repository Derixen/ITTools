USE CM_E01

SELECT distinct SYS.Name0 AS 'Host'
	,LDISK.Description0 AS 'Description'
	,LDISK.DeviceID0 AS 'Drive'
	,LDISK.VolumeName0 AS 'Disk Name'
	,LDISK.FileSystem0 AS 'FS'
	,LDISK.Size0/1024 AS 'Size (GB)'
	,LDISK.FreeSpace0/1024 AS 'Free Space (GB)'

FROM
	v_R_System AS SYS
	join v_GS_LOGICAL_DISK AS LDISK ON SYS.ResourceID = LDISK.ResourceID

WHERE LDISK.Size0 is not NULL

ORDER BY 'Host'