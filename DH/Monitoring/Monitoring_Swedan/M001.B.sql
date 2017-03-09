# Sessions with 1 hits, and how they affect CVR.

SELECT
	Platform,
	COUNT(IF(count_hit == 1 AND first_hittype == "EVENT", 1, NULL)) AS Count_1_hit_e,
	COUNT(IF(count_hit == 1 AND (first_hittype == "PAGE" OR first_hittype == "APPVIEW"), 1, NULL)) AS Count_1_hit_p,
  	SUM(sum_bounce) AS Sum_bounces,
	COUNT(IF(count_hit > 1, 1, NULL)) AS Count_multi_hit,
	ROUND(COUNT(IF(count_hit == 1 AND first_hittype == "EVENT", 1, NULL))/COUNT(count_hit)*100,3) AS Perc_1_hit_e,
	ROUND(COUNT(IF(count_hit == 1 AND (first_hittype == "PAGE" OR first_hittype == "APPVIEW"), 1, NULL))/COUNT(count_hit)*100,3) AS Perc_1_hit_p,
	ROUND(COUNT(transaction_done)/COUNT(count_hit)*100,3) AS CVR_all,
	ROUND(COUNT(transaction_done)/COUNT(IF(count_hit > 1 OR (count_hit == 1 AND (first_hittype == "PAGE" OR first_hittype == "APPVIEW")), 1, NULL))*100,3) AS CVR_exc_1_hit_e,
	ROUND(COUNT(transaction_done)/COUNT(IF(count_hit > 1 OR (count_hit == 1 AND first_hittype == "EVENT"), 1, NULL))*100,3) AS CVR_exc_1_hit_p

FROM
	(SELECT
		visitID,
		fullvisitorID,
		IF(SUM(totals.transactions) > 0, 1, NULL) AS transaction_done,
		CONCAT("Delivery Hero - Sweden -  ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform,
		FIRST(hits.type) AS first_hittype,
		COUNT(hits.hitNumber) AS count_hit,
    		SUM(totals.bounces) AS sum_bounce
	FROM TABLE_DATE_RANGE([bdh---deliveryhero-se:123559331.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 1,2,4),

	(SELECT
		visitID,
		fullvisitorID,
		IF(SUM(totals.transactions) > 0, 1, NULL) AS transaction_done,
		"Delivery Hero - Sweden - Android" AS Platform,
		FIRST(hits.type) AS first_hittype,
		COUNT(hits.hitNumber) AS count_hit,
    		SUM(totals.bounces) AS sum_bounce
	FROM TABLE_DATE_RANGE([bdh---deliveryhero-se:123571417.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 1,2,4),

	(SELECT
	 	visitID,
	 	fullvisitorID,
		IF(SUM(totals.transactions) > 0, 1, NULL) AS transaction_done,
		"Delivery Hero - Sweden - iOS" AS Platform,
		FIRST(hits.type) AS first_hittype,
		COUNT(hits.hitNumber) AS count_hit,
    		SUM(totals.bounces) AS sum_bounce
	FROM TABLE_DATE_RANGE([bdh---deliveryhero-se:123548742.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 1,2,4),
	(SELECT
		visitID,
		fullvisitorID,
		IF(SUM(totals.transactions) > 0, 1, NULL) AS transaction_done,
		CONCAT("Online Pizza - Sweden - ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform,
		FIRST(hits.type) AS first_hittype,
		COUNT(hits.hitNumber) AS count_hit,
    		SUM(totals.bounces) AS sum_bounce
	FROM TABLE_DATE_RANGE([bop---onlinepizza:110474939.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 1,2,4),

	(SELECT
		visitID,
		fullvisitorID,
		IF(SUM(totals.transactions) > 0, 1, NULL) AS transaction_done,
		"Online Pizza- Sweden - Android" AS Platform,
		FIRST(hits.type) AS first_hittype,
		COUNT(hits.hitNumber) AS count_hit,
    		SUM(totals.bounces) AS sum_bounce
	FROM TABLE_DATE_RANGE([bop---onlinepizza:111057681.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 1,2,4),

	(SELECT
	 	visitID,
	 	fullvisitorID,
		IF(SUM(totals.transactions) > 0, 1, NULL) AS transaction_done,
		"Online Pizza - Sweden - iOS" AS Platform,
		FIRST(hits.type) AS first_hittype,
		COUNT(hits.hitNumber) AS count_hit,
    		SUM(totals.bounces) AS sum_bounce
	FROM TABLE_DATE_RANGE([bop---onlinepizza:111053874.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 1,2,4),
GROUP BY 1
ORDER BY 1