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
		CONCAT("Lieferheld ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform
	FROM TABLE_DATE_RANGE([blh---lieferheld:38642300.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 2,4),

	(SELECT
		COUNT(visitID) AS visit_per_user,
		fullvisitorID,
		COUNT(totals.transactions) AS total_transaction_done,
		"Lieferheld Android" AS Platform
	FROM TABLE_DATE_RANGE([blh---lieferheld:107101250.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 2,4),

	(SELECT
	 	COUNT(visitID) AS visit_per_user,
	 	fullvisitorID,
		COUNT(totals.transactions) AS total_transaction_done,
		"Lieferheld iOS" AS Platform
	FROM TABLE_DATE_RANGE([blh---lieferheld:116747487.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 2,4),




	(SELECT
		COUNT(visitID) AS visit_per_user,
		fullvisitorID,
		COUNT(totals.transactions) AS total_transaction_done,
		CONCAT("PizzaDE ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform
	FROM TABLE_DATE_RANGE([bpi---pizzade:107156186.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 2,4),

	(SELECT
		COUNT(visitID) AS visit_per_user,
		fullvisitorID,
		COUNT(totals.transactions) AS total_transaction_done,
		"PizzaDE Android" AS Platform
	FROM TABLE_DATE_RANGE([bpi---pizzade:109893332.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 2,4),

	(SELECT
	 	COUNT(visitID) AS visit_per_user,
	 	fullvisitorID,
		COUNT(totals.transactions) AS total_transaction_done,
		"PizzaDE iOS" AS Platform
	FROM TABLE_DATE_RANGE([bpi---pizzade:116747870.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 2,4),


	(SELECT
		COUNT(visitID) AS visit_per_user,
		fullvisitorID,
		COUNT(totals.transactions) AS total_transaction_done,
		CONCAT("Talabat ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform
	FROM TABLE_DATE_RANGE([bta---talabat:109362366.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 2,4),

	(SELECT
		COUNT(visitID) AS visit_per_user,
		fullvisitorID,
		COUNT(totals.transactions) AS total_transaction_done,
		CONCAT("Talabat ", device.operatingSystem) AS Platform
	FROM TABLE_DATE_RANGE([bta---talabat:108646433.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 2,4)



GROUP BY 1
ORDER BY 1