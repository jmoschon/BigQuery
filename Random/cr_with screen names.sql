select a.*, b.visits, c.visits from

(select area_id.area_id, area_id.city_id, date(vendor_visits.date) date,vendor_visits.vendor_id, countries.country,vendor_visits.device.operatingSystem, vendor_visits.Users, vendor_visits.channel, sum(vendor_visit) visits from
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

                        from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -1, 'DAY'))
                        where REGEXP_MATCH(hits.appInfo.ScreenName,'(Restaurant Categories Screen|Restaurant Products Screen|Restaurant Information Screen)') and hits.customDimensions.index=15
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

                        from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -1, 'DAY'))
                        where hits.customDimensions.index=1 and hits.customDimensions.value = 'HK'
                        group each by 1,2,4,5,6,7,8
                       ), visitid
                     ) a
        ) countries on vendor_visits.fullvisitorid=countries.fullvisitorId and vendor_visits.visitid=countries.visitid 
      left join each
            (select a.* from
            flatten (
            (select fullVisitorId, unique (visitId) as visitid, regexp_extract(hits.customDimensions.value,r'([^_]*)') as city_id, regexp_extract(hits.customDimensions.value,r'_(.*)') as area_id
/*!!this is for all platforms . USE THIS!!*/from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -1, 'DAY')), 
/*TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))*/
            where hits.customDimensions.index=11
            group each by 1,3,4), visitid) a) area_id

on area_id.fullvisitorid=vendor_visits.fullvisitorid and area_id.visitid=vendor_visits.visitid
        group by 1,2,3,4,5,6,7,8
        ) a
        
        
        left join
        
        (select area_id.area_Id ,area_id.city_id, date(vendor_visits.date) date,vendor_visits.vendor_id, countries.country,vendor_visits.device.operatingSystem, vendor_visits.Users, vendor_visits.channel, sum(vendor_visit) visits from
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

                        from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -1, 'DAY'))
                         where REGEXP_MATCH(hits.appInfo.ScreenName,'(Checkout Screen|Delivery Method Screen|Email Verification Screen|Address Book Screen|User Details Screen)') and hits.customDimensions.index= 15
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

                        from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -1, 'DAY'))
                        where hits.customDimensions.index=1 and hits.customDimensions.value = 'HK'
                        group each by 1,2,4,5,6,7,8
                       ), visitid
                     ) a
        ) countries on vendor_visits.fullvisitorid=countries.fullvisitorId and vendor_visits.visitid=countries.visitid 
      left join each
            (select a.* from
            flatten (
            (select fullVisitorId, unique (visitId) as visitid, regexp_extract(hits.customDimensions.value,r'([^_]*)') as city_id, regexp_extract(hits.customDimensions.value,r'_(.*)') as area_id
/*!!this is for all platforms . USE THIS!!*/from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -1, 'DAY')), 
/*TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))*/
            where hits.customDimensions.index=11
            group each by 1,3,4), visitid) a) area_id

on area_id.fullvisitorid=vendor_visits.fullvisitorid and area_id.visitid=vendor_visits.visitid
        group by 1,2,3,4,5,6,7,8
        ) b
        
        on  a.area_id.area_id=b.area_id.area_id and a.area_id.city_id=b.area_id.city_id and a.vendor_id = b.vendor_id and a.date = b.date and a.countries.country = b.countries.country and a.vendor_visits.device.operatingsystem=b.vendor_visits.device.operatingsystem and a.vendor_visits.users=b.vendor_visits.users and a.vendor_visits.channel=b.vendor_visits.channel
        
        left join
        
        (select area_id.area_id,area_id.city_id, date(vendor_visits.date) date,vendor_visits.vendor_id, countries.country,vendor_visits.device.operatingSystem, vendor_visits.Users, vendor_visits.channel, sum(vendor_visit) visits from
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

                        from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -1, 'DAY'))
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

                        from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -1, 'DAY'))
                        where hits.customDimensions.index=1 and hits.customDimensions.value = 'HK'
                        group each by 1,2,4,5,6,7,8
                       ), visitid
                     ) a
        ) countries on vendor_visits.fullvisitorid=countries.fullvisitorId and vendor_visits.visitid=countries.visitid 
      left join each
            (select a.* from
            flatten (
            (select fullVisitorId, unique (visitId) as visitid, regexp_extract(hits.customDimensions.value,r'([^_]*)') as city_id, regexp_extract(hits.customDimensions.value,r'_(.*)') as area_id
/*!!this is for all platforms . USE THIS!!*/from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -1, 'DAY')), 
/*TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))*/
            where hits.customDimensions.index=11
            group each by 1,3,4), visitid) a) area_id

on area_id.fullvisitorid=vendor_visits.fullvisitorid and area_id.visitid=vendor_visits.visitid
        group by 1,2,3,4,5,6,7,8
        ) c
        
        on  a.area_id.area_id=c.area_id.area_id and a.area_id.city_id=c.area_id.city_id and  a.vendor_id = c.vendor_id and a.date = c.date and a.countries.country = c.countries.country and a.vendor_visits.device.operatingsystem=c.vendor_visits.device.operatingsystem and c.vendor_visits.users=b.vendor_visits.users and a.vendor_visits.channel=c.vendor_visits.channel