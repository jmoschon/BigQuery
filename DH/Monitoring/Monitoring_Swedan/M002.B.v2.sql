# Count or sum difference in total transactions.

SELECT
	Platform,
	COUNT(sum_ses_transaction) AS Count_transactions,
	SUM(sum_ses_transaction) AS Sum_transactions,
	COUNT(visitID) AS Count_sessions,
	ROUND((SUM(total_visits)-COUNT(visitID))/COUNT(visitID)*100,3) AS Perc_diff_sessions_GA,
	ROUND(COUNT(sum_ses_transaction)/COUNT(visitID)*100,3) AS CVR_count_transaction,
	ROUND(SUM(sum_ses_transaction)/COUNT(visitID)*100,3) AS CVR_sum_transaction
  
FROM
	(SELECT
	 	visitID,
	 	fullvisitorID,
		SUM(totals.transactions) AS sum_ses_transaction,
		CONCAT("Delivery Hero - Sweden - ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform,
		SUM(totals.visits) AS total_visits
	FROM TABLE_DATE_RANGE([bdh---deliveryhero-se:123559331.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 1,2,4),

	(SELECT
	 	visitID,
	 	fullvisitorID,
		SUM(totals.transactions) AS sum_ses_transaction,
		"Delivery Hero - Sweden - Android" AS Platform,
		SUM(totals.visits) AS total_visits
	FROM TABLE_DATE_RANGE([bdh---deliveryhero-se:123571417.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 1,2,4),

	(SELECT
	 	visitID,
	 	fullvisitorID,
		SUM(totals.transactions) AS sum_ses_transaction,
		"Delivery Hero - Sweden - iOS" AS Platform,
		SUM(totals.visits) AS total_visits
	FROM TABLE_DATE_RANGE([bdh---deliveryhero-se:123548742.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 1,2,4),




	(SELECT
	 	visitID,
	 	fullvisitorID,
		SUM(totals.transactions) AS sum_ses_transaction,
		CONCAT("Online Pizza - Sweden - ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform,
		SUM(totals.visits) AS total_visits
	FROM TABLE_DATE_RANGE([bop---onlinepizza:110474939.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 1,2,4),

	(SELECT
	 	visitID,
	 	fullvisitorID,
		SUM(totals.transactions) AS sum_ses_transaction,
		"Online Pizza- Sweden - Android" AS Platform,
		SUM(totals.visits) AS total_visits
	FROM TABLE_DATE_RANGE([bop---onlinepizza:111057681.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 1,2,4),

	(SELECT
	 	visitID,
	 	fullvisitorID,
		SUM(totals.transactions) AS sum_ses_transaction,
		"Online Pizza - Sweden iOS" AS Platform,
		SUM(totals.visits) AS total_visits
	FROM TABLE_DATE_RANGE([bop---onlinepizza:111053874.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 1,2,4),


GROUP BY 1
ORDER BY 1
