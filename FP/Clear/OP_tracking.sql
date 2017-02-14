select * from
(    select

       ak.country country,
      'WEB' as platform,
      ak.deviceCategory as deviceCategory,
      ak.payment as payment,
      sum (case when ak.dif1<1 then 1 else 0 end) as lessThan1,
      sum (case when ak.dif1<2 and ak.dif1>=1 then 1 else 0 end) as _1to2,
      sum (case when ak.dif1<3 and ak.dif1>=2 then 1 else 0 end) as _2to3,
      sum (case when ak.dif1<4 and ak.dif1>=3 then 1 else 0 end) as _3to4,
      sum (case when ak.dif1<5 and ak.dif1>=4 then 1 else 0 end) as _4to5,
      sum (case when ak.dif1<6 and ak.dif1>=5 then 1 else 0 end) as _5to6,
      sum (case when ak.dif1<7 and ak.dif1>=6 then 1 else 0 end) as _6to7,
      sum (case when ak.dif1<8 and ak.dif1>=7 then 1 else 0 end) as _7to8,
      sum (case when ak.dif1<9 and ak.dif1>=8 then 1 else 0 end) as _8to9,
      sum (case when ak.dif1<10 and ak.dif1>=9 then 1 else 0 end) as _9to10,
      sum (case when ak.dif1<11 and ak.dif1>=10 then 1 else 0 end) as _10to11,
      sum (case when ak.dif1<12 and ak.dif1>=11 then 1 else 0 end) as _11to12,
      sum (case when ak.dif1<13 and ak.dif1>=12 then 1 else 0 end) as _12to13,
      sum (case when ak.dif1<14 and ak.dif1>=13 then 1 else 0 end) as _13to14,
      sum (case when ak.dif1<15 and ak.dif1>=14 then 1 else 0 end) as _14to15,

     from (

    select a.fullvisitorid as fullVisitorId,
     a.visitid as visitid,
     a.deviceCategory as deviceCategory,
     a.Payment as payment,
     a.time as time_order_place_button,
     b.time as time_transaction,
     a.hitNumber as order_place_button_hitNumber,
     b.hitNumber as transaction_hitNumber,
    --  case when b.hitNumber-a.hitNumber = min(b.hitNumber-a.hitNumber) then 1 else 0 end as peos,
      min(b.hitNumber-a.hitNumber) as dif,

     (b.time - a.time )/ 60000 as dif1,
     countries.country as country
     from
    (
    select date,
                  fullvisitorid,
                  visitid,
                  'WEB' as platform,
                  device.deviceCategory as deviceCategory,
                  hits.eventInfo.eventLabel as Payment,
                  hits.time as time,
                  hits.hitNumber as hitNumber,
                  sum(totals.visits) as sessions,
                  sum(totals.transactions) as gross_orders,
                  SUM(case when hits.eventInfo.eventAction='NA' then 1 else 0 end) as hasNA


            from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -30, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
            , TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -30, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
            , TABLE_DATE_RANGE([108857524.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -30, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
            where totals.transactions=1 and hits.eventInfo.eventAction='Select Payment'  --and hits.customDimensions.index=3

            group each by 1,2,3,4,5,6,7,8
    )a
    join each

    (
    select date,
                  fullvisitorid,
                  visitid,
                  'WEB' as platform,
                  device.deviceCategory as deviceCategory,
    --              hits.eventInfo.eventLabel as Payment,
                  hits.time as time,
                  hits.hitNumber as hitNumber,
                  sum(totals.visits) as sessions,
                  sum(totals.transactions) as gross_orders,

            from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -30, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
            , TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -30, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
            , TABLE_DATE_RANGE([108857524.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -30, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
            where totals.transactions=1 and hits.Type='TRANSACTION'  --and hits.customDimensions.index=3

            group each by 1,2,3,4,5,6,7

    )b

    on a.date=b.date and a.visitid=b.visitid and a.fullvisitorid=b.fullvisitorid

    join each

    (
    select date,
                  fullvisitorid,
                  visitid,
                  hits.customDimensions.value  as country


            from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -30, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
            , TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -30, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
            , TABLE_DATE_RANGE([108857524.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -30, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
            where hits.customDimensions.index=3

            group each by 1,2,3,4

    )countries

    on a.date=countries.date and a.visitid=countries.visitid and a.fullvisitorid=countries.fullvisitorid

    group by 1,2,3,4,5,6,7,8,10,11

    )ak

    join each
    (
    select a.fullvisitorid,
     a.visitid,
      min(b.hitNumber-a.hitNumber) as dif
     from
    (
    select date,
                  fullvisitorid,
                  visitid,
                  'WEB' as platform,
                  device.deviceCategory as deviceCategory,
                  hits.eventInfo.eventLabel as Payment,
                  hits.time as time,
                  hits.hitNumber as hitNumber,
                  sum(totals.visits) as sessions,
                  sum(totals.transactions) as gross_orders,
                  SUM(case when hits.eventInfo.eventAction='NA' then 1 else 0 end) as hasNA


            from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -30, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
            , TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -30, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
            , TABLE_DATE_RANGE([108857524.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -30, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
            where totals.transactions=1 and hits.eventInfo.eventAction='Select Payment'  --and hits.customDimensions.index=3

            group each by 1,2,3,4,5,6,7,8
    )a
    join each

    (
    select date,
                  fullvisitorid,
                  visitid,
                  'WEB' as platform,
                  device.deviceCategory as deviceCategory,
    --              hits.eventInfo.eventLabel as Payment,
                  hits.time as time,
                  hits.hitNumber as hitNumber,
                  sum(totals.visits) as sessions,
                  sum(totals.transactions) as gross_orders,

            from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -30, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
            , TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -30, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
            , TABLE_DATE_RANGE([108857524.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -30, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
            where totals.transactions=1 and hits.Type='TRANSACTION'  --and hits.customDimensions.index=3

            group each by 1,2,3,4,5,6,7

    )b

    on a.date=b.date and a.visitid=b.visitid and a.fullvisitorid=b.fullvisitorid

    where --a.fullVisitorId = '1438878517396758658' and a.visitId = 1484402370 and
    b.hitNumber-a.hitNumber>0
    group by 1,2

    )bk

    on ak.fullvisitorid=bk.fullVisitorId and ak.visitid=bk.visitid

    where bk.dif=ak.dif
    group by 1,2,3,4
)

,

(

select country, platform,deviceCategory,FIRST(split(NTH(2,SPLIT(ak.payment,'55=')),';113')) as payment,
_1to2,_2to3,_3to4,_4to5,_5to6,_6to7,_7to8,_8to9,_9to10,_10to11,_11to12,_12to13,_13to14,_14to15
from(
    select

       ak.country,
      'APP' as platform,
      ak.deviceCategory,
      ak.payment,

--      REGEXP_EXTRACT(ak.payment,'55=') as second_part,
      sum (case when ak.dif1<1 then 1 else 0 end) as lessThan1,
      sum (case when ak.dif1<2 and ak.dif1>=1 then 1 else 0 end) as _1to2,
      sum (case when ak.dif1<3 and ak.dif1>=2 then 1 else 0 end) as _2to3,
      sum (case when ak.dif1<4 and ak.dif1>=3 then 1 else 0 end) as _3to4,
      sum (case when ak.dif1<5 and ak.dif1>=4 then 1 else 0 end) as _4to5,
      sum (case when ak.dif1<6 and ak.dif1>=5 then 1 else 0 end) as _5to6,
      sum (case when ak.dif1<7 and ak.dif1>=6 then 1 else 0 end) as _6to7,
      sum (case when ak.dif1<8 and ak.dif1>=7 then 1 else 0 end) as _7to8,
      sum (case when ak.dif1<9 and ak.dif1>=8 then 1 else 0 end) as _8to9,
      sum (case when ak.dif1<10 and ak.dif1>=9 then 1 else 0 end) as _9to10,
      sum (case when ak.dif1<11 and ak.dif1>=10 then 1 else 0 end) as _10to11,
      sum (case when ak.dif1<12 and ak.dif1>=11 then 1 else 0 end) as _11to12,
      sum (case when ak.dif1<13 and ak.dif1>=12 then 1 else 0 end) as _12to13,
      sum (case when ak.dif1<14 and ak.dif1>=13 then 1 else 0 end) as _13to14,
      sum (case when ak.dif1<15 and ak.dif1>=14 then 1 else 0 end) as _14to15,

     from (

    select a.fullvisitorid as fullVisitorId,
     a.visitid as visitid,
     a.deviceCategory as deviceCategory,
     a.Payment as payment,
     a.time as time_order_place_button,
     b.time as time_transaction,
     a.hitNumber as order_place_button_hitNumber,
     b.hitNumber as transaction_hitNumber,
    --  case when b.hitNumber-a.hitNumber = min(b.hitNumber-a.hitNumber) then 1 else 0 end as peos,
      min(b.hitNumber-a.hitNumber) as dif,

     (b.time - a.time )/ 60000 as dif1,
     countries.country as country
     from
    (
    select date,
                  fullvisitorid,
                  visitid,
                  'WEB' as platform,
                  device.operatingSystem as deviceCategory,
                  hits.eventInfo.eventLabel as Payment,
                  hits.time as time,
                  hits.hitNumber as hitNumber,
                  sum(totals.visits) as sessions,
                  sum(totals.transactions) as gross_orders,
                  SUM(case when hits.eventInfo.eventAction='NA' then 1 else 0 end) as hasNA


            from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -30, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
            , TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -30, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
            , TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -30, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
            where totals.transactions=1 and hits.eventInfo.eventAction='Place Order Button'  --and hits.customDimensions.index=3

            group each by 1,2,3,4,5,6,7,8
    )a
    join each

    (
    select date,
                  fullvisitorid,
                  visitid,
                  'WEB' as platform,
                  device.deviceCategory as deviceCategory,
    --              hits.eventInfo.eventLabel as Payment,
                  hits.time as time,
                  hits.hitNumber as hitNumber,
                  sum(totals.visits) as sessions,
                  sum(totals.transactions) as gross_orders,

            from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -30, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
            , TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -30, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
            , TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -30, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
            where totals.transactions=1 and hits.Type='TRANSACTION'  --and hits.customDimensions.index=3

            group each by 1,2,3,4,5,6,7

    )b

    on a.date=b.date and a.visitid=b.visitid and a.fullvisitorid=b.fullvisitorid

    join each

    (
    select date,
                  fullvisitorid,
                  visitid,
                  hits.customDimensions.value  as country


            from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -30, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
            , TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -30, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
            , TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -30, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
            where hits.customDimensions.index=1 --and hits.customDimensions.value='IN'

            group each by 1,2,3,4

    )countries

    on a.date=countries.date and a.visitid=countries.visitid and a.fullvisitorid=countries.fullvisitorid

    group by 1,2,3,4,5,6,7,8,10,11

    )ak

    join each
    (
    select a.fullvisitorid,
     a.visitid,
      min(b.hitNumber-a.hitNumber) as dif
     from
    (
    select date,
                  fullvisitorid,
                  visitid,
                  'WEB' as platform,
                  device.deviceCategory as deviceCategory,
                  hits.eventInfo.eventLabel as Payment,
                  hits.time as time,
                  hits.hitNumber as hitNumber,
                  sum(totals.visits) as sessions,
                  sum(totals.transactions) as gross_orders,
                  SUM(case when hits.eventInfo.eventAction='NA' then 1 else 0 end) as hasNA


            from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -30, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
            , TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -30, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
            , TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -30, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
            where totals.transactions=1 and hits.eventInfo.eventAction='Place Order Button'  --and hits.customDimensions.index=3

            group each by 1,2,3,4,5,6,7,8
    )a
    join each

    (
    select date,
                  fullvisitorid,
                  visitid,
                  'WEB' as platform,
                  device.deviceCategory as deviceCategory,
    --              hits.eventInfo.eventLabel as Payment,
                  hits.time as time,
                  hits.hitNumber as hitNumber,
                  sum(totals.visits) as sessions,
                  sum(totals.transactions) as gross_orders,

            from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -30, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
            , TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -30, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
            , TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -30, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
            where totals.transactions=1 and hits.Type='TRANSACTION'  --and hits.customDimensions.index=3

            group each by 1,2,3,4,5,6,7

    )b

    on a.date=b.date and a.visitid=b.visitid and a.fullvisitorid=b.fullvisitorid

    where --a.fullVisitorId = '1438878517396758658' and a.visitId = 1484402370 and
    b.hitNumber-a.hitNumber>0
    group by 1,2

    )bk

    on ak.fullvisitorid=bk.fullVisitorId and ak.visitid=bk.visitid

    where bk.dif=ak.dif
    group by 1,2,3,4
)
)app