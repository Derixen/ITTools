Select Deploymentname, Available, Deadline,

cast(cast(((cast([Compliant] as float) / (ISNULL([Compliant], 0) + ISNULL([Enforcement state unknown], 0) + ISNULL([Successfully installed update(s)], 0) + ISNULL([Failed to install update(s)], 0) + ISNULL([Installing update(s)], 0) + ISNULL([Waiting for another installation to complete], 0) + ISNULL([Pending system restart], 0) + ISNULL([Downloading update(s)], 0)))*100) as Numeric(10,2)) as varchar(256)) + '%' AS '% Compliant',

  [Compliant],

  [Enforcement state unknown],

  [Successfully installed update(s)],

  [Failed to install update(s)],

  [Installing update(s)],

  [Waiting for another installation to complete],

  [Pending system restart],

  [Downloading update(s)]

From

(select

a.AssignmentName as DeploymentName,

a.StartTime as Available,

a.EnforcementDeadline as Deadline,

sn.StateName as LastEnforcementState,

count(*) as NumberOfComputers

from v_CIAssignment a

join v_AssignmentState_Combined assc

on a.AssignmentID=assc.AssignmentID

join v_StateNames sn

on assc.StateType = sn.TopicType and sn.StateID=isnull(assc.StateID,0)

where a.AssignmentName LIKE '%tds%'

group by a.AssignmentName, a.StartTime, a.EnforcementDeadline,

      sn.StateName) as PivotData

PIVOT

(

SUM (NumberOfComputers)

FOR LastEnforcementState IN

( [Compliant],

  [Enforcement state unknown],

  [Successfully installed update(s)],

  [Failed to install update(s)],

  [Installing update(s)],

  [Waiting for another installation to complete],

  [Pending system restart],

  [Downloading update(s)])

) AS pvt