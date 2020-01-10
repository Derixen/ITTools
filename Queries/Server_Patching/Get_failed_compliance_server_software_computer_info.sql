
select distinct
    DeviceName,
	BL_ID,
	CI_ID,
	blname as 'Baseline Name',
	cIname as 'Configuration Item Name',
	RuleName as 'Failed Configuration Rule Name' ,
	RuleStateDisplay as 'state'
	FROM  fn_DCMDeploymentNonCompliantDetailsPerAsset(2) as NonCompliant
	where  BL_ID = '82664' and DeviceName = 'HUBUDSCCM2SITE'