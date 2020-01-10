select 
SystemName0,
Name0 as Processor_type ,
COUNT(DeviceID0) AS CPUs,
NumberOfCores0 As Cores_per_CPU,
--NumberOfLogicalProcessors0,
COUNT(DeviceID0)*NumberOfCores0 AS All_CPU_Cores

from v_GS_PROCESSOR

where v_GS_PROCESSOR.SystemName0 like 'HUBUDADMINTOOL'

group by SystemName0,name0,NumberOfCores0,NumberOfLogicalProcessors0