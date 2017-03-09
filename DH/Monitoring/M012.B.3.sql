# User based funnel evolution in different time intervals.

SELECT 
	Platform,
	Total_sessions,
	Pattern,
	first_session,
	thirty_min,
	an_hour,
	two_hours,
	longer_than_two_hours

FROM
	(SELECT
		Platform,
		Total_sessions,
		longer_than_two_hours AS Pattern,
		ROUND(COUNT(IF(first_session == longer_than_two_hours,1,NULL))/Total_sessions*100,3) AS first_session,
		ROUND(COUNT(IF(thirty_min == longer_than_two_hours,1,NULL))/Total_sessions*100,3) AS thirty_min,
		ROUND(COUNT(IF(an_hour == longer_than_two_hours,1,NULL))/Total_sessions*100,3) AS an_hour,
		ROUND(COUNT(IF(two_hours == longer_than_two_hours,1,NULL))/Total_sessions*100,3) AS two_hours,
		ROUND(COUNT(IF(longer_than_two_hours == longer_than_two_hours,1,NULL))/Total_sessions*100,3) AS longer_than_two_hours,
		ROW_NUMBER() OVER (PARTITION BY Platform ORDER BY Platform, first_session DESC) AS Share_Rate_index

	FROM
		(SELECT
			Platform,
			fullvisitorID,
			session_per_user,
			Total_sessions,
			MAX(IF(visit_difference_time == 0, full_funnel, NULL)) AS first_session,
			COUNT(IF(visit_difference_time <= 30 AND visit_difference_time > 0, full_funnel, NULL)) AS count_thirty_min,
			MAX(IF(visit_difference_time <= 30, full_funnel, NULL)) AS thirty_min,
			COUNT(IF(visit_difference_time <= 60 AND visit_difference_time > 30, full_funnel, NULL)) AS count_an_hour,
			MAX(IF(visit_difference_time <= 60, full_funnel, NULL)) AS an_hour,
			COUNT(IF(visit_difference_time <= 120 AND visit_difference_time > 60, full_funnel, NULL)) AS count_two_hours,
			MAX(IF(visit_difference_time <= 120, full_funnel, NULL)) AS two_hours,
			COUNT(IF(visit_difference_time > 120, full_funnel, NULL)) AS count_longer_than_two_hours,
			MAX(IF(visit_difference_time <= 1440, full_funnel, NULL)) AS longer_than_two_hours

		FROM
			(SELECT
				Platform,
				fullvisitorID,
				session_per_user,
				visitStartTime,
				ROUND(((visitStartTime-min_start_time)/60),3) AS visit_difference_time,
				CONCAT(STRING(IF(home_update>0,1,0)), STRING(IF(listing_update>0,1,0)), STRING(IF(shop_details_update>0,1,0)), STRING(IF(add_cart_update>0,1,0)), STRING(IF(checkout_update>0,1,0)), 				STRING(IF(transaction_update>0,1,0))) AS full_funnel,
				Total_sessions
    
			FROM
				(SELECT
					fullVisitorId,
					visitStartTime,
					CONCAT("Lieferheld ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform,
					IF(SUM(if(hits.customDimensions.index = 11 and hits.customDimensions.value = 'home', 1, 0)) > 0, 1, 0) AS home,
					IF(SUM(if(hits.eventInfo.eventAction = 'shop_list.loaded', 1, 0)) > 0, 1, 0) AS listing,
					IF(SUM(if(hits.eventInfo.eventAction = 'shop_details.loaded', 1, 0)) > 0, 1, 0) AS shop_details,
					IF(SUM(if(hits.eventInfo.eventAction = 'add_cart.clicked', 1, 0)) > 0, 1, 0) AS add_cart,
					IF(SUM(if(hits.eventInfo.eventAction = 'checkout.loaded', 1, 0)) > 0, 1, 0) AS checkout,
					IF(SUM(if(hits.eventInfo.eventAction = 'transaction', 1, 0)) > 0, 1, 0) AS transaction,
					MIN(visitStartTime) OVER (PARTITION BY Platform,fullvisitorID) AS min_start_time,
					SUM(home) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS home_update,
					SUM(listing) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS listing_update,
					SUM(shop_details) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS shop_details_update,
					SUM(add_cart) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS add_cart_update,
					SUM(checkout) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS checkout_update,
					SUM(transaction) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS transaction_update,
					COUNT(*) OVER (PARTITION BY Platform ORDER BY Platform) AS Total_sessions,
					COUNT(visitStartTime) OVER (PARTITION BY Platform,fullvisitorID) AS session_per_user
				FROM TABLE_DATE_RANGE([blh---lieferheld:38642300.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-2,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-2,"DAY")))
				GROUP BY 1,2,3
				ORDER BY 1,2),
    
				(SELECT
					fullVisitorId,
					visitStartTime,
					"Lieferheld Android" AS Platform,
					IF(SUM(if(hits.customDimensions.index = 11 and hits.customDimensions.value = 'home', 1, 0)) > 0, 1, 0) AS home,
					IF(SUM(if(hits.eventInfo.eventAction = 'shop_list.loaded', 1, 0)) > 0, 1, 0) AS listing,
					IF(SUM(if(hits.eventInfo.eventAction = 'shop_details.loaded', 1, 0)) > 0, 1, 0) AS shop_details,
					IF(SUM(if(hits.eventInfo.eventAction = 'add_cart.clicked', 1, 0)) > 0, 1, 0) AS add_cart,
					IF(SUM(if(hits.eventInfo.eventAction = 'checkout.loaded', 1, 0)) > 0, 1, 0) AS checkout,
					IF(SUM(if(hits.eventInfo.eventAction = 'transaction', 1, 0)) > 0, 1, 0) AS transaction,
					MIN(visitStartTime) OVER (PARTITION BY Platform,fullvisitorID) AS min_start_time,
					SUM(home) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS home_update,
					SUM(listing) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS listing_update,
					SUM(shop_details) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS shop_details_update,
					SUM(add_cart) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS add_cart_update,
					SUM(checkout) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS checkout_update,
					SUM(transaction) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS transaction_update,
					COUNT(*) OVER (PARTITION BY Platform ORDER BY Platform) AS Total_sessions,
					COUNT(visitStartTime) OVER (PARTITION BY Platform,fullvisitorID) AS session_per_user
				FROM TABLE_DATE_RANGE([blh---lieferheld:107101250.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-2,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-2,"DAY")))
				GROUP BY 1,2,3
				ORDER BY 1,2),
    
				(SELECT
					fullVisitorId,
					visitStartTime,
					"Lieferheld iOS" AS Platform,
					IF(SUM(if(hits.customDimensions.index = 11 and hits.customDimensions.value = 'home', 1, 0)) > 0, 1, 0) AS home,
					IF(SUM(if(hits.eventInfo.eventAction = 'shop_list.loaded', 1, 0)) > 0, 1, 0) AS listing,
					IF(SUM(if(hits.eventInfo.eventAction = 'shop_details.loaded', 1, 0)) > 0, 1, 0) AS shop_details,
					IF(SUM(if(hits.eventInfo.eventAction = 'add_cart.clicked', 1, 0)) > 0, 1, 0) AS add_cart,
					IF(SUM(if(hits.eventInfo.eventAction = 'checkout.loaded', 1, 0)) > 0, 1, 0) AS checkout,
					IF(SUM(if(hits.eventInfo.eventAction = 'transaction', 1, 0)) > 0, 1, 0) AS transaction,
					MIN(visitStartTime) OVER (PARTITION BY Platform,fullvisitorID) AS min_start_time,
					SUM(home) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS home_update,
					SUM(listing) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS listing_update,
					SUM(shop_details) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS shop_details_update,
					SUM(add_cart) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS add_cart_update,
					SUM(checkout) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS checkout_update,
					SUM(transaction) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS transaction_update,
					COUNT(*) OVER (PARTITION BY Platform ORDER BY Platform) AS Total_sessions,
					COUNT(visitStartTime) OVER (PARTITION BY Platform,fullvisitorID) AS session_per_user
				FROM TABLE_DATE_RANGE([blh---lieferheld:116747487.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-2,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-2,"DAY")))
				GROUP BY 1,2,3
				ORDER BY 1,2),



				(SELECT
					fullVisitorId,
					visitStartTime,
					CONCAT("PizzaDE ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform,
					IF(SUM(if(hits.customDimensions.index = 11 and hits.customDimensions.value = 'home', 1, 0)) > 0, 1, 0) AS home,
					IF(SUM(if(hits.eventInfo.eventAction = 'shop_list.loaded', 1, 0)) > 0, 1, 0) AS listing,
					IF(SUM(if(hits.eventInfo.eventAction = 'shop_details.loaded', 1, 0)) > 0, 1, 0) AS shop_details,
					IF(SUM(if(hits.eventInfo.eventAction = 'add_cart.clicked', 1, 0)) > 0, 1, 0) AS add_cart,
					IF(SUM(if(hits.eventInfo.eventAction = 'checkout.loaded', 1, 0)) > 0, 1, 0) AS checkout,
					IF(SUM(if(hits.eventInfo.eventAction = 'transaction', 1, 0)) > 0, 1, 0) AS transaction,
					MIN(visitStartTime) OVER (PARTITION BY Platform,fullvisitorID) AS min_start_time,
					SUM(home) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS home_update,
					SUM(listing) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS listing_update,
					SUM(shop_details) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS shop_details_update,
					SUM(add_cart) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS add_cart_update,
					SUM(checkout) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS checkout_update,
					SUM(transaction) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS transaction_update,
					COUNT(*) OVER (PARTITION BY Platform ORDER BY Platform) AS Total_sessions,
					COUNT(visitStartTime) OVER (PARTITION BY Platform,fullvisitorID) AS session_per_user
				FROM TABLE_DATE_RANGE([bpi---pizzade:107156186.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-2,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-2,"DAY")))
				GROUP BY 1,2,3
				ORDER BY 1,2),
    
				(SELECT
					fullVisitorId,
					visitStartTime,
					"PizzaDE Android" AS Platform,
					IF(SUM(if(hits.customDimensions.index = 11 and hits.customDimensions.value = 'home', 1, 0)) > 0, 1, 0) AS home,
					IF(SUM(if(hits.eventInfo.eventAction = 'shop_list.loaded', 1, 0)) > 0, 1, 0) AS listing,
					IF(SUM(if(hits.eventInfo.eventAction = 'shop_details.loaded', 1, 0)) > 0, 1, 0) AS shop_details,
					IF(SUM(if(hits.eventInfo.eventAction = 'add_cart.clicked', 1, 0)) > 0, 1, 0) AS add_cart,
					IF(SUM(if(hits.eventInfo.eventAction = 'checkout.loaded', 1, 0)) > 0, 1, 0) AS checkout,
					IF(SUM(if(hits.eventInfo.eventAction = 'transaction', 1, 0)) > 0, 1, 0) AS transaction,
					MIN(visitStartTime) OVER (PARTITION BY Platform,fullvisitorID) AS min_start_time,
					SUM(home) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS home_update,
					SUM(listing) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS listing_update,
					SUM(shop_details) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS shop_details_update,
					SUM(add_cart) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS add_cart_update,
					SUM(checkout) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS checkout_update,
					SUM(transaction) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS transaction_update,
					COUNT(*) OVER (PARTITION BY Platform ORDER BY Platform) AS Total_sessions,
					COUNT(visitStartTime) OVER (PARTITION BY Platform,fullvisitorID) AS session_per_user
				FROM TABLE_DATE_RANGE([bpi---pizzade:109893332.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-2,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-2,"DAY")))
				GROUP BY 1,2,3
				ORDER BY 1,2),
    
				(SELECT
					fullVisitorId,
					visitStartTime,
					"PizzaDE iOS" AS Platform,
					IF(SUM(if(hits.customDimensions.index = 11 and hits.customDimensions.value = 'home', 1, 0)) > 0, 1, 0) AS home,
					IF(SUM(if(hits.eventInfo.eventAction = 'shop_list.loaded', 1, 0)) > 0, 1, 0) AS listing,
					IF(SUM(if(hits.eventInfo.eventAction = 'shop_details.loaded', 1, 0)) > 0, 1, 0) AS shop_details,
					IF(SUM(if(hits.eventInfo.eventAction = 'add_cart.clicked', 1, 0)) > 0, 1, 0) AS add_cart,
					IF(SUM(if(hits.eventInfo.eventAction = 'checkout.loaded', 1, 0)) > 0, 1, 0) AS checkout,
					IF(SUM(if(hits.eventInfo.eventAction = 'transaction', 1, 0)) > 0, 1, 0) AS transaction,
					MIN(visitStartTime) OVER (PARTITION BY Platform,fullvisitorID) AS min_start_time,
					SUM(home) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS home_update,
					SUM(listing) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS listing_update,
					SUM(shop_details) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS shop_details_update,
					SUM(add_cart) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS add_cart_update,
					SUM(checkout) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS checkout_update,
					SUM(transaction) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS transaction_update,
					COUNT(*) OVER (PARTITION BY Platform ORDER BY Platform) AS Total_sessions,
					COUNT(visitStartTime) OVER (PARTITION BY Platform,fullvisitorID) AS session_per_user
				FROM TABLE_DATE_RANGE([bpi---pizzade:116747870.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-2,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-2,"DAY")))
				GROUP BY 1,2,3
				ORDER BY 1,2),


				(SELECT
					fullVisitorId,
					visitStartTime,
					CONCAT("Talabat ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform,
					IF(SUM(if(hits.customDimensions.index = 11 and hits.customDimensions.value = 'home', 1, 0)) > 0, 1, 0) AS home,
					IF(SUM(if(hits.eventInfo.eventAction = 'shop_list.loaded', 1, 0)) > 0, 1, 0) AS listing,
					IF(SUM(if(hits.eventInfo.eventAction = 'shop_details.loaded', 1, 0)) > 0, 1, 0) AS shop_details,
					IF(SUM(if(hits.eventInfo.eventAction = 'add_cart.clicked', 1, 0)) > 0, 1, 0) AS add_cart,
					IF(SUM(if(hits.eventInfo.eventAction = 'checkout.loaded', 1, 0)) > 0, 1, 0) AS checkout,
					IF(SUM(if(hits.eventInfo.eventAction = 'transaction', 1, 0)) > 0, 1, 0) AS transaction,
					MIN(visitStartTime) OVER (PARTITION BY Platform,fullvisitorID) AS min_start_time,
					SUM(home) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS home_update,
					SUM(listing) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS listing_update,
					SUM(shop_details) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS shop_details_update,
					SUM(add_cart) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS add_cart_update,
					SUM(checkout) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS checkout_update,
					SUM(transaction) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS transaction_update,
					COUNT(*) OVER (PARTITION BY Platform ORDER BY Platform) AS Total_sessions,
					COUNT(visitStartTime) OVER (PARTITION BY Platform,fullvisitorID) AS session_per_user
				FROM TABLE_DATE_RANGE([bta---talabat:109362366.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-2,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-2,"DAY")))
				GROUP BY 1,2,3
				ORDER BY 1,2),
    
				(SELECT
					fullVisitorId,
					visitStartTime,
					CONCAT("Talabat ", device.operatingSystem) AS Platform,
					IF(SUM(if(hits.customDimensions.index = 11 and hits.customDimensions.value = 'home', 1, 0)) > 0, 1, 0) AS home,
					IF(SUM(if(hits.eventInfo.eventAction = 'shop_list.loaded', 1, 0)) > 0, 1, 0) AS listing,
					IF(SUM(if(hits.eventInfo.eventAction = 'shop_details.loaded', 1, 0)) > 0, 1, 0) AS shop_details,
					IF(SUM(if(hits.eventInfo.eventAction = 'add_cart.clicked', 1, 0)) > 0, 1, 0) AS add_cart,
					IF(SUM(if(hits.eventInfo.eventAction = 'checkout.loaded', 1, 0)) > 0, 1, 0) AS checkout,
					IF(SUM(if(hits.eventInfo.eventAction = 'transaction', 1, 0)) > 0, 1, 0) AS transaction,
					MIN(visitStartTime) OVER (PARTITION BY Platform,fullvisitorID) AS min_start_time,
					SUM(home) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS home_update,
					SUM(listing) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS listing_update,
					SUM(shop_details) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS shop_details_update,
					SUM(add_cart) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS add_cart_update,
					SUM(checkout) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS checkout_update,
					SUM(transaction) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime) AS transaction_update,
					COUNT(*) OVER (PARTITION BY Platform ORDER BY Platform) AS Total_sessions,
					COUNT(visitStartTime) OVER (PARTITION BY Platform,fullvisitorID) AS session_per_user
				FROM TABLE_DATE_RANGE([bta---talabat:108646433.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-2,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-2,"DAY")))
				GROUP BY 1,2,3
				ORDER BY 1,2)
			
			
			ORDER BY 3 DESC,2,4)
    
		GROUP BY 1,2,3,4
		ORDER BY 3 DESC, 2)

	GROUP BY 1,2,3
	ORDER BY 1,4 DESC)

WHERE Share_Rate_index < 4



