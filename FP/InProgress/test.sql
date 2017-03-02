
        Select   a1.date,
                 a1.fullVisitorId,
                 a1.visitId,
                 countries.country as country,
                 a1.operatingSystem as operatingSystem,
                 a1.appVersion as appVersion,
                 a1.visits as sessions,
                 a1.gross_orders as orders,
                 c.transactionId as transactionId,

                 case when a.visitid>0 and (b.visitid<1 or b.visitid is null) then 1 else 0 end as Usagef,
                 case when (a.visits>0 and b.visits>0) and a.OrderSummaryScreenHitNumber>=b.AddressBookHitNumber then 1 else 0 end as noUsagef,
                 case when a.OrderSummaryScreenHitNumber<b.AddressBookHitNumber then 1 else 0 end as UsageButChangeAddress,

                 case when a.visits=1 then 1 else 0 end  as _sessionsWithOrderSummary,
                 case when b.visits=1 then 1 else 0 end  as _sessionsWithAddressBook



          from

                     ( select date,
                      fullvisitorId,
                      visitId,
                      device.operatingSystem as operatingSystem,
        --              case when regexp_match(device.operatingSystem,'iOS') then totals.visits else 0 end as ios_sessions,
                      totals.visits as visits,
                      totals.transactions as gross_orders,
                      hits.transaction.transactionId as transactionId,
                      hits.appInfo.appVersion as appVersion,
               from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -40, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
               --, TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -40, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -40, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
               where regexp_match(hits.appInfo.appVersion,'2.16') and visitnumber>1

               group each by 1,2,3,4,5,6,7,8

             )a1

        left join each

                     ( select date,
                      fullvisitorId,
                      visitId,
                      totals.visits as visits,
                      hits.hitNumber as OrderSummaryScreenHitNumber
               from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -40, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
               --, TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -40, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -40, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
               where regexp_match(hits.appInfo.appVersion,'2.16') and regexp_match(hits.appInfo.screenName,'Order Summary Screen')
               group each by 1,2,3,4,5

             )a
            on a.fullVisitorId=a1.fullVisitorId and a.visitid=a1.visitid and a1.date=a.date
        left join each



             ( select date,
                      fullvisitorId,
                      visitId,

                      totals.visits as visits,
                      hits.hitNumber as AddressBookHitNumber,

               from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -40, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
               --, TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -40, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -40, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
               where regexp_match(hits.appInfo.appVersion,'2.16') and regexp_match(hits.appInfo.screenName,'Address Book')
               group each by 1,2,3,4,5

             )b
             on b.fullvisitorid=a1.fullvisitorId and b.visitid=a1.visitid and b.date=a.date

         left join each

             ( select date,
                      fullvisitorId,
                      visitId,
                      totals.visits as visits,
                      totals.transactions as gross_orders,
                      hits.transaction.transactionId as transactionId,

               from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -40, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
               --, TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -40, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -40, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
               where regexp_match(hits.appInfo.appVersion,'2.16') and totals.transactions>0 and hits.transaction.transactionId is not null

               group each by 1,2,3,4,5,6

             )c on a1.fullvisitorid=c.fullvisitorId and a1.visitid=c.visitid and a1.date=c.date


        /* joining country */

        join each

              (
                select a.*
                from
                    flatten (
                              (
                                select date,
                                       fullVisitorId,
                                       unique (visitId) as visitid,
                                       upper(hits.customDimensions.value) as country,
                                from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -40, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
                                --, TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -40, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -40, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
                                where hits.customDimensions.index=1  -- and hits.customDimensions.value='IN'
                                group each by 1,2,4
                               ), visitid
                             ) a
                ) countries on a1.fullvisitorid=countries.fullvisitorId and countries.visitid=a1.visitid and countries.date=a1.date

    --

              where  c.transactionId is not null
               group each by 1,2,3,4,5,6,7,8,9,10,11,12,13,14
    --             order by 2untries on a1.fullvisitorid=countries.fullvisitorId and countries.visitid=a1.visitid and countries.date=a1.date

    --

