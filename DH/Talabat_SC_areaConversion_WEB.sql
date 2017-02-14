//Talabat All
Select 
A.PostalCode as PostalCode,
B.ShopID as ShopID,
A.device.operatingSystem as Device,
Count(DISTINCT A.session_id) as NumBrowse,
Count(DISTINCT B.session_id) as NumRestLoaded,
Count(DISTINCT C.session_id) as NumBought

FROM 
(
Select
    CONCAT(fullVisitorId, STRING(visitId)) as session_id,
    device.operatingSystem,
last( hits.eventInfo.eventLabel) as PostalCode,
From TABLE_DATE_RANGE([bta---talabat:109362366.ga_sessions_],TIMESTAMP(DATE_ADD(TIMESTAMP(current_date()),-2,"DAY")),TIMESTAMP(DATE_ADD(TIMESTAMP(current_date()),-1,"DAY")))
where hits.eventInfo.eventAction = 'shop_list.loaded'
group by 1,2 ) A 

left join

(
Select
    CONCAT(fullVisitorId, STRING(visitId)) as session_id,
    last( hits.eventInfo.eventLabel) as ShopID
From TABLE_DATE_RANGE([bta---talabat:109362366.ga_sessions_],TIMESTAMP(DATE_ADD(TIMESTAMP(current_date()),-2,"DAY")),TIMESTAMP(DATE_ADD(TIMESTAMP(current_date()),-1,"DAY")))
where hits.eventInfo.eventAction = 'shop_details.loaded'
group by 1
) B
on A.session_id = B.session_id

left join

(
Select
    CONCAT(fullVisitorId, STRING(visitId)) as session_id,
From TABLE_DATE_RANGE([bta---talabat:109362366.ga_sessions_],TIMESTAMP(DATE_ADD(TIMESTAMP(current_date()),-2,"DAY")),TIMESTAMP(DATE_ADD(TIMESTAMP(current_date()),-1,"DAY")))
where hits.eventInfo.eventAction = 'transaction'
group by 1
) C
on B.session_id = C.session_id

group by 1,2,3
order by NumBrowse desc

