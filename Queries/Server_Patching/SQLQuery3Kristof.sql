WITH OS AS(
Select Distinct rs.resourceid, rs.Name0, rs.Operating_System_Name_and0,
CAST(SUM(CASE WHEN sn.StateName = 'Update is installed' THEN 1 ELSE 0 END) AS float) AS 'UpdatesInstalled',
Case
When rs.Operating_System_Name_and0 Like '%Server 5.2%' Then 'Windows Server 2003' 
When rs.Operating_System_Name_and0 Like '%Server 6.0%' Then 'Windows Server 2008' 
When rs.Operating_System_Name_and0 Like '%Server 6.1%' Then 'Windows Server 2008 R2' 
When rs.Operating_System_Name_and0 Like '%Server 6.2%' Then 'Windows Server 2012' 
When rs.Operating_System_Name_and0 Like '%Server 6.3%' Then 'Windows Server 2012 R2' 
When rs.Operating_System_Name_and0 Like '%Server 10.0%' Then 'Windows Server 2016' 
When rs.Operating_System_Name_and0 Like '%Workstation 6.1%' Then 'Windows 7' 
When rs.Operating_System_Name_and0 Like '%Workstation 6.3%' Then 'Windows 8.1' 
End As OperatingSystem,
uss.LastScanTime,
(Select count(ucs.ResourceID)
From v_Update_ComplianceStatus ucs
JOIN v_StateNames AS SN ON SN.TopicType = 500 and sn.StateID = ucs.Status
JOIN v_UpdateInfo ui on ui.CI_ID = ucs.CI_ID and ucs.Status = 2 AND ui.IsSuperseded = 0 AND ui.DateRevised BETWEEN @StartDate AND @EndDate
JOIN v_CICategoryInfo_All cica JOIN v_CategoryInfo ci on cica.CategoryInstanceID = ci.CategoryInstanceID AND cica.CategoryInstanceName IN (@Category) on ucs.CI_ID = cica.CI_ID
Where ucs.ResourceID = rs.ResourceID) [Required_Updates] 
From v_r_system rs
JOIN v_UpdateScanStatus uss on uss.ResourceID = rs.ResourceID AND rs.Operating_System_Name_and0 like '%'+@OS+'%' 
AND (rs.Operating_System_Name_and0 NOT LIKE '%Workstation 5%' AND rs.Operating_System_Name_and0 NOT LIKE '%Workstation 6.2%')
AND DATEDIFF("d",uss.LastScanTime,getdate()) <= @DaysScanned AND rs.Obsolete0 = 0
)
Select OS.*,
CASE
WHEN gscs.Model0 in ('Virtual Machine', 'VMware Virtual Platform', 'Xen', 'VirtualBox') Then 'Yes'
Else 'No'
End as VM,
CASE 
WHEN gsse.ChassisTypes0 in ('3','4','5,','6','7','15','16') THEN 'Desktop'
WHEN gsse.ChassisTypes0 in ('8','9','10','11','12','14','18','21') THEN 'Laptop'
WHEN gsse.ChassisTypes0 in ('2','17','23') THEN 'Server'
WHEN gsse.ChassisTypes0 = '0' Then 'Other'
WHEN gsse.ChassisTypes0 = '1' Then 'Unknown'
WHEN gsse.ChassisTypes0 = '13' Then 'All-in-one'
WHEN gsse.ChassisTypes0 = '15' Then 'Space-saving'
WHEN gsse.ChassisTypes0 = '16' Then 'Lunch Box'
WHEN gsse.ChassisTypes0 = '19' Then 'Sub chassis'
WHEN gsse.ChassisTypes0 = '20' Then 'Bus Expansion Chassis'
WHEN gsse.ChassisTypes0 = '22' Then 'Storage chassis'
WHEN gsse.ChassisTypes0 = '24' Then 'Sealed-case PC'
ELSE gsse.ChassisTypes0
End As 'Chassis Type',
gsse.ChassisTypes0,
gsscu.TopConsoleUser0
From OS
LEFT JOIN v_GS_SYSTEM_CONSOLE_USAGE gsscu on gsscu.ResourceID = OS.ResourceID
LEFT JOIN v_GS_SYSTEM_ENCLOSURE gsse on gsse.ResourceID = OS.ResourceID
LEFT JOIN v_GS_COMPUTER_SYSTEM gscs on gscs.ResourceID = OS.ResourceID


Where os.Required_Updates BETWEEN @RequiredUpdates
AND 
CASE @RequiredUpdates
When 0 Then 1000
When 1 Then 10 
When 11 Then 25
When 26 Then 50
When 51 Then 1000
END