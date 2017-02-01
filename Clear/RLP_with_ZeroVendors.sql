--TODO fix table range
--TODO f
select * from

(
select a.date,
       c.country,
--       a.fullVisitorId,
--       a.visitid,
       case when d.EXISTING_users>0 then 'EXISTING' when d.NEW_users>0 then 'NEW' else 'NA' end as Users,
       a.path,
       b.area
 from
(
       select date,
               fullVisitorId,
               (visitId) as visitid,
               'WEB' as platform,
               -- case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
               hits.page.pagePath as path,
               min(hits.hitNumber) as messageHit,




            from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
--            ,TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108857524.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
              where  REGEXP_MATCH( hits.eventInfo.eventAction,'Zero Vendors Message')
              group each by 1,2,3,4,5
      )a

      join each

      (
       select date,
               fullVisitorId,
               (visitId) as visitid,
               'WEB' as platform,
               -- case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
               hits.customDimensions.value as area,
               min(hits.hitNumber) as dimensionHitMin,
               max(hits.hitNumber) as dimensionHitMax,



            from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
--            ,TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108857524.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
              where  hits.customDimensions.index=36
              group each by 1,2,3,4,5
      )b

      on a.fullVisitorId=b.fullVisitorId and a.visitid=b.visitid

     join each

       (
       select date,
              fullVisitorId,
              (visitId) as visitId ,
              upper(hits.customDimensions.value) as country,
              'WEB' as platform,
               -- case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
            from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
--            ,TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108857524.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
             where  hits.customDimensions.index=3
           group each by 1,2,3,4,5

         )c

          on a.fullVisitorId=c.fullVisitorId and a.visitId=c.visitId and a.date=c.date


    left join each

      (
       select date,
              fullVisitorId,
              (visitId) as visitId ,
              'WEB' as platform,
--               'NA' as Users,
              sum (case when REGEXP_MATCH(hits.customDimensions.value,'NA') then 1 else 0 end ) as NA_users,
              sum (case when REGEXP_MATCH(hits.customDimensions.value,'existing') then 1 else 0 end ) as EXISTING_users,
              sum (case when REGEXP_MATCH(hits.customDimensions.value,'new') then 1 else 0 end ) as NEW_users,
--               upper(hits.customDimensions.value) as Users
               -- case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
            from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
--            ,TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108857524.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
           where  hits.customDimensions.index=38
           group each by 1,2,3,4

          )d

          on a.fullVisitorId=d.fullVisitorId and a.visitId=d.visitId and c.date=d.date



      where (a.messageHit< b.dimensionHitMax and a.messageHit>b.dimensionHitMin)

      group by 1,2,3,4,5
    )base