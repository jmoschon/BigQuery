

  /*
  __      __  ___   ___
  \ \    / / | __| | _ )
   \ \/\/ /  | _|  | _ \
    \_/\_/   |___| |___/
    */

select
         errors.fullVisitorId as fullVisitorId, 
         errors.visitid as visitid,
         errors.country as country,
         errors.platform as platform,
         errors.Users,
         errors.date as date,
         errors1.formSubmited as formSubmited
from (
  select 
         a.fullVisitorId as fullVisitorId, 
         a.visitid as visitid,
         b.country as country,
         b.platform as platform,
         b.date as date,
         case when c.EXISTING_users>0 then 'EXISTING' when c.NEW_users>0 then 'NEW' else 'NA' end as Users,
        -- case when c.EXISTING_users>0 then 'EXISTING' when c.NEW_users>0 then 'NEW' else 'NA' end as Users,

         sum(case when (a.sessionsWithRLP<1 and a.error1>0) then 1 else 0 end) as error1,
        

         from   
          (
         select date,
                 fullVisitorId,
                 (visitId) as visitid,
                 'WEB' as platform,
                 sum(case when REGEXP_MATCH( hits.eventInfo.eventAction,'Validation Attempt' ) and (REGEXP_MATCH(hits.eventInfo.eventLabel,";NA") or REGEXP_MATCH(hits.eventInfo.eventLabel,"NA;"))then 1 else 0 end)  as error1,
                 sum(case when(regexp_match(hits.page.pagePath,'/restaurant')) then 1 else 0 end) as sessionsWithRLP,

              from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -9, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')),TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -9, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108857524.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -9, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
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
             from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -9, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')),TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -9, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108857524.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -9, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
                where  hits.customDimensions.index=3 and  (hits.customDimensions.value='HK' or hits.customDimensions.value='SG' or hits.customDimensions.value='IN') 
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
           from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -9, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')),TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -9, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108857524.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -9, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
           where  hits.customDimensions.index=38 
           group each by 1,2,3,4
           
          )c
                 
          on a.fullVisitorId=c.fullVisitorId and a.visitId=c.visitId and c.date=b.date 


            group each by 1,2,3,4,5,6
          having error1>0  
     )errors
/*join with the sessions with location errors and pull the event label*/
     join each

     (

  select 
         a.fullVisitorId as fullVisitorId, 
         a.visitid as visitid,
         b.country as country,
         b.platform as platform,
         b.date as date,
         a.hits.eventInfo.eventLabel as formSubmited
  --        c.Users,
        -- case when c.EXISTING_users>0 then 'EXISTING' when c.NEW_users>0 then 'NEW' else 'NA' end as Users,

        

         from   
          (
         select date,
                 fullVisitorId,
                 (visitId) as visitid,
                 'WEB' as platform,
                 hits.eventInfo.eventLabel,
                                   -- sum(case when REGEXP_MATCH( hits.eventInfo.eventAction,'Validation Attempt' ) and (REGEXP_MATCH(hits.eventInfo.eventLabel,";NA") or REGEXP_MATCH(hits.eventInfo.eventLabel,"NA;"))then 1 else 0 end)  as error1,
              from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -9, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')),TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -9, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108857524.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -9, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
              where hits.eventInfo.eventAction='Validation Form Submitted'  
                group each by 1,2,3,4,5
        )a
             
       join each 
             
         (
         select date,
                fullVisitorId,
                (visitId) as visitId ,
                upper(hits.customDimensions.value) as country,
                'WEB' as platform,
                 -- case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
             from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -9, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')),TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -9, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108857524.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -9, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
                where  hits.customDimensions.index=3 and (hits.customDimensions.value='HK' or hits.customDimensions.value='SG' or hits.customDimensions.value='IN') 
             group each by 1,2,3,4,5
             
           )b
                   
            on a.fullVisitorId=b.fullVisitorId and a.visitId=b.visitId and a.date=b.date             
            group each by 1,2,3,4,5,6 
     )errors1

on errors1.fullVisitorId=errors.fullVisitorId and errors1.visitid=errors.visitid and errors1.country= errors.country






