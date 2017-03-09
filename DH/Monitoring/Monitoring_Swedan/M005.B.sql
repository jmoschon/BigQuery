# Cumulative event distribution of sessions from shop_details (1), add_cart.clicked (1), checkout.loaded(1) to transaction (0).  (double check how transaction events and totals.transactions are matching)
# For PizzaDe WEB, we count checkout.loaded if there is add_cart.clicked, because there is no checkout.loaded event for PizzaDe.
# For pizza online iOS event "chechout.loaded" is not there
SELECT
	Platform,
	UNIQUE(Total_sessions) AS Count_sessions,
	"XX111X" AS Full_funnel,
	#COUNT(fullVisitorId) AS Funnel_count_sessions,
	ROUND(COUNT(fullVisitorId)/MAX(Total_sessions)*100,3) AS Full_funnel_share,
	#SUM(IF(listing == 1 AND home == 1, 1, NULL))/COUNT(fullVisitorId)*100 AS Home_perc,
	#SUM(IF(listing == 1 AND home == 0, 1, NULL))/COUNT(fullVisitorId)*100 AS Listing_perc,
	#shop_details,
	#add_cart,
	#checkout_loaded,
	ROUND(SUM(transaction_event)/COUNT(fullVisitorId)*100,3) AS Transaction_event_perc

FROM
	(SELECT
		fullVisitorId,
		visitId,
		CONCAT("Delivery Hero - Sweden -  ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform,
		IF(SUM(if(hits.customDimensions.index = 11 and hits.customDimensions.value = 'home', 1, 0)) > 0, 1, 0) AS home,
		IF(SUM(if(hits.eventInfo.eventAction = 'shop_list.loaded', 1, 0)) > 0, 1, 0) AS listing,
		IF(SUM(if(hits.eventInfo.eventAction = 'shop_details.loaded', 1, 0)) > 0, 1, 0) AS shop_details,
		IF(SUM(if(hits.eventInfo.eventAction = 'add_cart.clicked', 1, 0)) > 0, 1, 0) AS add_cart,
		IF(SUM(if(hits.eventInfo.eventAction = 'checkout.loaded', 1, 0)) > 0, 1, 0) AS checkout_loaded,
		IF(SUM(if(hits.eventInfo.eventAction = 'transaction', 1, 0)) > 0, 1, 0) AS transaction_event,
		COUNT(fullVisitorId) OVER (PARTITION BY Platform ORDER BY Platform) AS Total_sessions
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
		IF(SUM(if(hits.eventInfo.eventAction = 'checkout.loaded', 1, 0)) > 0, 1, 0) AS checkout_loaded,
		IF(SUM(if(hits.eventInfo.eventAction = 'transaction', 1, 0)) > 0, 1, 0) AS transaction_event,
		COUNT(fullVisitorId) OVER (PARTITION BY Platform ORDER BY Platform) AS Total_sessions
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
		IF(SUM(if(hits.eventInfo.eventAction = 'checkout.loaded', 1, 0)) > 0, 1, 0) AS checkout_loaded,
		IF(SUM(if(hits.eventInfo.eventAction = 'transaction', 1, 0)) > 0, 1, 0) AS transaction_event,
		COUNT(fullVisitorId) OVER (PARTITION BY Platform ORDER BY Platform) AS Total_sessions
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
		IF(SUM(if(hits.eventInfo.eventAction = 'checkout.loaded', 1, 0)) > 0, 1, 0) AS checkout_loaded,
		IF(SUM(if(hits.eventInfo.eventAction = 'transaction', 1, 0)) > 0, 1, 0) AS transaction_event,
		COUNT(fullVisitorId) OVER (PARTITION BY Platform ORDER BY Platform) AS Total_sessions
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
		IF(SUM(if(hits.eventInfo.eventAction = 'checkout.loaded', 1, 0)) > 0, 1, 0) AS checkout_loaded,
		IF(SUM(if(hits.eventInfo.eventAction = 'transaction', 1, 0)) > 0, 1, 0) AS transaction_event,
		COUNT(fullVisitorId) OVER (PARTITION BY Platform ORDER BY Platform) AS Total_sessions
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
		IF(SUM(if(hits.eventInfo.eventAction = 'checkout.loaded', 1, 0)) > 0, 1, 0) AS checkout_loaded,
		IF(SUM(if(hits.eventInfo.eventAction = 'transaction', 1, 0)) > 0, 1, 0) AS transaction_event,
		COUNT(fullVisitorId) OVER (PARTITION BY Platform ORDER BY Platform) AS Total_sessions
	FROM TABLE_DATE_RANGE([bop---onlinepizza:111053874.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 1,2,3),





WHERE shop_details == 1 AND add_cart == 1 AND checkout_loaded == 1
GROUP BY 1,3
ORDER BY 1,4 DESC