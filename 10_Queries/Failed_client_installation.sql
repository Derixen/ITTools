SELECT
Name,PushSiteCode,AssignedSiteCode,InitialRequestDate
LatestProcessingAttempt,
LastErrorCode,NumProcessAttempts
From v_CP_Machine
where LastErrorCode<>0
Order By LastErrorCode