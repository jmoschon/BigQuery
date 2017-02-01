select *

from
(
select a.country as country,
       a.city_id as city_id, 
       a.area_id as area_id,
       a.operatingsystem as OperatingSystem,
       a.vendor_id as vendor_id,
       '' as vendor_code,
       a.date as date,
       'APP' as platform,
       a.channel as medium,
       '' as landingpage,
       a.visits as CR3_start,
       b.visits as CR3_completion,
       c.visits as CR4_completion
       from
/***********************CR3 START*********************************/
(select area_id.area_id as area_id, area_id.city_id as city_id, vendor_visits.date as date ,vendor_visits.vendor_id as vendor_id, countries.country as country,vendor_visits.device.operatingSystem as operatingSystem, vendor_visits.Users as Users, vendor_visits.channel as channel, sum(vendor_visit) visits from
      (
        select a.*
        from
            flatten (
            
                      (
                        select date,
                               fullVisitorId,
                               unique (visitId) as visitid,
                               upper(hits.customDimensions.value) as vendor_id,
                               1 as vendor_visit,
                               device.operatingSystem,
                               hits.eventInfo.eventAction,
                               case when device.operatingSystem='Android' OR device.operatingSystem='iOS' then 'APP' end as platform_agg,
                               case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
                               case when trafficSource.source='(direct)' and trafficSource.medium='(none)' then 'direct'
                                    when trafficSource.source='push' and trafficSource.medium='push' then 'push'else 'others'
                               END AS channel,

                        from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
                         where REGEXP_MATCH(hits.eventInfo.eventAction,'(Restaurant Detail Page)') and hits.customDimensions.index=15
                        group each by 1,2,4,5,6,7,8,9,10
                       ), visitid
                     ) a
        ) vendor_visits

      /*country*/
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

                        from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
                        where hits.customDimensions.index=1 
                        group each by 1,2,4,5,6,7,8
                       ), visitid
                     ) a
        ) countries on vendor_visits.fullvisitorid=countries.fullvisitorId and vendor_visits.visitid=countries.visitid 
      /*area_id and city_id*/
      left join each
            (select a.* from
            flatten (
            (select fullVisitorId, unique (visitId) as visitid, regexp_extract(hits.customDimensions.value,r'([^_]*)') as city_id, regexp_extract(hits.customDimensions.value,r'_(.*)') as area_id
from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), 
TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
            where hits.customDimensions.index=11
            group each by 1,3,4), visitid) a) area_id

on area_id.fullvisitorid=vendor_visits.fullvisitorid and area_id.visitid=vendor_visits.visitid
        group by 1,2,3,4,5,6,7,8
        ) a
        
        /****************CR3 COMPLETION***************/
        left join
        
        (select area_id.area_Id as area_id ,area_id.city_id as city_id,vendor_visits.date as date,vendor_visits.vendor_id as vendor_id, countries.country as country,vendor_visits.device.operatingSystem as operatingSystem, vendor_visits.Users as Users, vendor_visits.channel as channel, sum(vendor_visit) visits from
      (
        select a.*
        from
            flatten (
                      (
                        select date,
                               fullVisitorId,
                               unique (visitId) as visitid,
                               upper(hits.customDimensions.value) as vendor_id,
                               1 as vendor_visit,
                               device.operatingSystem,
                               hits.eventInfo.eventAction,
                               case when device.operatingSystem='Android' OR device.operatingSystem='iOS' then 'APP' end as platform_agg,
                               case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
                               case when trafficSource.source='(direct)' and trafficSource.medium='(none)' then 'direct'
                                    when trafficSource.source='push' and trafficSource.medium='push' then 'push'else 'others'
                               END AS channel,

                        from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
                         where REGEXP_MATCH(hits.eventInfo.eventAction,'(Checkout)') and hits.customDimensions.index= 15
                        group each by 1,2,4,5,6,7,8,9,10
                       ), visitid
                     ) a
        ) vendor_visits

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

                        from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
                        where hits.customDimensions.index=1 
                        group each by 1,2,4,5,6,7,8
                       ), visitid
                     ) a
        ) countries on vendor_visits.fullvisitorid=countries.fullvisitorId and vendor_visits.visitid=countries.visitid 
      left join each
            (select a.* from
            flatten (
            (select fullVisitorId, unique (visitId) as visitid, regexp_extract(hits.customDimensions.value,r'([^_]*)') as city_id, regexp_extract(hits.customDimensions.value,r'_(.*)') as area_id
            from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), 
            TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
            where hits.customDimensions.index=11
            group each by 1,3,4), visitid) a) area_id

on area_id.fullvisitorid=vendor_visits.fullvisitorid and area_id.visitid=vendor_visits.visitid
        group by 1,2,3,4,5,6,7,8
        ) b
        
        on  a.area_id=b.area_id and a.city_id=b.city_id and a.vendor_id = b.vendor_id and a.date = b.date and a.country = b.country and a.operatingsystem=b.operatingsystem and a.users=b.users and a.channel=b.channel
        /*********************CR4 COMPLETION************************/
        left join
        
        (select area_id.area_id as area_id,area_id.city_id as city_id,vendor_visits.date as date,vendor_visits.vendor_id as vendor_id, countries.country as country,vendor_visits.device.operatingSystem as operatingSystem, vendor_visits.Users as Users, vendor_visits.channel as channel, sum(vendor_visit) visits from
      (
        select a.*
        from
            flatten (
                      (
                        select date,
                               fullVisitorId,
                               unique (visitId) as visitid,
                               upper(hits.customDimensions.value) as vendor_id,
                               1 as vendor_visit,
                               device.operatingSystem,
                               hits.eventInfo.eventAction,
                               case when device.operatingSystem='Android' OR device.operatingSystem='iOS' then 'APP' end as platform_agg,
                               case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
                               case when trafficSource.source='(direct)' and trafficSource.medium='(none)' then 'direct'
                                    when trafficSource.source='push' and trafficSource.medium='push' then 'push'else 'others'
                               END AS channel,

                        from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
                         where REGEXP_MATCH(hits.eventInfo.eventAction,'(Transaction)') and hits.customDimensions.index=15
                        group each by 1,2,4,5,6,7,8,9,10
                       ), visitid
                     ) a
        ) vendor_visits

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

                        from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
                        where hits.customDimensions.index=1 
                        group each by 1,2,4,5,6,7,8
                       ), visitid
                     ) a
        ) countries on vendor_visits.fullvisitorid=countries.fullvisitorId and vendor_visits.visitid=countries.visitid 
      left join each
            (select a.* from
            flatten (
            (select fullVisitorId, unique (visitId) as visitid, regexp_extract(hits.customDimensions.value,r'([^_]*)') as city_id, regexp_extract(hits.customDimensions.value,r'_(.*)') as area_id
from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), 
TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
            where hits.customDimensions.index=11
            group each by 1,3,4), visitid) a) area_id

on area_id.fullvisitorid=vendor_visits.fullvisitorid and area_id.visitid=vendor_visits.visitid
        group by 1,2,3,4,5,6,7,8
        ) c
        
        on  a.area_id=c.area_id and a.area_id=c.area_id and  a.vendor_id = c.vendor_id and a.date = c.date and a.country = c.country and a.operatingsystem=c.operatingsystem and c.users=b.users and a.channel=c.channel

)

/*
__      __  ___   ___
\ \    / / | __| | _ )
 \ \/\/ /  | _|  | _ \
  \_/\_/   |___| |___/

*/


,(
select cr3_start.country as country, 
        cr3_start.city_id as city_id ,
        cr3_start.area_id as area_id, 
        '' as OperatingSystem, 
        '' as vendor_id ,
        cr3_start.vendor_code as vendor_code ,
        cr3_start.date as date,
        'WEB' as platform,
        cr3_start.medium as medium,
        cr3_start.landingpage as landingpage,
        INTEGER(cr3_start.visits) as CR3_start,
        cr3_compl.visits as CR3_completion,
        cr4_compl.visits as CR4_completion
        
        from
/***************CR3 START****************/
(select countries.country as country,area_id.area_id as area_id,area_id.city_id as city_id,vendor_visits.date as date,vendor_code, countries.medium as medium ,landingpage , sum(vendor_visit) visits from
      (
        select a.*
        from
            flatten (
            
                      (
                        select date,
                               fullVisitorId,
                               unique (visitId) as visitid,
                               regexp_extract(hits.page.pagePath,'(?:/(?:restaurant|checkout|review-order|order/finishorder)/([^/]*))') as vendor_code ,
                               1 as vendor_visit,
                        from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
                         where  regexp_match(hits.page.pagePath,'/restaurant/') and hits.customDimensions.index=15
                        group each by 1,2,4,5
                       ), visitid
                     ) a
        ) vendor_visits

  inner join each/*country*/
    (

    select *
    from
    (
    select fullVisitorId,visitId, upper(hits.customDimensions.value)
     as country,case when visitNumber=1 then "New Visitor" else "Returning Visitor" end as user_type
      ,case when trafficSource.medium in ('organic', 'cpc', 'affiliate', 'referral' , 'display') then trafficSource.medium
      when trafficSource.medium in ('newsletter', 'Newsletter', 'email') then 'newsletter/email'
      else 'other'
      end as medium
      ,case when REGEXP_MATCH(hits.appInfo.landingScreenName,('.*/$|.*/[?].*')) then 'HP'
             when REGEXP_MATCH(hits.appInfo.landingScreenName,('.*/restaurants/.*|.*/.*/restaurants/.*|.*/restaurants.*')) then 'RLP'
             when REGEXP_MATCH(hits.appInfo.landingScreenName,('.*/restaurant/.*'))  then 'RDP'
             else 'other' end as landingPage
    from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')),
    TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108857524.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
    where hits.customDimensions.index=3
    group by 1,2,3,4,5,6
    )

    ) as countries on vendor_visits.fullvisitorid=countries.fullvisitorId and vendor_visits.visitid=countries.visitid 
left join each

(select a.* from
flatten (
(select fullVisitorId, unique (visitId) as visitid, regexp_extract(hits.customDimensions.value,r'([^_]*)') as city_id, regexp_extract(hits.customDimensions.value,r'_(.*)') as area_id
from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')),TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108857524.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
where hits.customDimensions.index=1
group each by 1,3,4), visitid) a) area_id

on area_id.fullvisitorid=vendor_visits.fullvisitorid and area_id.visitid=vendor_visits.visitid
    group by  1,2,3,4,5,6,7
      )cr3_start
/*****************CR3 COMPLETION*********/
      
      left join

(select countries.country as country,area_id.area_id as area_id,area_id.city_id as city_id,vendor_visits.date,vendor_code, countries.medium ,landingpage, sum(vendor_visit) visits from
      (
        select a.*
        from
            flatten (
            
                      (
                        select date,
                               fullVisitorId,
                               unique (visitId) as visitid,
                               regexp_extract(hits.page.pagePath,'(?:/(?:restaurant|checkout|review-order|order/finishorder)/([^/]*))') as vendor_code ,
                               1 as vendor_visit,
                        from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
                         where  regexp_match(hits.page.pagePath,'checkout|review-order|login') --and hits.customDimensions.index=15
                        group each by 1,2,4,5
                       ), visitid
                     ) a
        ) vendor_visits

  inner join each/*country*/
    (

    select *
    from
    (
    select fullVisitorId,visitId, upper(hits.customDimensions.value)
     as country,case when visitNumber=1 then "New Visitor" else "Returning Visitor" end as user_type
      ,case when trafficSource.medium in ('organic', 'cpc', 'affiliate', 'referral' , 'display') then trafficSource.medium
      when trafficSource.medium in ('newsletter', 'Newsletter', 'email') then 'newsletter/email'
      else 'other'
      end as medium
      ,case when REGEXP_MATCH(hits.appInfo.landingScreenName,('.*/$|.*/[?].*')) then 'HP'
             when REGEXP_MATCH(hits.appInfo.landingScreenName,('.*/restaurants/.*|.*/.*/restaurants/.*|.*/restaurants.*')) then 'RLP'
             when REGEXP_MATCH(hits.appInfo.landingScreenName,('.*/restaurant/.*'))  then 'RDP'
             else 'other' end as landingPage
    from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')),
    TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108857524.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
    where hits.customDimensions.index=3
    group by 1,2,3,4,5,6
    )

    ) as countries on vendor_visits.fullvisitorid=countries.fullvisitorId and vendor_visits.visitid=countries.visitid 
left join each

  (select a.* from
  flatten (
  (select fullVisitorId, unique (visitId) as visitid, regexp_extract(hits.customDimensions.value,r'([^_]*)') as city_id, regexp_extract(hits.customDimensions.value,r'_(.*)') as area_id
  from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')),TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108857524.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
  where hits.customDimensions.index=1
  group each by 1,3,4), visitid) a) area_id

    on area_id.fullvisitorid=vendor_visits.fullvisitorid and area_id.visitid=vendor_visits.visitid
    group by  1,2,3,4,5,6,7
      )cr3_compl

      on  cr3_start.area_id=cr3_compl.area_id and cr3_start.city_id=cr3_compl.city_id and cr3_start.date=cr3_compl.date and cr3_start.country= cr3_compl.country and cr3_start.landingpage=cr3_compl.landingpage and
          cr3_start.medium=cr3_compl.medium and cr3_start.vendor_code=cr3_compl.vendor_code
      
/****************CR4 COMPLETION ***********/
      left join

(select countries.country as country,area_id.area_id as area_id,area_id.city_id as city_id,vendor_visits.date,vendor_code, countries.medium ,landingpage, sum(vendor_visit) visits from
      (
        select a.*
        from  
            flatten (
            
                      (
                        select date,
                               fullVisitorId,
                               unique (visitId) as visitid,
                               regexp_extract(hits.page.pagePath,'(?:/(?:restaurant|checkout|review-order|order/finishorder)/([^/]*))') as vendor_code ,
                               1 as vendor_visit,
                        from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
                         where  regexp_match(hits.page.pagePath,'/finishorder/') --and hits.customDimensions.index=15
                        group each by 1,2,4,5
                       ), visitid
                     ) a
        ) vendor_visits

  inner join each/*country*/
    (

    select *
    from
    (
    select fullVisitorId,visitId, upper(hits.customDimensions.value)
     as country,case when visitNumber=1 then "New Visitor" else "Returning Visitor" end as user_type
      ,case when trafficSource.medium in ('organic', 'cpc', 'affiliate', 'referral' , 'display') then trafficSource.medium
      when trafficSource.medium in ('newsletter', 'Newsletter', 'email') then 'newsletter/email'
      else 'other'
      end as medium
      ,case when REGEXP_MATCH(hits.appInfo.landingScreenName,('.*/$|.*/[?].*')) then 'HP'
             when REGEXP_MATCH(hits.appInfo.landingScreenName,('.*/restaurants/.*|.*/.*/restaurants/.*|.*/restaurants.*')) then 'RLP'
             when REGEXP_MATCH(hits.appInfo.landingScreenName,('.*/restaurant/.*'))  then 'RDP'
             else 'other' end as landingPage
    from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')),
    TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108857524.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
    where hits.customDimensions.index=3
    group by 1,2,3,4,5,6
    )

    ) as countries on vendor_visits.fullvisitorid=countries.fullvisitorId and vendor_visits.visitid=countries.visitid 
left join each

  (select a.* from
  flatten (
  (select fullVisitorId, unique (visitId) as visitid, regexp_extract(hits.customDimensions.value,r'([^_]*)') as city_id, regexp_extract(hits.customDimensions.value,r'_(.*)') as area_id
  from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')),TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108857524.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
  where hits.customDimensions.index=1
  group each by 1,3,4), visitid) a) area_id

    on area_id.fullvisitorid=vendor_visits.fullvisitorid and area_id.visitid=vendor_visits.visitid
    group by  1,2,3,4,5,6,7
      )cr4_compl

      on  cr3_start.area_id=cr4_compl.area_id and cr3_start.city_id=cr4_compl.city_id and cr3_start.date=cr4_compl.date and cr3_start.country= cr4_compl.country and cr3_start.landingpage=cr4_compl.landingpage and
          cr3_start.medium=cr4_compl.medium and cr3_start.vendor_code=cr4_compl.vendor_code
where (length(cr3_start.vendor_code) = 0 or length(cr3_start.vendor_code) = 4 )
)  