
select  date(a.date) as ga_date,
        year(CAST(a.date AS TIMESTAMP)) as ga_year,
        case when a.date in('20160101','20160102') then '2015-53' else case when length(string(week(CAST(a.date AS TIMESTAMP))))=1 then CONCAT(string(year(CAST(a.date AS TIMESTAMP))),'-0',string(week(CAST(a.date AS TIMESTAMP)))) else CONCAT(string(year(CAST(a.date AS TIMESTAMP))),'-',string(week(CAST(a.date AS TIMESTAMP)))) end end as ga_week,
        case when dayofweek(CAST(a.date AS TIMESTAMP))=1 then '1.Sunday'
             when dayofweek(CAST(a.date AS TIMESTAMP))=2 then '2.Monday'
             when dayofweek(CAST(a.date AS TIMESTAMP))=3 then '3.Tuesday'
             when dayofweek(CAST(a.date AS TIMESTAMP))=4 then '4.Wednesday'
             when dayofweek(CAST(a.date AS TIMESTAMP))=5 then '5.Thursday'
             when dayofweek(CAST(a.date AS TIMESTAMP))=6 then '6.Friday'
             when dayofweek(CAST(a.date AS TIMESTAMP))=7 then '7.Saturday' else 'none'
        END as ga_day,
        countries.country as country,
--        iso.common_name as common_name,
        a.device.deviceCategory as platform,
--        a.platform_agg as platform_agg,
        a.users as user_type,
        countries.channel as channel,
        countries.landing_page as landing_page,
--        ab_sorting.sorting as sorting,
--        language.language as language,
        varietions.varietion as varietion,
--        a.loadTime as loadTime,
--        dim_area.city as city,
--        dim_area.area as area,
        SUM(a.sessions) as visits,
        sum(a.gross_orders) as orders,
        sum(CR1_start) as hp_rlp_start,
        INTEGER(sum(CR1_completion)) as hp_rlp_complete,
        sum(CR2_start) as rlp_rdp_start,
        sum(CR2_completion) as rlp_rdp_complete,
        sum(CR3_start) as rdp_co_start,
        sum(CR3_completion) as rdp_co_complete,
        sum(CR4_start) as co_so_start,
        sum(CR4_completion) as co_so_complete

from
  (select date,
          fullvisitorid,
          visitid,
          device.deviceCategory,
--          hits.latencyTracking.domContentLoadedTime as loadTime,
          case when device.devicecategory='tablet' OR device.devicecategory='mobile' OR device.devicecategory='desktop' then 'WEB' end as platform_agg,
          case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
          sum(totals.visits) as sessions,
          sum(totals.transactions) as gross_orders,

          case when sum(case when hits.eventinfo.eventaction='CR1 Start' then 1 else 0 end)>=1 then 1 else 0 end as CR1_start,
          case when sum(case when hits.eventinfo.eventaction='CR1 Completion' then 1 else 0 end)>=1 then 1 else 0 end as CR1_completion,
          case when sum(case when hits.eventinfo.eventaction='CR2 Start' then 1 else 0 end)>=1 then 1 else 0 end as CR2_start,
          case when sum(case when hits.eventinfo.eventaction='CR2 Completion' then 1 else 0 end)>=1 then 1 else 0 end as CR2_completion,
          case when sum(case when hits.eventinfo.eventaction='CR3 Start' then 1 else 0 end)>=1 then 1 else 0 end as CR3_start,
          case when sum(case when hits.eventinfo.eventaction='CR3 Completion' then 1 else 0 end)>=1 then 1 else 0 end as CR3_completion,
          case when sum(case when hits.eventinfo.eventaction='CR4 Start' then 1 else 0 end)>=1 then 1 else 0 end as CR4_start,
          case when sum(case when hits.eventinfo.eventaction='CR4 Completion' then 1 else 0 end)>=1 then 1 else 0 end as CR4_completion,

    from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108857524.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
    group each by 1,2,3,4,5,6
  ) a

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

                       from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108857524.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
                       where hits.customDimensions.index=3 and hits.customDimensions.value='HK'
                       group each by 1,2,4,5,6,7,8,9
                      ), visitid
                    ) a
       ) countries

on a.fullvisitorid=countries.fullvisitorId and a.visitid=countries.visitid and a.date=countries.date


/*add language */

join each

     (
        select a.*
        from
            flatten (
                      (
                        select date,
                               fullVisitorId,
                               unique (visitId) as visitid,
--                               hits.latencyTracking.domContentLoadedTime as loadTime,
--                               upper(regexp_extract(hits.customDimensions.value,r'([^_]*)')) as language
                                hits.customDimensions.value as varietion
                       from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')),TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
                       where hits.customDimensions.index=75 and regexp_match(hits.customDimensions.value,'A/B/X')
                       group each by 1,2,4
                      ), visitid
                    ) a
       ) varietions

on a.fullvisitorid=varietions.fullvisitorId and a.visitid=varietions.visitid




group each by 1,2,3,4,5,6,7,8,9,10
