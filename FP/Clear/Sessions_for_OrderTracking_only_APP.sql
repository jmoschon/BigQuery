
/*__  ___   ___
APP
*/
--(
select  country,
        platform,
        date,
        Users,
        INTEGER(total_sessions) as sessions,
        INTEGER(Total_Transactions) as transactions,
        INTEGER(OrderTracking_sessions) as OrderTracking_sessions






from
(
select b.country as country,
       b.platform as platform,
       b.date as date,
       'ALL'as Users,
       sum(Total_sessions) as total_sessions,
       sum(case when(RLP_RPD<1 and orderStatus>0)then 1 else 0 end) as OrderTracking_sessions,
       sum(Total_Transactions) as Total_Transactions






       from
      (
       select date,
               fullVisitorId,
               (visitId) as visitid,
               'APP' as platform,
               --case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,

               sum(totals.visits) Total_sessions,
               sum(totals.transactions) as Total_Transactions,

               sum(case when REGEXP_MATCH(hits.appInfo.ScreenName,'Restaurant') then 1 else 0 end ) as RLP_RPD,
               sum(case when REGEXP_MATCH(hits.appInfo.ScreenName,'Order Status Screen') then 1 else 0 end) as orderStatus

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

          group each by 1,2,3,4

          )
          group by 1,2,3,4,5,6,7

          --) as app


