
select  
        fullVisitorId,
        visitid,
        country,
        platform,
        date,
        Users,
        INTEGER(error1)as error1,

from
(
select 
       a.fullVisitorId as fullVisitorId,
       a.visitid as visitid,
       b.country as country,
       b.platform as platform,
       b.date as date,
       'ALL'as Users,
       sum(case when a.RLP<1 and a.error1>0 then 1 else 0 end) as error1,




       from 
      (
       select date,
               fullVisitorId,
               (visitId) as visitid,
               'APP' as platform,
               sum(case when (REGEXP_MATCH( hits.eventInfo.eventAction,'Pickers - Area list \\(Display\\)' ) 
                        or   REGEXP_MATCH(hits.eventInfo.eventAction,'Pickers - City list \\(Display\\)')
                        or   REGEXP_MATCH(hits.eventInfo.eventAction,"Location Screen - Click on City")
                        or   REGEXP_MATCH(hits.eventInfo.eventAction,'Pickers - City list \\(Selected\\)')
                        or   REGEXP_MATCH(hits.eventInfo.eventAction,"Location Screen - Click on GPS location")
                        or   REGEXP_MATCH(hits.eventInfo.eventAction,'Pickers - Address \\(Search\\)'))then 1 else 0 end)  as error1,
               sum(case when REGEXP_MATCH(hits.appInfo.ScreenName,'Restaurants') then 1 else 0 end ) as RLP,


               
          from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')),TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

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
           from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')),TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

           where  hits.customDimensions.index=1 
           group each by 1,2,3,4,5
           
        )b
                 
          on a.fullVisitorId=b.fullVisitorId and a.visitId=b.visitId and a.date=b.date 
          
          group each by 1,2,3,4,5,6
          
          )
     
          group by 1,2,3,4,5,6,7
          having error1>0

          