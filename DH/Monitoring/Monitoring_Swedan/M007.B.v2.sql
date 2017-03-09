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
		CONCAT("Delivery Hero - Sweden -  ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform,
		SUM(totals.transactions) AS tot_transaction_per_ses,
		SUM(totals.totalTransactionRevenue) AS tot_revenue_per_ses,
		SUM(hits.transaction.transactionRevenue) AS tot_event_revenue_per_ses,
		COUNT(IF(hits.eventInfo.eventAction = "transaction", 1,NULL)) AS tot_transaction_event_per_ses
  	FROM TABLE_DATE_RANGE([bdh---deliveryhero-se:123559331.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 1,2,3),
  
	(SELECT
	 	visitID,
	 	fullvisitorID,
		"Delivery Hero - Sweden - Android" AS Platform,
		SUM(totals.transactions) AS tot_transaction_per_ses,
		SUM(totals.totalTransactionRevenue) AS tot_revenue_per_ses,
		SUM(hits.transaction.transactionRevenue) AS tot_event_revenue_per_ses,
		COUNT(IF(hits.eventInfo.eventAction = "transaction", 1,NULL)) AS tot_transaction_event_per_ses
  	FROM TABLE_DATE_RANGE([bdh---deliveryhero-se:123571417.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 1,2,3),

	(SELECT
	 	visitID,
	 	fullvisitorID,
		"Delivery Hero - Sweden - iOS" AS Platform,
		SUM(totals.transactions) AS tot_transaction_per_ses,
		SUM(totals.totalTransactionRevenue) AS tot_revenue_per_ses,
		SUM(hits.transaction.transactionRevenue) AS tot_event_revenue_per_ses,
		COUNT(IF(hits.eventInfo.eventAction = "transaction", 1,NULL)) AS tot_transaction_event_per_ses
  	FROM TABLE_DATE_RANGE([blh---lieferheld:107101250.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 1,2,3),




	(SELECT
		visitID,
		fullvisitorID,
		CONCAT("Online Pizza - Sweden - ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform,
		SUM(totals.transactions) AS tot_transaction_per_ses,
		SUM(totals.totalTransactionRevenue) AS tot_revenue_per_ses,
		SUM(hits.transaction.transactionRevenue) AS tot_event_revenue_per_ses,
		COUNT(IF(hits.eventInfo.eventAction = "transaction", 1,NULL)) AS tot_transaction_event_per_ses
  	FROM TABLE_DATE_RANGE([bop---onlinepizza:110474939.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 1,2,3),
  
	(SELECT
	 	visitID,
	 	fullvisitorID,
		"Online Pizza- Sweden - Android" AS Platform,
		SUM(totals.transactions) AS tot_transaction_per_ses,
		SUM(totals.totalTransactionRevenue) AS tot_revenue_per_ses,
		SUM(hits.transaction.transactionRevenue) AS tot_event_revenue_per_ses,
		COUNT(IF(hits.eventInfo.eventAction = "transaction", 1,NULL)) AS tot_transaction_event_per_ses
  	FROM TABLE_DATE_RANGE([bop---onlinepizza:111057681.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 1,2,3),

	(SELECT
	 	visitID,
	 	fullvisitorID,
		"Online Pizza - Sweden - iOS" AS Platform,
		SUM(totals.transactions) AS tot_transaction_per_ses,
		SUM(totals.totalTransactionRevenue) AS tot_revenue_per_ses,
		SUM(hits.transaction.transactionRevenue) AS tot_event_revenue_per_ses,
		COUNT(IF(hits.eventInfo.eventAction = "transaction", 1,NULL)) AS tot_transaction_event_per_ses
  	FROM TABLE_DATE_RANGE([bop---onlinepizza:111053874.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 1,2,3),


GROUP BY 1
ORDER BY 1
