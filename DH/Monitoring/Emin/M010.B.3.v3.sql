# Landing page share and top two funnels.
# yiannis addition: split calculated columns

SELECT
	Platform,
	Total_sessions,
	landing_page,
	Total_landing,
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
			CONCAT("Lieferheld ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform,
			FIRST(IF((hits.type == "PAGE" OR hits.type == "APPVIEW") AND hits.customDimensions.index = 11, hits.customDimensions.value, NULL)) AS landing_page,
			IF(SUM(if(hits.customDimensions.index = 11 and hits.customDimensions.value = 'home', 1, 0)) > 0, 1, 0) AS home,
			IF(SUM(if(hits.eventInfo.eventAction = 'shop_list.loaded', 1, 0)) > 0, 1, 0) AS listing,
			IF(SUM(if(hits.eventInfo.eventAction = 'shop_details.loaded', 1, 0)) > 0, 1, 0) AS shop_details,
			IF(SUM(if(hits.eventInfo.eventAction = 'add_cart.clicked', 1, 0)) > 0, 1, 0) AS add_cart,
			IF(SUM(if(hits.eventInfo.eventAction = 'checkout.loaded', 1, 0)) > 0, 1, 0) AS checkout,
			IF(SUM(if(hits.eventInfo.eventAction = 'transaction', 1, 0)) > 0, 1, 0) AS transaction,
			COUNT(fullVisitorId) OVER (PARTITION BY Platform ORDER BY Platform) AS Total_sessions
		FROM TABLE_DATE_RANGE([blh---lieferheld:38642300.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
		GROUP BY 1,2,3),

		(SELECT
			fullVisitorId,
			visitId,
			"Lieferheld Android" AS Platform,
			FIRST(IF((hits.type == "PAGE" OR hits.type == "APPVIEW") AND hits.customDimensions.index = 11, hits.customDimensions.value, NULL)) AS landing_page,
			IF(SUM(if(hits.customDimensions.index = 11 and hits.customDimensions.value = 'home', 1, 0)) > 0, 1, 0) AS home,
			IF(SUM(if(hits.eventInfo.eventAction = 'shop_list.loaded', 1, 0)) > 0, 1, 0) AS listing,
			IF(SUM(if(hits.eventInfo.eventAction = 'shop_details.loaded', 1, 0)) > 0, 1, 0) AS shop_details,
			IF(SUM(if(hits.eventInfo.eventAction = 'add_cart.clicked', 1, 0)) > 0, 1, 0) AS add_cart,
			IF(SUM(if(hits.eventInfo.eventAction = 'checkout.loaded', 1, 0)) > 0, 1, 0) AS checkout,
			IF(SUM(if(hits.eventInfo.eventAction = 'transaction', 1, 0)) > 0, 1, 0) AS transaction,
			COUNT(*) OVER (PARTITION BY Platform ORDER BY Platform) AS Total_sessions
		FROM TABLE_DATE_RANGE([blh---lieferheld:107101250.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
		GROUP BY 1,2,3),

		(SELECT
			fullVisitorId,
			visitId,
			"Lieferheld iOS" AS Platform,
			FIRST(IF((hits.type == "PAGE" OR hits.type == "APPVIEW") AND hits.customDimensions.index = 11, hits.customDimensions.value, NULL)) AS landing_page,
			IF(SUM(if(hits.customDimensions.index = 11 and hits.customDimensions.value = 'home', 1, 0)) > 0, 1, 0) AS home,
			IF(SUM(if(hits.eventInfo.eventAction = 'shop_list.loaded', 1, 0)) > 0, 1, 0) AS listing,
			IF(SUM(if(hits.eventInfo.eventAction = 'shop_details.loaded', 1, 0)) > 0, 1, 0) AS shop_details,
			IF(SUM(if(hits.eventInfo.eventAction = 'add_cart.clicked', 1, 0)) > 0, 1, 0) AS add_cart,
			IF(SUM(if(hits.eventInfo.eventAction = 'checkout.loaded', 1, 0)) > 0, 1, 0) AS checkout,
			IF(SUM(if(hits.eventInfo.eventAction = 'transaction', 1, 0)) > 0, 1, 0) AS transaction,
			COUNT(*) OVER (PARTITION BY Platform ORDER BY Platform) AS Total_sessions
		FROM TABLE_DATE_RANGE([blh---lieferheld:116747487.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
		GROUP BY 1,2,3),




		(SELECT
			fullVisitorId,
			visitId,
			CONCAT("PizzaDE ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform,			FIRST(IF((hits.type == "PAGE" OR hits.type == "APPVIEW") AND hits.customDimensions.index = 11, hits.customDimensions.value, NULL)) AS landing_page,
			IF(SUM(if(hits.customDimensions.index = 11 and hits.customDimensions.value = 'home', 1, 0)) > 0, 1, 0) AS home,
			IF(SUM(if(hits.eventInfo.eventAction = 'shop_list.loaded', 1, 0)) > 0, 1, 0) AS listing,
			IF(SUM(if(hits.eventInfo.eventAction = 'shop_details.loaded', 1, 0)) > 0, 1, 0) AS shop_details,
			IF(SUM(if(hits.eventInfo.eventAction = 'add_cart.clicked', 1, 0)) > 0, 1, 0) AS add_cart,
			IF(SUM(if(hits.eventInfo.eventAction = 'add_cart.clicked', 1, 0)) > 0, 1, 0) AS checkout,
			IF(SUM(if(hits.eventInfo.eventAction = 'transaction', 1, 0)) > 0, 1, 0) AS transaction,
			COUNT(*) OVER (PARTITION BY Platform ORDER BY Platform) AS Total_sessions
		FROM TABLE_DATE_RANGE([bpi---pizzade:107156186.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
		GROUP BY 1,2,3),

		(SELECT
			fullVisitorId,
			visitId,
			"PizzaDE Android" AS Platform,
			FIRST(IF((hits.type == "PAGE" OR hits.type == "APPVIEW") AND hits.customDimensions.index = 11, hits.customDimensions.value, NULL)) AS landing_page,
			IF(SUM(if(hits.customDimensions.index = 11 and hits.customDimensions.value = 'home', 1, 0)) > 0, 1, 0) AS home,
			IF(SUM(if(hits.eventInfo.eventAction = 'shop_list.loaded', 1, 0)) > 0, 1, 0) AS listing,
			IF(SUM(if(hits.eventInfo.eventAction = 'shop_details.loaded', 1, 0)) > 0, 1, 0) AS shop_details,
			IF(SUM(if(hits.eventInfo.eventAction = 'add_cart.clicked', 1, 0)) > 0, 1, 0) AS add_cart,
			IF(SUM(if(hits.eventInfo.eventAction = 'checkout.loaded', 1, 0)) > 0, 1, 0) AS checkout,
			IF(SUM(if(hits.eventInfo.eventAction = 'transaction', 1, 0)) > 0, 1, 0) AS transaction,
			COUNT(*) OVER (PARTITION BY Platform ORDER BY Platform) AS Total_sessions
		FROM TABLE_DATE_RANGE([bpi---pizzade:109893332.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
		GROUP BY 1,2,3),

		(SELECT
			fullVisitorId,
			visitId,
			"PizzaDE iOS" AS Platform,
			FIRST(IF((hits.type == "PAGE" OR hits.type == "APPVIEW") AND hits.customDimensions.index = 11, hits.customDimensions.value, NULL)) AS landing_page,
			IF(SUM(if(hits.customDimensions.index = 11 and hits.customDimensions.value = 'home', 1, 0)) > 0, 1, 0) AS home,
			IF(SUM(if(hits.eventInfo.eventAction = 'shop_list.loaded', 1, 0)) > 0, 1, 0) AS listing,
			IF(SUM(if(hits.eventInfo.eventAction = 'shop_details.loaded', 1, 0)) > 0, 1, 0) AS shop_details,
			IF(SUM(if(hits.eventInfo.eventAction = 'add_cart.clicked', 1, 0)) > 0, 1, 0) AS add_cart,
			IF(SUM(if(hits.eventInfo.eventAction = 'checkout.loaded', 1, 0)) > 0, 1, 0) AS checkout,
			IF(SUM(if(hits.eventInfo.eventAction = 'transaction', 1, 0)) > 0, 1, 0) AS transaction,
			COUNT(*) OVER (PARTITION BY Platform ORDER BY Platform) AS Total_sessions
		FROM TABLE_DATE_RANGE([bpi---pizzade:116747870.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
		GROUP BY 1,2,3),


		(SELECT
			fullVisitorId,
			visitId,
			CONCAT("Talabat ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform,
			FIRST(IF((hits.type == "PAGE" OR hits.type == "APPVIEW") AND hits.customDimensions.index = 11, hits.customDimensions.value, NULL)) AS landing_page,
			IF(SUM(if(hits.customDimensions.index = 11 and hits.customDimensions.value = 'home', 1, 0)) > 0, 1, 0) AS home,
			IF(SUM(if(hits.eventInfo.eventAction = 'shop_list.loaded', 1, 0)) > 0, 1, 0) AS listing,
			IF(SUM(if(hits.eventInfo.eventAction = 'shop_details.loaded', 1, 0)) > 0, 1, 0) AS shop_details,
			IF(SUM(if(hits.eventInfo.eventAction = 'add_cart.clicked', 1, 0)) > 0, 1, 0) AS add_cart,
			IF(SUM(if(hits.eventInfo.eventAction = 'checkout.loaded', 1, 0)) > 0, 1, 0) AS checkout,
			IF(SUM(if(hits.eventInfo.eventAction = 'transaction', 1, 0)) > 0, 1, 0) AS transaction,
			COUNT(*) OVER (PARTITION BY Platform ORDER BY Platform) AS Total_sessions
		FROM TABLE_DATE_RANGE([bta---talabat:109362366.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
		GROUP BY 1,2,3),

		(SELECT
			fullVisitorId,
			visitId,
			CONCAT("Talabat ", device.operatingSystem) AS Platform,
			FIRST(IF((hits.type == "PAGE" OR hits.type == "APPVIEW") AND hits.customDimensions.index = 11, hits.customDimensions.value, NULL)) AS landing_page,
			IF(SUM(if(hits.customDimensions.index = 11 and hits.customDimensions.value = 'home', 1, 0)) > 0, 1, 0) AS home,
			IF(SUM(if(hits.eventInfo.eventAction = 'shop_list.loaded', 1, 0)) > 0, 1, 0) AS listing,
			IF(SUM(if(hits.eventInfo.eventAction = 'shop_details.loaded', 1, 0)) > 0, 1, 0) AS shop_details,
			IF(SUM(if(hits.eventInfo.eventAction = 'add_cart.clicked', 1, 0)) > 0, 1, 0) AS add_cart,
			IF(SUM(if(hits.eventInfo.eventAction = 'checkout.loaded', 1, 0)) > 0, 1, 0) AS checkout,
			IF(SUM(if(hits.eventInfo.eventAction = 'transaction', 1, 0)) > 0, 1, 0) AS transaction,
			COUNT(*) OVER (PARTITION BY Platform ORDER BY Platform) AS Total_sessions
		FROM TABLE_DATE_RANGE([bta---talabat:108646433.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
		GROUP BY 1,2,3)




	GROUP BY 1,2,3
	ORDER BY 1,2,6)
WHERE Share_Rate_index < 3
ORDER BY 1, 3 DESC, 6 DESC

