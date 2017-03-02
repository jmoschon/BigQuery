


select country.venture_url,a.deviceCategory ,country.filter_selection as filter_selection,
country.filter_apply as filter_apply ,
--country.filter_apply_times as apl,
                   sum (case when  country.filter_apply_times=0 then 1 else 0 end) as filter0,
                   sum (case when  country.filter_apply_times>0 and country.filter_apply_times<=1 then 1 else 0 end) as filter1,
                   sum (case when  country.filter_apply_times>1 and country.filter_apply_times<=2 then 1 else 0 end) as filter2,
                   sum (case when  country.filter_apply_times>=3 then 1 else 0 end) as filter3_plus,

count(a.sessions) as sessions from (
select
          fullvisitorid,
          visitid,
           device.deviceCategory as deviceCategory,
--           case when device.devicecategory='tablet' OR device.devicecategory='mobile' OR device.devicecategory='desktop' then 'WEB' end as platform_agg,
--           case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
          hits.page.hostname AS venture_url,
          sum(totals.visits) as sessions,
--           sum(totals.transactions) as gross_orders,
    from TABLE_DATE_RANGE([102473846.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -31, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), --fr
    TABLE_DATE_RANGE([85827534.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -31, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), --de
    TABLE_DATE_RANGE([105594681.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -31, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')) --ca
    --, TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108857524.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
    where visitnumber>=1 --and totals.visits=0
    group  by 1,2,3,4

)a


left join each

(
select
   fullvisitorid,
   visitid,
   hits.page.hostname AS venture_url,
  sum(totals.visits) as sessions,

   case when sum(case when hits.eventinfo.eventaction='RLP - Restaurant Filters' and hits.eventInfo.eventCategory='Navigation' then 1 else 0 end)>=1 then 1 else 0 end as filter_selection,
   case when sum(case when hits.eventinfo.eventaction='Filter - RLP' and hits.eventInfo.eventCategory='Filter' then 1 else 0 end)>=1 then 1 else 0 end as filter_apply,
   sum( case when hits.eventinfo.eventaction='Filter - RLP' and hits.eventInfo.eventCategory='Filter' then 1 else 0 end) as filter_apply_times,
       from TABLE_DATE_RANGE([102473846.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -31, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), --fr
    TABLE_DATE_RANGE([85827534.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -31, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), --de
    TABLE_DATE_RANGE([105594681.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -31, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')) --ca
    --, TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108857524.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
    where visitnumber>=1 -- and hits.customDimensions.index=3 --and totals.visits=0
    group  by 1,2,3

)country
on a.fullvisitorid=country.fullvisitorid and a.visitid = country.visitid

group by 1,2,3,4

--754