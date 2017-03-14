# Event Quality - shop_list.loaded : checking if all variables are tracked properly.

SELECT

	main_table.Platform AS Platform,
	CD_index AS CD_index,
	ROUND(MAX(IF(main_table.event_action == "address.submitted",CD_count_index/event_count*100,NULL)),3) AS address_submitted_index,
	ROUND(MAX(IF(main_table.event_action == "address.submitted",CD_count_value/event_count*100,NULL)),3) AS address_submitted_value,
	ROUND(MAX(IF(main_table.event_action == "shop_list.loaded",CD_count_index/event_count*100,NULL)),3) AS shop_list_loaded_index,
    ROUND(MAX(IF(main_table.event_action == "shop_list.loaded",CD_count_value/event_count*100,NULL)),3) AS shop_list_loaded_value,
	ROUND(MAX(IF(main_table.event_action == "shop.clicked",CD_count_index/event_count*100,NULL)),3) AS shop_clicked_index,
	ROUND(MAX(IF(main_table.event_action == "shop.clicked",CD_count_value/event_count*100,NULL)),3) AS shop_clicked_value,
	ROUND(MAX(IF(main_table.event_action == "shop_details.loaded",CD_count_index/event_count*100,NULL)),3) AS shop_details_loaded_index,
	ROUND(MAX(IF(main_table.event_action == "shop_details.loaded",CD_count_value/event_count*100,NULL)),3) AS shop_details_loaded_value,
	ROUND(MAX(IF(main_table.event_action == "checkout.clicked",CD_count_index/event_count*100,NULL)),3) AS checkout_clicked_index,
	ROUND(MAX(IF(main_table.event_action == "checkout.clicked",CD_count_value/event_count*100,NULL)),3) AS checkout_clicked_value,
	ROUND(MAX(IF(main_table.event_action == "checkout.loaded",CD_count_index/event_count*100,NULL)),3) AS checkout_loaded_index,
	ROUND(MAX(IF(main_table.event_action == "checkout.loaded",CD_count_value/event_count*100,NULL)),3) AS checkout_loaded_value,

	ROUND(MAX(IF(main_table.event_action == "transaction.clicked",CD_count_index/event_count*100,NULL)),3) AS transaction_clicked_index,
	ROUND(MAX(IF(main_table.event_action == "transaction.clicked",CD_count_value/event_count*100,NULL)),3) AS transaction_clicked_value,
	ROUND(MAX(IF(main_table.event_action == "transaction",CD_count_index/event_count*100,NULL)),3) AS transaction_index,
	ROUND(MAX(IF(main_table.event_action == "transaction",CD_count_value/event_count*100,NULL)),3) AS transaction_value
  
FROM
	(SELECT
		*
	FROM
		(SELECT
			CONCAT("Lieferheld ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform,
			hits.eventInfo.eventAction AS event_action,
			hits.customDimensions.index AS CD_index,
			COUNT(*) AS CD_count_index,
			COUNT(if((hits.customDimensions.value is not null) and length(hits.customDimensions.value)>0,1,null)) as CD_count_value

		FROM TABLE_DATE_RANGE([blh---lieferheld:38642300.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
    GROUP BY 1,2,3),
    
    		(SELECT
			"Lieferheld iOS" AS Platform,
			hits.eventInfo.eventAction AS event_action,
			hits.customDimensions.index AS CD_index,
			COUNT(*) AS CD_count_index,
			COUNT(if((hits.customDimensions.value is not null) and length(hits.customDimensions.value)>0,1,null)) as CD_count_value
		FROM TABLE_DATE_RANGE([blh---lieferheld:116747487.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
    GROUP BY 1,2,3),
    
    		(SELECT
			"Lieferheld Android" AS Platform,
			hits.eventInfo.eventAction AS event_action,
			hits.customDimensions.index AS CD_index,
			COUNT(*) AS CD_count_index,
			COUNT(if((hits.customDimensions.value is not null) and length(hits.customDimensions.value)>0,1,null)) as CD_count_value
		FROM TABLE_DATE_RANGE([blh---lieferheld:107101250.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
    GROUP BY 1,2,3),



		(SELECT
			CONCAT("PizzaDE ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform,
			hits.eventInfo.eventAction AS event_action,
			hits.customDimensions.index AS CD_index,
			COUNT(*) AS CD_count_index,
			COUNT(if((hits.customDimensions.value is not null) and length(hits.customDimensions.value)>0,1,null)) as CD_count_value
		FROM TABLE_DATE_RANGE([bpi---pizzade:107156186.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
    GROUP BY 1,2,3),
    
    		(SELECT
			"PizzaDE iOS" AS Platform,
			hits.eventInfo.eventAction AS event_action,
			hits.customDimensions.index AS CD_index,
			COUNT(*) AS CD_count_index,
			COUNT(if((hits.customDimensions.value is not null) and length(hits.customDimensions.value)>0,1,null)) as CD_count_value
		FROM TABLE_DATE_RANGE([bpi---pizzade:116747870.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
    GROUP BY 1,2,3),
    
    		(SELECT
			"PizzaDE Android" AS Platform,
			hits.eventInfo.eventAction AS event_action,
			hits.customDimensions.index AS CD_index,
			COUNT(*) AS CD_count_index,
			COUNT(if((hits.customDimensions.value is not null) and length(hits.customDimensions.value)>0,1,null)) as CD_count_value
		FROM TABLE_DATE_RANGE([bpi---pizzade:109893332.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
    GROUP BY 1,2,3),



		(SELECT
			CONCAT("Talabat ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform,
			hits.eventInfo.eventAction AS event_action,
			hits.customDimensions.index AS CD_index,
			COUNT(*) AS CD_count_index,
			COUNT(if((hits.customDimensions.value is not null) and length(hits.customDimensions.value)>0,1,null)) as CD_count_value
		FROM TABLE_DATE_RANGE([bta---talabat:109362366.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-1,"DAY")))
    GROUP BY 1,2,3),
    
    		(SELECT
			CONCAT("Talabat ", device.operatingSystem) AS Platform,
			hits.eventInfo.eventAction AS event_action,
			hits.customDimensions.index AS CD_index,
			COUNT(*) AS CD_count_index,
			COUNT(if((hits.customDimensions.value is not null) and length(hits.customDimensions.value)>0,1,null)) as CD_count_value
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

ON main_table.event_action == join_table.event_action AND main_table.Platform == join_table.Platform
GROUP BY 1,2
ORDER BY 1,2