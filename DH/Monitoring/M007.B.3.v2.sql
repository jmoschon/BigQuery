# Comparison of totals.transactions - transaction event, total revenue and sum-count difference.

SELECT
	Platform,
	COUNT(IF(tot_transaction_per_ses >0,1,NULL)) AS Sessions_inc_transaction,
	ROUND((COUNT(IF(tot_transaction_event_per_ses >0,1,NULL))-COUNT(IF(tot_transaction_per_ses >0,1,NULL)))/COUNT(IF(tot_transaction_per_ses >0,1,NULL))*100,3) AS Diff_perc_ses_transaction_event,
	ROUND((SUM(tot_transaction_per_ses)-COUNT(IF(tot_transaction_per_ses >0,1,NULL)))/COUNT(IF(tot_transaction_per_ses >0,1,NULL))*100,3) AS Diff_perc_Sum_tot_transaction,
	ROUND((SUM(tot_transaction_event_per_ses)-COUNT(IF(tot_transaction_per_ses >0,1,NULL)))/COUNT(IF(tot_transaction_per_ses >0,1,NULL))*100,3) AS Diff_perc_Count_transaction_event,
	ROUND(SUM(tot_revenue_per_ses)/1000000,3) AS Sum_total_revenue,
	ROUND(SUM(tot_event_revenue_per_ses)/1000000,3) Sum_total_revenue_event
FROM
	(SELECT
		visitID,
		fullvisitorID,
		CONCAT("Lieferheld ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform,
		SUM(totals.transactions) AS tot_transaction_per_ses,
		SUM(totals.totalTransactionRevenue) AS tot_revenue_per_ses,
		SUM(hits.transaction.transactionRevenue) AS tot_event_revenue_per_ses,
		COUNT(IF(hits.eventInfo.eventAction = "transaction", 1,NULL)) AS tot_transaction_event_per_ses
  	FROM TABLE_DATE_RANGE([blh---lieferheld:38642300.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 1,2,3),
  
	(SELECT
	 	visitID,
	 	fullvisitorID,
		"Lieferheld Android" AS Platform,
		SUM(totals.transactions) AS tot_transaction_per_ses,
		SUM(totals.totalTransactionRevenue) AS tot_revenue_per_ses,
		SUM(hits.transaction.transactionRevenue) AS tot_event_revenue_per_ses,
		COUNT(IF(hits.eventInfo.eventAction = "transaction", 1,NULL)) AS tot_transaction_event_per_ses
  	FROM TABLE_DATE_RANGE([blh---lieferheld:107101250.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 1,2,3),

	(SELECT
	 	visitID,
	 	fullvisitorID,
		"Lieferheld iOS" AS Platform,
		SUM(totals.transactions) AS tot_transaction_per_ses,
		SUM(totals.totalTransactionRevenue) AS tot_revenue_per_ses,
		SUM(hits.transaction.transactionRevenue) AS tot_event_revenue_per_ses,
		COUNT(IF(hits.eventInfo.eventAction = "transaction", 1,NULL)) AS tot_transaction_event_per_ses
  	FROM TABLE_DATE_RANGE([blh---lieferheld:116747487.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 1,2,3),




	(SELECT
		visitID,
		fullvisitorID,
		CONCAT("PizzaDE ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform,
		SUM(totals.transactions) AS tot_transaction_per_ses,
		SUM(totals.totalTransactionRevenue) AS tot_revenue_per_ses,
		SUM(hits.transaction.transactionRevenue) AS tot_event_revenue_per_ses,
		COUNT(IF(hits.eventInfo.eventAction = "transaction", 1,NULL)) AS tot_transaction_event_per_ses
  	FROM TABLE_DATE_RANGE([bpi---pizzade:107156186.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 1,2,3),
  
	(SELECT
	 	visitID,
	 	fullvisitorID,
		"PizzaDE Android" AS Platform,
		SUM(totals.transactions) AS tot_transaction_per_ses,
		SUM(totals.totalTransactionRevenue) AS tot_revenue_per_ses,
		SUM(hits.transaction.transactionRevenue) AS tot_event_revenue_per_ses,
		COUNT(IF(hits.eventInfo.eventAction = "transaction", 1,NULL)) AS tot_transaction_event_per_ses
  	FROM TABLE_DATE_RANGE([bpi---pizzade:109893332.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 1,2,3),

	(SELECT
	 	visitID,
	 	fullvisitorID,
		"PizzaDE iOS" AS Platform,
		SUM(totals.transactions) AS tot_transaction_per_ses,
		SUM(totals.totalTransactionRevenue) AS tot_revenue_per_ses,
		SUM(hits.transaction.transactionRevenue) AS tot_event_revenue_per_ses,
		COUNT(IF(hits.eventInfo.eventAction = "transaction", 1,NULL)) AS tot_transaction_event_per_ses
  	FROM TABLE_DATE_RANGE([bpi---pizzade:116747870.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 1,2,3),



	(SELECT
		visitID,
		fullvisitorID,
		CONCAT("Talabat ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform,
		SUM(totals.transactions) AS tot_transaction_per_ses,
		SUM(totals.totalTransactionRevenue) AS tot_revenue_per_ses,
		SUM(hits.transaction.transactionRevenue) AS tot_event_revenue_per_ses,
		COUNT(IF(hits.eventInfo.eventAction = "transaction", 1,NULL)) AS tot_transaction_event_per_ses
  	FROM TABLE_DATE_RANGE([bta---talabat:109362366.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 1,2,3),
  
	(SELECT
	 	visitID,
	 	fullvisitorID,
		CONCAT("Talabat ", device.operatingSystem) AS Platform,
		SUM(totals.transactions) AS tot_transaction_per_ses,
		SUM(totals.totalTransactionRevenue) AS tot_revenue_per_ses,
		SUM(hits.transaction.transactionRevenue) AS tot_event_revenue_per_ses,
		COUNT(IF(hits.eventInfo.eventAction = "transaction", 1,NULL)) AS tot_transaction_event_per_ses
  	FROM TABLE_DATE_RANGE([bta---talabat:108646433.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 1,2,3)





GROUP BY 1
ORDER BY 1
