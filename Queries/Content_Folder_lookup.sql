USE CM_E01

DECLARE @ContentID nvarchar(30)
SET @ContentID = 'Content_9ca2b2c3-2a6b-4504-a632-976e4ee2afd5'

SELECT LP.DisplayName,
	CP.CI_ID,
	CPS.PkgID,
	CPS.ContentSubFolder

FROM dbo.CI_ContentPackages AS CPS
	INNER JOIN dbo.CIContentPackage CP ON CPS.PkgID = CP.PkgID
	LEFT OUTER JOIN dbo.CI_LocalizedProperties AS LP ON CP.CI_ID = LP.CI_ID

WHERE CPS.ContentSubFolder like '%' + @ContentID + '%'

ORDER BY LP.LocaleID DESC

select * from v_Package where packageid = 'E0100357'