--    select a1.fullVisitorId,  a1.visitid, a2.maxhit, a2.screenName from (

    select fullVisitorId, visitid,max(maxhit) as maxhit, screenName from
    (
    Select

      a.fullVisitorId as fullVisitorId,
      a.visitid as visitid,
      max(a.hitNumber) as maxhit,
      max(c.hitNumber) as stoper,
      a.screenName as screenName,
      from(

           select date,
                   fullVisitorId,
                   (visitId) as visitid,
                   'APP' as platform,
                   device.operatingSystem as os,
                   hits.hitNumber as hitNumber,
                   hits.customDimensions.value as area,
                   hits.appInfo.screenName	as screenName,

                   --case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
              from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
    --          ,TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
              where hits.customDimensions.index = 34 and hits.customDimensions.value='NA'

               group each by 1,3,2,4,5,6,7,8
               )a

               join each
               (
                   select date,
                   fullVisitorId,
                   (visitId) as visitid,
                   'APP' as platform,
                   device.operatingSystem as os,
                   hits.hitNumber as hitNumber,
                   hits.customDimensions.value as area,
                   hits.appInfo.screenName	as screenName,

                   --case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
              from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
    --          ,TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
              where hits.customDimensions.index = 52 and hits.customDimensions.value='NA'

               group each by 1,3,2,4,5,6,7,8
               )b

               on a.fullVisitorId=b.fullVisitorId and b.visitid=a.visitid
                          join each
               (
                   select date,
                   fullVisitorId,
                   (visitId) as visitid,
                   'APP' as platform,
                   device.operatingSystem as os,
                   hits.hitNumber as hitNumber,
                   hits.customDimensions.value as area,
                   hits.appInfo.screenName	as screenName,

                   --case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
              from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
    --          ,TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
              where hits.customDimensions.index = 34 and  not hits.customDimensions.value='NA'

               group each by 1,3,2,4,5,6,7,8
               )c

               on a.fullVisitorId=c.fullVisitorId and c.visitid=a.visitid


    group by 1,2,5
    ) where maxhit>=stoper
    group by 1,2,4
--    )a2
--    join
--    (
--    select fullVisitorId, visitid,min(maxhit) as maxhit from
--    (
--    Select
--
--      a.fullVisitorId as fullVisitorId,
--      a.visitid as visitid,
--      max(a.hitNumber) as maxhit,
--      max(c.hitNumber) as stoper,
--      a.screenName,
--      from(
--
--           select date,
--                   fullVisitorId,
--                   (visitId) as visitid,
--                   'APP' as platform,
--                   device.operatingSystem as os,
--                   hits.hitNumber as hitNumber,
--                   hits.customDimensions.value as area,
--                   hits.appInfo.screenName	as screenName,
--
--                   --case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
--              from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
--    --          ,TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
--              where hits.customDimensions.index = 34 and hits.customDimensions.value='NA'
--
--               group each by 1,3,2,4,5,6,7,8
--               )a
--
--               join each
--               (
--                   select date,
--                   fullVisitorId,
--                   (visitId) as visitid,
--                   'APP' as platform,
--                   device.operatingSystem as os,
--                   hits.hitNumber as hitNumber,
--                   hits.customDimensions.value as area,
--                   hits.appInfo.screenName	as screenName,
--
--                   --case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
--              from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
--    --          ,TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
--              where hits.customDimensions.index = 52 and hits.customDimensions.value='NA'
--
--               group each by 1,3,2,4,5,6,7,8
--               )b
--
--               on a.fullVisitorId=b.fullVisitorId and b.visitid=a.visitid
--                          join each
--               (
--                   select date,
--                   fullVisitorId,
--                   (visitId) as visitid,
--                   'APP' as platform,
--                   device.operatingSystem as os,
--                   hits.hitNumber as hitNumber,
--                   hits.customDimensions.value as area,
--                   hits.appInfo.screenName	as screenName,
--
--                   --case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
--              from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
--    --          ,TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
--              where hits.customDimensions.index = 34 and  not hits.customDimensions.value='NA'
--
--               group each by 1,3,2,4,5,6,7,8
--               )c
--
--               on a.fullVisitorId=c.fullVisitorId and c.visitid=a.visitid
--
--
--    group by 1,2,5
--    ) where maxhit>stoper
--    group by 1,2
--
--    )a1 on a1.fullVisitorId=a2.fullVisitorId and a1.visitid=a2.visitid and a2.maxhit=a1.maxhit
--    group by 1,2,3,4
--
--    order by 1