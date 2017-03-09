# Sessions per day by users, with and without transaction.

SELECT
	Platform,
	count_ses_str AS Session_Bin,
	COUNT(fullvisitorID) AS Count_users,
	SUM(count_ses) AS Count_sessions,
	ROUND(SUM(count_ses)/UNIQUE(Total_sessions)*100,3) AS Share_sessions,
#	ROUND(COUNT(user_bad_flag)/UNIQUE(Total_sessions)*100,3) AS Perc_30_min_flag,
#	SUM(count_trans) AS Count_transactions,
	ROUND(SUM(count_trans)/SUM(count_ses)*100,3) AS CVR,
	ROUND(AVG(count_hit),3) AS AVG_hit,
	ROUND(AVG(visittime_interval),3) AS Avg_visittime_diff_min
FROM

	(SELECT
		IF(COUNT(visitID) < 4, STRING(COUNT(visitID)), IF(COUNT(visitID) >= 4 , "x > 4", NULL)) AS count_ses_str,
		COUNT(visitID) AS count_ses,
		fullvisitorID,
		CONCAT("Delivery Hero - Sweden -  ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform,
		IF(COUNT(totals.transactions) > 0, COUNT(totals.transactions), NULL) count_trans,
		COUNT(hits.hitNumber) AS count_hit,
		(MAX(visitStartTime)-MIN(visitStartTime))/60 AS visittime_interval,
		IF(((MAX(visitStartTime)-MIN(visitStartTime))/60) / (COUNT(visitID)-1) < 30, 1, NULL) user_bad_flag,
		SUM(count_ses) OVER (PARTITION BY Platform) AS Total_sessions
	FROM TABLE_DATE_RANGE([bdh---deliveryhero-se:123559331.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 3,4),
  
	(SELECT
		IF(COUNT(visitID) < 4, STRING(COUNT(visitID)), IF(COUNT(visitID) >= 4 , "x > 4", NULL)) AS count_ses_str,
		COUNT(visitID) AS count_ses,
		fullvisitorID,
		"Delivery Hero - Sweden - Android" AS Platform,
		IF(COUNT(totals.transactions) > 0, COUNT(totals.transactions), NULL) count_trans,
		COUNT(hits.hitNumber) AS count_hit,
		(MAX(visitStartTime)-MIN(visitStartTime))/60 AS visittime_interval,
		IF(((MAX(visitStartTime)-MIN(visitStartTime))/60) / (COUNT(visitID)-1) < 30, 1, NULL) user_bad_flag,
		SUM(count_ses) OVER (PARTITION BY Platform) AS Total_sessions
	FROM TABLE_DATE_RANGE([bdh---deliveryhero-se:123571417.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 3,4),
  
	(SELECT
		IF(COUNT(visitID) < 4, STRING(COUNT(visitID)), IF(COUNT(visitID) >= 4 , "x > 4", NULL)) AS count_ses_str,
		COUNT(visitID) AS count_ses,
		fullvisitorID,
		"Delivery Hero - Sweden - iOS" AS Platform,
		IF(COUNT(totals.transactions) > 0, COUNT(totals.transactions), NULL) count_trans,
		COUNT(hits.hitNumber) AS count_hit,
		(MAX(visitStartTime)-MIN(visitStartTime))/60 AS visittime_interval,
		IF(((MAX(visitStartTime)-MIN(visitStartTime))/60) / (COUNT(visitID)-1) < 30, 1, NULL) user_bad_flag,
		SUM(count_ses) OVER (PARTITION BY Platform) AS Total_sessions
	FROM TABLE_DATE_RANGE([bdh---deliveryhero-se:123548742.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 3,4),



	(SELECT
		IF(COUNT(visitID) < 4, STRING(COUNT(visitID)), IF(COUNT(visitID) >= 4 , "x > 4", NULL)) AS count_ses_str,
		COUNT(visitID) AS count_ses,
		fullvisitorID,
		CONCAT("Online Pizza - Sweden - ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform,
		IF(COUNT(totals.transactions) > 0, COUNT(totals.transactions), NULL) count_trans,
		COUNT(hits.hitNumber) AS count_hit,
		(MAX(visitStartTime)-MIN(visitStartTime))/60 AS visittime_interval,
		IF(((MAX(visitStartTime)-MIN(visitStartTime))/60) / (COUNT(visitID)-1) < 30, 1, NULL) user_bad_flag,
		SUM(count_ses) OVER (PARTITION BY Platform) AS Total_sessions
	FROM TABLE_DATE_RANGE([bop---onlinepizza:110474939.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 3,4),
  
	(SELECT
		IF(COUNT(visitID) < 4, STRING(COUNT(visitID)), IF(COUNT(visitID) >= 4 , "x > 4", NULL)) AS count_ses_str,
		COUNT(visitID) AS count_ses,
		fullvisitorID,
		"Online Pizza- Sweden - Android" AS Platform,
		IF(COUNT(totals.transactions) > 0, COUNT(totals.transactions), NULL) count_trans,
		COUNT(hits.hitNumber) AS count_hit,
		(MAX(visitStartTime)-MIN(visitStartTime))/60 AS visittime_interval,
		IF(((MAX(visitStartTime)-MIN(visitStartTime))/60) / (COUNT(visitID)-1) < 30, 1, NULL) user_bad_flag,
		SUM(count_ses) OVER (PARTITION BY Platform) AS Total_sessions
	FROM TABLE_DATE_RANGE([bop---onlinepizza:111057681.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 3,4),
  
	(SELECT
		IF(COUNT(visitID) < 4, STRING(COUNT(visitID)), IF(COUNT(visitID) >= 4 , "x > 4", NULL)) AS count_ses_str,
		COUNT(visitID) AS count_ses,
		fullvisitorID,
		"Online Pizza - Sweden - iOS" AS Platform,
		IF(COUNT(totals.transactions) > 0, COUNT(totals.transactions), NULL) count_trans,
		COUNT(hits.hitNumber) AS count_hit,
		(MAX(visitStartTime)-MIN(visitStartTime))/60 AS visittime_interval,
		IF(((MAX(visitStartTime)-MIN(visitStartTime))/60) / (COUNT(visitID)-1) < 30, 1, NULL) user_bad_flag,
		SUM(count_ses) OVER (PARTITION BY Platform) AS Total_sessions
	FROM TABLE_DATE_RANGE([bop---onlinepizza:111053874.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 3,4),



GROUP BY 1,2
ORDER BY 1,2,3