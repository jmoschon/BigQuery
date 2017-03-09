# Event Quality - shop_list.loaded : checking if all variables are tracked properly.

SELECT

	main_table.Platform AS Platform,
	CD_index AS CD_index,
	ROUND(MAX(IF(main_table.event_action == "address.submitted",CD_count/event_count*100,NULL)),3) AS address_submitted,
	ROUND(MAX(IF(main_table.event_action == "shop_list.loaded",CD_count/event_count*100,NULL)),3) AS shop_list_loaded,
	ROUND(MAX(IF(main_table.event_action == "shop.clicked",CD_count/event_count*100,NULL)),3) AS shop_clicked,
	ROUND(MAX(IF(main_table.event_action == "shop_details.loaded",CD_count/event_count*100,NULL)),3) AS shop_details_loaded,
	ROUND(MAX(IF(main_table.event_action == "checkout.clicked",CD_count/event_count*100,NULL)),3) AS checkout_clicked,
	ROUND(MAX(IF(main_table.event_action == "checkout.loaded",CD_count/event_count*100,NULL)),3) AS checkout_loaded,
	ROUND(MAX(IF(main_table.event_action == "transaction.clicked",CD_count/event_count*100,NULL)),3) AS transaction_clicked,
	ROUND(MAX(IF(main_table.event_action == "transaction",CD_count/event_count*100,NULL)),3) AS transaction
  
FROM
	(SELECT
		*
	FROM
		(SELECT
			CONCAT("Delivery Hero - Sweden -  ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform,
			hits.eventInfo.eventAction AS event_action,
			hits.customDimensions.index AS CD_index,
			COUNT(IF(hits.customDimensions.index IS NULL, 1, 1)) AS CD_count
		FROM TABLE_DATE_RANGE([bdh---deliveryhero-se:123559331.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
    GROUP BY 1,2,3),
    
    		(SELECT
			"Delivery Hero - Sweden - Android" AS Platform,
			hits.eventInfo.eventAction AS event_action,
			hits.customDimensions.index AS CD_index,
			COUNT(IF(hits.customDimensions.index IS NULL, 1, 1)) AS CD_count
		FROM TABLE_DATE_RANGE([bdh---deliveryhero-se:123571417.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
    GROUP BY 1,2,3),

    		(SELECT
			"Delivery Hero - Sweden - iOS" AS Platform,
			hits.eventInfo.eventAction AS event_action,
			hits.customDimensions.index AS CD_index,
			COUNT(IF(hits.customDimensions.index IS NULL, 1, 1)) AS CD_count
		FROM TABLE_DATE_RANGE([bdh---deliveryhero-se:123548742.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
    GROUP BY 1,2,3),



		(SELECT
			CONCAT("Online Pizza - Sweden - ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform,
			hits.eventInfo.eventAction AS event_action,
			hits.customDimensions.index AS CD_index,
			COUNT(IF(hits.customDimensions.index IS NULL, 1, 1)) AS CD_count
		FROM TABLE_DATE_RANGE([bop---onlinepizza:110474939.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
    GROUP BY 1,2,3),
    
    		(SELECT
			"Online Pizza- Sweden - Android" AS Platform,
			hits.eventInfo.eventAction AS event_action,
			hits.customDimensions.index AS CD_index,
			COUNT(IF(hits.customDimensions.index IS NULL, 1, 1)) AS CD_count
		FROM TABLE_DATE_RANGE([bop---onlinepizza:111057681.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
    GROUP BY 1,2,3),
    
    		(SELECT
			"Online Pizza - Sweden - iOS" AS Platform,
			hits.eventInfo.eventAction AS event_action,
			hits.customDimensions.index AS CD_index,
			COUNT(IF(hits.customDimensions.index IS NULL, 1, 1)) AS CD_count
		FROM TABLE_DATE_RANGE([bop---onlinepizza:111053874.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
    GROUP BY 1,2,3),

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
			CONCAT("Delivery Hero - Sweden -  ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform,
			hits.eventInfo.eventAction AS event_action,
    			COUNT(hits.eventInfo.eventAction) AS  event_count
		FROM TABLE_DATE_RANGE([bdh---deliveryhero-se:123559331.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
    GROUP BY 1,2),
    
    		(SELECT
			"Delivery Hero - Sweden - Android" AS Platform,
			hits.eventInfo.eventAction AS event_action,
    			COUNT(hits.eventInfo.eventAction) AS  event_count
		FROM TABLE_DATE_RANGE([bdh---deliveryhero-se:123571417.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
    GROUP BY 1,2),
    
    		(SELECT
			"Delivery Hero - Sweden - iOS" AS Platform,
			hits.eventInfo.eventAction AS event_action,
    			COUNT(hits.eventInfo.eventAction) AS  event_count
		FROM TABLE_DATE_RANGE([bdh---deliveryhero-se:123548742.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
    GROUP BY 1,2),




		(SELECT
			CONCAT("Online Pizza - Sweden - ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform,
			hits.eventInfo.eventAction AS event_action,
    			COUNT(hits.eventInfo.eventAction) AS  event_count
		FROM TABLE_DATE_RANGE([bop---onlinepizza:110474939.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
    GROUP BY 1,2),
    
    		(SELECT
			"Online Pizza- Sweden - Android" AS Platform,
			hits.eventInfo.eventAction AS event_action,
    			COUNT(hits.eventInfo.eventAction) AS  event_count
		FROM TABLE_DATE_RANGE([bop---onlinepizza:111057681.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
    GROUP BY 1,2),
    
    		(SELECT
			"Online Pizza - Sweden - iOS" AS Platform,
			hits.eventInfo.eventAction AS event_action,
    			COUNT(hits.eventInfo.eventAction) AS  event_count
		FROM TABLE_DATE_RANGE([bop---onlinepizza:111053874.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
    GROUP BY 1,2),




	WHERE
		event_action == "shop_list.loaded" OR
		event_action == "shop_details.loaded" OR
		event_action == "checkout.loaded" OR
		event_action == "transaction" OR
		event_action == "transaction.clicked" OR
		event_action == "shop.clicked" OR
		event_action == "address.submitted" OR
		event_action == "checkout.clicked") AS join_table

ON main_table.event_action == join_table.event_action AND main_table.Platform == join_table.Platform
GROUP BY 1,2
ORDER BY 1,2