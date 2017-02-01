Select
        countries.country as country,
--         b.opVersion as op_version,

        sum(b.visits) as visits,
        sum(b.ios_sessions) as ios_visits,
        sum(b.session_ios8x) as visit_8x,
        sum(b.gross_orders ) as gross_orders,
        sum(b.gross_orders_ios) as gross_orders_ios,
        sum(b.gross_orders_ios8x) as gross_orders_ios8x
       


/* assigning 1 or 0 for each funnel step for every session */
  from

     ( select date,
              fullvisitorId,
              visitId,
              device.operatingSystem,
              device.operatingSystemVersion as opVersion,
  
              upper(regexp_extract(device.language,r'([^_]*)')) as language,
              case when regexp_match(device.operatingSystem,'iOS') then totals.visits else 0 end as ios_sessions,
              totals.visits as visits,
              totals.transactions as gross_orders,
              case when regexp_match(device.operatingSystem,'iOS') then totals.transactions else 0 end as gross_orders_ios,
              case when regexp_match(device.operatingSystem,'iOS') and regexp_match(device.operatingSystemVersion,'8.') then totals.transactions else 0 end as gross_orders_ios8x,
              case when regexp_match(device.operatingSystemVersion,'8.') and regexp_match(device.operatingSystem,'iOS') then 1 else 0 end as session_ios8x
       from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -90, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -90, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -90, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

       group each by 1,2,3,4,5,6,7,8,9,10,11,12

     )b

/* joining country */

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

                        from TABLE_DATE_RANGE([74773001.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -90, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([74762698.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -90, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108855442.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -90, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
                        where hits.customDimensions.index=1
                        group each by 1,2,4
                       ), visitid
                     ) a
        ) countries on b.fullvisitorid=countries.fullvisitorId and b.visitid=countries.visitid and b.date=countries.date


        group each by 1