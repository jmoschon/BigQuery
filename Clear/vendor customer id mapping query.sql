


select *

from


(select country, customer_id, vendor_id,'' as vendor_code, date, 'APP' as platform

,sum(CR3_start) as menu_visits
--,sum(CR3a_completion) as CR3a_completion
--,sum(CR3b_completion) as CR3b_completion
--,sum(CR3b2_completion) as CR3b2_completion
--,sum(CR3c_completion) as CR3c_completion
--,sum(CR3d_completion ) as CR3d_completion
,sum(CR3_completion) as checkout_visits
--,sum(CR4a_completion) as CR4a_completion
--,sum(CR4d_completion) as CR4d_completion
--,sum(CR4e_completion) as CR4e_completion
,sum(CR4_completion) as transactions

from
(
/*aggregation at the level of vendor - calculate CR steps */
select a.fullvisitorid , a.visitid, country, customer_id, OperatingSystem, v.vendor_id as vendor_id, a.date as date, medium,user_type,
case when sum(case when REGEXP_MATCH(g.hits.appInfo.ScreenName,'Restaurant[^s]') then 1 else 0 end)>=1 then 1 else 0 end as CR3_start,
case when sum(case when REGEXP_MATCH(g.hits.appInfo.ScreenName,'^(Checkout Screen|Delivery Method)') then 1 else 0 end)>=1 then 1 else 0 end as CR3_completion,
case when sum(case when REGEXP_MATCH(g.hits.appInfo.ScreenName,'^Checkout Confirmation Screen') then 1 else 0 end)>=1 then 1 else 0 end as CR4_completion,
case when sum(case when regexp_match(g.hits.appInfo.ScreenName,'Restaurant Categories Screen|Restaurant Menus Screen') then 1 else 0 end)>=1 then 1 else 0 end as CR3a_completion,
case when sum(case when regexp_match(g.hits.appInfo.ScreenName,'Variations and Toppings Screen|Restaurant Products Screen') then 1 else 0 end)>=1 then 1 else 0 end as CR3b2_completion,
case when sum(case when regexp_match(g.hits.appInfo.ScreenName,'Variations and Toppings Screen') then 1 else 0 end)>=1 then 1 else 0 end as CR3b_completion,
case when sum(case when g.hits.eventinfo.eventaction='RDP _ Add Item to cart' then 1 else 0 end)>=1 then 1 else 0 end as CR3c_completion,
case when sum(case when g.hits.eventinfo.eventaction='RDP - Minimum value reached (On Basket)' or REGEXP_MATCH(g.hits.appInfo.ScreenName,'^(Checkout Screen|Delivery Method)') then 1 else 0 end)>=1 then 1 else 0 end as CR3d_completion,
case when sum(case when (REGEXP_MATCH(g.hits.appInfo.ScreenName,'^(Checkout Screen|Delivery Method)')) then 1 else 0 end)>=1 then 1 else 0 end as CR4a_completion,
case when sum(case when g.hits.eventinfo.eventaction='Checkout _ Payment option' then 1 else 0 end)>=1 then 1 else 0 end as CR4d_completion, --is not always farying
case when sum(case when (REGEXP_MATCH(g.hits.appInfo.ScreenName,'^Checkout Confirmation Screen')) then 1 else 0 end)>=1 then 1 else 0 end as CR4e_completion


from (
/*basic list of hits with assigned second values */
select a.*, v.vendor_id,g.hits.appInfo.ScreenName,g.hits.eventinfo.eventaction,g.device.operatingSystem, c.country as country, id.customer_id as customer_id, c.device.operatingSystem as OperatingSystem, c.medium as medium , user_type
  from
    (
    /*choose proper hit with country to hit - final list */
    select fullvisitorid, visitid, date, b.hits.hitNumber as b.hits.hitNumber
    ,case when before is null then after /*for all sessions before 1st hit*/
    else before /*take hit which appear before*/
    end as hits.hitNumber_country

    from (
    /* list hits with closes country match hit */
    select a.fullvisitorid, a.visitid, b.hits.hitNumber, date
    ,min (case when dif <=0 then a.hits.hitNumber end ) as after /*closest hit above*/
    ,max (case when dif >=0 then a.hits.hitNumber end ) as before /*closes hit after */

    from(
      /*base matrix of hits connections */
      select a.fullvisitorid, a.visitid, b.hits.hitNumber, a.hits.hitNumber , b.hits.hitNumber-a.hits.hitNumber as dif, a.date as date

      from /*list of hits with assigned vendors*/
      (select visitid, fullVisitorId, hits.hitNumber,date,  hits.customDimensions.value, totals.hits
	from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -1, 'DAY'))

      where hits.customDimensions.index=9 and hits.customDimensions.value <>'NA' and device.operatingSystem in('Android','iOS')
      ) as a

      inner join each /*list of menaingfull hits and screens*/
      (select visitid, fullVisitorId, hits.hitNumber, date
      from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -1, 'DAY'))
      where device.operatingSystem in('Android','iOS')
      and (REGEXP_MATCH(hits.appInfo.ScreenName,'^(Checkout Screen|Delivery Method|Restaurant[^s])|Checkout Confirmation Screen|Variations and Toppings Screen|Restaurant Products Screen|Restaurant Categories Screen|Restaurant Menus Screen')
      or hits.eventinfo.eventaction in('RDP _ Add Item to cart','RDP - Minimum value reached (On Basket)', 'Checkout _ Payment option'))
      group each by 1,2,3,4
      ) as b

       on a.visitid= b.visitid and  a.fullVisitorId=b.fullVisitorId and a.date = b.date
      ) as g
     group each by 1,2,3,4
    ) as l
  ) as a

left outer join each/*assign vendor_id*/
  (select visitid, fullVisitorId, date,  hits.hitNumber, replace(hits.customDimensions.value, '.0','') as vendor_id,case when visitnumber=1 then "New Visitor" else "Returning Visitor" end as user_type
  from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -1, 'DAY'))
  where hits.customDimensions.index=9 and hits.customDimensions.value <>'NA' and device.operatingSystem in('Android','iOS')
  group each by 1,2,3,4,5,6
  ) as v
  on v.visitid =a.visitid and v.fullvisitorid= a.fullvisitorid and v.hits.hitnumber = a.hits.hitnumber_country  and v.date = a.date

left outer join each /*assigning heats and screen names */
  (select visitid, fullVisitorId, hits.hitNumber, hits.appInfo.ScreenName,hits.eventinfo.eventaction,device.operatingSystem, date
  from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -1, 'DAY'))
  where device.operatingSystem in('Android','iOS')
  and (REGEXP_MATCH(hits.appInfo.ScreenName,'^(Checkout Screen|Delivery Method|Restaurant[^s])|Checkout Confirmation Screen|Variations and Toppings Screen|Checkout _ Payment option')
  or hits.eventinfo.eventaction in('RDP _ Add Item to cart','RDP - Minimum value reached (On Basket)', 'Checkout _ Payment option'))
  group each by 1,2,3,4,5,6,7
  ) as g
  on g.visitid =a.visitid and g.fullvisitorid= a.fullvisitorid and g.hits.hitnumber = a.b.hits.hitNumber and a.date = g.date

inner join each /*country */
	(
  select *
  from
  (select visitid, fullVisitorId, hits.customDimensions.value as country, device.operatingSystem
  , case when trafficSource.medium='(none)' then 'direct'
            when trafficSource.medium='push' then 'push'
            else 'other'
      end as medium
  from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -1, 'DAY'))
  where device.operatingSystem in('Android','iOS') and hits.customDimensions.index=1 and hits.customDimensions.value='IN'
  group each by 1,2,3,4,5
  )
  
  ) as c
  on c.visitid =a.visitid and c.fullvisitorid= a.fullvisitorid

  inner join each

    (select fullVisitorId,visitId, unique(hits.customDimensions.value) as customer_id
      from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -1, 'DAY'))
      where hits.customDimensions.index=17
      group by 1,2
      ) id 
    on a.visitId=id.visitId and a.fullVisitorId=id.fullVisitorId

) as d

group each by 1,2,3,4,5,6,7,8,9
) as e
group each by 1,2,3,4,5,6
)




/*
__      __  ___   ___
\ \    / / | __| | _ )
 \ \/\/ /  | _|  | _ \
  \_/\_/   |___| |___/

*/

,(

select  country, customer_id, '' as vendor_id ,vendor_code, date, 'WEB' as platform
,sum(CR3_start) as menu_visits
--,sum(CR3a_completion) as CR3a_completion
--,sum(CR3b_completion) as CR3b_completion
--,null as CR3b2_completion
--,sum(CR3c_completion) as CR3c_completion
--,sum(CR3d_completion ) as CR3d_completion
,sum(CR3_completion) as checkout_visits
--,sum(CR4a_completion) as CR4a_completion
--,sum(CR4d_completion) as CR4d_completion
--,sum(CR4e_completion) as CR4e_completion
,sum(CR4_completion) as transactions
from
(
select a.fullVisitorId as fullVisitorId
        , a.visitId as visitId
        , a.date as date
        , a.vendor_code as vendor_code
        , a.vendor_name as vendor_name
        , country
        , id.customer_id as customer_id
        ,medium
        ,landingPage
        ,user_type
        ,st.CR3_start as CR3_start
        ,st2.CR3_completion as CR3_completion
        ,st.CR3a_completion as CR3a_completion
        ,st.CR3b_completion as CR3b_completion
        ,st.CR3c_completion as CR3c_completion
        ,st.CR3d_completion as CR3d_completion
        ,st.CR4_completion as CR4_completion
        ,st.CR4a_completion as CR4a_completion
        ,st.CR4d_completion as CR4d_completion
        ,st.CR4e_completion as CR4e_completion
  from /*base*/
    (select fullVisitorId, visitId, date
          ,regexp_extract(hits.page.pagePath,'(?:/(?:restaurant|checkout|review-order|order/finishorder)/([^/]*))') as vendor_code
          , regexp_extract(hits.page.pagePath,'(?:/(?:restaurant)/(?:[^/]*)/([^/]*))') as vendor_name
	from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -1, 'DAY'))


    where regexp_match(hits.page.pagePath,'/restaurant/')
    group each by 1,2,3,4,5) as a

  inner join each/*country*/
    (

    select *
    from
    (
    select fullVisitorId,visitId, hits.customDimensions.value as country,case when visitNumber=1 then "New Visitor" else "Returning Visitor" end as user_type
			,case when trafficSource.medium in ('organic', 'cpc', 'affiliate', 'referral' , 'display') then trafficSource.medium
			when trafficSource.medium in ('newsletter', 'Newsletter', 'email') then 'newsletter/email'
			else 'other'
			end as medium
      ,case when REGEXP_MATCH(hits.appInfo.landingScreenName,('.*/$|.*/[?].*')) then 'HP'
             when REGEXP_MATCH(hits.appInfo.landingScreenName,('.*/restaurants/.*|.*/.*/restaurants/.*|.*/restaurants.*')) then 'RLP'
             when REGEXP_MATCH(hits.appInfo.landingScreenName,('.*/restaurant/.*'))  then 'RDP'
             else 'other' end as landingPage
    from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -1, 'DAY'))
    where hits.customDimensions.index=3 and hits.customDimensions.value = 'IN'
    group by 1,2,3,4,5,6
    )
    ) as c2
    on a.visitId=c2.visitId and a.fullVisitorId=c2.fullVisitorId

    inner join each

    (select fullVisitorId,visitId, unique(hits.customDimensions.value) as customer_id
      from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -1, 'DAY'))
      where hits.customDimensions.index=31
      group by 1,2
      ) id 
    on a.visitId=id.visitId and a.fullVisitorId=id.fullVisitorId

    left outer join each /*CR steps*/
        (select date, fullvisitorid, visitid
          ,regexp_extract(hits.page.pagePath,'(?:/(?:restaurant|checkout|review-order|order/finishorder)/([^/]*))') as vendor_code
          ,case when sum(case when hits.eventinfo.eventaction='CR3 Start' then 1 else 0 end)>=1 then 1 else 0 end as CR3_start,
          case when sum(case when hits.eventinfo.eventaction='CR3a Completion' then 1 else 0 end)>=1 then 1 else 0 end as CR3a_completion,
          case when sum(case when hits.eventinfo.eventaction='CR3b Completion' then 1 else 0 end)>=1 then 1 else 0 end as CR3b_completion,
          case when sum(case when hits.eventinfo.eventaction='CR3c Completion' then 1 else 0 end)>=1 then 1 else 0 end as CR3c_completion,
          case when sum(case when hits.eventinfo.eventaction='CR3d Completion' then 1 else 0 end)>=1 then 1 else 0 end as CR3d_completion,
          case when sum(case when hits.eventinfo.eventaction='CR4 Start' then 1 else 0 end)>=1 then 1 else 0 end as CR4_start,
          case when sum(case when hits.eventinfo.eventaction='CR4 Completion' then 1 else 0 end)>=1 then 1 else 0 end as CR4_completion,
          case when sum(case when hits.eventinfo.eventaction='CR4a Completion' then 1 else 0 end)>=1 then 1 else 0 end as CR4a_completion,
          case when sum(case when hits.eventinfo.eventaction='CR4d Completion' then 1 else 0 end)>=1 then 1 else 0 end as CR4d_completion,
          case when sum(case when hits.eventinfo.eventaction='CR4e Completion' then 1 else 0 end)>=1 then 1 else 0 end as CR4e_completion
        from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -1, 'DAY'))
         where  regexp_match(hits.page.pagePath,'/(restaurant|checkout|review-order|order)/')
          group each by 1,2,3,4
        ) as st
        on st.date=a.date and a.fullvisitorid=st.fullvisitorid and a.visitid=st.visitid and a.vendor_code=st.vendor_code

       left outer join each /*CR steps_2*/
          (select date, fullvisitorid, visitid
                ,regexp_extract(hits.page.pagePath,'(?:/(?:restaurant|checkout|review-order|order/finishorder)/([^/]*))') as vendor_code
              ,case when sum(case when hits.eventinfo.eventaction='CR3 Completion' then 1 else 0 end)>=1 then 1 else 0 end as CR3_completion,
          from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -1, 'DAY'))
          where  regexp_match(hits.page.pagePath,'/review-order/')
          group each by 1,2,3,4
          ) as st2
        on st2.date=a.date and a.fullvisitorid=st2.fullvisitorid and a.visitid=st2.visitid and a.vendor_code=st2.vendor_code
  )
  group each by 1,2,3,4,5,6
  )
  where (length(vendor_code) = 0 or length(vendor_code) = 4 )
  and vendor_code='r1my'
