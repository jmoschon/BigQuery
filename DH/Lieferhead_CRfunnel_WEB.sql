SELECT
    new_visits,
    device,
    os,
    CONCAT(STRING(home),STRING(listing),STRING(shop_details),STRING(add_cart),STRING(checkout),STRING(transaction)) as full_funnel,
    home,
    listing,
    shop_details,
    add_cart,
    checkout,
    transaction,
    COUNT(*) as sessions

FROM (

SELECT
    fullVisitorId,
    visitStartTime,
    totals.newVisits as new_visits,
    device.deviceCategory as device,
    device.operatingSystem as os,
    IF(sum(if(hits.customDimensions.index = 11 and hits.customDimensions.value = 'home', 1,0))>0,1,0) as home,
    IF(sum(if(hits.eventInfo.eventAction = 'shop_list.loaded', 1,0))>0,1,0) as listing,
    IF(sum(if(hits.eventInfo.eventAction = 'shop_details.loaded', 1,0))>0,1,0) as shop_details,
    IF(sum(if(hits.eventInfo.eventAction = 'add_cart.clicked', 1,0))>0,1,0) as add_cart,
    IF(sum(if(hits.eventInfo.eventAction = 'checkout.loaded', 1,0))>0,1,0) as checkout,
    IF(sum(if(hits.eventInfo.eventAction = 'transaction', 1,0))>0,1,0) as transaction
FROM TABLE_DATE_RANGE([blh---lieferheld:38642300.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
GROUP BY 1,2,3,4,5
)
GROUP BY 1,2,3,4,5,6,7,8,9,10
ORDER BY 11 desc


-- 000001 only transaction
