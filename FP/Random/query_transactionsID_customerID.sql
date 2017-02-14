select a.*, customers.customer_id, transactions.transaction_id from 

(select DATE(date) date, fullVisitorId, visitId, totals.visits visits, totals.transactions transactions, visitnumber, device.operatingSystem OS
from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -16, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -10, 'DAY'))) a

left join each

        (select a.* from
        flatten (
        (select fullVisitorId, unique (visitId) as visitid, hits.customDimensions.value as customer_id
        from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -16, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -10, 'DAY'))
        where hits.customDimensions.index=31
        group each by 1,3), visitid) a) customers

        on customers.fullvisitorid=a.fullvisitorid and customers.visitid=a.visitid
        
        
left join each

        (select a.* from
        flatten (
        (select fullVisitorId, unique (visitId) as visitid, hits.transaction.transactionId transaction_id
        from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -16, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -10, 'DAY'))
        where hits.transaction.transactionId is not null
        group each by 1,3), visitid) a) transactions

        on transactions.fullvisitorid=a.fullvisitorid and transactions.visitid=a.visitid