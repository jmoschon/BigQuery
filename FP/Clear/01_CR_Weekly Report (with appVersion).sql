

/* WEEKLY REPORT */

/************** Foodpanda/Hellofood WEB **************/

select *
from
(
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
        iso.common_name as common_name,
        a.device.deviceCategory as platform,
        a.platform_agg as platform_agg,
        'N/A' as app_version,
        a.users as user_type,
        countries.channel as channel,
        countries.landing_page as landing_page,
        ab_sorting.sorting as sorting,
        language.language as language,
        dim_area.city as city,
        dim_area.area as area,
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

/* assigning 1 or 0 for each funnel step for every session */

from
  (select date,
          fullvisitorid,
          visitid,
          device.deviceCategory,
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

                       from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108857524.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
                       where hits.customDimensions.index=3
                       group each by 1,2,4,5,6,7,8,9
                      ), visitid
                    ) a
       ) countries

on a.fullvisitorid=countries.fullvisitorId and a.visitid=countries.visitid and a.date=countries.date

/*add city and area */

left join each

(select a.* from
flatten (
(select fullVisitorId, unique (visitId) as visitid, regexp_extract(hits.customDimensions.value,r'([^_]*)') as city_id, regexp_extract(hits.customDimensions.value,r'_(.*)') as area_id
from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')),TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
where hits.customDimensions.index=1
group each by 1,3,4), visitid) a) area_id

on area_id.fullvisitorid=a.fullvisitorid and area_id.visitid=a.visitid

/*add sorting */

left join each

(select a.* from
flatten (
(select fullVisitorId, unique (visitId) as visitid, hits.customDimensions.value as sorting
from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')),TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
where hits.customDimensions.index=2
group each by 1,3), visitid) a) ab_sorting

on ab_sorting.fullvisitorid=a.fullvisitorid and ab_sorting.visitid=a.visitid


/*add language */

left join each

     (
        select a.*
        from
            flatten (
                      (
                        select date,
                               fullVisitorId,
                               unique (visitId) as visitid,
                               upper(regexp_extract(hits.customDimensions.value,r'([^_]*)')) as language

                       from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')),TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
                       where hits.customDimensions.index=41
                       group each by 1,2,4
                      ), visitid
                    ) a
       ) language

on a.fullvisitorid=language.fullvisitorId and a.visitid=language.visitid


join each [CR_team.iso_common_countries] iso
on countries.country=iso.iso

left join [CR_team.dim_area] dim_area
on dim_area.area_id = area_id.area_id and dim_area.common_name = iso.common_name

group each by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16) as web

,


/************** Foodpanda/Hellofood APP **************/



(


 Select * from
(Select date(b.date) as ga_date,
        year(CAST(b.date AS TIMESTAMP)) as ga_year,
        case when b.date in('20160101','20160102') then '2015-53' else case when length(string(week(CAST(b.date AS TIMESTAMP))))=1 then CONCAT(string(year(CAST(b.date AS TIMESTAMP))),'-0',string(week(CAST(b.date AS TIMESTAMP)))) else CONCAT(string(year(CAST(b.date AS TIMESTAMP))),'-',string(week(CAST(b.date AS TIMESTAMP)))) end end as ga_week,
        case when dayofweek(CAST(b.date AS TIMESTAMP))=1 then '1.Sunday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=2 then '2.Monday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=3 then '3.Tuesday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=4 then '4.Wednesday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=5 then '5.Thursday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=6 then '6.Friday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=7 then '7.Saturday' else 'none'
        END as ga_day,
        countries.country as country,
        iso.common_name as common_name,
        b.device.operatingSystem as platform,
        b.platform_agg as platform_agg,
        b.appVersion as app_version,
        b.Users as user_type,
        countries.channel as channel,
        'N/A' as landing_page,
        'a' as sorting,
        b.language as language,
        dim_area.city as city,
        dim_area.area as area,
        sum(b.sessions) as visits,
        sum(b.gross_orders) as orders,
        sum(CR1_start) as hp_rlp_start,
        INTEGER(sum(CR1_complete)) as hp_rlp_complete,
        sum(b.CR2_start) as rlp_rdp_start,
        sum(b.CR3_start) as rlp_rdp_complete,
        sum(b.CR3_start) as rdp_co_start,
        sum(b.CR4_start) as rdp_co_complete,
        sum(b.CR4_start) as co_so_start,
        sum(b.CR4_complete) as co_so_complete

/* assigning 1 or 0 for each funnel step for every session */
  from

     ( select date,
              fullvisitorId,
              visitId,
              device.operatingSystem,
              hits.appInfo.appVersion as appVersion,
              case when device.operatingSystem='Android' OR device.operatingSystem='iOS' then 'APP' end as platform_agg,
              case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
              upper(regexp_extract(device.language,r'([^_]*)')) as language,
              sum(totals.visits) as sessions,
              sum(totals.transactions) as gross_orders,
              case when sum(case when(REGEXP_MATCH(hits.appInfo.ScreenName,('Onboarding|Location'))) then 1 else 0 end)>=1 then 1 else 0 end as CR1_start,
              case when sum(case when(REGEXP_MATCH(hits.appInfo.ScreenName,'Restaurants')) then 1 else 0 end)>=1 then 1 else 0 end as CR2_start,
              case when sum(case when(REGEXP_MATCH(hits.appInfo.ScreenName,'Restaurant[^s]')) then 1 else 0 end)>=1 then 1 else 0 end as CR3_start,
              case when sum(case when(REGEXP_MATCH(hits.appInfo.ScreenName,'^(Checkout Screen|Delivery Method Screen|Email Verification Screen|Address Book Screen|User Details Screen)')) then 1 else 0 end)>=1 then 1 else 0 end as CR4_start,
              case when sum(case when(REGEXP_MATCH(hits.appInfo.ScreenName,'^Checkout Confirmation Screen')) then 1 else 0 end)>=1 then 1 else 0 end as CR4_complete
       from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
       group each by 1,2,3,4,5,6,7,8

     )b

/* joining CR1 complete */

left join each

    (
      select c.date as date,
            c.fullVisitorId as fullVisitorId,
            c.visitId as visitId,
            count(c.hits) as CR1_complete

      from

        (
          Select date,
                 fullVisitorId,
                 visitId,
                 max(hits.hitnumber) as hits
          from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
          where REGEXP_MATCH(hits.appInfo.screenName,'Restaurants')
          group each by 1,2,3
        ) c

join each

      (
        Select date,
                fullVisitorId,
                visitId,
                min(hits.hitnumber) as hits
         from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
         where REGEXP_MATCH(hits.appInfo.screenName,'(Onboarding|Location)')
         group each  by 1,2,3
       ) b on c.fullvisitorId=b.fullvisitorId and c.visitid=b.visitid and c.date=b.date
         where c.hits>b.hits
         group each by 1,2,3
    ) a on a.fullvisitorId=b.fullvisitorId and a.visitId=b.visitId and a.date=b.date


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

                        from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
                        where hits.customDimensions.index=1
                        group each by 1,2,4,5,6,7,8
                       ), visitid
                     ) a
        ) countries on b.fullvisitorid=countries.fullvisitorId and b.visitid=countries.visitid and b.date=countries.date

/*add city and area*/

left join each

(select a.* from
flatten (
(select fullVisitorId, unique (visitId) as visitid, regexp_extract(hits.customDimensions.value,r'([^_]*)') as city_id, regexp_extract(hits.customDimensions.value,r'_(.*)') as area_id
from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
where hits.customDimensions.index=11
group each by 1,3,4), visitid) a) area_id

on area_id.fullvisitorid=b.fullvisitorid and area_id.visitid=b.visitid

join each [CR_team.iso_common_countries] iso
on countries.country=iso.iso

left join [CR_team.dim_area] dim_area
on dim_area.area_id = area_id.area_id and dim_area.common_name = iso.common_name
        group each by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16
) foodpanda
) as app
,

/************** Delivery Club WEB **************/

(select * from
(Select date(b.date) as ga_date,
        year(CAST(b.date AS TIMESTAMP)) as ga_year,
        case when b.date in('20160101','20160102') then '2015-53' else case when length(string(week(CAST(b.date AS TIMESTAMP))))=1 then CONCAT(string(year(CAST(b.date AS TIMESTAMP))),'-0',string(week(CAST(b.date AS TIMESTAMP)))) else CONCAT(string(year(CAST(b.date AS TIMESTAMP))),'-',string(week(CAST(b.date AS TIMESTAMP)))) end end as ga_week,
        case when dayofweek(CAST(b.date AS TIMESTAMP))=1 then '1.Sunday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=2 then '2.Monday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=3 then '3.Tuesday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=4 then '4.Wednesday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=5 then '5.Thursday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=6 then '6.Friday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=7 then '7.Saturday' else 'none'
        END as ga_day,
        countries.country as country,
        "Russia (Delivery Club)" as common_name,
        b.device.deviceCategory as platform,
        b.platform_agg as platform_agg,
        'N/A' as app_version,
        b.users as user_type,
        countries.channel as channel,
        'N/A' as landing_page,
        'N/A' as sorting,
        'N/A' as language,
        cities.city as city,
        'null' as area,
        sum(b.sessions) as visits,
        sum(b.gross_orders) as orders,
        sum(b.CR1_start) as hp_rlp_start,
        INTEGER(sum(CR1_completion)) as hp_rlp_complete,
        sum(b.CR2_start) as rlp_rdp_start,
        INTEGER(sum(cr2_compl.CR2_completion)) as rlp_rdp_complete,
        sum(b.CR3_start) as rdp_co_start,
        INTEGER(sum(cr3_compl.CR3_completion)) as rdp_co_complete,
        sum(b.CR4_start) as co_so_start,
        INTEGER(sum(cr4_compl.CR4_completion)) as co_so_complete
  from

     (        select date,
              fullvisitorId,
              visitId,
              device.deviceCategory,
              case when device.deviceCategory='desktop' OR device.deviceCategory='tablet' OR device.deviceCategory='mobile' then 'WEB' end as platform_agg,
              case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
              sum(totals.visits) as sessions,
              sum(totals.transactions) as gross_orders,
              case when sum(case when(regexp_match(hits.page.pagePath,'^(/$|/\\?.*)')) then 1 else 0 end)>=1 then 1 else 0 end as CR1_start,
              case when sum(case when(regexp_match(hits.page.pagePath,'^/entities')) then 1 else 0 end)>=1 then 1 else 0 end as CR2_start,
              case when sum(case when(regexp_match(hits.page.pagePath,'^/srv')) then 1 else 0 end)>=1 then 1 else 0 end as CR3_start,
              case when sum(case when(regexp_match(hits.page.pagePath,'^/checkout')) then 1 else 0 end)>=1 then 1 else 0 end as CR4_start,
              case when sum(case when(regexp_match(hits.page.pagePath,'^(/thank-you|/pay/)')) then 1 else 0 end)>=1 then 1 else 0 end as CR4_complete
       from TABLE_DATE_RANGE([46979369.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
       group each by 1,2,3,4,5,6

     )b

left join each

    (
      select c.date as date,
            c.fullVisitorId as fullVisitorId,
            c.visitId as visitId,
            count(c.hits) as CR1_completion

      from

        (
          Select date,
                 fullVisitorId,
                 visitId,
                 max(hits.hitnumber) as hits
          from TABLE_DATE_RANGE([46979369.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

          where regexp_match(hits.page.pagePath,'^/entities')
          group each by 1,2,3
        ) c

join each

      (
        Select date,
                fullVisitorId,
                visitId,
                min(hits.hitnumber) as hits
         from TABLE_DATE_RANGE([46979369.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

         where regexp_match(hits.page.pagePath,'^(/$|/\\?.*)')
         group each  by 1,2,3
       ) b on c.fullvisitorId=b.fullvisitorId and c.visitid=b.visitid and c.date=b.date
         where c.hits>b.hits
         group each by 1,2,3
    ) cr1_compl on cr1_compl.fullvisitorId=b.fullvisitorId and cr1_compl.visitId=b.visitId and cr1_compl.date=b.date

/*********************joining CR2 complete**************************/

    left join each

(
    select c.date as date,
           c.fullVisitorId as fullVisitorId,
           c.visitId as visitId,
           count(c.hits) as CR2_completion

      from

            (
              Select date,
                     fullVisitorId,
                     visitId,
                     max(hits.hitnumber) as hits
              from TABLE_DATE_RANGE([46979369.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

              where regexp_match(hits.page.pagePath,'^/srv')
              group each by 1,2,3
            ) c

join each

            (
              Select  date,
                      fullVisitorId,
                      visitId,
                      min(hits.hitnumber) as hits
               from TABLE_DATE_RANGE([46979369.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

               where regexp_match(hits.page.pagePath,'^/entities')
               group each  by 1,2,3
             ) b
    on c.fullvisitorId=b.fullvisitorId and c.visitid=b.visitid and c.date=b.date
    where c.hits>b.hits
    group each by 1,2,3
) cr2_compl on cr2_compl.fullvisitorId=b.fullvisitorId and cr2_compl.visitId=b.visitId and cr2_compl.date=b.date


/*******************joining CR3 complete********************/

left join each

(
      select  c.date as date,
              c.fullVisitorId as fullVisitorId,
              c.visitId as visitId,
              count(c.hits) as CR3_completion

      from

              (
                Select date,
                       fullVisitorId,
                       visitId,
                       max(hits.hitnumber) as hits
                from TABLE_DATE_RANGE([46979369.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

                where regexp_match(hits.page.pagePath,'^/checkout')
                group each by 1,2,3
              ) c

join each

              (
                Select date,
                        fullVisitorId,
                        visitId,
                        min(hits.hitnumber) as hits
                 from TABLE_DATE_RANGE([46979369.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

                 where regexp_match(hits.page.pagePath,'^/srv')
                 group each  by 1,2,3
               ) b
   on c.fullvisitorId=b.fullvisitorId and c.visitid=b.visitid and c.date=b.date
   where c.hits>b.hits
   group each by 1,2,3
) cr3_compl on cr3_compl.fullvisitorId=b.fullvisitorId and cr3_compl.visitId=b.visitId and cr3_compl.date=b.date


/*****************joining CR4 complete**********************************/

left join each

(
      select  c.date as date,
              c.fullVisitorId as fullVisitorId,
              c.visitId as visitId,
              count(c.hits) as CR4_completion

      from

              (
                Select date,
                       fullVisitorId,
                       visitId,
                       max(hits.hitnumber) as hits
                from TABLE_DATE_RANGE([46979369.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

                where regexp_match(hits.page.pagePath,'^(/thank-you|/pay/)')
                group each by 1,2,3
              ) c

join each

              (
                Select date,
                        fullVisitorId,
                        visitId,
                        min(hits.hitnumber) as hits
                 from TABLE_DATE_RANGE([46979369.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

                 where regexp_match(hits.page.pagePath,'^/checkout')
                 group each  by 1,2,3
               ) b
   on c.fullvisitorId=b.fullvisitorId and c.visitid=b.visitid and c.date=b.date
   where c.hits>b.hits
   group each by 1,2,3
) cr4_compl on cr4_compl.fullvisitorId=b.fullvisitorId and cr4_compl.visitId=b.visitId and cr4_compl.date=b.date


join each

      (

        select a.*
        from
            flatten (
                      (
                        select date,
                               fullVisitorId,
                               unique (visitId) as visitid,
                              'Russia' as country,
                               device.deviceCategory,
                               case when device.deviceCategory='desktop' OR device.deviceCategory='tablet' OR device.deviceCategory='mobile' then 'WEB' end as platform_agg,
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


                        from TABLE_DATE_RANGE([46979369.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

                        group each by 1,2,4,5,6,7,8
                       ), visitid
                     ) a
        ) countries on b.fullvisitorid=countries.fullvisitorId and b.visitid=countries.visitid and b.date=countries.date


/*add city */

left join each

        (select a.* from
        flatten (
        (select fullVisitorId, unique (visitId) as visitid, hits.customDimensions.value as city
        from TABLE_DATE_RANGE([46979369.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
        where hits.customDimensions.index=9
        group each by 1,3), visitid) a) cities

        on cities.fullvisitorid=b.fullvisitorid and cities.visitid=b.visitid

        group each by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16

)  as web
)dc_web


,


/************** Delivery Club APP **************/

(
Select * from
(Select date(b.date) as ga_date,
        year(CAST(b.date AS TIMESTAMP)) as ga_year,
        case when b.date in('20160101','20160102') then '2015-53' else case when length(string(week(CAST(b.date AS TIMESTAMP))))=1 then CONCAT(string(year(CAST(b.date AS TIMESTAMP))),'-0',string(week(CAST(b.date AS TIMESTAMP)))) else CONCAT(string(year(CAST(b.date AS TIMESTAMP))),'-',string(week(CAST(b.date AS TIMESTAMP)))) end end as ga_week,
        case when dayofweek(CAST(b.date AS TIMESTAMP))=1 then '1.Sunday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=2 then '2.Monday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=3 then '3.Tuesday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=4 then '4.Wednesday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=5 then '5.Thursday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=6 then '6.Friday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=7 then '7.Saturday' else 'none'
        END as ga_day,
        countries.country as country,
        "Russia (Delivery Club)" as common_name,
        b.device.operatingSystem as platform,
        b.platform_agg as platform_agg,
        b.appVersion as app_version,
        b.users as user_type,
        countries.channel as channel,
        'N/A' as landing_page,
        'N/A' as sorting,
        'N/A' as language,
        cities.city as city,
        'null' as area,
        sum(b.sessions) as visits,
        sum(b.gross_orders) as orders,
        sum(b.CR1_start) as hp_rlp_start,
        INTEGER(sum(CR1_completion)) as hp_rlp_complete,
        sum(b.CR2_start) as rlp_rdp_start,
        Integer(sum(cr2_compl.CR2_completion)) as rlp_rdp_complete,
        sum(b.CR3_start) as rdp_co_start,
        sum(b.CR4_start) as rdp_co_complete,
        sum(b.CR4_start) as co_so_start,
        sum(b.CR4_complete) as co_so_complete
  from

     ( select date,
              fullvisitorId,
              visitId,
              device.operatingSystem,
              hits.appInfo.appVersion as appVersion,
              geonetwork.region as region,
              case when device.operatingSystem='Android' OR device.operatingSystem='iOS' then 'APP' end as platform_agg,
              case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
              sum(totals.visits) as sessions,
              sum(totals.transactions) as gross_orders,
              case when sum(case when(REGEXP_MATCH(hits.appInfo.ScreenName,'(Main Screen|Location|ShopMain)')) then 1 else 0 end)>=1 then 1 else 0 end as CR1_start,
              case when sum(case when(REGEXP_MATCH(hits.appInfo.ScreenName,'Restaurants')) then 1 else 0 end)>=1 then 1 else 0 end as CR2_start,
              case when sum(case when(REGEXP_MATCH(hits.appInfo.ScreenName,'(Restaurant[^s]|Menu|menu|Cart Screen)')) then 1 else 0 end)>=1 then 1 else 0 end as CR3_start,
              case when sum(case when(REGEXP_MATCH(hits.appInfo.ScreenName,'Checkout[^C]')) then 1 else 0 end)>=1 then 1 else 0 end as CR4_start,
              case when sum(case when(REGEXP_MATCH(hits.appInfo.ScreenName,'Confirmation')) then 1 else 0 end)>=1 then 1 else 0 end as CR4_complete
       from TABLE_DATE_RANGE([96340741.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
       group each by 1,2,3,4,5,6,7,8

     )b

/*********************************CR1 Complete***********************/
left join each

    (
      select c.date as date,
            c.fullVisitorId as fullVisitorId,
            c.visitId as visitId,
            count(c.hits) as CR1_completion

      from

        (
          Select date,
                 fullVisitorId,
                 visitId,
                 max(hits.hitnumber) as hits
          from TABLE_DATE_RANGE([96340741.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

          where REGEXP_MATCH(hits.appInfo.screenName,'Restaurant')
          group each by 1,2,3
        ) c

join each

      (
        Select date,
                fullVisitorId,
                visitId,
                min(hits.hitnumber) as hits
         from TABLE_DATE_RANGE([96340741.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

         where REGEXP_MATCH(hits.appInfo.screenName,'(Main Screen|Location|ShopMain)')
         group each  by 1,2,3
       ) b on c.fullvisitorId=b.fullvisitorId and c.visitid=b.visitid and c.date=b.date
         where c.hits>b.hits
         group each by 1,2,3
    ) a on a.fullvisitorId=b.fullvisitorId and a.visitId=b.visitId and a.date=b.date

/*********************************CR2 Complete***********************/

left join each

    (
      select c.date as date,
            c.fullVisitorId as fullVisitorId,
            c.visitId as visitId,
            count(c.hits) as CR2_completion

      from

        (
          Select date,
                 fullVisitorId,
                 visitId,
                 max(hits.hitnumber) as hits
          from TABLE_DATE_RANGE([96340741.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

          where REGEXP_MATCH(hits.appInfo.screenName,'Restaurant[^s]|Menu|menu')
          group each by 1,2,3
        ) c

join each

      (
        Select date,
                fullVisitorId,
                visitId,
                min(hits.hitnumber) as hits
         from TABLE_DATE_RANGE([96340741.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

         where REGEXP_MATCH(hits.appInfo.screenName,'Restaurants')
         group each  by 1,2,3
       ) b on c.fullvisitorId=b.fullvisitorId and c.visitid=b.visitid and c.date=b.date
         where c.hits>b.hits
         group each by 1,2,3
    ) cr2_compl on cr2_compl.fullvisitorId=b.fullvisitorId and cr2_compl.visitId=b.visitId and cr2_compl.date=b.date

join each

      (
        select a.*
        from
            flatten (
                      (
                        select date,
                               fullVisitorId,
                               unique (visitId) as visitid,
                              'Russia' as country,
                               device.operatingSystem,
                               case when device.operatingSystem='Android' OR device.operatingSystem='iOS' then 'APP' end as platform_agg,
                               case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
                               case when trafficSource.source='(direct)' and trafficSource.medium='(none)' then 'direct'
                                    when trafficSource.source='push' and trafficSource.medium='push' then 'push' else 'others'end as channel,


                        from TABLE_DATE_RANGE([96340741.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
                        group each by 1,2,4,5,6,7,8
                       ), visitid
                     ) a
        ) countries on b.fullvisitorid=countries.fullvisitorId and b.visitid=countries.visitid and b.date=countries.date

left join each

        (select a.* from
        flatten (
        (select fullVisitorId, unique (visitId) as visitid, hits.customDimensions.value as city
        from TABLE_DATE_RANGE([96340741.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
        where hits.customDimensions.index=3
        group each by 1,3), visitid) a) cities

        on cities.fullvisitorid=b.fullvisitorid and cities.visitid=b.visitid

        group each by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16

) app
) as dc_app

,
/************************************ EATOYE PAKISTAN WEB QUERY *******************************************/

(Select * from
(Select date(b.date) as ga_date,
        year(CAST(b.date AS TIMESTAMP)) as ga_year,
        case when b.date in('20160101','20160102') then '2015-53' else case when length(string(week(CAST(b.date AS TIMESTAMP))))=1 then CONCAT(string(year(CAST(b.date AS TIMESTAMP))),'-0',string(week(CAST(b.date AS TIMESTAMP)))) else CONCAT(string(year(CAST(b.date AS TIMESTAMP))),'-',string(week(CAST(b.date AS TIMESTAMP)))) end end as ga_week,
        case when dayofweek(CAST(b.date AS TIMESTAMP))=1 then '1.Sunday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=2 then '2.Monday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=3 then '3.Tuesday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=4 then '4.Wednesday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=5 then '5.Thursday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=6 then '6.Friday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=7 then '7.Saturday' else 'none'
        END as ga_day,
        countries.country as country,
        "Pakistan(Eat-Oye)" as common_name,
        b.device.deviceCategory as platform,
        b.platform_agg as platform_agg,
        'N/A' as appVersion,
        b.users as user_type,
        countries.channel as channel,
        'N/A' as landing_page,
        'N/A' as sorting,
        'N/A' as language,
        'null' as city,
        'null' as area,
        sum(b.sessions) as visits,
        sum(b.gross_orders) as orders,
        sum(b.CR1_start) as hp_rlp_start,
        INTEGER(sum(cr1_compl.CR1_completion)) as hp_rlp_complete,
        sum(b.CR2_start) as rlp_rdp_start,
        INTEGER(sum(cr2_compl.CR2_completion)) as rlp_rdp_complete,
        sum(b.CR3_start) as rdp_co_start,
        INTEGER(sum(cr3_compl.CR3_completion)) as rdp_co_complete,
        sum(b.CR4_start) as co_so_start,
        INTEGER(sum(cr4_compl.CR4_completion)) as co_so_complete
  from

     (        select date,
              fullvisitorId,
              visitId,
              device.deviceCategory,
              case when device.deviceCategory='desktop' OR device.deviceCategory='tablet' OR device.deviceCategory='mobile' then 'WEB' end as platform_agg,
              case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
              sum(totals.visits) as sessions,
              sum(totals.transactions) as gross_orders,
              case when sum(case when(regexp_match(hits.page.pagePath,'^/home')) then 1 else 0 end)>=1 then 1 else 0 end as CR1_start,
              case when sum(case when(regexp_match(hits.page.pagePath,'(/delivery|/allrestaurants)')) then 1 else 0 end)>=1 then 1 else 0 end as CR2_start,
              case when sum(case when(regexp_match(hits.page.pagePath,'^/restaurant/')) then 1 else 0 end)>=1 then 1 else 0 end as CR3_start,
              case when sum(case when(regexp_match(hits.page.pagePath,'^/cart$')) then 1 else 0 end)>=1 then 1 else 0 end as CR4_start,
              case when sum(case when(regexp_match(hits.page.pagePath,'^/thanks$')) then 1 else 0 end)>=1 then 1 else 0 end as CR4_complete
       from TABLE_DATE_RANGE([98946202.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
       group each by 1,2,3,4,5,6

     )b

/********************* joining CR1 complete **************************/

left join each

    (
      select c.date as date,
            c.fullVisitorId as fullVisitorId,
            c.visitId as visitId,
            count(c.hits) as CR1_completion

      from

        (
          Select date,
                 fullVisitorId,
                 visitId,
                 max(hits.hitnumber) as hits
          from TABLE_DATE_RANGE([98946202.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

          where regexp_match(hits.page.pagePath,'(/delivery|/allrestaurants)')
          group each by 1,2,3
        ) c

join each

      (
        Select date,
                fullVisitorId,
                visitId,
                min(hits.hitnumber) as hits
         from TABLE_DATE_RANGE([98946202.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

         where regexp_match(hits.page.pagePath,'^/home')
         group each  by 1,2,3
       ) b on c.fullvisitorId=b.fullvisitorId and c.visitid=b.visitid and c.date=b.date
         where c.hits>b.hits
         group each by 1,2,3
    ) cr1_compl on cr1_compl.fullvisitorId=b.fullvisitorId and cr1_compl.visitId=b.visitId and cr1_compl.date=b.date

/********************* joining CR2 complete **************************/

    left join each

(
    select c.date as date,
           c.fullVisitorId as fullVisitorId,
           c.visitId as visitId,
           count(c.hits) as CR2_completion

      from

            (
              Select date,
                     fullVisitorId,
                     visitId,
                     max(hits.hitnumber) as hits
              from TABLE_DATE_RANGE([98946202.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

              where regexp_match(hits.page.pagePath,'^/restaurant/')
              group each by 1,2,3
            ) c

join each

            (
              Select  date,
                      fullVisitorId,
                      visitId,
                      min(hits.hitnumber) as hits
               from TABLE_DATE_RANGE([98946202.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

               where regexp_match(hits.page.pagePath,'(/delivery|/allrestaurants)')
               group each  by 1,2,3
             ) b
    on c.fullvisitorId=b.fullvisitorId and c.visitid=b.visitid and c.date=b.date
    where c.hits>b.hits
    group each by 1,2,3
) cr2_compl on cr2_compl.fullvisitorId=b.fullvisitorId and cr2_compl.visitId=b.visitId and cr2_compl.date=b.date


/******************* joining CR3 complete ********************/

left join each

(
      select  c.date as date,
              c.fullVisitorId as fullVisitorId,
              c.visitId as visitId,
              count(c.hits) as CR3_completion

      from

              (
                Select date,
                       fullVisitorId,
                       visitId,
                       max(hits.hitnumber) as hits
                from TABLE_DATE_RANGE([98946202.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

                where regexp_match(hits.page.pagePath,'^/cart$')
                group each by 1,2,3
              ) c

join each

              (
                Select date,
                        fullVisitorId,
                        visitId,
                        min(hits.hitnumber) as hits
                 from TABLE_DATE_RANGE([98946202.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

                 where regexp_match(hits.page.pagePath,'^/restaurant/')
                 group each  by 1,2,3
               ) b
   on c.fullvisitorId=b.fullvisitorId and c.visitid=b.visitid and c.date=b.date
   where c.hits>b.hits
   group each by 1,2,3
) cr3_compl on cr3_compl.fullvisitorId=b.fullvisitorId and cr3_compl.visitId=b.visitId and cr3_compl.date=b.date


/***************** joining CR4 complete **********************************/

left join each

(
      select  c.date as date,
              c.fullVisitorId as fullVisitorId,
              c.visitId as visitId,
              count(c.hits) as CR4_completion

      from

              (
                Select date,
                       fullVisitorId,
                       visitId,
                       max(hits.hitnumber) as hits
                from TABLE_DATE_RANGE([98946202.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

                where regexp_match(hits.page.pagePath,'^/thanks$')
                group each by 1,2,3
              ) c

join each

              (
                Select date,
                        fullVisitorId,
                        visitId,
                        min(hits.hitnumber) as hits
                 from TABLE_DATE_RANGE([98946202.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

                 where regexp_match(hits.page.pagePath,'^/cart$')
                 group each  by 1,2,3
               ) b
   on c.fullvisitorId=b.fullvisitorId and c.visitid=b.visitid and c.date=b.date
   where c.hits>b.hits
   group each by 1,2,3
) cr4_compl on cr4_compl.fullvisitorId=b.fullvisitorId and cr4_compl.visitId=b.visitId and cr4_compl.date=b.date


join each

      (

        select a.*
        from
            flatten (
                      (
                        select date,
                               fullVisitorId,
                               unique (visitId) as visitid,
                              'Pakistan' as country,
                               device.deviceCategory,
                               case when device.deviceCategory='desktop' OR device.deviceCategory='tablet' OR device.deviceCategory='mobile' then 'WEB' end as platform_agg,
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


                        from TABLE_DATE_RANGE([98946202.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

                        group each by 1,2,4,5,6,7,8
                       ), visitid
                     ) a
        ) countries on b.fullvisitorid=countries.fullvisitorId and b.visitid=countries.visitid and b.date=countries.date

        group each by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16

)  as web
) as eatoye_web

,

/************************************ UAE 24H WEB QUERY *******************************************/

(Select * from
(Select date(b.date) as ga_date,
        year(CAST(b.date AS TIMESTAMP)) as ga_year,
        case when b.date in('20160101','20160102') then '2015-53' else case when length(string(week(CAST(b.date AS TIMESTAMP))))=1 then CONCAT(string(year(CAST(b.date AS TIMESTAMP))),'-0',string(week(CAST(b.date AS TIMESTAMP)))) else CONCAT(string(year(CAST(b.date AS TIMESTAMP))),'-',string(week(CAST(b.date AS TIMESTAMP)))) end end as ga_week,
        case when dayofweek(CAST(b.date AS TIMESTAMP))=1 then '1.Sunday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=2 then '2.Monday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=3 then '3.Tuesday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=4 then '4.Wednesday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=5 then '5.Thursday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=6 then '6.Friday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=7 then '7.Saturday' else 'none'
        END as ga_day,
        countries.country as country,
        "UAE (24H)" as common_name,
        b.device.deviceCategory as platform,
        b.platform_agg as platform_agg,
        'N/A' as app_version,
        b.users as user_type,
        countries.channel as channel,
        'N/A' as landing_page,
        'N/A' as sorting,
        'N/A' as language,
        'null' as city,
        'null' as area,
        sum(b.sessions) as visits,
        sum(b.gross_orders) as orders,
        sum(b.CR1_start) as hp_rlp_start,
        sum(CR1_completion) as hp_rlp_complete,
        sum(b.CR2_start) as rlp_rdp_start,
        INTEGER(sum(cr2_compl.CR2_completion)) as rlp_rdp_complete,
        sum(b.CR3_start) as rdp_co_start,
        INTEGER(sum(cr3_compl.CR3_completion)) as rdp_co_complete,
        sum(b.CR4_start) as co_so_start,
        (sum(CR4_complete)) as co_so_complete
  from

     (        select date,
              fullvisitorId,
              visitId,
              device.deviceCategory,
              case when device.deviceCategory='desktop' OR device.deviceCategory='tablet' OR device.deviceCategory='mobile' then 'WEB' end as platform_agg,
              case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
              sum(totals.visits) as sessions,
              sum(totals.transactions) as gross_orders,
              case when sum(case when(regexp_match(hits.page.pagePath,'(^/$|^/\?.*|/site/index$|/site/index\?.*|/site/index/\?.*|/site/index.html$)')) then 1 else 0 end)>=1 then 1 else 0 end as CR1_start,
              case when sum(case when(regexp_match(hits.page.pagePath,'(searchRestaurant/|/virtualpageview/restaurants)')) then 1 else 0 end)>=1 then 1 else 0 end as CR1_completion,
              case when sum(case when(regexp_match(hits.page.pagePath,'(searchRestaurant/|/virtualpageview/restaurants)')) then 1 else 0 end)>=1 then 1 else 0 end as CR2_start,
              case when sum(case when(regexp_match(hits.page.pagePath,'/virtualpageview/restaurant$')) then 1 else 0 end)>=1 then 1 else 0 end as CR3_start,
              case when sum(case when(regexp_match(hits.page.pagePath,'/virtualpageview/checkout')) then 1 else 0 end)>=1 then 1 else 0 end as CR4_start,
              case when sum(case when(regexp_match(hits.page.pagePath,'/order/thank')) then 1 else 0 end)>=1 then 1 else 0 end as CR4_complete
       from TABLE_DATE_RANGE([94706414.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
       group each by 1,2,3,4,5,6

     )b

/********************* joining CR2 complete **************************/

    left join each

(
    select c.date as date,
           c.fullVisitorId as fullVisitorId,
           c.visitId as visitId,
           count(c.hits) as CR2_completion

      from

            (
              Select date,
                     fullVisitorId,
                     visitId,
                     max(hits.hitnumber) as hits
              from TABLE_DATE_RANGE([94706414.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

              where regexp_match(hits.page.pagePath,'/virtualpageview/restaurant$')
              group each by 1,2,3
            ) c

join each

            (
              Select  date,
                      fullVisitorId,
                      visitId,
                      min(hits.hitnumber) as hits
               from TABLE_DATE_RANGE([94706414.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

               where regexp_match(hits.page.pagePath,'(searchRestaurant/|/virtualpageview/restaurants)')
               group each  by 1,2,3
             ) b
    on c.fullvisitorId=b.fullvisitorId and c.visitid=b.visitid and c.date=b.date
    where c.hits>b.hits
    group each by 1,2,3
) cr2_compl on cr2_compl.fullvisitorId=b.fullvisitorId and cr2_compl.visitId=b.visitId and cr2_compl.date=b.date


/******************* joining CR3 complete ********************/

left join each

(
      select  c.date as date,
              c.fullVisitorId as fullVisitorId,
              c.visitId as visitId,
              count(c.hits) as CR3_completion

      from

              (
                Select date,
                       fullVisitorId,
                       visitId,
                       max(hits.hitnumber) as hits
                from TABLE_DATE_RANGE([94706414.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

                where regexp_match(hits.page.pagePath,'/virtualpageview/checkout')
                group each by 1,2,3
              ) c

join each

              (
                Select date,
                        fullVisitorId,
                        visitId,
                        min(hits.hitnumber) as hits
                 from TABLE_DATE_RANGE([94706414.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

                 where regexp_match(hits.page.pagePath,'/virtualpageview/restaurant$')
                 group each  by 1,2,3
               ) b
   on c.fullvisitorId=b.fullvisitorId and c.visitid=b.visitid and c.date=b.date
   where c.hits>b.hits
   group each by 1,2,3
) cr3_compl on cr3_compl.fullvisitorId=b.fullvisitorId and cr3_compl.visitId=b.visitId and cr3_compl.date=b.date




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
                               case when device.deviceCategory='desktop' OR device.deviceCategory='tablet' OR device.deviceCategory='mobile' then 'WEB' end as platform_agg,
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


                        from TABLE_DATE_RANGE([94706414.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
                       where hits.customDimensions.index=3
                        group each by 1,2,4,5,6,7,8
                       ), visitid
                     ) a
        ) countries on b.fullvisitorid=countries.fullvisitorId and b.visitid=countries.visitid and b.date=countries.date

        group each by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16

) as web
) as uae_web

,

/************************************ NETPINCER HUNGARY WEB QUERY *******************************************/

(Select * from
(Select date(b.date) as ga_date,
        year(CAST(b.date AS TIMESTAMP)) as ga_year,
        case when b.date in('20160101','20160102') then '2015-53' else case when length(string(week(CAST(b.date AS TIMESTAMP))))=1 then CONCAT(string(year(CAST(b.date AS TIMESTAMP))),'-0',string(week(CAST(b.date AS TIMESTAMP)))) else CONCAT(string(year(CAST(b.date AS TIMESTAMP))),'-',string(week(CAST(b.date AS TIMESTAMP)))) end end as ga_week,
        case when dayofweek(CAST(b.date AS TIMESTAMP))=1 then '1.Sunday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=2 then '2.Monday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=3 then '3.Tuesday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=4 then '4.Wednesday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=5 then '5.Thursday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=6 then '6.Friday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=7 then '7.Saturday' else 'none'
        END as ga_day,
        countries.country as country,
        "Hungary(Netpincer)" as common_name,
        b.device.deviceCategory as platform,
        b.platform_agg as platform_agg,
        'N/A' as app_version,
        b.users as user_type,
        countries.channel as channel,
        'N/A' as landing_page,
        'N/A' as sorting,
        'N/A' as language,
        case when cities.city like '%Budapest%' then 'Budapest' else cities.city end as city,
        'null' as area,
        sum(b.sessions) as visits,
        sum(b.gross_orders) as orders,
        sum(b.CR1_start) as hp_rlp_start,
        sum(b.CR1_completion) as hp_rlp_complete,
        sum(b.CR2_start) as rlp_rdp_start,
        sum(b.CR2_completion) as rlp_rdp_complete,
        sum(b.CR3_start) as rdp_co_start,
        sum(b.CR3_completion) as rdp_co_complete,
        sum(b.CR4_start) as co_so_start,
        sum(b.CR4_completion) as co_so_complete
  from

     (        select date,
              fullvisitorId,
              visitId,
              device.deviceCategory,
              case when device.deviceCategory='desktop' OR device.deviceCategory='tablet' OR device.deviceCategory='mobile' then 'WEB' end as platform_agg,
              case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
              sum(totals.visits) as sessions,
              sum(totals.transactions) as gross_orders,
              case when sum(case when(regexp_match(hits.page.pagePath,'^/$')) then 1 else 0 end)>=1 then 1 else 0 end as CR1_start,
              case when sum(case when(regexp_match(hits.page.pagePath,'^/hazhozszallitas/')) then 1 else 0 end)>=1 then 1 else 0 end as CR1_completion,
              case when sum(case when(regexp_match(hits.page.pagePath,'^/hazhozszallitas/')) then 1 else 0 end)>=1 then 1 else 0 end as CR2_start,
              case when sum(case when(regexp_match(hits.page.pagePath,'/etlap')) then 1 else 0 end)>=1 then 1 else 0 end as CR2_completion,
              case when sum(case when(regexp_match(hits.page.pagePath,'/etlap')) then 1 else 0 end)>=1 then 1 else 0 end as CR3_start,
              case when sum(case when(regexp_match(hits.page.pagePath,'/rendeles-ellenorzes')) then 1 else 0 end)>=1 then 1 else 0 end as CR3_completion,
              case when sum(case when(regexp_match(hits.page.pagePath,'/rendeles-ellenorzes')) then 1 else 0 end)>=1 then 1 else 0 end as CR4_start,
              case when sum(case when(regexp_match(hits.page.pagePath,'/sikeres-rendeles')) then 1 else 0 end)>=1 then 1 else 0 end as CR4_completion
       from TABLE_DATE_RANGE([95325133.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
       group each by 1,2,3,4,5,6

     )b


join each

      (

        select a.*
        from
            flatten (
                      (
                        select date,
                               fullVisitorId,
                               unique (visitId) as visitid,
                              'Hungary' as country,
                               device.deviceCategory,
                               case when device.deviceCategory='desktop' OR device.deviceCategory='tablet' OR device.deviceCategory='mobile' then 'WEB' end as platform_agg,
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


                        from TABLE_DATE_RANGE([95325133.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

                        group each by 1,2,4,5,6,7,8
                       ), visitid
                     ) a
        ) countries on b.fullvisitorid=countries.fullvisitorId and b.visitid=countries.visitid and b.date=countries.date

left join each

        (select a.* from
        flatten (
        (select fullVisitorId, unique (visitId) as visitid, hits.customDimensions.value as city
        from TABLE_DATE_RANGE([95325133.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
        where hits.customDimensions.index=9
        group each by 1,3), visitid) a) cities

        on cities.fullvisitorid=b.fullvisitorid and cities.visitid=b.visitid

        group each by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16

)  as web
) as npc_web

,


/************************************ NETPINCER HUNGARY APP QUERY *******************************************/

(Select * from
(Select date(b.date) as ga_date,
        year(CAST(b.date AS TIMESTAMP)) as ga_year,
        case when b.date in('20160101','20160102') then '2015-53' else case when length(string(week(CAST(b.date AS TIMESTAMP))))=1 then CONCAT(string(year(CAST(b.date AS TIMESTAMP))),'-0',string(week(CAST(b.date AS TIMESTAMP)))) else CONCAT(string(year(CAST(b.date AS TIMESTAMP))),'-',string(week(CAST(b.date AS TIMESTAMP)))) end end as ga_week,
        case when dayofweek(CAST(b.date AS TIMESTAMP))=1 then '1.Sunday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=2 then '2.Monday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=3 then '3.Tuesday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=4 then '4.Wednesday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=5 then '5.Thursday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=6 then '6.Friday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=7 then '7.Saturday' else 'none'
        END as ga_day,
        countries.country as country,
        'Hungary(Netpincer)' as common_name,
        b.device.operatingSystem as platform,
        b.platform_agg as platform_agg,
        b.appVersion as app_version,
        b.Users as user_type,
        countries.channel as channel,
        'N/A' as landing_page,
        'N/A' as sorting,
        'N/A' as language,
        case when cities.city like '%Budapest%' then 'Budapest' else cities.city end as city,
        'null' as area,
        sum(b.sessions) as visits,
        sum(b.gross_orders) as orders,
        sum(CR1_start) as hp_rlp_start,
        INTEGER(sum(CR1_complete)) as hp_rlp_complete,
        sum(b.CR2_start) as rlp_rdp_start,
        sum(b.CR3_start) as rlp_rdp_complete,
        sum(b.CR3_start) as rdp_co_start,
        sum(b.CR4_start) as rdp_co_complete,
        sum(b.CR4_start) as co_so_start,
        sum(b.CR4_complete) as co_so_complete
  from

     ( select date,
              fullvisitorId,
              visitId,
              device.operatingSystem,
              hits.appInfo.appVersion as appVersion,
              case when device.operatingSystem='Android' OR device.operatingSystem='iOS' then 'APP' end as platform_agg,
              case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
              sum(totals.visits) as sessions,
              sum(totals.transactions) as gross_orders,
              case when sum(case when(REGEXP_MATCH(hits.appInfo.ScreenName,'Main Dashboard Screen')) then 1 else 0 end)>=1 then 1 else 0 end as CR1_start,
              case when sum(case when(REGEXP_MATCH(hits.appInfo.ScreenName,'Restaurants')) then 1 else 0 end)>=1 then 1 else 0 end as CR2_start,
              case when sum(case when(REGEXP_MATCH(hits.appInfo.ScreenName,'Restaurant[^s]')) then 1 else 0 end)>=1 then 1 else 0 end as CR3_start,
              case when sum(case when(REGEXP_MATCH(hits.appInfo.ScreenName,'Cart Screen')) then 1 else 0 end)>=1 then 1 else 0 end as CR4_start,
              case when sum(case when(REGEXP_MATCH(hits.appInfo.ScreenName,'^(Checkout Screen|Delivery Method Screen|Email Verification Screen|Address Book Screen|User Details Screen)')) then 1 else 0 end)>=1 then 1 else 0 end as CR4_complete
       from TABLE_DATE_RANGE([96332490.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

       group each by 1,2,3,4,5,6,7

     )b

/*********************joining CR1 complete**************************/

left join each

    (
      select c.date as date,
             c.fullVisitorId as fullVisitorId,
             c.visitId as visitId,
             count(c.hits) as CR1_complete

      from

        (
          Select date,
                 fullVisitorId,
                 visitId,
                 max(hits.hitnumber) as hits
          from TABLE_DATE_RANGE([96332490.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

          where REGEXP_MATCH(hits.appInfo.screenName,'Restaurants')
          group each by 1,2,3
        ) c

join each

      (
        Select date,
                fullVisitorId,
                visitId,
                min(hits.hitnumber) as hits
         from TABLE_DATE_RANGE([96332490.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

         where REGEXP_MATCH(hits.appInfo.screenName,'Main Dashboard Screen')
         group each  by 1,2,3
       ) b on c.fullvisitorId=b.fullvisitorId and c.visitid=b.visitid and c.date=b.date
         where c.hits>b.hits
         group each by 1,2,3
    ) a on a.fullvisitorId=b.fullvisitorId and a.visitId=b.visitId and a.date=b.date


join each

      (
        select a.*
        from
            flatten (
                      (
                        select date,
                               fullVisitorId,
                               unique (visitId) as visitid,
                               'Hungary' as country,
                               device.operatingSystem,
                               case when device.operatingSystem='Android' OR device.operatingSystem='iOS' then 'APP' end as platform_agg,
                               case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
                               case when trafficSource.source='(direct)' and trafficSource.medium='(none)' then 'direct'
                                    when trafficSource.source='push' and trafficSource.medium='push' then 'push' else 'others'
                               END AS channel,

                        from TABLE_DATE_RANGE([96332490.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

                        group each by 1,2,4,5,6,7,8
                       ), visitid
                     ) a
        ) countries on b.fullvisitorid=countries.fullvisitorId and b.visitid=countries.visitid and b.date=countries.date

left join each

        (select a.* from
        flatten (
        (select fullVisitorId, unique (visitId) as visitid, hits.customDimensions.value as city
        from TABLE_DATE_RANGE([96332490.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
        where hits.customDimensions.index=3
        group each by 1,3), visitid) a) cities

        on cities.fullvisitorid=b.fullvisitorid and cities.visitid=b.visitid

        group each by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16
) app
) as npc_app
