select * from (
select
a.date as date,
year(cast(a.date as timestamp)) as year,
week(cast(a.date as timestamp)) as week,
a.user_type as user_type,
countries.country as iso_code,
iso.common_name as country,
company.company as company,
sum(total_visits) as total_visits,
sum(gross_orders) as gross_orders,
--sum(CR1_start) as CR1_start,
--sum(CR2_start) as CR2_start,
--sum(CR3_start) as CR3_start,
sum(CR4_start) as CR4_start,
--sum(CR1a_completion) as CR1a_completion,
--sum(CR1b_completion) as CR1b_completion,
--sum(CR1c_completion) as CR1c_completion,
--sum(CR2a_completion) as CR2a_completion,
--sum(CR3a_completion) as CR3a_completion,
--sum(CR3b_completion) as CR3b_completion,
--sum(CR3c_completion) as CR3c_completion,
--sum(CR3d_completion) as CR3d_completion,
sum(CR4a_completion) as CR4a_completion,
sum(CR4c_completion) as CR4c_completion,
sum(CR4d_completion) as CR4d_completion,
sum(CR4e_completion) as CR4e_completion,
--sum(CR4e_completion) as CR4e_completion,
--sum(CR1_completion) as CR1_completion,
--sum(CR2_completion) as CR2_completion,
--sum(CR3_completion) as CR3_completion,
sum(CR4_completion) as CR4_completion

from
(select date, fullvisitorid, visitid, device.deviceCategory,
case when visitnumber=1 then "New Visitor" else "Returning Visitor" end as user_type,
totals.visits as total_visits,
totals.transactions as gross_orders,
--case when sum(case when hits.eventinfo.eventaction='CR1 Start' then 1 else 0 end)>=1 then 1 else 0 end as CR1_start,
--case when sum(case when hits.eventinfo.eventaction='CR1 Completion' then 1 else 0 end)>=1 then 1 else 0 end as CR1_completion,
--case when sum(case when hits.eventinfo.eventaction='CR2 Start' then 1 else 0 end)>=1 then 1 else 0 end as CR2_start,
--case when sum(case when hits.eventinfo.eventaction='CR2 Completion' then 1 else 0 end)>=1 then 1 else 0 end as CR2_completion,
--case when sum(case when hits.eventinfo.eventaction='CR3 Start' then 1 else 0 end)>=1 then 1 else 0 end as CR3_start,
--case when sum(case when hits.eventinfo.eventaction='CR3 Completion' then 1 else 0 end)>=1 then 1 else 0 end as CR3_completion,
case when sum(case when hits.eventinfo.eventaction='CR4 Start' then 1 else 0 end)>=1 then 1 else 0 end as CR4_start,
case when sum(case when hits.eventinfo.eventaction='CR4 Completion' then 1 else 0 end)>=1 then 1 else 0 end as CR4_completion,
--case when sum(case when hits.eventinfo.eventaction='CR1a Completion' then 1 else 0 end)>=1 then 1 else 0 end as CR1a_completion,
--case when sum(case when hits.eventinfo.eventaction='CR1b Completion' then 1 else 0 end)>=1 then 1 else 0 end as CR1b_completion,
--case when sum(case when hits.eventinfo.eventaction='CR1c Completion' then 1 else 0 end)>=1 then 1 else 0 end as CR1c_completion,
--case when sum(case when hits.eventinfo.eventaction='CR2a Completion' then 1 else 0 end)>=1 then 1 else 0 end as CR2a_completion,
--case when sum(case when hits.eventinfo.eventaction='CR3a Completion' then 1 else 0 end)>=1 then 1 else 0 end as CR3a_completion,
--case when sum(case when hits.eventinfo.eventaction='CR3b Completion' then 1 else 0 end)>=1 then 1 else 0 end as CR3b_completion,
--case when sum(case when hits.eventinfo.eventaction='CR3c Completion' then 1 else 0 end)>=1 then 1 else 0 end as CR3c_completion,
--case when sum(case when hits.eventinfo.eventaction='CR3d Completion' then 1 else 0 end)>=1 then 1 else 0 end as CR3d_completion,
case when sum(case when regexp_match (hits.page.pagePath,'/login') then 1 else 0 end)>=1 then 1 else 0 end as CR4a_completion
case when sum(case when regexp_match (hits.page.pagePath,'/verification') then 1 else 0 end)>=1 then 1 else 0 end as CR4b_completion
case when sum(case when regexp_match (hits.page.pagePath,'/review-order') then 1 else 0 end)>=1 then 1 else 0 end as CR4c_completion,
case when sum(case when regexp_match(hits.page.pagePath,'/checkout' )then 1 else 0 end)>=1 then 1 else 0 end as CR4d_completion,
case when sum(case when hits.eventinfo.eventaction='CR4e Completion' then 1 else 0 end)>=1 then 1 else 0 end as CR4e_completion

from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -15, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
--, TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -15, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
group each by 1,2,3,4,5
) a

join each

(select a.* from
flatten (
(select date, fullVisitorId, unique (visitId) as visitid, hits.customDimensions.value as country,
case when visitnumber=1 then "New Visitor" else "Returning Visitor" end as user_type
from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -15, 'DAY') ,DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
--,TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -15, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
where hits.customDimensions.index=3 and hits.customDimensions.value='PK'
group each by 1,2,4,5), visitid) a) countries
on a.fullvisitorid=countries.fullvisitorId and a.visitid=countries.visitid and a.date=countries.date

join each (

select date, fullVisitorId, visitId , hits.customDimensions.value as company
from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -15, 'DAY') ,DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
where hits.customDimensions.index=182
)company
on a.fullvisitorid=company.fullvisitorid and a.visitid = company.visitid and a.date=company.date


join each [CR_team.iso_common_countries] iso on iso.iso=countries.country
group each by 1,2,3,4,5,6,7) foodpanda