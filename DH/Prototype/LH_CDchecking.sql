# Event CD tracking : checking if CDs are populated properly.

SELECT

	main_table.Platform AS Platform,
	IF(main_table.device_isMobile == true, 1, 0) AS device_ismobile,
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
			"Lieferheld Web" AS Platform,
			device.isMobile AS device_isMobile,
			hits.eventInfo.eventAction AS event_action,
			hits.customDimensions.index AS CD_index,
			COUNT(IF(hits.customDimensions.index IS NULL, 1, 1)) AS CD_count
		FROM TABLE_DATE_RANGE([38642300.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
    GROUP BY 1,2,3,4),

    		(SELECT
			"Lieferheld iOS" AS Platform,
			device.isMobile AS device_isMobile,
			hits.eventInfo.eventAction AS event_action,
			hits.customDimensions.index AS CD_index,
			COUNT(IF(hits.customDimensions.index IS NULL, 1, 1)) AS CD_count
		FROM TABLE_DATE_RANGE([116747487.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
    GROUP BY 1,2,3,4),

    		(SELECT
			"Lieferheld Android" AS Platform,
			device.isMobile AS device_isMobile,
			hits.eventInfo.eventAction AS event_action,
			hits.customDimensions.index AS CD_index,
			COUNT(IF(hits.customDimensions.index IS NULL, 1, 1)) AS CD_count
		FROM TABLE_DATE_RANGE([107101250.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
    GROUP BY 1,2,3,4)

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
			"Lieferheld Web" AS Platform,
			device.isMobile AS device_isMobile,
			hits.eventInfo.eventAction AS event_action,
    			COUNT(hits.eventInfo.eventAction) AS  event_count
		FROM TABLE_DATE_RANGE([38642300.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
    GROUP BY 1,2,3),

    		(SELECT
			"Lieferheld iOS" AS Platform,
			device.isMobile AS device_isMobile,
			hits.eventInfo.eventAction AS event_action,
    			COUNT(hits.eventInfo.eventAction) AS  event_count
		FROM TABLE_DATE_RANGE([116747487.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
    GROUP BY 1,2,3),

    		(SELECT
			"Lieferheld Android" AS Platform,
			device.isMobile AS device_isMobile,
			hits.eventInfo.eventAction AS event_action,
    			COUNT(hits.eventInfo.eventAction) AS  event_count
		FROM TABLE_DATE_RANGE([107101250.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
    GROUP BY 1,2,3)

	WHERE
		event_action == "shop_list.loaded" OR
		event_action == "shop_details.loaded" OR
		event_action == "checkout.loaded" OR
		event_action == "transaction" OR
		event_action == "transaction.clicked" OR
		event_action == "shop.clicked" OR
		event_action == "address.submitted" OR
		event_action == "checkout.clicked") AS join_table

ON main_table.event_action == join_table.event_action AND main_table.Platform == join_table.Platform AND main_table.device_isMobile == join_table.device_isMobile
GROUP BY 1,2,3
ORDER BY 1,2,3
