SELECT *,
NTH(1, SPLIT(cd1, '_'))  AS city,
NTH(2, SPLIT(cd1, '_'))  AS zipcode
FROM (
      SELECT
      venture_url, report_date, time_of_day, visitor_type, device, operatingsystem, medium, campaign, source,
      cd1, cd45, cd15,
      cr1_start, cr1_a, cr1_b, cr1_end,
      cr2_start, cr2_a, cr2_b, cr2_end,
      cr3_start, cr3_a, cr3_b, cr3_c, cr3_d, cr3_end,
      cr4_start,
      cr4_a_start, cr4_a_end,
      cr4_b_start, cr4_b_end,
      cr4_c_start, cr4_c_end,
      cr4_d_start, cr4_d_end,
      cr4_e_start, cr4_e_end,
      cr4_f_start, cr4_f_end,
      cr4_end,
      COUNT(DISTINCT fullVisitorId) as pageviews

      FROM (
                SELECT
                venture_url,
                DATE(date) as report_date,
                time_of_day,
                fullVisitorId,
                visitor_type,
                device,
                operatingsystem,
                --operatingsystem,
                medium,
                campaign,
                source,
                cd1,   -- address
                cd45,  -- expedition_type
                cd15,  -- vendor_code
        ------------------------------------------------------------------------CR1------------------------------------------------------------------------
        IF(sum(if(hits.eventInfo.eventAction = 'HomePage View' or hits.eventInfo.eventAction = 'CityPage View' or hits.eventInfo.eventAction = 'CuisinePage View' or hits.eventInfo.eventAction = 'ChainPage View', 1,0))>0,1,0) as cr1_start, # MACRO CR
        IF(sum(if(hits.eventInfo.eventAction = 'restaurants-search-form__input' or hits.eventInfo.eventAction = 'Address Bar Selection', 1,0))>0,1,0) as cr1_a,
        IF(sum(if(hits.eventInfo.eventAction = 'Home - Submit Location Attempt' or hits.eventInfo.eventAction = 'Location - City - Submit Attempt' or hits.eventInfo.eventAction = 'Location - Cuisine - Submit Attempt', 1,0))>0,1,0) as cr1_b,
        IF(sum(if(hits.eventInfo.eventAction = 'Home - Location Submit Success' or hits.eventInfo.eventAction = 'Location - City - Submit Success' or hits.eventInfo.eventAction = 'Location - Cuisine - Submit Success' or hits.eventInfo.eventAction = 'Location - Chain - Submit Success', 1,0))>0,1,0) as cr1_end, # MACRO CR
        ------------------------------------------------------------------------CR2------------------------------------------------------------------------
        IF(sum(if(hits.eventInfo.eventAction = 'Home - Location Submit Success' or hits.eventInfo.eventAction = 'Location - City - Submit Success' or hits.eventInfo.eventAction = 'Location - Cuisine - Submit Success' or hits.eventInfo.eventAction = 'Location - Chain - Submit Success', 1,0))>0,1,0) as cr2_start, # MACRO CR
        IF(sum(if(hits.eventInfo.eventAction = 'Restaurant Impressions' , 1,0))>0,1,0) as cr2_a,
        IF(sum(if(hits.eventInfo.eventAction = 'Restaurant Selection' , 1,0))>0,1,0) as cr2_b,
        IF(sum(if(hits.eventInfo.eventAction = 'Restaurant Detail View', 1,0))>0,1,0) as cr2_end, # MACRO CR
        ------------------------------------------------------------------------CR3------------------------------------------------------------------------
        IF(sum(if(hits.eventInfo.eventAction = 'Restaurant Detail View', 1,0))>0,1,0) as cr3_start,  # MACRO CR
        IF(sum(if(hits.eventInfo.eventAction = 'Add to cart Attempt' , 1,0))>0,1,0) as cr3_a,
        IF(sum(if(hits.eventInfo.eventAction = 'Add to cart' , 1,0))>0,1,0) as cr3_b,
        IF(sum(if(hits.eventInfo.eventAction = 'Menu - Cart Submit' , 1,0))>0,1,0) as cr3_c,
        IF(sum(if(hits.eventInfo.eventAction = 'LoginPage View' , 1,0))>0,1,0) as cr3_d,
        IF(sum(if(hits.eventInfo.eventAction = 'CO - Checkout Started', 1,0))>0,1,0) as cr3_end, # MACRO CR
        ------------------------------------------------------------------------CR4------------------------------------------------------------------------
        IF(sum(if(hits.eventInfo.eventAction = 'CO - Checkout Started', 1,0))>0,1,0) as cr4_start, # MACRO CR
                                        IF(sum(if(hits.eventInfo.eventAction = 'CO - Address To be validated' , 1,0))>0,1,0) as cr4_a_start,
                                        IF(sum(if(hits.eventInfo.eventAction = 'CO - Location Submit Success' , 1,0))>0,1,0) as cr4_a_end,
                                        IF(sum(if(hits.eventInfo.eventAction = 'Credit Card Process Attempt' , 1,0))>0,1,0) as cr4_b_start,
                                        IF(sum(if(hits.eventInfo.eventAction = 'CO - Payment Attempt' , 1,0))>0,1,0) as cr4_b_end,
                                        IF(sum(if(hits.eventInfo.eventAction = 'CO - Voucher Submit Attempt' , 1,0))>0,1,0) as cr4_c_start,
                                        IF(sum(if(hits.eventInfo.eventAction = 'CO - CO - Payment Attempt' , 1,0))>0,1,0) as cr4_c_end,
                                        IF(sum(if(hits.eventInfo.eventAction = 'CO - Payment Attempt' , 1,0))>0,1,0) as cr4_d_start,
                                        IF(sum(if(hits.eventInfo.eventAction = 'CO - Transaction Placed' , 1,0))>0,1,0) as cr4_d_end,
                                        IF(sum(if(hits.eventInfo.eventAction = 'CO - SMS Verification' , 1,0))>0,1,0) as cr4_e_start,
                                        IF(sum(if(hits.eventInfo.eventAction = 'SMS Verification Validated' , 1,0))>0,1,0) as cr4_e_end,
                                        IF(sum(if(hits.eventInfo.eventAction = 'CO - Payment Attempt' , 1,0))>0,1,0) as cr4_f_start,
                                        IF(sum(if(hits.eventInfo.eventAction = 'CO - Payment Failed' , 1,0))>0,1,0) as cr4_f_end,
                                IF(sum(if(hits.eventInfo.eventAction = 'Transaction Placed', 1,0))>0,1,0) as cr4_end,# MACRO CR

                FROM (
                                  SELECT
                                  date,
                                  CASE
                                  WHEN HOUR(FORMAT_UTC_USEC(visitStartTime * 1000000)) BETWEEN 4 and 11 THEN 'Morning'
                                  WHEN HOUR(FORMAT_UTC_USEC(visitStartTime * 1000000)) BETWEEN 11 and 14 THEN 'Lunchtime'
                                  WHEN HOUR(FORMAT_UTC_USEC(visitStartTime * 1000000)) BETWEEN 14 and 16 THEN 'Afternoon'
                                  ELSE 'Dinnertime' end as time_of_day,
                                  hits.page.hostname AS venture_url,
                                  fullVisitorId,
                                  visitStartTime,
                                  CASE WHEN totals.newVisits = 1 THEN 'New Visitors' WHEN totals.newVisits is null then 'Returning Visitors' end as visitor_type,
                                  device.deviceCategory as device,
                                  device.operatingSystem as operatingsystem,
                                  trafficSource.medium as medium,
                                  trafficSource.campaign as campaign,
                                  trafficSource.source as source,
                                  hits.eventInfo.eventAction,
                                  max(IF(hits.customDimensions.index = 1, hits.customDimensions.value, NULL)) within RECORD cd1,   -- address
                                  max(IF(hits.customDimensions.index = 45, hits.customDimensions.value, NULL)) within RECORD cd45, -- expedition_type
                                  max(IF(hits.customDimensions.index = 15, hits.customDimensions.value, NULL)) within RECORD cd15  -- vendor_code

                                  FROM
                                  TABLE_DATE_RANGE([103309403.ga_sessions_], TIMESTAMP(DATE('2017-01-10')), TIMESTAMP(DATE('2017-01-11'))) at,
                                  TABLE_DATE_RANGE([102465099.ga_sessions_], TIMESTAMP(DATE('2017-01-10')), TIMESTAMP(DATE('2017-01-11'))) it,
                                  TABLE_DATE_RANGE([102472558.ga_sessions_], TIMESTAMP(DATE('2017-01-10')), TIMESTAMP(DATE('2017-01-11'))) nl,
                                  TABLE_DATE_RANGE([102473846.ga_sessions_], TIMESTAMP(DATE('2017-01-10')), TIMESTAMP(DATE('2017-01-11'))) fr,
                                  TABLE_DATE_RANGE([103305457.ga_sessions_], TIMESTAMP(DATE('2017-01-10')), TIMESTAMP(DATE('2017-01-11'))) se,
                                  TABLE_DATE_RANGE([103740472.ga_sessions_], TIMESTAMP(DATE('2017-01-10')), TIMESTAMP(DATE('2017-01-11'))) fi,
                                  TABLE_DATE_RANGE([103756848.ga_sessions_], TIMESTAMP(DATE('2017-01-10')), TIMESTAMP(DATE('2017-01-11'))) no,
                                  TABLE_DATE_RANGE([104570775.ga_sessions_], TIMESTAMP(DATE('2017-01-10')), TIMESTAMP(DATE('2017-01-11'))) au,
                                  TABLE_DATE_RANGE([105594681.ga_sessions_], TIMESTAMP(DATE('2017-01-10')), TIMESTAMP(DATE('2017-01-11'))) ca,
                                  TABLE_DATE_RANGE([85827534.ga_sessions_],  TIMESTAMP(DATE('2017-01-10')), TIMESTAMP(DATE('2017-01-11'))) de
                                  WHERE hits.customDimensions.index IN (1,45,15)
                      )
                      GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13
)
      GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40
)