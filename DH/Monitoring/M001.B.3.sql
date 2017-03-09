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
		CONCAT("Lieferheld ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform,		FIRST(hits.type) AS first_hittype,
		COUNT(hits.hitNumber) AS count_hit,
    		SUM(totals.bounces) AS sum_bounce
	FROM TABLE_DATE_RANGE([blh---lieferheld:38642300.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 1,2,4),

	(SELECT
		visitID,
		fullvisitorID,
		IF(SUM(totals.transactions) > 0, 1, NULL) AS transaction_done,
		"Lieferheld Android" AS Platform,
		FIRST(hits.type) AS first_hittype,
		COUNT(hits.hitNumber) AS count_hit,
    		SUM(totals.bounces) AS sum_bounce
	FROM TABLE_DATE_RANGE([blh---lieferheld:107101250.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 1,2,4),

	(SELECT
	 	visitID,
	 	fullvisitorID,
		IF(SUM(totals.transactions) > 0, 1, NULL) AS transaction_done,
		"Lieferheld iOS" AS Platform,
		FIRST(hits.type) AS first_hittype,
		COUNT(hits.hitNumber) AS count_hit,
    		SUM(totals.bounces) AS sum_bounce
	FROM TABLE_DATE_RANGE([blh---lieferheld:116747487.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 1,2,4),





	(SELECT
		visitID,
		fullvisitorID,
		IF(SUM(totals.transactions) > 0, 1, NULL) AS transaction_done,
		CONCAT("PizzaDE ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform,		FIRST(hits.type) AS first_hittype,
		COUNT(hits.hitNumber) AS count_hit,
    		SUM(totals.bounces) AS sum_bounce
	FROM TABLE_DATE_RANGE([bpi---pizzade:107156186.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 1,2,4),

	(SELECT
		visitID,
		fullvisitorID,
		IF(SUM(totals.transactions) > 0, 1, NULL) AS transaction_done,
		"PizzaDE Android" AS Platform,
		FIRST(hits.type) AS first_hittype,
		COUNT(hits.hitNumber) AS count_hit,
    		SUM(totals.bounces) AS sum_bounce
	FROM TABLE_DATE_RANGE([bpi---pizzade:109893332.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 1,2,4),

	(SELECT
	 	visitID,
	 	fullvisitorID,
		IF(SUM(totals.transactions) > 0, 1, NULL) AS transaction_done,
		"PizzaDE iOS" AS Platform,
		FIRST(hits.type) AS first_hittype,
		COUNT(hits.hitNumber) AS count_hit,
    		SUM(totals.bounces) AS sum_bounce
	FROM TABLE_DATE_RANGE([bpi---pizzade:116747870.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 1,2,4),




	(SELECT
		visitID,
		fullvisitorID,
		IF(SUM(totals.transactions) > 0, 1, NULL) AS transaction_done,
		CONCAT("Talabat ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform,		FIRST(hits.type) AS first_hittype,
		COUNT(hits.hitNumber) AS count_hit,
    		SUM(totals.bounces) AS sum_bounce
	FROM TABLE_DATE_RANGE([bta---talabat:109362366.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 1,2,4),

	(SELECT
		visitID,
		fullvisitorID,
		IF(SUM(totals.transactions) > 0, 1, NULL) AS transaction_done,
		CONCAT("Talabat ", device.operatingSystem) AS Platform,
		FIRST(hits.type) AS first_hittype,
		COUNT(hits.hitNumber) AS count_hit,
    		SUM(totals.bounces) AS sum_bounce
	FROM TABLE_DATE_RANGE([bta---talabat:108646433.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 1,2,4)




GROUP BY 1
ORDER BY 1