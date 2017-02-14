 /*Working and tested Query*/

            select date ,
            date(date) as ga_date,
        year(CAST(date AS TIMESTAMP)) as ga_year,
        case when date in('20160101','20160102') then '2015-53' else case when length(string(week(CAST(date AS TIMESTAMP))))=1 then CONCAT(string(year(CAST(date AS TIMESTAMP))),'-0',string(week(CAST(date AS TIMESTAMP)))) else CONCAT(string(year(CAST(date AS TIMESTAMP))),'-',string(week(CAST(date AS TIMESTAMP)))) end end as ga_week,
        case when dayofweek(CAST(date AS TIMESTAMP))=1 then '1.Sunday'
             when dayofweek(CAST(date AS TIMESTAMP))=2 then '2.Monday'
             when dayofweek(CAST(date AS TIMESTAMP))=3 then '3.Tuesday'
             when dayofweek(CAST(date AS TIMESTAMP))=4 then '4.Wednesday'
             when dayofweek(CAST(date AS TIMESTAMP))=5 then '5.Thursday'
             when dayofweek(CAST(date AS TIMESTAMP))=6 then '6.Friday'
             when dayofweek(CAST(date AS TIMESTAMP))=7 then '7.Saturday' else 'none'
        END as ga_day,
                   hits.customDimensions.value as country,
                   case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
                   device.operatingSystem as os,
                   case when regexp_match(hits.appInfo.appVersion,'2.12') then '2.12' else
                  (case when regexp_match(hits.appInfo.appVersion,'2.13') then '2.13' else
                  (case when regexp_match(hits.appInfo.appVersion ,'2.14') then '2.14' else '2.15' end )end ) end as apv,
                   hits.appInfo.appVersion as appVersion,
                   sum (totals.hits) as totalHits,
                   sum (totals.visits) check_sum ,
                   sum (case when  totals.hits < 500  and totals.visits ==1 then 1 else 0 end) as lessThan500,
                   sum (case when  totals.hits == 500 and totals.visits ==1 then 1 else 0 end) as moreThan500,
                   sum (case when  totals.hits >400 then 1 else 0 end ) as Over400hits,
                   sum (case when  totals.hits>300 and totals.hits<=400 then 1 else 0 end) as hits300to400,
                   sum (case when  totals.hits>200 and totals.hits<=300 then 1 else 0 end) as hits200to300,
                   sum (case when  totals.hits>100 and totals.hits<=200 then 1 else 0 end) as hits100to200,
                   sum (case when  totals.hits<=100 then 1 else 0 end) as hitsUpto100,
                   sum (case when hits.transaction.transactionId is not null then 1 else 0 end) as totalTransactions,
                   sum (case when hits.transaction.transactionId is not null then totals.hits else 0 end) as totalhitsWithTransaction,
                   sum (case when hits.transaction.transactionId is not null and totals.hits >400 then 1 else 0 end ) as TransactionsOver400hits,
                   sum (case when hits.transaction.transactionId is not null and totals.hits>300 and totals.hits<=400 then 1 else 0 end) as Transactions300to400,
                   sum (case when hits.transaction.transactionId is not null and totals.hits>200 and totals.hits<=300 then 1 else 0 end) as Transactions200to300,
                   sum (case when hits.transaction.transactionId is not null and totals.hits>100 and totals.hits<=200 then 1 else 0 end) as Transactions100to200,
                   sum (case when hits.transaction.transactionId is not null and totals.hits<=100 then 1 else 0 end) as TransactionsUpto100
               from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -60, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
               where  hits.customDimensions.index=1 and hits.customDimensions.value in ('BD','BG','BN','HK','IN','KZ','MY','PH','RO','SG','TH','TW')
                      and ( REGEXP_MATCH(hits.appInfo.appVersion,'2.12')
                            or REGEXP_MATCH(hits.appInfo.appVersion,'2.13')
                            or REGEXP_MATCH(hits.appInfo.appVersion,'2.14')
                            or REGEXP_MATCH(hits.appInfo.appVersion,'2.15'))
               group by 1,2,3,4,5,6,7,8,9,10
               order by date

           --86553600 web country index 3
