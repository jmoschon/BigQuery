select
-- b.fullVisitorId,
-- b.visitId,
 peos.operatingSystem,
 peos.direct_splash,
 peos.SL_screeName,
 peos.other_screeName,
-- peos.channel,
  sum (case when countries.channel='direct' and countries.landing_page='landing_homepage' then 1 else 0 end) as direct_home,
 sum (case when countries.channel='direct' then 1 else 0 end) as direct
 from (
select
peos.operatingSystem,
sum (case when peos.channel='direct'  and peos.landing_page='landing_splash'then 1 else 0 end ) as  direct_splash,
 sum (case when regexp_match(b.screeName,'Onboarding|Location|Country Selection') and peos.channel='direct' and peos.landing_page='landing_splash' then 1 else 0 end) as SL_screeName,
 sum (case when not regexp_match(b.screeName,'Onboarding|Location|Country Selection') and peos.channel='direct' and peos.landing_page='landing_splash' then 1 else 0 end ) as other_screeName,

 from(
 select
a.fullVisitorId as fullVisitorId,
a.visitId as visitid,
a.operatingSystem as operatingSystem,
countries.landing_page as landing_page,
countries.channel as channel,
min(b.hitNumber) as min_hitNumber

from

     ( select date,
              fullvisitorId,
              visitId,
              device.operatingSystem as operatingSystem,
              case when device.operatingSystem='Android' OR device.operatingSystem='iOS' then 'APP' end as platform_agg,
              case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
               hits.hitNumber as hitNumber,

              sum(totals.visits) as sessions,
              sum(totals.transactions) as gross_orders,
       from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -30, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
       --, TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -30, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -30, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
       where REGEXP_MATCH(hits.appInfo.landingscreenName,'Splash')
       group each by 1,2,3,4,5,6,7

     )a

 join each

     ( select date,
              fullvisitorId,
              visitId,
              device.operatingSystem,
              case when device.operatingSystem='Android' OR device.operatingSystem='iOS' then 'APP' end as platform_agg,
              case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
              hits.hitNumber as hitNumber,
              hits.appInfo.ScreenName,
              sum(totals.visits) as sessions,
              sum(totals.transactions) as gross_orders,


       from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -30, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
     --, TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -30, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -30, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
       where  not REGEXP_MATCH(hits.appInfo.ScreenName,'Splash') and REGEXP_MATCH(hits.appInfo.landingscreenName,'Splash')
       group each by 1,2,3,4,5,6,7,8

     )b

 on b.fullvisitorid=a.fullvisitorId and b.visitid=a.visitid and b.date=a.date


join each

      (
        select a.*
        from
            flatten (
                      (
                        select date,
                               fullVisitorId,
                               unique (visitId) as visitid,
                               upper(hits.customDimensions.value) as country,
                               device.operatingSystem,
                               case when device.operatingSystem='Android' OR device.operatingSystem='iOS' then 'APP' end as platform_agg,
                               case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
                               case when trafficSource.source='(direct)' and trafficSource.medium='(none)' then 'direct'
                                    when trafficSource.source='push' and trafficSource.medium='push' then 'push'else 'others'
                               END AS channel,
                               trafficSource.campaign as campaign,
                               case when regexp_match(hits.appInfo.landingscreenName,'Restaurants') then 'landing_listings'
                                    when regexp_match(hits.appInfo.landingscreenName,'Restaurant[^s]') then'landing_menu'
                                    when regexp_match(hits.appInfo.landingscreenName,'Onboarding|Location|Country Selection') then'landing_homepage'
                                    when regexp_match(hits.appInfo.landingscreenName,'Splash') then 'landing_splash' else 'landing_other'
                               END AS landing_page
                        from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -30, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
                        --, TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -30, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -30, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
                        where hits.customDimensions.index=1
                        group each by 1,2,4,5,6,7,8,9,10
                       ), visitid
                     ) a
        ) countries on b.fullvisitorid=countries.fullvisitorId and b.visitid=countries.visitid and b.date=countries.date


        group by 1,2,3,4,5

       )peos

join each

     ( select date,
              fullvisitorId,
              visitId,
              device.operatingSystem,
              case when device.operatingSystem='Android' OR device.operatingSystem='iOS' then 'APP' end as platform_agg,
              case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
              hits.hitNumber as hitNumber,
              hits.appInfo.ScreenName as screeName,
              sum(totals.visits) as sessions,
              sum(totals.transactions) as gross_orders,


       from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -30, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
       --, TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -30, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -30, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

       group each by 1,2,3,4,5,6,7,8

     )b

     on peos.fullVisitorId=b.fullVisitorId and peos.visitid=b.visitId and b.hitNumber=peos.min_hitNumber
group by 1
)peos

left join

      (
        select a.*
        from
            flatten (
                      (
                        select date,
                               fullVisitorId,
                               unique (visitId) as visitid,
                               upper(hits.customDimensions.value) as country,
                               device.operatingSystem operatingSystem,
                               case when device.operatingSystem='Android' OR device.operatingSystem='iOS' then 'APP' end as platform_agg,
                               case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
                               case when trafficSource.source='(direct)' and trafficSource.medium='(none)' then 'direct'
                                    when trafficSource.source='push' and trafficSource.medium='push' then 'push'else 'others'
                               END AS channel,
                               trafficSource.campaign as campaign,
                               case when regexp_match(hits.appInfo.landingscreenName,'Restaurants') then 'landing_listings'
                                    when regexp_match(hits.appInfo.landingscreenName,'Restaurant[^s]') then'landing_menu'
                                    when regexp_match(hits.appInfo.landingscreenName,'Onboarding|Location|Country Selection') then'landing_homepage'
                                    when regexp_match(hits.appInfo.landingscreenName,'Splash') then 'landing_splash' else 'landing_other'
                               END AS landing_page
                        from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -30, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
                        --, TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -30, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -30, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
                        where hits.customDimensions.index=1
                        group each by 1,2,4,5,6,7,8,9,10
                       ), visitid
                     ) a
        ) countries on peos.operatingSystem = countries.operatingSystem
        group by 1,2,3,4
--     order by 1
