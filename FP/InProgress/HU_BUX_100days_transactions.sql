
            select b.country as country,
       b.date as date,
       c.transaction_id as transaction_id,
       sum (case when ((RLP<1 and a.error1>0 ) or a.error2>0 or  (a.error4_1>0 and a.error4_2<=0)
               or (a.error5_1>0 and a.error5_2<=0)
               or (a.error6_1>0 and a.error6_2<=0)
               or (a.error7_1>0 and a.error7_2<=0) ) then 1 else 0 end) as SessionsWithErrors,


       sum(case when a.RLP<1 and a.error1>0 then 1 else 0 end) as error1,
       sum(case when a.error2>0 then 1 else 0 end) as error2,
       0 as error3,
       sum(case when a.error4_1>0 and a.error4_2<1 then 1 else 0 end) as error4,
       sum(case when a.error5_1>0 and a.error5_2<1 then 1 else 0 end) as error5,
       sum(case when a.error6_1>0 and a.error6_2<1 then 1 else 0 end) as error6,
       sum(case when a.error7_1>0 and a.error7_2<1 then 1 else 0 end) as error7,
       sum(a.error8) as error8,
       sum((a.voucher))as error9,
       sum(case when a.SMS_ver_compl<1 and a.SMS_ver_start>0 then 1 else 0 end) as error10


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
               sum(case when REGEXP_MATCH(hits.appInfo.ScreenName,'^(Checkout Screen|Delivery Method Screen|Email Verification Screen|Address Book Screen|User Details Screen)')then 1 else 0 end) as error7_2,

               /*Voucher errors*/
               sum(case when REGEXP_MATCH(hits.eventInfo.eventAction,"Checkout _ Voucher error") then 1 else 0 end) as error8,
               sum(case when REGEXP_MATCH(hits.eventInfo.eventAction, "Voucher Report") then 1 else 0 end) as voucher,
                              /*SMS verification error*/
              case when sum(case when(REGEXP_MATCH(hits.appInfo.ScreenName,('Enter Phone Number Screen|SMS Verification Screen'))) then 1 else 0 end)>=1 then 1 else 0 end as SMS_ver_start,
              case when sum(case when(REGEXP_MATCH(hits.appInfo.ScreenName,('Address Book Screen|Payment Selection Screen'))) then 1 else 0 end)>=1 then 1 else 0 end as SMS_ver_compl,



          --from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')),TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
            --NETPINCER VIEW
            from TABLE_DATE_RANGE([96332490.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -100, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
           group each by 1,3,2,4
     )a

     join each


       (
       select date,
              fullVisitorId,
               (visitId) visitId ,
              upper(hits.customDimensions.value) as country
         --  from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')),TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
             --NETPINCER VIEW
            from TABLE_DATE_RANGE([96332490.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -100, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
           where  hits.customDimensions.index=1
           group each by 1,2,3,4

        )b

          on a.fullVisitorId=b.fullVisitorId and a.visitId=b.visitId


     join each

        (
        select date,
       fullVisitorId,
       (visitId) as visitId ,
       hits.transaction.transactionId as transaction_id

       --from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')),TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
        --NETPINCER VIEW
       from TABLE_DATE_RANGE([96332490.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -100, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
       --where  hits.customDimensions.index=38
       where totals.transactions>0 and hits.transaction.transactionId is not null
       group each by 1,2,3,4

            )c

            on a.fullVisitorId=c.fullVisitorId and a.visitId=c.visitId

          group each by 1,2,3
