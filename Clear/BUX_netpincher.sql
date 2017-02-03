--
--
--  /*
--  __      __  ___   ___
--  \ \    / / | __| | _ )
--   \ \/\/ /  | _|  | _ \
--    \_/\_/   |___| |___/
--    */
--
--  select * from(
--
--
--  select  country,
--          platform,
--          date,
--          Users,
--          total_sessions,
--          coalesce(INTEGER(SessionsWithErrors),0) as SessionsWithErrors,
--          coalesce(INTEGER(total_transactions),0) as TotalTransactions,
--          coalesce(INTEGER(Sessions_withTransactions),0) as Sessions_withTransactions,
--          coalesce(TransactionsWithErrors,0) as TransactionsWithErrors,
--          coalesce(INTEGER(error1),0)as error1,
--          coalesce(INTEGER(error2),0)as error2,
--          coalesce(INTEGER(error3),0)as error3,
--          coalesce(INTEGER(error4),0)as error4,
--          coalesce(INTEGER(error5),0)as error5,
--          coalesce(INTEGER(error6),0) as error6,
--          coalesce(INTEGER(error7),0) as error7,
--          coalesce(INTEGER(error8),0)as error8,
--          coalesce(FLOAT(avg(error8/error9)),0) as error9,
--
--
--         coalesce(INTEGER(error1_withTransaction),0)as error1_withTransaction,
--         coalesce(INTEGER(error2_withTransaction),0)as error2_withTransaction,
--         coalesce(INTEGER(error3_withTransaction),0)as error3withTransaction,
--         coalesce(INTEGER(error4_withTransaction),0)as error4_withTransaction,
--         coalesce(INTEGER(error5_withTransaction),0)as error5_withTransaction,
--         coalesce(INTEGER(error6_withTransaction),0)as error6_withTransaction,
--         coalesce(INTEGER(error7_withTransaction),0)as error7_withTransaction,
--         coalesce(INTEGER(error8_withTransaction),0)as error8_withTransaction,
--          coalesce(avg (FLOAT(error8_withTransaction/error9_withTransaction)),0) as error9_withTransaction,
--           coalesce(INTEGER(error10),0) as error10,
--           coalesce(INTEGER(error10_withTransaction),0)as error10_withTransactions
--
--  from
--  (
--  select b.country,
--         b.platform,
--         b.date,
--  --        c.Users,
--        case when c.EXISTING_users>0 then 'EXISTING' when c.NEW_users>0 then 'NEW' else 'NA' end as Users,
--         sum(Total_session) as total_sessions,
--         sum (case when ((a.sessionsWithRLP<1 and a.error1>0) or a.error2>0 or (a.error3_1>0 or a.error3_2>0 or a.error3_3>0) or (a.error4_1>0 and a.error4_2<=0)
--                 or (a.error5_1>0 and a.error5_2<=0)
--                 or (a.error6_1>0 and a.error6_2<=0)
--                 or (a.error7_1>0 and a.error7_2<=0)
--                 ) then 1 else 0 end) as SessionsWithErrors,
--         sum (case when (Total_transactions>0 and ((a.sessionsWithRLP<1 and a.error1>0) or a.error2>0 or (a.error3_1>0 or a.error3_2>0 or a.error3_3>0) or   (a.error4_1>0 and a.error4_2<=0)
--                 or (a.error5_1>0 and a.error5_2<=0)
--                 or (a.error6_1>0 and a.error6_2<=0)
--                 or (a.error7_1>0 and a.error7_2<=0) )) then 1 else 0 end) as TransactionsWithErrors,
--         sum( Total_transactions) as total_transactions,
--         sum (case when Total_transactions>0 then 1 else 0 end) as Sessions_withTransactions,
--         sum(case when a.SMS_ver_compl<1 and a.SMS_ver_start>0 then 1 else 0 end) as error10,
--
--         --sum(case when a.error1>0 then 1 else 0 end) as error1,
--         sum(case when (a.sessionsWithRLP<1 and a.error1>0) then 1 else 0 end) as error1,
--         sum(case when a.error2>0 then  1 else 0 end) as error2,
--         sum(case when (a.error3_1>0 or a.error3_2>0 or a.error3_3>0) athen 1 else 0 end ) as error3,
--         sum(case when a.error4_1>0 and a.error4_2<=0 then 1 else 0 end) as error4,
--         sum(case when a.error5_1>0 and a.error5_2<=0 then 1 else 0 end) as error5,
--         sum(case when a.error6_1>0 and a.error6_2<=0 then 1 else 0 end) as error6,
--         sum(case when a.error7_1>0 and a.error7_2<=0 then 1 else 0 end) as error7,
--         sum(a.error8) as error8,
--         sum((a.error8+a.voucher_succ))as error9,
--
--         sum(case when a.error1>0 and a.sessionsWithRLP<1 and Total_transactions>0 then 1 else 0 end ) as error1_withTransaction,
--         sum(case when a.error2>0 and Total_transactions>0 then 1 else 0 end ) as error2_withTransaction,
--         sum(case when (a.error3_1>0 or a.error3_2>0 or a.error3_3>0) and Total_transactions>0 then 1 else 0 end ) as error3_withTransaction ,
--         sum(case when a.error4_1>0 and a.error4_2<=0 and Total_transactions>0 then 1 else 0 end) as error4_withTransaction,
--         sum(case when a.error5_1>0 and a.error5_2<=0 and Total_transactions>0 then 1 else 0 end) as error5_withTransaction,
--         sum(case when a.error6_1>0 and a.error6_2<=0 and Total_transactions>0 then 1 else 0 end) as error6_withTransaction,
--         sum(case when a.error7_1>0 and a.error7_2<=0 and Total_transactions>0 then 1 else 0 end) as error7_withTransaction,
--         sum(case when Total_transactions>0 then a.error8 else 0 end) as error8_withTransaction,
--  --        FLOAT (avg(case when Total_transactions>0 then (a.error6/(a.error6+a.voucher_succ)) else 1 end ))as error7_withTransaction,
--         sum(case when Total_transactions>0 then a.voucher_succ+a.error8 else 0 end) as error9_withTransaction,
--         sum(case when Total_transactions>0 and a.SMS_ver_compl<1 and a.SMS_ver_start>0 then 1 else 0 end) as error10_withTransaction
--
--
--         from
--
--          (
--         select date,
--                 fullVisitorId,
--                 (visitId) as visitid,
--                 'WEB' as platform,
--                 -- case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
--                 sum(totals.visits) Total_session,
--                 sum(totals.transactions) as Total_Transactions,
--                 /*User locates successfully but cannot find enough inventory*/
--                 sum(case when  REGEXP_MATCH( hits.eventInfo.eventAction,'Zero Vendors Message') then 1 else 0 end) as error2,
--                 /*User tries to locates himself but fails at least one time*/
--                 sum(case when REGEXP_MATCH( hits.eventInfo.eventAction,'Validation Attempt' ) and (REGEXP_MATCH(hits.eventInfo.eventLabel,";NA") or REGEXP_MATCH(hits.eventInfo.eventLabel,"NA;"))then 1 else 0 end)  as error1,
--                 sum(case when(regexp_match(hits.page.pagePath,'^/restaurants')) then 1 else 0 end) as sessionsWithRLP,
--                 /*User goes through process but faces restaurant closure or site flood feature*/
--                 sum(case when  (REGEXP_MATCH( hits.eventInfo.eventAction,'Restaurant Status - Flood Feature') and REGEXP_MATCH( hits.eventInfo.eventCategory,'Restaurant Detail Page')) then 1 else 0 end) as error3_1,
--                 sum(case when  (REGEXP_MATCH( hits.eventInfo.eventAction,'Restaurant Status - Closed') and REGEXP_MATCH( hits.eventInfo.eventCategory,'Restaurant Detail Page') ) then 1 else 0 end) as error3_2,
--                 sum(case when  (REGEXP_MATCH( hits.eventInfo.eventAction,'Restaurant Status - FP Closed') and REGEXP_MATCH( hits.eventInfo.eventCategory,'Restaurant Detail Page') ) then 1 else 0 end) as error3_3,
--                 /*User goes through checkout but faces payment issue*/
--                 sum(case when  (REGEXP_MATCH( hits.eventInfo.eventAction,'CR4d Completion') and REGEXP_MATCH( hits.eventInfo.eventCategory,'Goal') ) then 1 else 0 end) as error4_1,
--                 sum(case when  (REGEXP_MATCH( hits.eventInfo.eventAction,'CR4e Completion') and REGEXP_MATCH( hits.eventInfo.eventCategory,'Goal') ) then 1 else 0 end) as error4_2,
--                 /*User adds item to cart, but seems blocked by variation and toppings screen*/
--                 sum(case when  (REGEXP_MATCH( hits.eventInfo.eventAction,'CR3b Completion') ) then 1 else 0 end) as error5_1,
--                 sum(case when  (REGEXP_MATCH( hits.eventInfo.eventAction,'CR3c Completion') ) then 1 else 0 end) as error5_2,
--                 /*User adds item to cart successfully but doesnt reach MoV*/
--                 sum(case when  (REGEXP_MATCH( hits.eventInfo.eventAction,'CR3c Completion') ) then 1 else 0 end) as error6_1,
--                 sum(case when  (REGEXP_MATCH( hits.eventInfo.eventAction,'CR3d Completion') ) then 1 else 0 end) as error6_2,
--                 /*User reaches MoV but doesnt start checkout - fees to high?*/
--                 sum(case when  (REGEXP_MATCH( hits.eventInfo.eventAction,'CR3d Completion') ) then 1 else 0 end) as error7_1,
--                 sum(case when  (REGEXP_MATCH( hits.eventInfo.eventAction,'CR3 Completion') ) then 1 else 0 end) as error7_2,
--                 /*Voucher errors*/
--                 sum(case when  REGEXP_MATCH( hits.eventInfo.eventAction,'Voucher Applied Error') then 1 else 0 end) as error8,
--                 sum(case when  REGEXP_MATCH( hits.eventInfo.eventAction,'Voucher Successful Applied') then 1 else 0 end) as voucher_succ,
--
--           case when sum(case when(regexp_match(hits.page.pagePath,'/customer/verification')) then 1 else 0 end)>=1 then 1 else 0 end as SMS_ver_start,
--           case when sum(case when(regexp_match(hits.page.pagePath,'/review-order')) then 1 else 0 end)>=1 then 1 else 0 end as SMS_ver_compl,
--
--
--
--              from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')),TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108857524.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
--                group each by 1,2,3,4
--        )a
--
--       join each
--
--         (
--         select date,
--                fullVisitorId,
--                (visitId) as visitId ,
--                upper(hits.customDimensions.value) as country,
--                'WEB' as platform,
--                 -- case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
--             from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')),TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108857524.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
--                where  hits.customDimensions.index=3
--             group each by 1,2,3,4,5
--
--           )b
--
--            on a.fullVisitorId=b.fullVisitorId and a.visitId=b.visitId and a.date=b.date
--
--
--      left join each
--
--        (
--         select date,
--                fullVisitorId,
--                (visitId) as visitId ,
--                'WEB' as platform,
--  --               'NA' as Users,
--                sum (case when REGEXP_MATCH(hits.customDimensions.value,'NA') then 1 else 0 end ) as NA_users,
--                sum (case when REGEXP_MATCH(hits.customDimensions.value,'existing') then 1 else 0 end ) as EXISTING_users,
--                sum (case when REGEXP_MATCH(hits.customDimensions.value,'new') then 1 else 0 end ) as NEW_users,
--  --               upper(hits.customDimensions.value) as Users
--                 -- case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
--             from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')),TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108857524.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
--             where  hits.customDimensions.index=38
--             group each by 1,2,3,4
--
--            )c
--
--            on a.fullVisitorId=c.fullVisitorId and a.visitId=c.visitId and c.date=b.date
--
--            group each by 1,2,3,4
--
--            )
--             group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,19,20,21,22,23,24,25,26,28,29)as web
--      ,/*
--__      __  ___   ___
--APP
--*/
(
select  country,
        platform,
        date,
        Users,
        total_sessions,
        coalesce(INTEGER(SessionsWithErrors),0) as SessionsWithErrors,
        coalesce(INTEGER(total_transactions),0) as TotalTransactions,
        coalesce(INTEGER(Sessions_withTransactions),0) as Sessions_withTransactions,
        coalesce(TransactionsWithErrors,0) as TransactionsWithErrors,
        coalesce(INTEGER(error1),0)as error1,
        coalesce(INTEGER(error2),0)as error2,
        coalesce(INTEGER(error3),0)as error3,
        coalesce(INTEGER(error4),0)as error4,
        coalesce(INTEGER(error5),0)as error5,
        coalesce(INTEGER(error6),0) as error6,
        coalesce(INTEGER(error7),0) as error7,
        coalesce(INTEGER(error8),0)as error8,
        coalesce(FLOAT(avg(error8/error9)),0) as error9,


       coalesce(INTEGER(error1_withTransaction),0)as error1_withTransaction,
       coalesce(INTEGER(error2_withTransaction),0)as error2_withTransaction,
       coalesce(INTEGER(error3_withTransaction),0)as error3withTransaction,
       coalesce(INTEGER(error4_withTransaction),0)as error4_withTransaction,
       coalesce(INTEGER(error5_withTransaction),0)as error5_withTransaction,
       coalesce(INTEGER(error6_withTransaction),0)as error6_withTransaction,
       coalesce(INTEGER(error7_withTransaction),0)as error7_withTransaction,
       coalesce(INTEGER(error8_withTransaction),0)as error8_withTransaction,
        coalesce(avg (FLOAT(error8_withTransaction/error9_withTransaction)),0) as error9_withTransaction,
        coalesce(INTEGER(error10),0) as error10,
       coalesce(INTEGER(error10_withTransaction),0)as error10_withTransactions

from
(
select b.country as country,
       b.platform as platform,
       b.date as date,
       'ALL'as Users,
       sum(Total_sessions) as total_sessions,
       sum (case when ((RLP<1 and a.error1>0 ) or a.error2>0 or  (a.error4_1>0 and a.error4_2<=0)
               or (a.error5_1>0 and a.error5_2<=0)
               or (a.error6_1>0 and a.error6_2<=0)
               or (a.error7_1>0 and a.error7_2<=0) ) then 1 else 0 end) as SessionsWithErrors,
       sum (case when (Total_transactions>0 and ((RLP<1 and a.error1>0 ) or a.error2>0 or  (a.error4_1>0 and a.error4_2<=0)
               or (a.error5_1>0 and a.error5_2<=0)
               or (a.error6_1>0 and a.error6_2<=0)
               or (a.error7_1>0 and a.error7_2<=0))) then 1 else 0 end) as TransactionsWithErrors,
       sum(case when Total_transactions>0 then 1 else 0 end) as Sessions_withTransactions,
       sum(Total_transactions) as total_transactions,
       sum(case when a.RLP<1 and a.error1>0 then 1 else 0 end) as error1,
       sum(case when a.error2>0 then 1 else 0 end) as error2,
       'N/A' as error3,
       sum(case when a.error4_1>0 and a.error4_2<1 then 1 else 0 end) as error4,
       sum(case when a.error5_1>0 and a.error5_2<1 then 1 else 0 end) as error5,
       sum(case when a.error6_1>0 and a.error6_2<1 then 1 else 0 end) as error6,
       sum(case when a.error7_1>0 and a.error7_2<1 then 1 else 0 end) as error7,
       sum(a.error8) as error8,
       sum((a.voucher))as error9,
       sum(case when a.SMS_ver_compl<1 and a.SMS_ver_start>0 then 1 else 0 end) as error10,

       sum(case when a.RLP<1 and a.error1>0 and Total_transactions>0 then 1 else 0 end) as error1_withTransaction,
       sum(case when a.error2>0 and Total_transactions>0 then 1 else 0 end) as error2_withTransaction,
       'NA' as error3_withTransaction,
       sum(case when (a.error4_1>0 and a.error4_2<1)<0 and Total_transactions>0 then 1 else 0 end) as error4_withTransaction,
       sum(case when (a.error5_1>0 and a.error5_2<1)<0 and Total_transactions>0 then 1 else 0 end) as error5_withTransaction,
       sum(case when (a.error6_1>0 and a.error6_2<1)<0 and Total_transactions>0 then 1 else 0 end) as error6_withTransaction,
       sum(case when (a.error7_1>0 and a.error7_2<1)<0 and Total_transactions>0 then 1 else 0 end) as error7_withTransaction,
       sum(case when Total_transactions>0 then a.error8 else 0 end) as error8_withTransaction,
       sum(case when Total_transactions>0 then a.voucher else 0 end) as error9_withTransaction,
       /*SMS var*/
       sum(case when Total_transactions>0 and a.SMS_ver_compl<1 and a.SMS_ver_start>0 then 1 else 0 end) as error10_withTransaction





       from
      (
       select date,
               fullVisitorId,
               (visitId) as visitid,
               'APP' as platform,
               --case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,

               sum(totals.visits) Total_sessions,
               sum(totals.transactions) as Total_Transactions,
               /*User locates successfully but cannot find enough inventory*/
               sum(case when (REGEXP_MATCH(hits.eventInfo.eventCategory,'Location')
                         and REGEXP_MATCH(hits.eventInfo.eventAction,'Quantity Restaurants Displayed')
                         and REGEXP_MATCH(hits.eventInfo.eventLabel,"=0")) then 1 else 0 end) as error2,

               /*User tries to locates himself but fails at least one time*/
               sum(case when (REGEXP_MATCH( hits.eventInfo.eventAction,'Pickers - Area list \\(Display\\)' )
                        or   REGEXP_MATCH(hits.eventInfo.eventAction,'Pickers - City list \\(Display\\)')
                        or   REGEXP_MATCH(hits.eventInfo.eventAction,"Location Screen - Click on City")
                        or   REGEXP_MATCH(hits.eventInfo.eventAction,'Pickers - City list \\(Selected\\)')
                        or   REGEXP_MATCH(hits.eventInfo.eventAction,"Location Screen - Click on GPS location")
                        or   REGEXP_MATCH(hits.eventInfo.eventAction,'Pickers - Address \\(Search\\)'))then 1 else 0 end)  as error1,
               sum(case when REGEXP_MATCH(hits.appInfo.ScreenName,'Restaurants') then 1 else 0 end ) as RLP,

               /*User goes through process but faces restaurant closure or site flood feature*/
               /*
                *
                * MISSING
                *
                *
                */
               /*User goes through checkout but faces payment issue*/
               sum(case when (REGEXP_MATCH(hits.eventInfo.eventCategory,'Transaction')
                         and REGEXP_MATCH(hits.eventInfo.eventAction,'Checkout _ Payment option'))then 1 else 0 end) as error4_1,
               sum(case when REGEXP_MATCH(hits.type,"TRANSACTION") then 1 else 0 end ) as error4_2,
               /*User adds item to cart, but seems blocked by variation and toppings screen*/
               sum(case when REGEXP_MATCH(hits.eventInfo.eventAction,'RDP _ Toppings pickers \\(display\\)') then 1 else 0 end) as error5_1,
               sum(case when REGEXP_MATCH(hits.eventInfo.eventAction,'RDP _ Toppings selected \\(Success\\)') then 1 else 0 end) as error5_2,
               /*User adds item to cart successfully but doesnt reach MoV*/
               sum(case when REGEXP_MATCH(hits.eventInfo.eventAction,'RDP - Minimum value \\(called on basket\\)') then 1 else 0 end) as error6_1,
               sum(case when REGEXP_MATCH(hits.eventInfo.eventAction,'RDP - Minimum value reached \\(On Basket\\)')then 1 else 0 end) as error6_2,
               /*User reaches MoV but doesnt start checkout - fees to high?*/

               sum(case when REGEXP_MATCH(hits.eventInfo.eventAction,'RDP - Minimum value reached \\(On Basket\\)')then 1 else 0 end) as error7_1,
               sum(case when REGEXP_MATCH(hits.appInfo.ScreenName,'^(Checkout Screen|Delivery Method|Email Verification Screen|Address Book Screen|User Details Screen)')then 1 else 0 end) as error7_2,

               /*Voucher errors*/
               sum(case when REGEXP_MATCH(hits.eventInfo.eventAction,"Checkout _ Voucher error") then 1 else 0 end) as error8,
               sum(case when REGEXP_MATCH(hits.eventInfo.eventAction, "Voucher Report") then 1 else 0 end) as voucher,
                              /*SMS verification error*/
              case when sum(case when(REGEXP_MATCH(hits.appInfo.ScreenName,('Enter Phone Number Screen|SMS Verification Screen'))) then 1 else 0 end)>=1 then 1 else 0 end as SMS_ver_start,
              case when sum(case when(REGEXP_MATCH(hits.appInfo.ScreenName,('Adress Book Screen|Payment Selection Screen'))) then 1 else 0 end)>=1 then 1 else 0 end as SMS_ver_compl,



          from TABLE_DATE_RANGE([96332490.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
          --,TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

           group each by 1,3,2,4
     )a

     join each


       (
       select date,
              fullVisitorId,
               (visitId) visitId ,
              upper(hits.customDimensions.value) as country,
              'APP' as platform,
               --case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
           from TABLE_DATE_RANGE([96332490.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
           --,TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

           where  hits.customDimensions.index=1
           group each by 1,2,3,4,5

        )b

          on a.fullVisitorId=b.fullVisitorId and a.visitId=b.visitId and a.date=b.date

          group each by 1,2,3,4

          )
          group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,19,20,21,22,23,24,25,26,28,29) as app


