USE CM_E01

SELECT dbo.v_RA_System_MACAddresses.MAC_Addresses0
	,Count(dbo.v_R_System.Name0) AS SystemCount

FROM dbo.v_R_System 
	RIGHT OUTER JOIN dbo.v_RA_System_MACAddresses ON dbo.v_R_System.ResourceID = dbo.v_RA_System_MACAddresses.ResourceID

GROUP BY dbo.v_RA_System_MACAddresses.MAC_Addresses0 ORDER BY SystemCount DESC

select * from LastPXEAdvertisement ORDER BY LastPXEAdvertisementTime DESC

select * from Netcard_DATA where MACAddress00 = '9C:EB:E8:7F:A2:B7'