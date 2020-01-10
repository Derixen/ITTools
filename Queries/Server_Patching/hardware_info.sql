SELECT  distinct 
 CS.name0 as 'Computer Name', 
 CS.domain0 as 'Domain', 
 CS.UserName0 as 'User', 
 CS.Manufacturer0 as 'Manufacturer', 
 CS.Model0 as 'model', 
 OS.Caption0 as 'OS', 
 RAA.SMS_Assigned_Sites0 as 'Site', 
 RAM.TotalPhysicalMemory0 as 'Total Memory', 
 sum(isnull(LDisk.Size0,'0')) as 'Hardrive Size', 
 sum(isnull(LDisk.FreeSpace0,'0')) AS 'Free Space', 
 CPU.name0 as 'CPU type' 
 ,prc.NumberOfLogicalProcessors0 AS 'Cores'
from  
  v_GS_COMPUTER_SYSTEM CS right join v_GS_PC_BIOS BIOS on BIOS.ResourceID = CS.ResourceID
 right join v_GS_SYSTEM SYS on SYS.ResourceID = CS.ResourceID  
 right join v_GS_OPERATING_SYSTEM OS on OS.ResourceID = CS.ResourceID  
 right join v_RA_System_SMSAssignedSites RAA on RAA.ResourceID = CS.ResourceID
 right join V_GS_X86_PC_MEMORY RAM on RAM.ResourceID = CS.ResourceID 
 right join v_GS_Logical_Disk LDisk on LDisk.ResourceID = CS.ResourceID 
 right join v_GS_Processor CPU on CPU.ResourceID = CS.ResourceID    
 right join v_GS_SYSTEM_ENCLOSURE SE on SE.ResourceID = CS.ResourceID 
 LEFT JOIN v_GS_PROCESSOR AS prc ON prc.ResourceID = sys.ResourceID and prc.NumberOfCores0 is not null
where 
 LDisk.DriveType0 =3
 and CS.name0 like 'TRKOCG1DP01SRV'

group by 
 CS.Name0, 
 CS.domain0,
 CS.Username0, 
 BIOS.SerialNumber0, 
 SE.SerialNumber0,
 CS.Manufacturer0, 
 CS.Model0, 
 OS.Caption0, 
 RAA.SMS_Assigned_Sites0,
 RAM.TotalPhysicalMemory0, 
 CPU.name0,
 prc.NumberOfLogicalProcessors0