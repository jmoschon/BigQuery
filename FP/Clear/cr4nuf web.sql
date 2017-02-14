

select *
from
(
select  date(a.date) as ga_date,
        -- year(CAST(a.date AS TIMESTAMP)) as ga_year,
        -- case when a.date in('20160101','20160102') then '2015-53' else case when length(string(week(CAST(a.date AS TIMESTAMP))))=1 then CONCAT(string(year(CAST(a.date AS TIMESTAMP))),'-0',string(week(CAST(a.date AS TIMESTAMP)))) else CONCAT(string(year(CAST(a.date AS TIMESTAMP))),'-',string(week(CAST(a.date AS TIMESTAMP)))) end end as ga_week,
        -- case when dayofweek(CAST(a.date AS TIMESTAMP))=1 then '1.Sunday'
        --      when dayofweek(CAST(a.date AS TIMESTAMP))=2 then '2.Monday'
        --      when dayofweek(CAST(a.date AS TIMESTAMP))=3 then '3.Tuesday'
        --      when dayofweek(CAST(a.date AS TIMESTAMP))=4 then '4.Wednesday'
        --      when dayofweek(CAST(a.date AS TIMESTAMP))=5 then '5.Thursday'
        --      when dayofweek(CAST(a.date AS TIMESTAMP))=6 then '6.Friday'
        --      when dayofweek(CAST(a.date AS TIMESTAMP))=7 then '7.Saturday' else 'none'
        -- END as ga_day,
        countries.country as country,

        a.device.deviceCategory as platform,
        a.platform_agg as platform_agg,
        a.users as user_type,
        -- countries.channel as channel,
        -- countries.landing_page as landing_page,
        SUM(a.sessions) as visits,
        sum(a.gross_orders) as orders,
        sum(a.CR4_nuf_start) as CR4_nuf_start,
        sum(case when a.CR4_nuf_start>0 then a.CR4_nuf_complete else 0 end) as CR4_nuf_complete


/* assigning 1 or 0 for each funnel step for every session */

from
  (select date,
          fullvisitorid,
          visitid,
          device.deviceCategory,
          case when device.devicecategory='tablet' OR device.devicecategory='mobile' OR device.devicecategory='desktop' then 'WEB' end as platform_agg,
          case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
--           hits.customDimensions.value as Users,
          sum(totals.visits) as sessions,
          sum(totals.transactions) as gross_orders,
         case when sum(case when(regexp_match(hits.page.pagePath,'/customer/verification')) then 1 else 0 end)>=1 then 1 else 0 end as CR4_nuf_start,
         case when sum(case when(regexp_match(hits.page.pagePath,'/review-order')) then 1 else 0 end)>=1 then 1 else 0 end as CR4_nuf_complete,


    from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -32, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')),TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -32, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108857524.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -32, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))


    group each by 1,2,3,4,5,6
  ) a

/* joining country */

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
                               device.deviceCategory,
                               case when device.devicecategory='tablet' OR device.devicecategory='mobile' OR device.devicecategory='desktop' then 'WEB' end as platform_agg,
                               case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
                               CASE WHEN (( trafficSource.source = 'google' AND trafficSource.medium = 'cpc' AND ((trafficSource.campaign LIKE '%[D[%') OR (trafficSource.campaign LIKE '%[T%') OR (trafficSource.campaign LIKE '%[Y%'))) OR (trafficSource.source = 'FB' AND trafficSource.medium = 'cpc')) THEN 'Display'
                                   WHEN (( trafficSource.source = 'google' OR  trafficSource.source = 'bing' OR  trafficSource.source = 'yandex') AND (trafficSource.medium = 'cpc') AND (trafficSource.campaign LIKE '%[S[CB%' OR trafficSource.campaign LIKE '%[MB[CB%')) THEN 'SEM Brand'
                                   WHEN (( trafficSource.source = 'google' OR  trafficSource.source = 'bing' OR  trafficSource.source = 'yandex') AND (trafficSource.medium = 'cpc')) THEN 'SEM non Brand'
                                   WHEN ( trafficSource.source = '(direct)' OR (( trafficSource.source LIKE 'foodpanda.com'OR trafficSource.source LIKE 'hellofood.com') AND trafficSource.medium = 'referral')) THEN 'direct'
                                   WHEN (regexp_match(trafficSource.medium, '.*[Ee]mail?.*') OR REGEXP_MATCH(trafficSource.medium ,'.*[Nn]ewsletter?.*') OR regexp_match( trafficSource.source , '%newsletter%')) THEN 'Newsletter'
                                   WHEN REGEXP_MATCH(trafficSource.medium ,'[Oo]rganic') THEN 'SEO'
                                   WHEN trafficSource.source = 'transactional' OR trafficSource.source = 'transactional_email' OR trafficSource.source = 'EDM' THEN 'email'
                                   WHEN trafficSource.medium ='referral' then 'referral'
                              else 'others'
                              END AS channel,
                              if (regexp_match(hits.appInfo.landingscreenName,'/restaurant/') is true, 'landing_menu',
                              if (regexp_match(hits.appInfo.landingscreenName,'/restaurants') is true, 'landing_listings',
                              if (regexp_match(Regexp_extract(hits.appInfo.landingscreenName,r'^(?:[^/]*/){1}([^/]*)/?'),'^($|\\?.*|..$|../\\?.*)') is true,'landing_homepage',
                              'landing_other'))) as landing_page

                       from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -32, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')),TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -32, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108857524.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -32, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

                       where hits.customDimensions.index=3 
                       group each by 1,2,4,5,6,7,8,9
                      ), visitid
                    ) a
       ) countries

on a.fullvisitorid=countries.fullvisitorId and a.visitid=countries.visitid and a.date=countries.date





group each by 1,2,3,4,5) as web

,(

 Select * from
(Select date(b.date) as ga_date,
        -- year(CAST(b.date AS TIMESTAMP)) as ga_year,
        -- case when b.date in('20160101','20160102') then '2015-53' else case when length(string(week(CAST(b.date AS TIMESTAMP))))=1 then CONCAT(string(year(CAST(b.date AS TIMESTAMP))),'-0',string(week(CAST(b.date AS TIMESTAMP)))) else CONCAT(string(year(CAST(b.date AS TIMESTAMP))),'-',string(week(CAST(b.date AS TIMESTAMP)))) end end as ga_week,
        -- case when dayofweek(CAST(b.date AS TIMESTAMP))=1 then '1.Sunday'
        --      when dayofweek(CAST(b.date AS TIMESTAMP))=2 then '2.Monday'
        --      when dayofweek(CAST(b.date AS TIMESTAMP))=3 then '3.Tuesday'
        --      when dayofweek(CAST(b.date AS TIMESTAMP))=4 then '4.Wednesday'
        --      when dayofweek(CAST(b.date AS TIMESTAMP))=5 then '5.Thursday'
        --      when dayofweek(CAST(b.date AS TIMESTAMP))=6 then '6.Friday'
        --      when dayofweek(CAST(b.date AS TIMESTAMP))=7 then '7.Saturday' else 'none'
        -- END as ga_day,
        countries.country as country,
        b.device.operatingSystem as platform,
        b.platform_agg as platform_agg,
        b.Users as user_type,
--         countries.channel as channel,
        sum(b.sessions) as visits,
        sum(b.gross_orders) as orders,
        sum(CR4neuf_start) as CR4_nuf_start,
        sum(case when CR4neuf_start>0 then CR4neuf_compl else 0 end) as CR4_nuf_complete,




/* assigning 1 or 0 for each funnel step for every session */
  from

     ( select date,
              fullvisitorId,
              visitId,
              device.operatingSystem,
              case when device.operatingSystem='Android' OR device.operatingSystem='iOS' then 'APP' end as platform_agg,
              case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
              upper(regexp_extract(device.language,r'([^_]*)')) as language,
              sum(totals.visits) as sessions,
              sum(totals.transactions) as gross_orders,
              case when sum(case when(REGEXP_MATCH(hits.appInfo.ScreenName,('Enter Phone Number Screen|SMS Verification Screen'))) then 1 else 0 end)>=1 then 1 else 0 end as CR4neuf_start,
              case when sum(case when(REGEXP_MATCH(hits.appInfo.ScreenName,('Address Details Screen|Adress Book Screen|Payment Selection Screen'))) then 1 else 0 end)>=1 then 1 else 0 end as CR4neuf_compl,
      from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -32, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')),TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -32, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -32, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

       group each by 1,2,3,4,5,6,7

     )b




/* joining country */

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

                        from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -32, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')),TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -32, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -32, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

                        where hits.customDimensions.index=1 
                        group each by 1,2,4,5,6,7,8
                       ), visitid
                     ) a
        ) countries on b.fullvisitorid=countries.fullvisitorId and b.visitid=countries.visitid and b.date=countries.date




        group each by 1,2,3,4,5
) foodpanda) as app