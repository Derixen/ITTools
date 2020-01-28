USE CM_E01

DECLARE @ContentID nvarchar(30)
SET @ContentID = 'Content_XXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX'

SELECT LP.DisplayName,
	CP.CI_ID,
	CPS.PkgID,
	CPS.ContentSubFolder

FROM dbo.CI_ContentPackages AS CPS
	INNER JOIN dbo.CIContentPackage CP ON CPS.PkgID = CP.PkgID
	LEFT OUTER JOIN dbo.CI_LocalizedProperties AS LP ON CP.CI_ID = LP.CI_ID

WHERE CPS.ContentSubFolder like '%' + @ContentID + '%'

ORDER BY LP.LocaleID DESC