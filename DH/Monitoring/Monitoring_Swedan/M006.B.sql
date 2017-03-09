# Session based and user based CVR for app and web, derived for a day.

SELECT
	Platform,
	SUM(visit_per_user) AS Count_sessions,
	SUM(total_transaction_done) AS Count_transactions,
	ROUND(SUM(total_transaction_done)/SUM(visit_per_user)*100,3) AS CVR_session_based,
	EXACT_COUNT_DISTINCT(fullvisitorID) AS Count_users,
	COUNT(IF(total_transaction_done > 0,1,NULL)) AS Count_user_trans,
	ROUND(COUNT(IF(total_transaction_done > 0,1,NULL))/EXACT_COUNT_DISTINCT(fullvisitorID)*100,3) AS CVR_user_based
FROM
	(SELECT
		COUNT(visitID) AS visit_per_user,
		fullvisitorID,
		COUNT(totals.transactions) AS total_transaction_done,
		CONCAT("Delivery Hero - Sweden -  ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform,
	FROM TABLE_DATE_RANGE([bdh---deliveryhero-se:123559331.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 2,4),

	(SELECT
		COUNT(visitID) AS visit_per_user,
		fullvisitorID,
		COUNT(totals.transactions) AS total_transaction_done,
		"Delivery Hero - Sweden - Android" AS Platform,
	FROM TABLE_DATE_RANGE([bdh---deliveryhero-se:123571417.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 2,4),

	(SELECT
	 	COUNT(visitID) AS visit_per_user,
	 	fullvisitorID,
		COUNT(totals.transactions) AS total_transaction_done,
		"Delivery Hero - Sweden - iOS" AS Platform,
	FROM TABLE_DATE_RANGE([bdh---deliveryhero-se:123548742.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 2,4),




	(SELECT
		COUNT(visitID) AS visit_per_user,
		fullvisitorID,
		COUNT(totals.transactions) AS total_transaction_done,
		CONCAT("Online Pizza - Sweden - ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform,
	FROM TABLE_DATE_RANGE([bop---onlinepizza:110474939.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 2,4),

	(SELECT
		COUNT(visitID) AS visit_per_user,
		fullvisitorID,
		COUNT(totals.transactions) AS total_transaction_done,
		"Online Pizza- Sweden - Android" AS Platform,
	FROM TABLE_DATE_RANGE([bop---onlinepizza:111057681.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 2,4),

	(SELECT
	 	COUNT(visitID) AS visit_per_user,
	 	fullvisitorID,
		COUNT(totals.transactions) AS total_transaction_done,
		"Online Pizza - Sweden - iOS" AS Platform,
	FROM TABLE_DATE_RANGE([bop---onlinepizza:111053874.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 2,4),





GROUP BY 1
ORDER BY 1