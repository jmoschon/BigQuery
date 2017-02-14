

     Select * from
    (Select date(b.date) as ga_date,
            year(CAST(b.date AS TIMESTAMP)) as ga_year,
            case when b.date in('20160101','20160102') then '2015-53' else case when length(string(week(CAST(b.date AS TIMESTAMP))))=1 then CONCAT(string(year(CAST(b.date AS TIMESTAMP))),'-0',string(week(CAST(b.date AS TIMESTAMP)))) else CONCAT(string(year(CAST(b.date AS TIMESTAMP))),'-',string(week(CAST(b.date AS TIMESTAMP)))) end end as ga_week,
            case when dayofweek(CAST(b.date AS TIMESTAMP))=1 then '1.Sunday'
                 when dayofweek(CAST(b.date AS TIMESTAMP))=2 then '2.Monday'
                 when dayofweek(CAST(b.date AS TIMESTAMP))=3 then '3.Tuesday'
                 when dayofweek(CAST(b.date AS TIMESTAMP))=4 then '4.Wednesday'
                 when dayofweek(CAST(b.date AS TIMESTAMP))=5 then '5.Thursday'
                 when dayofweek(CAST(b.date AS TIMESTAMP))=6 then '6.Friday'
                 when dayofweek(CAST(b.date AS TIMESTAMP))=7 then '7.Saturday' else 'none'
            END as ga_day,
            countries.country as country,
            iso.common_name as common_name,
            b.device.operatingSystem as platform,
            b.platform_agg as platform_agg,
            b.Users as user_type,
            countries.channel as channel,
            b.start_time as hourTime,
--            'N/A' as landing_page,
--            'a' as sorting,
--            b.language as language,
--            dim_area.city as city,
--            dim_area.area as area,
            sum(case when (RLP_RPD<1 and orderStatus>0) then 0 else b.sessions end) as visits,
            sum(b.gross_orders) as orders,
            sum(CR1_start) as hp_rlp_start,
            INTEGER(sum(CR1_complete)) as hp_rlp_complete,
            sum(b.CR2_start) as rlp_rdp_start,
            sum(b.CR3_start) as rlp_rdp_complete,
            sum(b.CR3_start) as rdp_co_start,
            sum(b.CR4_start) as rdp_co_complete,
            sum(b.CR4_start) as co_so_start,
            sum(b.CR4_complete) as co_so_complete
      from

         ( select date,
                  fullvisitorId,
                  visitId,
                  device.operatingSystem,
                  case when device.operatingSystem='Android' OR device.operatingSystem='iOS' then 'APP' end as platform_agg,
                  case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
                  hour(timestamp(integer(visitStartTime*1000000))) as start_time,
                  upper(regexp_extract(device.language,r'([^_]*)')) as language,
                  sum(totals.visits) as sessions,
                  sum(totals.transactions) as gross_orders,
                   sum(case when REGEXP_MATCH(hits.appInfo.ScreenName,'Restaurant') then 1 else 0 end ) as RLP_RPD,
                   sum(case when REGEXP_MATCH(hits.appInfo.ScreenName,'Order Status Screen') then 1 else 0 end) as orderStatus,
                  case when sum(case when(REGEXP_MATCH(hits.appInfo.ScreenName,('Onboarding|Location'))) then 1 else 0 end)>=1 then 1 else 0 end as CR1_start,
                  case when sum(case when(REGEXP_MATCH(hits.appInfo.ScreenName,'Restaurants')) then 1 else 0 end)>=1 then 1 else 0 end as CR2_start,
                  case when sum(case when(REGEXP_MATCH(hits.appInfo.ScreenName,'Restaurant[^s]')) then 1 else 0 end)>=1 then 1 else 0 end as CR3_start,
                  case when sum(case when(REGEXP_MATCH(hits.appInfo.ScreenName,'^(Checkout Screen|Delivery Method Screen|Email Verification Screen|Address Book Screen|User Details Screen|SMS Verification Screen|Enter Phone Number Screen|Order Summary Screen)')) then 1 else 0 end)>=1 then 1 else 0 end as CR4_start,
                  case when sum(case when(REGEXP_MATCH(hits.appInfo.ScreenName,'^Checkout Confirmation Screen')) then 1 else 0 end)>=1 then 1 else 0 end as CR4_complete
           from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
           --, TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
           group each by 1,2,3,4,5,6,7,8


         )b

    /*********************joining CR1 complete**************************/

    left join each

        (
          select c.date as date,
                c.fullVisitorId as fullVisitorId,
                c.visitId as visitId,
                count(c.hits) as CR1_complete

          from

            (
              Select date,
                     fullVisitorId,
                     visitId,
                     max(hits.hitnumber) as hits
              from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
              --, TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
              where REGEXP_MATCH(hits.appInfo.screenName,'Restaurants')
              group each by 1,2,3
            ) c

    join each

          (
            Select date,
                    fullVisitorId,
                    visitId,
                    min(hits.hitnumber) as hits
             from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
             --, TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
             where REGEXP_MATCH(hits.appInfo.screenName,'(Onboarding|Location)')
             group each  by 1,2,3
           ) b on c.fullvisitorId=b.fullvisitorId and c.visitid=b.visitid and c.date=b.date
             where c.hits>b.hits
             group each by 1,2,3
        ) a on a.fullvisitorId=b.fullvisitorId and a.visitId=b.visitId and a.date=b.date


    join each

          (
            select a.*
            from
                flatten (
                          (
                            select date,
                                   fullVisitorId,
                                   unique (visitId) as visitid,
                                   upper(hits.customDimensions.value) as country,
                                   device.operatingSystem,
                                   case when device.operatingSystem='Android' OR device.operatingSystem='iOS' then 'APP' end as platform_agg,
                                   case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
                                   case when trafficSource.source='(direct)' and trafficSource.medium='(none)' then 'direct'
                                        when trafficSource.source='push' and trafficSource.medium='push' then 'push'else 'others'
                                   END AS channel,

                            from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
                            --, TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
                            where hits.customDimensions.index=1 and hits.customDimensions.value in ('HK','SG','IN')
                            group each by 1,2,4,5,6,7,8
                           ), visitid
                         ) a
            ) countries on b.fullvisitorid=countries.fullvisitorId and b.visitid=countries.visitid and b.date=countries.date

    /*add city and area*/

    left join each

    (select a.* from
    flatten (
    (select fullVisitorId, unique (visitId) as visitid, regexp_extract(hits.customDimensions.value,r'([^_]*)') as city_id, regexp_extract(hits.customDimensions.value,r'_(.*)') as area_id
    from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
    --, TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
    where hits.customDimensions.index=11
    group each by 1,3,4), visitid) a) area_id

    on area_id.fullvisitorid=b.fullvisitorid and area_id.visitid=b.visitid

    join each [CR_team.iso_common_countries] iso
    on countries.country=iso.iso

    left join [CR_team.dim_area] dim_area
    on dim_area.area_id = area_id.area_id and dim_area.common_name = iso.common_name

            group each by 1,2,3,4,5,6,7,8,9,10,11
    ) foodpanda

  ,
  
(Select * from
(Select date(b.date) as ga_date,
        year(CAST(b.date AS TIMESTAMP)) as ga_year,
        case when b.date in('20160101','20160102') then '2015-53' else case when length(string(week(CAST(b.date AS TIMESTAMP))))=1 then CONCAT(string(year(CAST(b.date AS TIMESTAMP))),'-0',string(week(CAST(b.date AS TIMESTAMP)))) else CONCAT(string(year(CAST(b.date AS TIMESTAMP))),'-',string(week(CAST(b.date AS TIMESTAMP)))) end end as ga_week,
        case when dayofweek(CAST(b.date AS TIMESTAMP))=1 then '1.Sunday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=2 then '2.Monday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=3 then '3.Tuesday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=4 then '4.Wednesday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=5 then '5.Thursday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=6 then '6.Friday'
             when dayofweek(CAST(b.date AS TIMESTAMP))=7 then '7.Saturday' else 'none'
        END as ga_day,
        countries.country as country,
        'Hungary(Netpincer)' as common_name,
        b.device.operatingSystem as platform,
        b.platform_agg as platform_agg,
        b.Users as user_type,
        countries.channel as channel,
        b.start_time as hourTime,
--        'N/A' as landing_page,
--        'N/A' as sorting,
--        'N/A' as language,
--        case when cities.city like '%Budapest%' then 'Budapest' else cities.city end as city,
--        'null' as area,
        sum(b.sessions) as visits,
        sum(b.gross_orders) as orders,
        sum(CR1_start) as hp_rlp_start,
        INTEGER(sum(CR1_complete)) as hp_rlp_complete,
        sum(b.CR2_start) as rlp_rdp_start,
        sum(b.CR3_start) as rlp_rdp_complete,
        sum(b.CR3_start) as rdp_co_start,
        sum(b.CR4_start) as rdp_co_complete,
        sum(b.CR4_start) as co_so_start,
        sum(b.CR4_complete) as co_so_complete
  from

     ( select date,
              fullvisitorId,
              visitId,
              device.operatingSystem,
              case when device.operatingSystem='Android' OR device.operatingSystem='iOS' then 'APP' end as platform_agg,
              case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
              hour(timestamp(integer(visitStartTime*1000000))) as start_time,
              sum(totals.visits) as sessions,
              sum(totals.transactions) as gross_orders,
              case when sum(case when(REGEXP_MATCH(hits.appInfo.ScreenName,'Main Dashboard Screen')) then 1 else 0 end)>=1 then 1 else 0 end as CR1_start,
              case when sum(case when(REGEXP_MATCH(hits.appInfo.ScreenName,'Restaurants')) then 1 else 0 end)>=1 then 1 else 0 end as CR2_start,
              case when sum(case when(REGEXP_MATCH(hits.appInfo.ScreenName,'Restaurant[^s]')) then 1 else 0 end)>=1 then 1 else 0 end as CR3_start,
              case when sum(case when(REGEXP_MATCH(hits.appInfo.ScreenName,'Cart Screen')) then 1 else 0 end)>=1 then 1 else 0 end as CR4_start,
              case when sum(case when(REGEXP_MATCH(hits.appInfo.ScreenName,'^(Checkout Screen|Delivery Method Screen|Email Verification Screen|Address Book Screen|User Details Screen)')) then 1 else 0 end)>=1 then 1 else 0 end as CR4_complete
       from TABLE_DATE_RANGE([96332490.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

       group each by 1,2,3,4,5,6,7

     )b

/*********************joining CR1 complete**************************/

left join each

    (
      select c.date as date,
             c.fullVisitorId as fullVisitorId,
             c.visitId as visitId,
             count(c.hits) as CR1_complete

      from

        (
          Select date,
                 fullVisitorId,
                 visitId,
                 max(hits.hitnumber) as hits
          from TABLE_DATE_RANGE([96332490.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

          where REGEXP_MATCH(hits.appInfo.screenName,'Restaurants')
          group each by 1,2,3
        ) c

join each

      (
        Select date,
                fullVisitorId,
                visitId,
                min(hits.hitnumber) as hits
         from TABLE_DATE_RANGE([96332490.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

         where REGEXP_MATCH(hits.appInfo.screenName,'Main Dashboard Screen')
         group each  by 1,2,3
       ) b on c.fullvisitorId=b.fullvisitorId and c.visitid=b.visitid and c.date=b.date
         where c.hits>b.hits
         group each by 1,2,3
    ) a on a.fullvisitorId=b.fullvisitorId and a.visitId=b.visitId and a.date=b.date


join each

      (
        select a.*
        from
            flatten (
                      (
                        select date,
                               fullVisitorId,
                               unique (visitId) as visitid,
                               'Hungary' as country,
                               device.operatingSystem,
                               case when device.operatingSystem='Android' OR device.operatingSystem='iOS' then 'APP' end as platform_agg,
                               case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
                               case when trafficSource.source='(direct)' and trafficSource.medium='(none)' then 'direct'
                                    when trafficSource.source='push' and trafficSource.medium='push' then 'push' else 'others'
                               END AS channel,

                        from TABLE_DATE_RANGE([96332490.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

                        group each by 1,2,4,5,6,7,8
                       ), visitid
                     ) a
        ) countries on b.fullvisitorid=countries.fullvisitorId and b.visitid=countries.visitid and b.date=countries.date

left join each

        (select a.* from
        flatten (
        (select fullVisitorId, unique (visitId) as visitid, hits.customDimensions.value as city
        from TABLE_DATE_RANGE([96332490.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
        where hits.customDimensions.index=3
        group each by 1,3), visitid) a) cities

        on cities.fullvisitorid=b.fullvisitorid and cities.visitid=b.visitid

        group each by 1,2,3,4,5,6,7,8,9,10,11
) app
) as npc_app