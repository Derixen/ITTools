USE CM_E01

SELECT  sgn.System_Group_Name0,
		sys.Name0

FROM v_RA_System_SystemGroupName as sgn
	join v_R_System as sys on sys.ResourceID = sgn.resourceid

WHERE sgn.System_Group_Name0 like '%SCCM_Exclusion_%circuit%' and sys.Name0 like 'EVH0266%'

order by sys.Name0



