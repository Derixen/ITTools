USE CM_E01

select 
	C.Name,
	FCM.Name
from 
	dbo.v_Collection AS C
	join dbo.v_FullCollectionMembership AS FCM on C.CollectionID = FCM.CollectionID

WHERE
	c.name = '[eIS][Software][A] SafeGuard LAN Crypt Client 3.95.1.13'