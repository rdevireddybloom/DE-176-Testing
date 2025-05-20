Select A.UsersFK
     , A.Name
     , A.ProjectName
     , A.StatsDate
     , A.HourOfCall
     , Sum(A.WaitSeconds)         As TotalWait
     , Sum(A.PauseSeconds)        As TotalPause
     , Sum(A.NotAvailableSeconds) As TotalNotAvailableSeconds
     , Sum(A.SystemSeconds)       As TotalSystem
From raw_schema_name.raw_table_name A
Group By A.UsersFK
       , A.Name
       , A.ProjectName
       , A.StatsDate
       , A.HourOfCall;