
                            select [date],
                                   fullVisitorId,
                                   visitId as visitid,
                                   hits.customDimensions.value as country,
                                   GROUP_CONCAT(REGEXP_EXTRACT(hits.page.pagePath, r'(/restaurant.*)'), ">>")
                                    WITHIN RECORD AS Sequence,
                           from TABLE_DATE_RANGE([86553600.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
                           --, TABLE_DATE_RANGE([87584217.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY')), TABLE_DATE_RANGE([108857524.ga_sessions_], DATE_ADD(CURRENT_TIMESTAMP(), -3, 'DAY'), DATE_ADD(CURRENT_TIMESTAMP(), -2, 'DAY'))
                           where hits.customDimensions.index=3 and hits.customDimensions.value='IN'
                           HAVING
                           Sequence contains
    REGEXP_EXTRACT(Sequence,r'(^/restaurants[?]user_search=[^&].*?>>/restaurants[?]user_search=&.*?>>/restaurant/.*)')
