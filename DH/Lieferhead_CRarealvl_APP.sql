select
a.customDimensions.value AS zip_code,
sum (b.listing) as listing,
sum (b.shop_details) as shop_details,
sum (b.add_cart) as add_cart,
sum (b.checkout_clicked) as checkout_clicked,
sum (b.checkout) as checkout,
sum (b.transaction) as transaction

from
(
select  
visitId,
customDimensions.index,
customDimensions.value
FROM TABLE_DATE_RANGE([blh---lieferheld:107101250.ga_sessions_],TIMESTAMP(DATE_ADD(TIMESTAMP(current_date()),-7,"DAY")),TIMESTAMP(DATE_ADD(TIMESTAMP(current_date()),-1,"DAY")))
where customDimensions.index = 17 --CD17 : locationArea session level
group by 1,2,3) a

join

(
select  
visitid,
--IF(sum(if(REGEXP_MATCH(hits.page.pagePath, '/../../food-delivery'), 1,0))>0,1,0) as home,
--IF(sum(if(hits.eventInfo.eventAction = 'address.submitted', 1,0))>0,1,0) as address_submitted,
IF(sum(if(hits.eventInfo.eventAction = 'shop_list.loaded', 1,0))>0,1,0) as listing,
IF(sum(if(hits.eventInfo.eventAction = 'shop_details.loaded', 1,0))>0,1,0) as shop_details,
IF(sum(if(hits.eventInfo.eventAction = 'add_cart.clicked', 1,0))>0,1,0) as add_cart,
IF(sum(if(hits.eventInfo.eventAction = 'checkout.clicked', 1,0))>0,1,0) as checkout_clicked,
IF(sum(if(hits.eventInfo.eventAction = 'checkout.loaded', 1,0))>0,1,0) as checkout,
IF(sum(if(hits.eventInfo.eventAction = 'transaction', 1,0))>0,1,0) as transaction
FROM TABLE_DATE_RANGE([blh---lieferheld:107101250.ga_sessions_],TIMESTAMP(DATE_ADD(TIMESTAMP(current_date()),-7,"DAY")),TIMESTAMP(DATE_ADD(TIMESTAMP(current_date()),-1,"DAY")))
group by 1)
b on a.visitId=b.visitid
group by 1