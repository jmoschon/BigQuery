# Landing page share and top two funnels.

SELECT
	Platform,
	landing_page,
	ROUND(Total_landing/Total_sessions*100,3) AS landing_share,
	full_funnel,
	funnel_sessions,
	ROUND(funnel_sessions/Total_landing*100,3) AS funnel_share

FROM
	(SELECT
		Platform,
		landing_page,
		CONCAT(STRING(home), STRING(listing), STRING(shop_details), STRING(add_cart), STRING(checkout), STRING(transaction)) AS full_funnel,
		COUNT(fullVisitorId) AS funnel_sessions,
		UNIQUE(Total_sessions) AS Total_sessions,
		SUM(funnel_sessions) OVER (PARTITION BY Platform,landing_page) AS Total_landing,
		ROW_NUMBER() OVER (PARTITION BY Platform,landing_page ORDER BY funnel_sessions DESC) AS Share_Rate_index
	FROM

		(SELECT
			fullVisitorId,
			visitId,
			CONCAT("Delivery Hero - Sweden -  ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform,
			FIRST(IF((hits.type == "PAGE" OR hits.type == "APPVIEW") AND hits.customDimensions.index = 11, hits.customDimensions.value, NULL)) AS landing_page,
			IF(SUM(if(hits.customDimensions.index = 11 and hits.customDimensions.value = 'home', 1, 0)) > 0, 1, 0) AS home,
			IF(SUM(if(hits.eventInfo.eventAction = 'shop_list.loaded', 1, 0)) > 0, 1, 0) AS listing,
			IF(SUM(if(hits.eventInfo.eventAction = 'shop_details.loaded', 1, 0)) > 0, 1, 0) AS shop_details,
			IF(SUM(if(hits.eventInfo.eventAction = 'add_cart.clicked', 1, 0)) > 0, 1, 0) AS add_cart,
			IF(SUM(if(hits.eventInfo.eventAction = 'checkout.loaded', 1, 0)) > 0, 1, 0) AS checkout,
			IF(SUM(if(hits.eventInfo.eventAction = 'transaction', 1, 0)) > 0, 1, 0) AS transaction,
			COUNT(fullVisitorId) OVER (PARTITION BY Platform ORDER BY Platform) AS Total_sessions
		FROM TABLE_DATE_RANGE([bdh---deliveryhero-se:123559331.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
		GROUP BY 1,2,3),

		(SELECT
			fullVisitorId,
			visitId,
			"Delivery Hero - Sweden - Android" AS Platform,
			FIRST(IF((hits.type == "PAGE" OR hits.type == "APPVIEW") AND hits.customDimensions.index = 11, hits.customDimensions.value, NULL)) AS landing_page,
			IF(SUM(if(hits.customDimensions.index = 11 and hits.customDimensions.value = 'home', 1, 0)) > 0, 1, 0) AS home,
			IF(SUM(if(hits.eventInfo.eventAction = 'shop_list.loaded', 1, 0)) > 0, 1, 0) AS listing,
			IF(SUM(if(hits.eventInfo.eventAction = 'shop_details.loaded', 1, 0)) > 0, 1, 0) AS shop_details,
			IF(SUM(if(hits.eventInfo.eventAction = 'add_cart.clicked', 1, 0)) > 0, 1, 0) AS add_cart,
			IF(SUM(if(hits.eventInfo.eventAction = 'checkout.loaded', 1, 0)) > 0, 1, 0) AS checkout,
			IF(SUM(if(hits.eventInfo.eventAction = 'transaction', 1, 0)) > 0, 1, 0) AS transaction,
			COUNT(*) OVER (PARTITION BY Platform ORDER BY Platform) AS Total_sessions
		FROM TABLE_DATE_RANGE([bdh---deliveryhero-se:123571417.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
		GROUP BY 1,2,3),

		(SELECT
			fullVisitorId,
			visitId,
			"Delivery Hero - Sweden - iOS" AS Platform,
			FIRST(IF((hits.type == "PAGE" OR hits.type == "APPVIEW") AND hits.customDimensions.index = 11, hits.customDimensions.value, NULL)) AS landing_page,
			IF(SUM(if(hits.customDimensions.index = 11 and hits.customDimensions.value = 'home', 1, 0)) > 0, 1, 0) AS home,
			IF(SUM(if(hits.eventInfo.eventAction = 'shop_list.loaded', 1, 0)) > 0, 1, 0) AS listing,
			IF(SUM(if(hits.eventInfo.eventAction = 'shop_details.loaded', 1, 0)) > 0, 1, 0) AS shop_details,
			IF(SUM(if(hits.eventInfo.eventAction = 'add_cart.clicked', 1, 0)) > 0, 1, 0) AS add_cart,
			IF(SUM(if(hits.eventInfo.eventAction = 'checkout.loaded', 1, 0)) > 0, 1, 0) AS checkout,
			IF(SUM(if(hits.eventInfo.eventAction = 'transaction', 1, 0)) > 0, 1, 0) AS transaction,
			COUNT(*) OVER (PARTITION BY Platform ORDER BY Platform) AS Total_sessions
		FROM TABLE_DATE_RANGE([bdh---deliveryhero-se:123548742.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
		GROUP BY 1,2,3),




		(SELECT
			fullVisitorId,
			visitId,
			CONCAT("Online Pizza - Sweden - ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform,
		    FIRST(IF((hits.type == "PAGE" OR hits.type == "APPVIEW") AND hits.customDimensions.index = 11, hits.customDimensions.value, NULL)) AS landing_page,
			IF(SUM(if(hits.customDimensions.index = 11 and hits.customDimensions.value = 'home', 1, 0)) > 0, 1, 0) AS home,
			IF(SUM(if(hits.eventInfo.eventAction = 'shop_list.loaded', 1, 0)) > 0, 1, 0) AS listing,
			IF(SUM(if(hits.eventInfo.eventAction = 'shop_details.loaded', 1, 0)) > 0, 1, 0) AS shop_details,
			IF(SUM(if(hits.eventInfo.eventAction = 'add_cart.clicked', 1, 0)) > 0, 1, 0) AS add_cart,
			IF(SUM(if(hits.eventInfo.eventAction = 'add_cart.clicked', 1, 0)) > 0, 1, 0) AS checkout,
			IF(SUM(if(hits.eventInfo.eventAction = 'transaction', 1, 0)) > 0, 1, 0) AS transaction,
			COUNT(*) OVER (PARTITION BY Platform ORDER BY Platform) AS Total_sessions
		FROM TABLE_DATE_RANGE([bop---onlinepizza:110474939.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
		GROUP BY 1,2,3),

		(SELECT
			fullVisitorId,
			visitId,
			"Online Pizza- Sweden - Android" AS Platform,
			FIRST(IF((hits.type == "PAGE" OR hits.type == "APPVIEW") AND hits.customDimensions.index = 11, hits.customDimensions.value, NULL)) AS landing_page,
			IF(SUM(if(hits.customDimensions.index = 11 and hits.customDimensions.value = 'home', 1, 0)) > 0, 1, 0) AS home,
			IF(SUM(if(hits.eventInfo.eventAction = 'shop_list.loaded', 1, 0)) > 0, 1, 0) AS listing,
			IF(SUM(if(hits.eventInfo.eventAction = 'shop_details.loaded', 1, 0)) > 0, 1, 0) AS shop_details,
			IF(SUM(if(hits.eventInfo.eventAction = 'add_cart.clicked', 1, 0)) > 0, 1, 0) AS add_cart,
			IF(SUM(if(hits.eventInfo.eventAction = 'checkout.loaded', 1, 0)) > 0, 1, 0) AS checkout,
			IF(SUM(if(hits.eventInfo.eventAction = 'transaction', 1, 0)) > 0, 1, 0) AS transaction,
			COUNT(*) OVER (PARTITION BY Platform ORDER BY Platform) AS Total_sessions
		FROM TABLE_DATE_RANGE([bop---onlinepizza:111057681.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
		GROUP BY 1,2,3),

		(SELECT
			fullVisitorId,
			visitId,
			"Online Pizza - Sweden - iOS" AS Platform,
			FIRST(IF((hits.type == "PAGE" OR hits.type == "APPVIEW") AND hits.customDimensions.index = 11, hits.customDimensions.value, NULL)) AS landing_page,
			IF(SUM(if(hits.customDimensions.index = 11 and hits.customDimensions.value = 'home', 1, 0)) > 0, 1, 0) AS home,
			IF(SUM(if(hits.eventInfo.eventAction = 'shop_list.loaded', 1, 0)) > 0, 1, 0) AS listing,
			IF(SUM(if(hits.eventInfo.eventAction = 'shop_details.loaded', 1, 0)) > 0, 1, 0) AS shop_details,
			IF(SUM(if(hits.eventInfo.eventAction = 'add_cart.clicked', 1, 0)) > 0, 1, 0) AS add_cart,
			IF(SUM(if(hits.eventInfo.eventAction = 'checkout.loaded', 1, 0)) > 0, 1, 0) AS checkout,
			IF(SUM(if(hits.eventInfo.eventAction = 'transaction', 1, 0)) > 0, 1, 0) AS transaction,
			COUNT(*) OVER (PARTITION BY Platform ORDER BY Platform) AS Total_sessions
		FROM TABLE_DATE_RANGE([bop---onlinepizza:111053874.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
		GROUP BY 1,2,3),






	GROUP BY 1,2,3
	ORDER BY 1,2,6)
WHERE Share_Rate_index < 3
ORDER BY 1, 3 DESC, 6 DESC

