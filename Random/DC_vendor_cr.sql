select t1.date, t1.vendor_id, t1.OS, t1.channel,t1.users, t1.visits as visit_Screens,t1.orders as orders_Screens ,t2.visits as visits_EventAction,t2.orders as orders_EventAction from
(
select  date(vendor_visits.date)  date,
        vendor_visits.vendor_id as vendor_id, 
        vendor_visits.device.operatingSystem as OS, 
        vendor_visits.Users as users, 
        vendor_visits.channel as channel, 
        sum(vendor_visit) visits, 
        sum(vendor_order)   orders from
      /****************************CR3 START*********************************************/

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
                               case when device.operatingSystem='Android' OR device.operatingSystem='iOS' then 'APP' end as platform_agg,
                               case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
                               case when trafficSource.source='(direct)' and trafficSource.medium='(none)' then 'direct'
                                    when trafficSource.source='push' and trafficSource.medium='push' then 'push'else 'others'
                               END AS channel,

                        from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -1, 'DAY'))
                        where hits.customDimensions.index=15 and REGEXP_MATCH(hits.appInfo.ScreenName,'(Restaurant Categories Screen|Restaurant Products Screen|Restaurant Information Screen)')
                        group each by 1,2,4,5,6,7,8,9
                       ), visitid
                     ) a
        ) vendor_visits
        /********************************CR4 COMPLETION*********************************/
        left join
        (
        select a.*
        from
            flatten (
                      (
                        select date,
                               fullVisitorId,
                               unique (visitId) as visitid,
                               upper(hits.customDimensions.value) as vendor_id,
                               1 as vendor_order,
                               device.operatingSystem,
                               case when device.operatingSystem='Android' OR device.operatingSystem='iOS' then 'APP' end as platform_agg,
                               case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
                               case when trafficSource.source='(direct)' and trafficSource.medium='(none)' then 'direct'
                                    when trafficSource.source='push' and trafficSource.medium='push' then 'push'else 'others'
                               END AS channel,

                        from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -1, 'DAY'))
                        where hits.customDimensions.index=15 and REGEXP_MATCH(hits.appInfo.ScreenName,'(Checkout Confirmation Screen)')
                        group each by 1,2,4,5,6,7,8,9
                       ), visitid
                     ) a
        ) vendor_orders
        
        on vendor_orders.fullvisitorid = vendor_visits.fullvisitorid and vendor_orders.visitid = vendor_visits.visitid
        
        group by 1,2,3,4,5

)t1

left join
(
(
select  date(vendor_visits.date)  date,
        vendor_visits.vendor_id as vendor_id, 
        vendor_visits.device.operatingSystem as OS, 
        vendor_visits.Users as users, 
        vendor_visits.channel as channel, 
        sum(vendor_visit) visits, 
        sum(vendor_order)   orders from
      /****************************CR3 START action*********************************************/

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
                               case when device.operatingSystem='Android' OR device.operatingSystem='iOS' then 'APP' end as platform_agg,
                               case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
                               case when trafficSource.source='(direct)' and trafficSource.medium='(none)' then 'direct'
                                    when trafficSource.source='push' and trafficSource.medium='push' then 'push'else 'others'
                               END AS channel,

                        from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -1, 'DAY'))
                        where REGEXP_MATCH(hits.eventInfo.eventAction,'(Restaurant Detail Page|Restaurant Products Screen|Variation and Toppings Screen)')
                        group each by 1,2,4,5,6,7,8,9
                       ), visitid
                     ) a
        ) vendor_visits
        /********************************CR4 COMPLETION action *********************************/
        left join
        (
        select a.*
        from
            flatten (
                      (
                        select date,
                               fullVisitorId,
                               unique (visitId) as visitid,
                               upper(hits.customDimensions.value) as vendor_id,
                               1 as vendor_order,
                               device.operatingSystem,
                               case when device.operatingSystem='Android' OR device.operatingSystem='iOS' then 'APP' end as platform_agg,
                               case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
                               case when trafficSource.source='(direct)' and trafficSource.medium='(none)' then 'direct'
                                    when trafficSource.source='push' and trafficSource.medium='push' then 'push'else 'others'
                               END AS channel,

                        from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -1, 'DAY'))
                        where REGEXP_MATCH(hits.eventInfo.eventAction,'(Transaction)')
                        group each by 1,2,4,5,6,7,8,9
                       ), visitid
                     ) a
        ) vendor_orders
        
        on vendor_orders.fullvisitorid = vendor_visits.fullvisitorid and vendor_orders.visitid = vendor_visits.visitid
        
        group by 1,2,3,4,5

))t2

 on t1.vendor_id = t2.vendor_id
 group by 1,2,3,4,5,6,7,8,9

