

/*
__      __  ___   ___
\ \    / / | __| | _ )
 \ \/\/ /  | _|  | _ \
  \_/\_/   |___| |___/
  */
select * from(


select  country,
        platform,
        date,
        Users,
        sessions,
        INTEGER(total_transactions) as transactions,
        INTEGER (OrderTracking_sessions) as OrderTracking_sessions


from
(
select b.country,
       b.platform,
       b.date,
--        c.Users,
      case when c.EXISTING_users>0 then 'EXISTING' when c.NEW_users>0 then 'NEW' else 'NA' end as Users,
       sum(Total_session) as total_sessions,
       sum( Total_transactions) as total_transactions,
       sum (case when Total_transactions>0 then 1 else 0 end) as Sessions_withTransactions,
       sum (case when (sessionsWithRLP_RPD<1 and sessionsWithOrderStatus>0) then 1 else 0 end ) as OrderTracking_sessions



       from

        (
       select date,
               fullVisitorId,
               (visitId) as visitid,
               'WEB' as platform,
               -- case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
               sum(totals.visits) Total_session,
               sum(totals.transactions) as Total_Transactions,



               sum(case when(regexp_match(hits.page.pagePath,'/restaurant')) then 1 else 0 end) as sessionsWithRLP_RPD,
               sum(case when (regexp_match(hits.page.pagePath,'/finishorder')) then 1 else 0 end ) as sessionsWithOrderStatus


            from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')),TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108857524.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
              group each by 1,2,3,4
      )a

     join each

       (
       select date,
              fullVisitorId,
              (visitId) as visitId ,
              upper(hits.customDimensions.value) as country,
              'WEB' as platform,
               -- case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
           from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')),TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108857524.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
              where  hits.customDimensions.index=3 and hits.customDimensions.value='SG'
           group each by 1,2,3,4,5

         )b

          on a.fullVisitorId=b.fullVisitorId and a.visitId=b.visitId and a.date=b.date


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
           from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')),TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108857524.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
           where  hits.customDimensions.index=38
           group each by 1,2,3,4

          )c

          on a.fullVisitorId=c.fullVisitorId and a.visitId=c.visitId and c.date=b.date

          group each by 1,2,3,4

          )
      group by 1,2,3,4,5,6,7)as web



