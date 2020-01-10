SELECT distinct

	MAX (catinfo.CategoryInstanceName) as Vendor,
	catinfo2.CategoryInstanceName as UpdateClassification,
	ui.BulletinID as BulletinID,
	ui.ArticleID as ArticleID,
	ui.Title as Title,
	--css.Status as IsRequired,
	IsRequired=(CASE WHEN css.Status = 2 THEN '*' ELSE '' END),
	--SUM(CASE WHEN UCS.status=2 THEN 1 ELSE 0 END) AS TRequired,
	Deployed= (Case when cdl.Deadline is null then '' else '*' end),
	--SUM(CASE WHEN css.status=2 and ctm.ResourceID IS NOT NULL THEN 1 ELSE 0 END) AS Targeted,
	Superseded = (case when ui.IsSuperseded = 1  then '*' else '' end), 
	ui.DatePosted as DateReleased,
	ui.CI_UniqueID as UniqueUpdateID,
	ui.InfoURL as InformationURL,
	Severity = (case when ui.Severity = 2 then 'Low' when ui.Severity = 6 then 'Moderate' when ui.Severity = 8 then 'Important' when ui.Severity = 10 then 'Critical'  end ),
	--Severity=2 –> Low Severity=6—>Moderate Severity=8—>Important Severity=10—>Critical
	ui.MaxExecutionTime /60 as 'MaxRunningTime (min)',
	ui.Description

FROM
	v_UpdateComplianceStatus css
	join v_UpdateInfo ui on ui.CI_ID=css.CI_ID
	join v_CICategories_All catall on catall.CI_ID=ui.CI_ID
	join v_CategoryInfo catinfo on catall.CategoryInstance_UniqueID = catinfo.CategoryInstance_UniqueID and catinfo.CategoryTypeName='Company'
	join v_CICategories_All catall2 on catall2.CI_ID=ui.CI_ID
	join v_CategoryInfo catinfo2 on catall2.CategoryInstance_UniqueID = catinfo2.CategoryInstance_UniqueID and catinfo2.CategoryTypeName='UpdateClassification'
	--left join v_CITargetedMachines ctm on ctm.CI_ID=css.CI_ID and ctm.ResourceID = @RscID
	left join (

		select atc.CI_ID, Deadline=min(a.EnforcementDeadline) 
		
		from v_CIAssignment a
			join v_CIAssignmentToCI atc on atc.AssignmentID=a.AssignmentID

		group by atc.CI_ID
		   ) cdl   on cdl.CI_ID=css.CI_ID

WHERE 
	ui.articleid='4516064'
	and ui.Title like '% server %'
 
	--css.ResourceID = @RscID AND catinfo2.CategoryInstanceName like '%' and css.Status = 2
    --and ui.IsDeployed = 1 and (ui.Title like '% windows server %' or ui.Title like '% Removal Tool %'  or ui.Title like  '%for .NET Framework%' ) and catinfo2.CategoryInstanceName not like 'Feature Packs'-- and ui.IsSuperseded = 0
		
	--catinfo2.CategoryInstanceName IN ('Critical Updates','Definition Updates','Security Updates','Update Rollups','Updates')

group by 
	catinfo.CategoryInstanceName,
	catinfo2.CategoryInstanceName,
	ui.BulletinID,
	ui.ArticleID,
	ui.DatePosted,
	ui.CI_UniqueID,
	ui.InfoURL,
	ui.Title,
	css.Status,
	cdl.Deadline,
    ui.IsSuperseded,
	ui.Severity,
	ui.MaxExecutionTime,
	ui.Description