select a.date,country.country,a.fullvisitorid, a.visitid, sum(a.sessions), sum(b.sessions), sum(d.sessions) from (

select date,
              fullvisitorid,
              visitid,
--              device.deviceCategory,
--              case when device.devicecategory='tablet' OR device.devicecategory='mobile' OR device.devicecategory='desktop' then 'WEB' end as platform_agg,
--              case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
              totals.visits as sessions,

        from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -4, 'DAY')
        , DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
        --, TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -4, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108857524.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -4, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
--        where hits.customDimensions.index=100
       -- where regexp_match(hits.appInfo.appVersion,'2.16')
        group each by 1,2,3,4
        )a
 left join
 (
 select date,
              fullvisitorid,
              visitid,
--              device.deviceCategory,
--              case when device.devicecategory='tablet' OR device.devicecategory='mobile' OR device.devicecategory='desktop' then 'WEB' end as platform_agg,
--              case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
              totals.visits as sessions,

        from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -4, 'DAY')
        , DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
        --, TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -4, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108857524.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -4, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
       where hits.customDimensions.index=100 --and regexp_match(hits.appInfo.appVersion,'2.16')
        group each by 1,2,3,4
        )b
on a.fullvisitorid=b.fullvisitorid and a.visitid= b.visitid and a.date=b.date

left join
 (
 select date,
              fullvisitorid,
              visitid,
--              device.deviceCategory,
--              case when device.devicecategory='tablet' OR device.devicecategory='mobile' OR device.devicecategory='desktop' then 'WEB' end as platform_agg,
--              case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
              totals.visits as sessions,

        from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -4, 'DAY')
        , DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
        --, TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -4, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108857524.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -4, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
       where hits.eventInfo.eventAction = 'Restaurant Clicked' --and regexp_match(hits.appInfo.appVersion,'2.16')
        group each by 1,2,3,4
        )d
on a.fullvisitorid=d.fullvisitorid and a.visitid= d.visitid and a.date=d.date
join each

 (
 select date,
              fullvisitorid,
              visitid,
--              device.deviceCategory,
--              case when device.devicecategory='tablet' OR device.devicecategory='mobile' OR device.devicecategory='desktop' then 'WEB' end as platform_agg,
--              case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
              totals.visits as sessions,
              hits.customDimensions.value as country,

        from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -4, 'DAY')
        , DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
        --, TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -4, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108857524.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -4, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
       where hits.customDimensions.index=3
        group each by 1,2,3,4,5
        )country
on a.fullvisitorid=country.fullvisitorid and a.visitid= country.visitid and a.date=country.date
group by 1,2,3,4
