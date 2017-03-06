# Returns only the CDs that have problematic tracking (30 < x < 70)


SELECT
*
FROM



(SELECT

	main_table.Platform AS Platform,
	main_table.event_action,
	CD_index AS CD_index,
	ROUND(CD_count/event_count*100,3) AS track_alert
  
FROM
	(SELECT
		*
	FROM
		(SELECT
			CONCAT("Lieferheld ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform,
			hits.eventInfo.eventAction AS event_action,
			hits.customDimensions.index AS CD_index,
			COUNT(IF(hits.customDimensions.index IS NULL, 1, 1)) AS CD_count
		FROM TABLE_DATE_RANGE([blh---lieferheld:38642300.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
    GROUP BY 1,2,3),
    
    		(SELECT
			"Lieferheld iOS" AS Platform,
			hits.eventInfo.eventAction AS event_action,
			hits.customDimensions.index AS CD_index,
			COUNT(IF(hits.customDimensions.index IS NULL, 1, 1)) AS CD_count
		FROM TABLE_DATE_RANGE([blh---lieferheld:116747487.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
    GROUP BY 1,2,3),
    
    		(SELECT
			"Lieferheld Android" AS Platform,
			hits.eventInfo.eventAction AS event_action,
			hits.customDimensions.index AS CD_index,
			COUNT(IF(hits.customDimensions.index IS NULL, 1, 1)) AS CD_count
		FROM TABLE_DATE_RANGE([blh---lieferheld:107101250.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
    GROUP BY 1,2,3),



		(SELECT
			CONCAT("PizzaDE ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform,
			hits.eventInfo.eventAction AS event_action,
			hits.customDimensions.index AS CD_index,
			COUNT(IF(hits.customDimensions.index IS NULL, 1, 1)) AS CD_count
		FROM TABLE_DATE_RANGE([bpi---pizzade:107156186.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
    GROUP BY 1,2,3),
    
    		(SELECT
			"PizzaDE iOS" AS Platform,
			hits.eventInfo.eventAction AS event_action,
			hits.customDimensions.index AS CD_index,
			COUNT(IF(hits.customDimensions.index IS NULL, 1, 1)) AS CD_count
		FROM TABLE_DATE_RANGE([bpi---pizzade:116747870.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
    GROUP BY 1,2,3),
    
    		(SELECT
			"PizzaDE Android" AS Platform,
			hits.eventInfo.eventAction AS event_action,
			hits.customDimensions.index AS CD_index,
			COUNT(IF(hits.customDimensions.index IS NULL, 1, 1)) AS CD_count
		FROM TABLE_DATE_RANGE([bpi---pizzade:109893332.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
    GROUP BY 1,2,3),



		(SELECT
			CONCAT("Talabat ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform,
			hits.eventInfo.eventAction AS event_action,
			hits.customDimensions.index AS CD_index,
			COUNT(IF(hits.customDimensions.index IS NULL, 1, 1)) AS CD_count
		FROM TABLE_DATE_RANGE([bta---talabat:109362366.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
    GROUP BY 1,2,3),
    
    		(SELECT
			CONCAT("Talabat ", device.operatingSystem) AS Platform,
			hits.eventInfo.eventAction AS event_action,
			hits.customDimensions.index AS CD_index,
			COUNT(IF(hits.customDimensions.index IS NULL, 1, 1)) AS CD_count
		FROM TABLE_DATE_RANGE([bta---talabat:108646433.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
    GROUP BY 1,2,3)




 

	WHERE
		event_action == "shop_list.loaded" OR
		event_action == "shop_details.loaded" OR
		event_action == "checkout.loaded" OR
		event_action == "transaction" OR
		event_action == "transaction.clicked" OR
		event_action == "shop.clicked" OR
		event_action == "address.submitted" OR
		event_action == "checkout.clicked") AS main_table

INNER JOIN
	(SELECT
		*
	FROM
		(SELECT
			CONCAT("Lieferheld ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform,
			hits.eventInfo.eventAction AS event_action,
    			COUNT(hits.eventInfo.eventAction) AS  event_count
		FROM TABLE_DATE_RANGE([blh---lieferheld:38642300.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
    GROUP BY 1,2),
    
    		(SELECT
			"Lieferheld iOS" AS Platform,
			hits.eventInfo.eventAction AS event_action,
    			COUNT(hits.eventInfo.eventAction) AS  event_count
		FROM TABLE_DATE_RANGE([blh---lieferheld:116747487.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
    GROUP BY 1,2),
    
    		(SELECT
			"Lieferheld Android" AS Platform,
			hits.eventInfo.eventAction AS event_action,
    			COUNT(hits.eventInfo.eventAction) AS  event_count
		FROM TABLE_DATE_RANGE([blh---lieferheld:107101250.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
    GROUP BY 1,2),




		(SELECT
			CONCAT("PizzaDE ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform,
			hits.eventInfo.eventAction AS event_action,
    			COUNT(hits.eventInfo.eventAction) AS  event_count
		FROM TABLE_DATE_RANGE([bpi---pizzade:107156186.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
    GROUP BY 1,2),
    
    		(SELECT
			"PizzaDE iOS" AS Platform,
			hits.eventInfo.eventAction AS event_action,
    			COUNT(hits.eventInfo.eventAction) AS  event_count
		FROM TABLE_DATE_RANGE([bpi---pizzade:116747870.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
    GROUP BY 1,2),
    
    		(SELECT
			"PizzaDE Android" AS Platform,
			hits.eventInfo.eventAction AS event_action,
    			COUNT(hits.eventInfo.eventAction) AS  event_count
		FROM TABLE_DATE_RANGE([bpi---pizzade:109893332.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
    GROUP BY 1,2),



		(SELECT
			CONCAT("Talabat ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform,
			hits.eventInfo.eventAction AS event_action,
    			COUNT(hits.eventInfo.eventAction) AS  event_count
		FROM TABLE_DATE_RANGE([bta---talabat:109362366.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
    GROUP BY 1,2),
    
    		(SELECT
			CONCAT("Talabat ", device.operatingSystem) AS Platform,
			hits.eventInfo.eventAction AS event_action,
    			COUNT(hits.eventInfo.eventAction) AS  event_count
		FROM TABLE_DATE_RANGE([bta---talabat:108646433.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
    GROUP BY 1,2)




	WHERE
		event_action == "shop_list.loaded" OR
		event_action == "shop_details.loaded" OR
		event_action == "checkout.loaded" OR
		event_action == "transaction" OR
		event_action == "transaction.clicked" OR
		event_action == "shop.clicked" OR
		event_action == "address.submitted" OR
		event_action == "checkout.clicked") AS join_table

ON main_table.event_action == join_table.event_action AND main_table.Platform == join_table.Platform)


WHERE track_alert > 30 AND track_alert < 70
ORDER BY 1,2,3