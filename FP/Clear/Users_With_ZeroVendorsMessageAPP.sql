
select
        fullVisitorId,
        visitid,
        country,
        platform,
        date,
        Users,
        total_sessions,
        INTEGER(error2) as error2,
        INTEGER(error2_coverage) as error2_coverage,
        INTEGER(error2_filter) as error2_filter,
        INTEGER(error2_search) as error2_search,


from
(
select
       a.fullVisitorId as fullVisitorId,
       a.visitid as visitid,
       b.country as country,
       b.platform as platform,
       b.date as date,
       'ALL'as Users,
       sum(Total_sessions) as total_sessions,

       sum(case when a.error2>0 then  1 else 0 end) as error2,
       sum(case when a.error2>0 and a.filter<1  then 1 else 0 end ) as error2_coverage,
       sum(case when a.error2>0 and a.filter>0 then 1 else 0 end ) as error2_filter,
       0 as error2_search,





       from
      (
       select date,
               fullVisitorId,
               (visitId) as visitid,
               'APP' as platform,
               --case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,

               sum(totals.visits) Total_sessions,
               /*User locates successfully but cannot find enough inventory*/
               sum(case when (REGEXP_MATCH(hits.eventInfo.eventCategory,'Location')
                         and REGEXP_MATCH(hits.eventInfo.eventAction,'Quantity Restaurants Displayed')
                         and REGEXP_MATCH(hits.eventInfo.eventLabel,"=0")) then 1 else 0 end) as error2,
--                sum(case when REGEXP_MATCH(hits.eventInfo.eventAction,"Filter Submitted") and REGEXP_MATCH(hits.eventInfo.eventCategory,"Restaurant Listing Screen") then 1 else 0 end) as error2_filter,
               sum(case when  REGEXP_MATCH(hits.eventInfo.eventAction,"Filter Submitted") and REGEXP_MATCH(hits.eventInfo.eventCategory,"Restaurant Listing Screen") then 1 else 0 end) as filter,




          from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
--          ,TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

           group each by 1,3,2,4
     )a

     join each


       (
       select date,
              fullVisitorId,
               (visitId) visitId ,
              upper(hits.customDimensions.value) as country,
              'APP' as platform,

               --case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
           from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
--           ,TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

           where  hits.customDimensions.index=1
           group each by 1,2,3,4,5

        )b

          on a.fullVisitorId=b.fullVisitorId and a.visitId=b.visitId and a.date=b.date

          group each by 1,2,3,4,5,6

          )
          where error2>0

          group by 1,2,3,4,5,6,7,8,9,10,11

