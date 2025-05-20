select CASE WHEN a.UsersFK > 0 then a.UsersFK else 0 end UsersFK,
CASE WHEN a.UsersFK > 0 THEN u.Name ELSE 'Amcat Engine' END as Name,
PauseTime,
case when NumberOfCampaigns > 0 then
    (DATEDIFF(milliseconds, date(PauseTime)::timestamp, PauseTime::timestamp)/1000.00) / NumberOfCampaigns
else 0 end as PauseSeconds,
WaitTime,
case when NumberOfCampaigns > 0 then
    (DATEDIFF(milliseconds, date(WaitTime)::timestamp, WaitTime::timestamp)/1000.00) / NumberOfCampaigns
else 0 end as WaitSeconds,
NotAvailableTime,
case when NumberOfCampaigns > 0 then
    (DATEDIFF(milliseconds, date(NotAvailableTime)::timestamp, NotAvailableTime::timestamp)/1000.00) / NumberOfCampaigns
else 0 end as NotAvailableSeconds,
SystemTime,
(DATEDIFF(milliseconds, date(SystemTime)::timestamp, SystemTime::timestamp)/1000.00)  as SystemSeconds,
StatsDate,StatsTime,
EXTRACT(HOUR FROM StatsTime) AS HourOfCall,
(CASE WHEN ((EXTRACT(MINUTE FROM StatsTime) >= 0) and (EXTRACT(MINUTE FROM StatsTime) < 30)) THEN 0 ELSE 30 END) AS HalfHourOfCall,
a.CampaignFK, NumberOfCampaigns,
case
	when (a.ProjectType = 1 or (a.ProjectType is null and a.CampaignFK < 0))
		and i.Name is not null then RTRIM(LTRIM(i.Name))
	when (a.ProjectType = 2 or (a.ProjectType is null and a.CampaignFK > 0))
		and p.Name is not null then RTRIM(LTRIM(p.Name))
	when a.ProjectType = 3
		and e.Name is not null then RTRIM(LTRIM(e.Name))
end as ProjectName,
case
	when (a.ProjectType = 1 or (a.ProjectType is null and a.CampaignFK < 0))
		and i.Name is not null then i.DatabaseName
	when (a.ProjectType = 2 or (a.ProjectType is null and a.CampaignFK > 0))
		and p.Name is not null then p.DatabaseName
	when a.ProjectType = 3
		and e.Name is not null then e.DatabaseName
end as DatabaseName,
case
	when (a.ProjectType = 1 or (a.ProjectType is null and a.CampaignFK < 0))
		and i.Name is not null then i.DBType
	when (a.ProjectType = 2 or (a.ProjectType is null and a.CampaignFK > 0))
		and p.Name is not null then p.DBType
	when a.ProjectType = 3
		and e.Name is not null then e.DatabaseType
end as DBType,
case
	when (a.ProjectType = 1 or (a.ProjectType is null and a.CampaignFK < 0))
		and i.Name is not null then i.DatabaseServer
	when (a.ProjectType = 2 or (a.ProjectType is null and a.CampaignFK > 0))
		and p.Name is not null then p.DatabaseServer
	when a.ProjectType = 3
		and e.Name is not null then e.DatabaseServer
end as DatabaseServer,
case
	when (a.ProjectType = 1 or (a.ProjectType is null and a.CampaignFK < 0))
		and i.Name is not null then i.DBUserID
	when (a.ProjectType = 2 or (a.ProjectType is null and a.CampaignFK > 0))
		and p.Name is not null then p.DBUserName
	when a.ProjectType = 3
		and e.Name is not null then e.DBUserID
end as DBUserName,
case
	when (a.ProjectType = 1 or (a.ProjectType is null and a.CampaignFK < 0))
		and i.Name is not null then i.DBPassword
	when (a.ProjectType = 2 or (a.ProjectType is null and a.CampaignFK > 0))
		and p.Name is not null then p.DBPassword
	when a.ProjectType = 3
		and e.Name is not null then e.DBPassword
end as DBPassword,
case
	when (a.ProjectType = 1 or (a.ProjectType is null and a.CampaignFK < 0))
		and i.Name is not null then i.DBUsesWindows
	when (a.ProjectType = 2 or (a.ProjectType is null and a.CampaignFK > 0))
		and p.Name is not null then p.DBUseWindowsSecurity
	when a.ProjectType = 3
		and e.Name is not null then e.DBUsesWindows
end as DBUseWindowsSecurity,
PrevState,NextState,
PauseReasonFK,
case when PauseReasonFK <> -1 then r.Text else PauseReasonText end as PauseReason,
LogoutReasonFK,
case when LogoutReasonFK <> -1 then rr.Text else LogoutReasonText end as LogoutReason,
/*versioninfo*/'2007.4.1.10' as Version/*versioninfoend*/
from ((integrated_ccs.AgentStats a LEFT JOIN integrated_ccs.Users u on a.UsersFK = u.PKUsers)
LEFT JOIN integrated_ccs.Pools p on (a.ProjectType = 2 or (a.ProjectType is null and a.CampaignFK > 0)) and a.CampaignFK = p.PKPool)
LEFT JOIN integrated_ccs.InboundConfiguration i on (a.ProjectType = 1 or (a.ProjectType is null and a.CampaignFK < 0)) and a.CampaignFK = i.PKInboundConfiguration
LEFT JOIN integrated_ccs.Reasons r on a.PauseReasonFK = r.PKReason
LEFT JOIN integrated_ccs.Reasons rr on a.LogoutReasonFK = rr.PKReason
LEFT JOIN integrated_ccs.EmailProjects e on a.ProjectType = 3 and a.CampaignFK = e.PKEmailProject;