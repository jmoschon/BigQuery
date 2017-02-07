---EATOYE VENDOR CR QUERY---


select *

from
(
select date(a.date) as ga_date,
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
        'Eatoye_PK' as country,
        a.operatingsystem as OperatingSystem,
        a.Users as user_type,
       a.vendor_id as vendor_id,
       'WEB' as platform,

       sum(a.visits) as CR3_start,

       sum(b.visits) as CR3_completion,

       sum(c.visits) as CR4_completion

       from
/***********************CR3 START*********************************/
(select  vendor_visits.date as date ,vendor_visits.vendor_id as vendor_id,vendor_visits.device.devicecategory as operatingSystem, vendor_visits.Users as Users,  vendor_visit as visits from
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
                               device.devicecategory,
                               hits.eventInfo.eventAction,
                               case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users

                        from TABLE_DATE_RANGE([98946202.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
                        --,TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
                         where REGEXP_MATCH(hits.eventInfo.eventAction,'(RDP)') and regexp_match (hits.eventInfo.eventCategory,'Goal') and hits.customDimensions.index = 2

                        group each by 1,2,4,5,6,7,8
                       ), visitid
                     ) a
        ) vendor_visits

         group by 1,2,3,4,5
) a

        /****************CR3 COMPLETION***************/
        left join

        (select vendor_visits.date as date,vendor_visits.vendor_id as vendor_id, vendor_visits.device.devicecategory as operatingSystem, vendor_visits.Users as Users, vendor_visit as visits from
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
                               device.devicecategory,
                               hits.eventInfo.eventAction,
                                case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users

                        from TABLE_DATE_RANGE([98946202.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
                       ---,TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
                        where REGEXP_MATCH(hits.eventInfo.eventAction,'(Checkout)') and regexp_match (hits.eventInfo.eventCategory,'Goal') and hits.customDimensions.index = 2
                        group each by 1,2,4,5,6,7,8
                       ), visitid
                     ) a
        ) vendor_visits
        group by 1,2,3,4,5
        ) b
--
        on  a.vendor_id = b.vendor_id and a.date = b.date and a.operatingsystem=b.operatingsystem and a.users=b.users
        /*********************CR4 COMPLETION************************/
        left join

        (select vendor_visits.date as date,vendor_visits.vendor_id as vendor_id, vendor_visits.device.devicecategory as operatingSystem, vendor_visits.Users as Users, vendor_visit as visits from
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
                               device.devicecategory,
                               hits.eventInfo.eventAction,
                                case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users
                        from TABLE_DATE_RANGE([98946202.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
                       ---,TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
                        where REGEXP_MATCH(hits.eventInfo.eventAction,'Transaction') and regexp_match (hits.eventInfo.eventCategory,'Goal') and hits.customDimensions.index = 2
                        group each by 1,2,4,5,6,7,8
                       ), visitid
                     ) a
        ) vendor_visits
        group by 1,2,3,4,5
        ) c

        on  a.vendor_id = c.vendor_id and a.date = c.date and a.operatingsystem=c.operatingsystem and c.users=b.users

group by 1,2,3,4,5,6,7,8

)
