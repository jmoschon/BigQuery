
--select
----        date,
--        country,
----        platform,
----        os,
----        Users,
--        sum(total_sessions) as total_sessions,
--
--        sum(notNAhit) as sessions_with_not_NA_in_all_hits,
--        sum(notNAsessions) as sessiosn_with_not_NA_session
--
--
--
--from
--(
select


       a.fullVisitorId,
       a.visitid,
       b.country as country,
       b.platform as platform,
       a.device.operatingSystem as OS,
       b.date as date,
       'ALL'as Users,
       sum(c.transactions) as transactions,
       sum(Total_sessions) as total_sessions,
       sum(case when c.NotNAhit>0 then 1 else 0 end) as notNAhit,
       sum(case when c.NotNAhit<1 then 1 else 0 end) as Sessions_with_NA_HIT,
       sum(case when d.notNAsessions>0 then 1 else 0 end) as notNAsessions,
       sum(case when d.notNAsessions<1 then 1 else 0 end) as Sessions_with_NA_sessions,
       sum(case when a.transactions>0 and c.NotNAhit>0 then 1 else 0 end) as Transactions_notNAhit,
       sum(case when a.transactions>0 and c.NotNAhit<1 then 1 else 0 end ) as Transactions_with_NA_HIT,
       sum(case when a.transactions>0 and d.notNAsessions>0 then 1 else 0 end) as Transactions_notNAsessions,
       sum (case when a.transactions>0 and d.notNAsessions<1 then 1 else 0 end ) as Transactions_with_NA_sessions






       from
      (
       select date,
               fullVisitorId,
               (visitId) as visitid,
               'APP' as platform,
               device.operatingSystem,
               --case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
              (totals.transactions) as transactions,
              (totals.visits) Total_sessions,
          from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
          ,TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

           group each by 1,3,2,4,5,6,7
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
           ,TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

           where  hits.customDimensions.index=1
           and hits.customDimensions.value='HK'
           --and hits.customDimensions.value in ('BD','BG','BN','HK','IN','KZ','MY','PH','RO','SG','TH','TW','SA','EG','GE')
           group each by 1,2,3,4,5

        )b

          on a.fullVisitorId=b.fullVisitorId and a.visitId=b.visitId and a.date=b.date

     join each


       (
       select date,
              fullVisitorId,
               (visitId) visitId ,
--              upper(hits.customDimensions.value) as country,
                (totals.transactions) as transactions,
              'APP' as platform,
              sum(case when  not hits.customDimensions.value='NA' then 1 else 0 end) as notNAhit,
               --case when visitnumber=1 then "New Visitors" else "Returninag Visitors" end as Users,
           from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
           ,TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

           where  hits.customDimensions.index=34
           group each by 1,2,3,4,5

        )c

          on a.fullVisitorId=c.fullVisitorId and a.visitId=c.visitId and a.date=c.date

      join each

       (
       select date,
              fullVisitorId,
               (visitId) visitId ,
               (totals.transactions) as transactions,
--              upper(hits.customDimensions.value) as country,
              'APP' as platform,
              sum(case when not hits.customDimensions.value='NA' then 1 else 0 end) as NotNAsessions,
               --case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
           from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
           ,TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

           where  hits.customDimensions.index=52
           group each by 1,2,3,4,5

        )d

          on a.fullVisitorId=d.fullVisitorId and a.visitId=d.visitId and a.date=d.date

          group each by 1,2,3,4,5,6,7

--)group by 1

