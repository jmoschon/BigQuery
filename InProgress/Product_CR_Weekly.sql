/* WEEKLY REPORT PRODUCT*/

    /**************  FOODPANDA/HELLOFOOD/OTLOB WEB **************/
    select *
    from
    (select * from (
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
            a.users as user_type,
            countries.channel as channel,
            countries.landing_page as landing_page,
            ab_sorting.sorting as sorting,
            language.language as language,
            dim_area.city as city,
            dim_area.area as area,
            case when (sessionsWithRLP<1 and sessionsWithRDP>0) then 'non' else (case when sessionsWithAccount>0 and sessionsWithRLP<1 then 'non' else 'valid' end) end as sessionChecker,
            SUM(case when (sessionsWithRLP_RPD<1 and sessionsWithOrderStatus>0) then 0 else a.sessions end) as visits,
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
              case when device.devicecategory='tablet' OR device.devicecategory='mobile' OR device.devicecategory='desktop' then 'WEB' end as platform_agg,
              case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
              sum(totals.visits) as sessions,
              sum(totals.transactions) as gross_orders,

              sum(case when(regexp_match(hits.page.pagePath,'/restaurant')) then 1 else 0 end) as sessionsWithRLP_RPD,
              sum(case when (regexp_match(hits.page.pagePath,'/finishorder')) then 1 else 0 end ) as sessionsWithOrderStatus,
              sum(case when (regexp_match(hits.page.pagePath,'/customer/')) then 1 else 0 end ) as sessionsWithAccount,
              sum(case when (regexp_match(hits.page.pagePath,'/restaurant/')) then 1 else 0 end ) as sessionsWithRDP,
              sum(case when (regexp_match(hits.page.pagePath,'/restaurants')) then 1 else 0 end ) as sessionsWithRLP,


              case when sum(case when regexp_match(Regexp_extract(hits.page.pagePath,r'^(?:[^/]*/){1}([^/]*)/?'),'^($|\\?.*|..$|../\\?.*)')  then 1 else 0 end)>=1 then 1 else 0 end as CR1_start,
              case when sum(case when regexp_match(hits.page.pagePath,'/restaurants') then 1 else 0 end)>=1 then 1 else 0 end as CR1_completion,
              case when sum(case when regexp_match(hits.page.pagePath,'/restaurants') then 1 else 0 end)>=1 then 1 else 0 end as CR2_start,
              case when sum(case when regexp_match(hits.page.pagePath,'/restaurant/') then 1 else 0 end)>=1 then 1 else 0 end as CR2_completion,
              case when sum(case when regexp_match(hits.page.pagePath,'/restaurant/') then 1 else 0 end)>=1 then 1 else 0 end as CR3_start,
              case when sum(case when regexp_match(hits.page.pagePath,'review-order/') then 1 else 0 end)>=1 then 1 else 0 end as CR3_completion,
              case when sum(case when regexp_match(hits.page.pagePath,'review-order/') then 1 else 0 end)>=1 then 1 else 0 end as CR4_start,
              case when sum(case when regexp_match(hits.page.pagePath,'/finishorder')then 1 else 0 end)>=1 then 1 else 0 end as CR4_completion,

        from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108857524.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
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

                           from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108857524.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
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
    from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')),TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
    where hits.customDimensions.index=1
    group each by 1,3,4), visitid) a) area_id

    on area_id.fullvisitorid=a.fullvisitorid and area_id.visitid=a.visitid

    /*add sorting */

    left join each

    (select a.* from
    flatten (
    (select fullVisitorId, unique (visitId) as visitid, hits.customDimensions.value as sorting
    from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')),TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
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

                           from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')),TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
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

    where (countries.landing_page='landing_homepage')
    group each by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16) where sessionChecker='valid' )as web
,


/************** FOODPANDA/HELLOFOOD/OTLOB APP **************/



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
        b.Users as user_type,
        countries.channel as channel,
        countries.landing_page as landing_page,
        'a' as sorting,
        b.language as language,
        dim_area.city as city,
        dim_area.area as area,
        case when (sessionsWithRLP<1 and sessionsWithRDP>0) then 'non' else (case when sessionsWithAccount>0 and sessionsWithRLP<1 then 'non' else 'valid' end) end as sessionChecker,
        sum(case when (sessionsWithRLP_RPD<1 and sessionsWithOrderStatus>0) then 0 else b.sessions end) as visits,
        sum(b.gross_orders) as orders,
        sum(CR1_start) as hp_rlp_start,
        INTEGER(sum(CR2_start)) as hp_rlp_complete,
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
              case when device.operatingSystem='Android' OR device.operatingSystem='iOS' then 'APP' end as platform_agg,
              case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
              upper(regexp_extract(device.language,r'([^_]*)')) as language,
              sum(totals.visits) as sessions,
              sum(totals.transactions) as gross_orders,

              sum(case when(regexp_match(hits.appInfo.ScreenName,'Restaurant')) then 1 else 0 end) as sessionsWithRLP_RPD,
              sum(case when (regexp_match(hits.appInfo.ScreenName,'Order Status Screnn')) then 1 else 0 end ) as sessionsWithOrderStatus,
              sum(case when (regexp_match(hits.appInfo.ScreenName,'Account Screen|Recover Your Account Screen')) then 1 else 0 end ) as sessionsWithAccount,
              sum(case when (regexp_match(hits.appInfo.ScreenName,'Restaurant[^s]')) then 1 else 0 end ) as sessionsWithRDP,
              sum(case when (regexp_match(hits.appInfo.ScreenName,'Restaurants')) then 1 else 0 end ) as sessionsWithRLP,

              case when sum(case when(REGEXP_MATCH(hits.appInfo.ScreenName,('Onboarding|Location'))) then 1 else 0 end)>=1 then 1 else 0 end as CR1_start,
              case when sum(case when(REGEXP_MATCH(hits.appInfo.ScreenName,'Restaurants')) then 1 else 0 end)>=1 then 1 else 0 end as CR2_start,
              case when sum(case when(REGEXP_MATCH(hits.appInfo.ScreenName,'Restaurant[^s]')) then 1 else 0 end)>=1 then 1 else 0 end as CR3_start,
              case when sum(case when(REGEXP_MATCH(hits.appInfo.ScreenName,'^(Checkout Screen|Delivery Method Screen|Email Verification Screen|Address Book Screen|User Details Screen|SMS Verification Screen|Enter Phone Number Screen)')) then 1 else 0 end)>=1 then 1 else 0 end as CR4_start,
              case when sum(case when(REGEXP_MATCH(hits.appInfo.ScreenName,'^Checkout Confirmation Screen|Order Summary Screen')) then 1 else 0 end)>=1 then 1 else 0 end as CR4_complete
       from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
       group each by 1,2,3,4,5,6,7

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
                                    when regexp_match(hits.appInfo.landingscreenName,'Onboarding|Location') then'landing_homepage' else 'landing_other'
                               END AS landing_page
                        from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
                        where hits.customDimensions.index=1
                        group each by 1,2,4,5,6,7,8,9,10
                       ), visitid
                     ) a
        ) countries on b.fullvisitorid=countries.fullvisitorId and b.visitid=countries.visitid and b.date=countries.date

/*add city and area*/

left join each

(select a.* from
flatten (
(select fullVisitorId, unique (visitId) as visitid, regexp_extract(hits.customDimensions.value,r'([^_]*)') as city_id, regexp_extract(hits.customDimensions.value,r'_(.*)') as area_id
from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
where hits.customDimensions.index=11
group each by 1,3,4), visitid) a) area_id

on area_id.fullvisitorid=b.fullvisitorid and area_id.visitid=b.visitid

join each [CR_team.iso_common_countries] iso
on countries.country=iso.iso

left join [CR_team.dim_area] dim_area
on dim_area.area_id = area_id.area_id and dim_area.common_name = iso.common_name

where (countries.landing_page='landing_homepage')
group each by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16
) foodpanda
where sessionChecker='valid'
) as app


