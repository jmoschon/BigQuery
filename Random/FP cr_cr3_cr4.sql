select a.*, b.visits, c.visits from
/*********************** CR 3 START ***********************************************************/
(select date(vendor_visits.date) date,vendor_visits.vendor_id, countries.country,vendor_visits.device.operatingSystem, vendor_visits.Users, vendor_visits.channel, sum(vendor_visit) visits from
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
                         where hits.customDimensions.index=15 and REGEXP_MATCH(hits.appInfo.ScreenName,'(Restaurant Categories Screen|Restaurant Products Screen|Restaurant Information Screen)')
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
                        where hits.customDimensions.index=1 
                        group each by 1,2,4,5,6,7,8
                       ), visitid
                     ) a
        ) countries on vendor_visits.fullvisitorid=countries.fullvisitorId and vendor_visits.visitid=countries.visitid 
  
        group by 1,2,3,4,5,6
        ) a
        
        /************************************ CR 3 completion***********************************/
        left join
        
        (select date(vendor_visits.date) date,vendor_visits.vendor_id, countries.country,vendor_visits.device.operatingSystem, vendor_visits.Users, vendor_visits.channel, sum(vendor_visit) visits from
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
                         where hits.customDimensions.index=15 and REGEXP_MATCH(hits.appInfo.ScreenName,'(Checkout Screen|Delivery Method Screen|Email Verification Screen|Address Book Screen|User Details Screen)')
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
                        where hits.customDimensions.index=1 
                        group each by 1,2,4,5,6,7,8
                       ), visitid
                     ) a
        ) countries on vendor_visits.fullvisitorid=countries.fullvisitorId and vendor_visits.visitid=countries.visitid 
  
        group by 1,2,3,4,5,6
        ) b
        
        on a.vendor_id = b.vendor_id and a.date = b.date and a.countries.country = b.countries.country and a.vendor_visits.device.operatingsystem=b.vendor_visits.device.operatingsystem and a.vendor_visits.users=b.vendor_visits.users and a.vendor_visits.channel=b.vendor_visits.channel
        
        left join
/******************************************* CR 4 completion******************************/        
        (select date(vendor_visits.date) date,vendor_visits.vendor_id, countries.country,vendor_visits.device.operatingSystem, vendor_visits.Users, vendor_visits.channel, sum(vendor_visit) visits from
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
                         where hits.customDimensions.index=15 and REGEXP_MATCH(hits.appInfo.ScreenName,'(Checkout Confirmation Screen)')
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
                        where hits.customDimensions.index=1 
                        group each by 1,2,4,5,6,7,8
                       ), visitid
                     ) a
        ) countries on vendor_visits.fullvisitorid=countries.fullvisitorId and vendor_visits.visitid=countries.visitid 
  
        group by 1,2,3,4,5,6
        ) c
        
        on a.vendor_id = c.vendor_id and a.date = c.date and a.countries.country = c.countries.country and a.vendor_visits.device.operatingsystem=c.vendor_visits.device.operatingsystem and c.vendor_visits.users=a.vendor_visits.users and a.vendor_visits.channel=c.vendor_visits.channel