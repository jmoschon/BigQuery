# Distribution of sessions by events made. (LIMIT 5 for each group)
# For PizzaDe WEB, we count checkout.loaded if there is add_cart.clicked, because there is no checkout.loaded event for PizzaDe.

SELECT
	Platform,
	full_funnel AS Full_funnel,
	funnel_sessions AS Funnel_count_sessions,
	ROUND(session_share_percentage,3) AS Share_sessions
#	Share_Rate_index
FROM

	(SELECT
		Platform,
		CONCAT(STRING(home), STRING(listing), STRING(shop_details), STRING(add_cart), STRING(checkout), STRING(transaction)) AS full_funnel,
		home,
		listing,
		shop_details,
		add_cart,
		checkout,
		transaction,
		COUNT(fullVisitorId) AS funnel_sessions,
		COUNT(fullVisitorId)/UNIQUE(Total_sessions)*100 AS session_share_percentage,
		ROW_NUMBER() OVER (PARTITION BY Platform ORDER BY Platform, session_share_percentage DESC) AS Share_Rate_index
	FROM

		(SELECT
			fullVisitorId,
			visitId,
			CONCAT("Delivery Hero - Sweden -  ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform,
			IF(SUM(if(hits.customDimensions.index = 11 and hits.customDimensions.value = 'home', 1, 0)) > 0, 1, 0) AS home,
			IF(SUM(if(hits.eventInfo.eventAction = 'shop_list.loaded', 1, 0)) > 0, 1, 0) AS listing,
			IF(SUM(if(hits.eventInfo.eventAction = 'shop_details.loaded', 1, 0)) > 0, 1, 0) AS shop_details,
			IF(SUM(if(hits.eventInfo.eventAction = 'add_cart.clicked', 1, 0)) > 0, 1, 0) AS add_cart,
			IF(SUM(if(hits.eventInfo.eventAction = 'checkout.loaded', 1, 0)) > 0, 1, 0) AS checkout,
			IF(SUM(if(hits.eventInfo.eventAction = 'transaction', 1, 0)) > 0, 1, 0) AS transaction,
			COUNT(*) OVER (PARTITION BY Platform ORDER BY Platform) AS Total_sessions
	FROM TABLE_DATE_RANGE([bdh---deliveryhero-se:123559331.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
		GROUP BY 1,2,3),

		(SELECT
			fullVisitorId,
			visitId,
			"Delivery Hero - Sweden - Android" AS Platform,
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
			IF(SUM(if(hits.customDimensions.index = 11 and hits.customDimensions.value = 'home', 1, 0)) > 0, 1, 0) AS home,
			IF(SUM(if(hits.eventInfo.eventAction = 'shop_list.loaded', 1, 0)) > 0, 1, 0) AS listing,
			IF(SUM(if(hits.eventInfo.eventAction = 'shop_details.loaded', 1, 0)) > 0, 1, 0) AS shop_details,
			IF(SUM(if(hits.eventInfo.eventAction = 'add_cart.clicked', 1, 0)) > 0, 1, 0) AS add_cart,
			IF(SUM(if(hits.eventInfo.eventAction = 'checkout.loaded', 1, 0)) > 0, 1, 0) AS checkout,
			IF(SUM(if(hits.eventInfo.eventAction = 'transaction', 1, 0)) > 0, 1, 0) AS transaction,
			COUNT(*) OVER (PARTITION BY Platform ORDER BY Platform) AS Total_sessions
	FROM TABLE_DATE_RANGE([bop---onlinepizza:110474939.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
		GROUP BY 1,2,3),

		(SELECT
			fullVisitorId,
			visitId,
			"Online Pizza- Sweden - Android" AS Platform,
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
			IF(SUM(if(hits.customDimensions.index = 11 and hits.customDimensions.value = 'home', 1, 0)) > 0, 1, 0) AS home,
			IF(SUM(if(hits.eventInfo.eventAction = 'shop_list.loaded', 1, 0)) > 0, 1, 0) AS listing,
			IF(SUM(if(hits.eventInfo.eventAction = 'shop_details.loaded', 1, 0)) > 0, 1, 0) AS shop_details,
			IF(SUM(if(hits.eventInfo.eventAction = 'add_cart.clicked', 1, 0)) > 0, 1, 0) AS add_cart,
			IF(SUM(if(hits.eventInfo.eventAction = 'checkout.loaded', 1, 0)) > 0, 1, 0) AS checkout,
			IF(SUM(if(hits.eventInfo.eventAction = 'transaction', 1, 0)) > 0, 1, 0) AS transaction,
			COUNT(*) OVER (PARTITION BY Platform ORDER BY Platform) AS Total_sessions
	FROM TABLE_DATE_RANGE([bop---onlinepizza:111053874.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
		GROUP BY 1,2,3),





GROUP BY 1,2,3,4,5,6,7,8)
WHERE Share_Rate_index < 6
ORDER BY 1,4 DESC