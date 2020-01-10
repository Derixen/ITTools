select distinct v_R_System.ResourceId
, v_R_System.Name0
, v_R_System.Resource_Domain_OR_Workgr0
, v_GS_ADD_REMOVE_PROGRAMS_64.DisplayName0 AS AppNameX64
, v_GS_ADD_REMOVE_PROGRAMS_64.Version0 AS AppVersionX64
--, v_GS_ADD_REMOVE_PROGRAMS.DisplayName0 AS AppNameX86
--, v_GS_ADD_REMOVE_PROGRAMS.Version0 AS AppVersionX86

from  v_R_System 
inner join v_GS_ADD_REMOVE_PROGRAMS_64 on v_GS_ADD_REMOVE_PROGRAMS_64.ResourceID = v_R_System.ResourceId 
inner join v_GS_ADD_REMOVE_PROGRAMS on v_GS_ADD_REMOVE_PROGRAMS.ResourceID = v_R_System.ResourceId
JOIN v_FullCollectionMembership AS fcm on fcm.ResourceID = v_R_System.ResourceID

where fcm.CollectionID = 'E01006DD' -----CAS0023A HU, CAS00234   DE------all server E01006DD
	and v_GS_ADD_REMOVE_PROGRAMS_64.DisplayName0 like '%Winscp%'
--%Crowdstrike sensor% x64
--'%java 8%' all
--'%GIT version%' x64
--'%putty%'
--'%7-zip%'
order by v_R_System.Name0