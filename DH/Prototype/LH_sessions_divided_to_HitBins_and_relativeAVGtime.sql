# Sessions divided to hit bins and relative AVG time.

SELECT
	Platform,
  	ROUND(SUM(sum_bounce)/COUNT(max_hit)*100,3) AS Total_Bounces,
  	ROUND(COUNT(IF(max_hit == 1 AND first_type == "EVENT",1,NULL))/COUNT(max_hit)*100,3) AS Sessions_1_hit_event,
  	ROUND(COUNT(IF(max_hit == 1 AND (first_type == "PAGE" OR first_type == "APPVIEW"),1,NULL))/COUNT(max_hit)*100,3) AS Sessions_1_hit_page,
	ROUND(COUNT(IF(max_hit >1 AND max_hit <= 50,1,NULL))/COUNT(max_hit)*100,3) AS Sessions_1_50_hit,
	ROUND(AVG(IF(max_hit >1 AND max_hit <= 50,max_time,NULL)),3) AS AVG_time_1_50,
	ROUND(COUNT(IF(max_hit >50 AND max_hit <= 100,1,NULL))/COUNT(max_hit)*100,3) AS Sessions_50_100,
	ROUND(AVG(IF(max_hit >50 AND max_hit <= 100,max_time,NULL)),3) AS AVG_time_50_100,
	ROUND(COUNT(IF(max_hit >100 AND max_hit <= 200,1,NULL))/COUNT(max_hit)*100,3) AS Sessions_100_200,
	ROUND(AVG(IF(max_hit >100 AND max_hit <= 200,max_time,NULL)),3) AS AVG_time_100_200,
	ROUND(COUNT(IF(max_hit >200 AND max_hit <= 500,1,NULL))/COUNT(max_hit)*100,3) AS Sessions_200_500,
	ROUND(AVG(IF(max_hit >200 AND max_hit <= 499,max_time,NULL)),3) AS Avg_time_200_500,
	ROUND(COUNT(IF(max_hit  == 500,1,NULL))/COUNT(max_hit)*100,3) AS sessions_larger_500_hit,
	ROUND(AVG(IF(max_hit == 500,max_time,NULL)),3) AS AVG_time_500
FROM
	(SELECT
		visitID,
		fullvisitorID,
		CONCAT("Lieferheld ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform,
		COUNT(hits.hitNumber) AS max_hit,
		MAX(hits.time)/1000/60 AS max_time,
		FIRST(hits.type) AS first_type,
		SUM(totals.bounces) AS sum_bounce
  	FROM TABLE_DATE_RANGE([blh---lieferheld:38642300.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 1,2,3),

	(SELECT
		visitID,
		fullvisitorID,
		"Lieferheld Android" AS Platform,
		COUNT(hits.hitNumber) AS max_hit,
		MAX(hits.time)/1000/60 AS max_time,
		FIRST(hits.type) AS first_type,
		SUM(totals.bounces) AS sum_bounce
  	FROM TABLE_DATE_RANGE([blh---lieferheld:107101250.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 1,2,3),

	(SELECT
		visitID,
		fullvisitorID,
		"Lieferheld iOS" AS Platform,
		COUNT(hits.hitNumber) AS max_hit,
		MAX(hits.time)/1000/60 AS max_time,
		FIRST(hits.type) AS first_type,
		SUM(totals.bounces) AS sum_bounce
  	FROM TABLE_DATE_RANGE([blh---lieferheld:116747487.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-7,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
	GROUP BY 1,2,3),

GROUP BY 1
ORDER BY 1
