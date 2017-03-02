
Select date(b.date) as ga_date,
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
        "Pakistan(Eat-Oye)" as common_name,
        b.device.deviceCategory as platform,
        b.platform_agg as platform_agg,
        b.users as user_type,
        countries.channel as channel,
        countries.landing_page as landing_page,
        'N/A' as sorting,
        'N/A' as language,
        'null' as city,
        'null' as area,
        sum(b.sessions) as visits,
        sum(b.gross_orders) as orders,
        sum(b.CR1_start) as hp_rlp_start,
        INTEGER(sum(cr1_compl.CR1_completion)) as hp_rlp_complete,
        sum(b.CR2_start) as rlp_rdp_start,
        INTEGER(sum(cr2_compl.CR2_completion)) as rlp_rdp_complete,
        sum(b.CR3_start) as rdp_co_start,
        INTEGER(sum(cr3_compl.CR3_completion)) as rdp_co_complete,
        sum(b.CR4_start) as co_so_start,
        INTEGER(sum(cr4_compl.CR4_completion)) as co_so_complete
  from

     (        select date,
              fullvisitorId,
              visitId,
              device.deviceCategory,
              case when device.deviceCategory='desktop' OR device.deviceCategory='tablet' OR device.deviceCategory='mobile' then 'WEB' end as platform_agg,
              case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
              sum(totals.visits) as sessions,
              sum(totals.transactions) as gross_orders,
              case when sum(case when(regexp_match(hits.page.pagePath,'^/home')) then 1 else 0 end)>=1 then 1 else 0 end as CR1_start,
              case when sum(case when(regexp_match(hits.page.pagePath,'(/delivery|/allrestaurants)')) then 1 else 0 end)>=1 then 1 else 0 end as CR2_start,
              case when sum(case when(regexp_match(hits.page.pagePath,'^/restaurant/')) then 1 else 0 end)>=1 then 1 else 0 end as CR3_start,
              case when sum(case when(regexp_match(hits.page.pagePath,'^/cart$')) then 1 else 0 end)>=1 then 1 else 0 end as CR4_start,
              case when sum(case when(regexp_match(hits.page.pagePath,'^/thanks$')) then 1 else 0 end)>=1 then 1 else 0 end as CR4_complete
       from TABLE_DATE_RANGE([98946202.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -15, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
       group each by 1,2,3,4,5,6

     )b

/********************* joining CR1 complete **************************/

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
          from TABLE_DATE_RANGE([98946202.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -15, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

          where regexp_match(hits.page.pagePath,'(/delivery|/allrestaurants)')
          group each by 1,2,3
        ) c

join each

      (
        Select date,
                fullVisitorId,
                visitId,
                min(hits.hitnumber) as hits
         from TABLE_DATE_RANGE([98946202.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -15, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

         where regexp_match(hits.page.pagePath,'^/home')
         group each  by 1,2,3
       ) b on c.fullvisitorId=b.fullvisitorId and c.visitid=b.visitid and c.date=b.date
         where c.hits>b.hits
         group each by 1,2,3
    ) cr1_compl on cr1_compl.fullvisitorId=b.fullvisitorId and cr1_compl.visitId=b.visitId and cr1_compl.date=b.date

/********************* joining CR2 complete **************************/

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
              from TABLE_DATE_RANGE([98946202.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -15, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

              where regexp_match(hits.page.pagePath,'^/restaurant/')
              group each by 1,2,3
            ) c

join each

            (
              Select  date,
                      fullVisitorId,
                      visitId,
                      min(hits.hitnumber) as hits
               from TABLE_DATE_RANGE([98946202.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -15, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

               where regexp_match(hits.page.pagePath,'(/delivery|/allrestaurants)')
               group each  by 1,2,3
             ) b
    on c.fullvisitorId=b.fullvisitorId and c.visitid=b.visitid and c.date=b.date
    where c.hits>b.hits
    group each by 1,2,3
) cr2_compl on cr2_compl.fullvisitorId=b.fullvisitorId and cr2_compl.visitId=b.visitId and cr2_compl.date=b.date


/******************* joining CR3 complete ********************/

left join each

(
      select  c.date as date,
              c.fullVisitorId as fullVisitorId,
              c.visitId as visitId,
              count(c.hits) as CR3_completion

      from

              (
                Select date,
                       fullVisitorId,
                       visitId,
                       max(hits.hitnumber) as hits
                from TABLE_DATE_RANGE([98946202.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -15, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

                where regexp_match(hits.page.pagePath,'^/cart$')
                group each by 1,2,3
              ) c

join each

              (
                Select date,
                        fullVisitorId,
                        visitId,
                        min(hits.hitnumber) as hits
                 from TABLE_DATE_RANGE([98946202.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -15, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

                 where regexp_match(hits.page.pagePath,'^/restaurant/')
                 group each  by 1,2,3
               ) b
   on c.fullvisitorId=b.fullvisitorId and c.visitid=b.visitid and c.date=b.date
   where c.hits>b.hits
   group each by 1,2,3
) cr3_compl on cr3_compl.fullvisitorId=b.fullvisitorId and cr3_compl.visitId=b.visitId and cr3_compl.date=b.date


/***************** joining CR4 complete **********************************/

left join each

(
      select  c.date as date,
              c.fullVisitorId as fullVisitorId,
              c.visitId as visitId,
              count(c.hits) as CR4_completion

      from

              (
                Select date,
                       fullVisitorId,
                       visitId,
                       max(hits.hitnumber) as hits
                from TABLE_DATE_RANGE([98946202.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -15, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

                where regexp_match(hits.page.pagePath,'^/thanks$')
                group each by 1,2,3
              ) c

join each

              (
                Select date,
                        fullVisitorId,
                        visitId,
                        min(hits.hitnumber) as hits
                 from TABLE_DATE_RANGE([98946202.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -15, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

                 where regexp_match(hits.page.pagePath,'^/cart$')
                 group each  by 1,2,3
               ) b
   on c.fullvisitorId=b.fullvisitorId and c.visitid=b.visitid and c.date=b.date
   where c.hits>b.hits
   group each by 1,2,3
) cr4_compl on cr4_compl.fullvisitorId=b.fullvisitorId and cr4_compl.visitId=b.visitId and cr4_compl.date=b.date


join each

      (

        select a.*
        from
            flatten (
                      (
                        select date,
                               fullVisitorId,
                               unique (visitId) as visitid,
                              'Pakistan' as country,
                               device.deviceCategory,
                               case when device.deviceCategory='desktop' OR device.deviceCategory='tablet' OR device.deviceCategory='mobile' then 'WEB' end as platform_agg,
                               case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
                               CASE WHEN (( trafficSource.source = 'google' AND trafficSource.medium = 'cpc' AND ((trafficSource.campaign LIKE '%[D[%') OR (trafficSource.campaign LIKE '%[T%') OR (trafficSource.campaign LIKE '%[Y%'))) OR (trafficSource.source = 'FB' AND trafficSource.medium = 'cpc')) THEN 'Display'
                                   WHEN (( trafficSource.source = 'google' OR  trafficSource.source = 'bing' OR  trafficSource.source = 'yandex') AND (trafficSource.medium = 'cpc') AND (trafficSource.campaign LIKE '%[S[CB%' OR trafficSource.campaign LIKE '%[MB[CB%')) THEN 'SEM Brand'
                                   WHEN (( trafficSource.source = 'google' OR  trafficSource.source = 'bing' OR  trafficSource.source = 'yandex') AND (trafficSource.medium = 'cpc')) THEN 'SEM non Brand'
                                   WHEN ( trafficSource.source = '(direct)' OR (( trafficSource.source LIKE 'foodpanda.com'OR trafficSource.source LIKE 'hellofood.com') AND trafficSource.medium = 'referral')) THEN 'direct'
                                   WHEN (regexp_match(trafficSource.medium, '.*[Ee]mail?.*') OR REGEXP_MATCH(trafficSource.medium ,'.*[Nn]ewsletter?.*') OR regexp_match( trafficSource.source , '%newsletter%')) THEN 'Newsletter'
                                   WHEN REGEXP_MATCH(trafficSource.medium ,'[Oo]rganic') THEN 'SEO'
                                   WHEN trafficSource.source = 'transactional' OR trafficSource.source = 'transactional_email' OR trafficSource.source = 'EDM' THEN 'email'
                                   WHEN trafficSource.medium ='referral' then 'referral'
                              else 'others'
                              END AS channel,
                              if (regexp_match(hits.appInfo.landingscreenName,'^/restaurant/') is true, 'landing_menu',
                              if (regexp_match(hits.appInfo.landingscreenName,'(/delivery|/allrestaurants)') is true, 'landing_listings',
                              if (regexp_match(hits.appInfo.landingscreenName,'/home') is true,'landing_homepage',
                              'landing_other'))) as landing_page


                        from TABLE_DATE_RANGE([98946202.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -15, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))

                        group each by 1,2,4,5,6,7,8,9
                       ), visitid
                     ) a
        ) countries on b.fullvisitorid=countries.fullvisitorId and b.visitid=countries.visitid and b.date=countries.date

        group each by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15

