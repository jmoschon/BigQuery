
(
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
        null as country,
        "Donesi" as common_name,
        b.device.operatingSystem as platform,
        b.platform_agg as platform_agg,
        b.users as user_type,
        countries.channel as channel,
        'N/A' as landing_page,
        'N/A' as sorting,
        'N/A' as language,
         'null' as city,
        'null' as area,
        sum(b.sessions) as visits,
        sum(b.gross_orders) as orders,
        sum(b.CR1_start) as hp_rlp_start,
        INTEGER(sum(CR1_completion)) as hp_rlp_complete,
        sum(b.CR2_start) as rlp_rdp_start,
        Integer(sum(cr2_compl.CR2_completion)) as rlp_rdp_complete,
        sum(b.CR3_start) as rdp_co_start,
        sum(b.CR4_start) as rdp_co_complete,
        sum(b.CR4_start) as co_so_start,
        sum(b.CR4_complete) as co_so_complete
  from

     ( select date,
              fullvisitorId,
              visitId,
              device.operatingSystem,
              geonetwork.region as region,
              case when device.operatingSystem='Android' OR device.operatingSystem='iOS' then 'APP' end as platform_agg,
              case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
              sum(totals.visits) as sessions,
              sum(totals.transactions) as gross_orders,
              case when sum(case when(REGEXP_MATCH(hits.appInfo.ScreenName,'(Main Screen|Location|ShopMain)')) then 1 else 0 end)>=1 then 1 else 0 end as CR1_start,
              case when sum(case when(REGEXP_MATCH(hits.appInfo.ScreenName,'Restaurants')) then 1 else 0 end)>=1 then 1 else 0 end as CR2_start,
              case when sum(case when(REGEXP_MATCH(hits.appInfo.ScreenName,'(Restaurant[^s]|Menu|menu|Cart Screen)')) then 1 else 0 end)>=1 then 1 else 0 end as CR3_start,
              case when sum(case when(REGEXP_MATCH(hits.appInfo.ScreenName,'Checkout[^C]')) then 1 else 0 end)>=1 then 1 else 0 end as CR4_start,
--               case when sum(case when(REGEXP_MATCH(hits.appInfo.ScreenName,'Confirmation')) then 1 else 0 end)>=1 then 1 else 0 end as CR4_complete
              sum(totals.transactions) as CR4_complete,
       from TABLE_DATE_RANGE([97409043.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
       group each by 1,2,3,4,5,6,7

     )b

/*********************************CR1 Complete***********************/
left join each

    (
      select c.date as date,
            c.fullVisitorId as fullVisitorId,
            c.visitId as visitId,
            count(c.hits) as CR1_completion

      from

        (
          Select date,
                 fullVisitorId,
                 visitId,
                 max(hits.hitnumber) as hits
          from TABLE_DATE_RANGE([97409043.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

          where REGEXP_MATCH(hits.appInfo.screenName,'Restaurant')
          group each by 1,2,3
        ) c

join each

      (
        Select date,
                fullVisitorId,
                visitId,
                min(hits.hitnumber) as hits
         from TABLE_DATE_RANGE([97409043.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

         where REGEXP_MATCH(hits.appInfo.screenName,'(Main Screen|Location|ShopMain)')
         group each  by 1,2,3
       ) b on c.fullvisitorId=b.fullvisitorId and c.visitid=b.visitid and c.date=b.date
         where c.hits>b.hits
         group each by 1,2,3
    ) a on a.fullvisitorId=b.fullvisitorId and a.visitId=b.visitId and a.date=b.date

/*********************************CR2 Complete***********************/

left join each

    (
      select c.date as date,
            c.fullVisitorId as fullVisitorId,
            c.visitId as visitId,
            count(c.hits) as CR2_completion

      from

        (
          Select date,
                 fullVisitorId,
                 visitId,
                 max(hits.hitnumber) as hits
          from TABLE_DATE_RANGE([97409043.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

          where REGEXP_MATCH(hits.appInfo.screenName,'Restaurant[^s]|Menu|menu')
          group each by 1,2,3
        ) c

join each

      (
        Select date,
                fullVisitorId,
                visitId,
                min(hits.hitnumber) as hits
         from TABLE_DATE_RANGE([97409043.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

         where REGEXP_MATCH(hits.appInfo.screenName,'Restaurants')
         group each  by 1,2,3
       ) b on c.fullvisitorId=b.fullvisitorId and c.visitid=b.visitid and c.date=b.date
         where c.hits>b.hits
         group each by 1,2,3
    ) cr2_compl on cr2_compl.fullvisitorId=b.fullvisitorId and cr2_compl.visitId=b.visitId and cr2_compl.date=b.date

join each

      (
        select a.*
        from
            flatten (
                      (
                        select date,
                               fullVisitorId,
                               unique (visitId) as visitid,
                              'Russia' as country,
                               device.operatingSystem,
                               case when device.operatingSystem='Android' OR device.operatingSystem='iOS' then 'APP' end as platform_agg,
                               case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
                               case when trafficSource.source='(direct)' and trafficSource.medium='(none)' then 'direct'
                                    when trafficSource.source='push' and trafficSource.medium='push' then 'push' else 'others'end as channel,


                        from TABLE_DATE_RANGE([97409043.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -50, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
                        group each by 1,2,4,5,6,7,8
                       ), visitid
                     ) a
        ) countries on b.fullvisitorid=countries.fullvisitorId and b.visitid=countries.visitid and b.date=countries.date

-- left join each

--         (select a.* from
--         flatten (
--         (select fullVisitorId, unique (visitId) as visitid, hits.customDimensions.value as city
--         from TABLE_DATE_RANGE([97409043.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
--         where hits.customDimensions.index=3
--         group each by 1,3), visitid) a) cities

--         on cities.fullvisitorid=b.fullvisitorid and cities.visitid=b.visitid

        group each by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15

) app
)