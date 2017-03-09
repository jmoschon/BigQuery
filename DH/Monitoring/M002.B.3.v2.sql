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
		CONCAT("Lieferheld ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform,
		SUM(totals.visits) AS total_visits
	FROM TABLE_DATE_RANGE([blh---lieferheld:38642300.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 1,2,4),

	(SELECT
	 	visitID,
	 	fullvisitorID,
		SUM(totals.transactions) AS sum_ses_transaction,
		"Lieferheld Android" AS Platform,
		SUM(totals.visits) AS total_visits
	FROM TABLE_DATE_RANGE([blh---lieferheld:107101250.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 1,2,4),

	(SELECT
	 	visitID,
	 	fullvisitorID,
		SUM(totals.transactions) AS sum_ses_transaction,
		"Lieferheld iOS" AS Platform,
		SUM(totals.visits) AS total_visits
	FROM TABLE_DATE_RANGE([blh---lieferheld:116747487.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 1,2,4),





	(SELECT
	 	visitID,
	 	fullvisitorID,
		SUM(totals.transactions) AS sum_ses_transaction,
		CONCAT("PizzaDE ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform,
		SUM(totals.visits) AS total_visits
	FROM TABLE_DATE_RANGE([bpi---pizzade:107156186.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 1,2,4),

	(SELECT
	 	visitID,
	 	fullvisitorID,
		SUM(totals.transactions) AS sum_ses_transaction,
		"PizzaDE Android" AS Platform,
		SUM(totals.visits) AS total_visits
	FROM TABLE_DATE_RANGE([bpi---pizzade:109893332.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 1,2,4),

	(SELECT
	 	visitID,
	 	fullvisitorID,
		SUM(totals.transactions) AS sum_ses_transaction,
		"PizzaDE iOS" AS Platform,
		SUM(totals.visits) AS total_visits
	FROM TABLE_DATE_RANGE([bpi---pizzade:116747870.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 1,2,4),



	(SELECT
	 	visitID,
	 	fullvisitorID,
		SUM(totals.transactions) AS sum_ses_transaction,
		CONCAT("Talabat ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform,
		SUM(totals.visits) AS total_visits
	FROM TABLE_DATE_RANGE([bta---talabat:109362366.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 1,2,4),

	(SELECT
	 	visitID,
	 	fullvisitorID,
		SUM(totals.transactions) AS sum_ses_transaction,
		CONCAT("Talabat ", device.operatingSystem) AS Platform,
		SUM(totals.visits) AS total_visits
	FROM TABLE_DATE_RANGE([bta---talabat:108646433.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 1,2,4)


GROUP BY 1
ORDER BY 1
