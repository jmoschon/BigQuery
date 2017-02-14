

select
      base.date,
      base.fullVisitorId,
      base.visitid,
      base.platform,
      base.os,
      base.ZeroVendorsLabel,
      base.FilterLabel,
      base.ZeroHitNumber,
      min (distance),


from (
select
       a.date ,
       a.fullVisitorId as fullVisitorId,
       a.visitid as visitid,
       a.platform as platform,
       a.os as os,
       a.hitNumber as ZeroHitNumber,
       b.hitNumber as FilterHitNumber,
       c.hitNumber as SearchHitNumber,
       a.eventLabel as ZeroVendorsLabel,
       b.eventLabel as FilterLabel,
       c.eventLabel as SearchLabel,
       (a.hitNumber-b.hitNumber) as distance



       from
      (
       select date,
               fullVisitorId,
               (visitId) as visitid,
               'APP' as platform,
               device.operatingSystem as os,
               hits.hitNumber as hitNumber,
               hits.eventInfo.eventLabel as eventLabel
               --case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
          from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
--          ,TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
          where REGEXP_MATCH(hits.eventInfo.eventCategory,'Location')  and REGEXP_MATCH(hits.eventInfo.eventAction,'Quantity Restaurants Displayed')
                                                                        and REGEXP_MATCH(hits.eventInfo.eventLabel,"=0")
           group each by 1,3,2,4,5,6,7
     )a

     left join
     (
       select date,
               fullVisitorId,
               (visitId) as visitid,
               'APP' as platform,
               device.operatingSystem as os,
               hits.hitNumber as hitNumber,
               hits.eventInfo.eventLabel as eventLabel
               --case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
          from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
--          ,TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
          where REGEXP_MATCH(hits.eventInfo.eventCategory,'Restaurant Listing Screen')  and REGEXP_MATCH(hits.eventInfo.eventAction,'Filter Submitted')

           group each by 1,3,2,4,5,6,7
     )b

     on a.fullVisitorId=b.fullVisitorId and a.visitid=b.visitid

     left join
     (
       select date,
               fullVisitorId,
               (visitId) as visitid,
               'APP' as platform,
               device.operatingSystem as os,
               hits.hitNumber as hitNumber,
               hits.eventInfo.eventLabel as eventLabel
               --case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
          from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
--          ,TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
          where REGEXP_MATCH(hits.eventInfo.eventCategory,'Restaurant Listing Screen')  and REGEXP_MATCH(hits.eventInfo.eventAction,'Search Clicked')

           group each by 1,3,2,4,5,6,7
     )c
     on a.fullVisitorId=c.fullVisitorId and a.visitid=c.visitid

     left join
     (
       select date,
               fullVisitorId,
               (visitId) as visitid,
               'APP' as platform,
               device.operatingSystem as os,
               hits.hitNumber as hitNumber,
               hits.customDimensions.value as area
               --case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
          from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
--          ,TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
          where hits.customDimensions.index = 36

           group each by 1,3,2,4,5,6,7
     )d
     on a.fullVisitorId=d.fullVisitorId and a.visitid=d.visitid
     where a.os='iOS' and ((a.hitNumber>b.hitNumber) or (b.hitNumber is NULL) )
     group by 1,2,3,4,5,6,7,8,9,10,11,12
)base

group by 1,2,3,4,5,6,7,8

order by 2