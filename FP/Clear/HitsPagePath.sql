select * from
(
select a.date,
       a.platform_agg,
       b.country,
       sum(a.homepage) as homepage,
       sum(a.RLP) as rlp,
       sum(a.RDP) as rdp,
       sum(a.Review_order) as Review_order,
       sum(a.finish_order) as finish_oreder

from
          
     flatten (
     (
     select date,
              fullvisitorId,
              unique(visitId) as visitId,
              device.deviceCategory,
              case when device.deviceCategory='desktop' OR device.deviceCategory='tablet' OR device.deviceCategory='mobile' then 'WEB' end as platform_agg,
              case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
              sum(totals.visits) as sessions,
              sum(totals.transactions) as gross_orders,
              sum(case when(regexp_match(hits.page.pagePath,'^(/$|/\\?.*)')) then 1 else 0 end) as homepage,
              sum(case when(regexp_match(hits.page.pagePath,'.*/restaurants/.*')) then 1 else 0 end) as  RLP,
              sum(case when(regexp_match(hits.page.pagePath,'.*/restaurant/.*')) then 1 else 0 end)as RDP,
              sum(case when(regexp_match(hits.page.pagePath,'.*/review-order/.*')) then 1 else 0 end)as Review_order,
              sum(case when(regexp_match(hits.page.pagePath,'.*/finishorder/.*')) then 1 else 0 end)as finish_order
       from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -62, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -62, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108857524.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -62, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
       group each by 1,2,4,5,6
   ),visitId
     )a  
     
          join each 
           
       ( 
       select date,
              fullVisitorId,
              visitId ,
              upper(hits.customDimensions.value) as country,
              'WEB' as platform,
               -- case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
            from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -62, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -62, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108857524.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -62, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

           where  hits.customDimensions.index=3 
           group by 1,2,3,4,5
           
          )b
           on a.fullVisitorId=b.fullVisitorId and a.visitId=b.visitId and a.date=b.date 
           
           group by 1,2,3)as web
           


            