/****** Script for SelectTopNRows command from SSMS  ******/
SELECT distinct [IP_Subnets0]
				,bd.Value
				,bd.DisplayName

  FROM [CM_E01].[dbo].[v_RA_System_IPSubnets]
  inner join vSMS_Boundary as BD on [CM_E01].[dbo].[v_RA_System_IPSubnets].IP_Subnets0 = bd.Value