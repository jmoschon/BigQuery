# mCVR home> home.list
# Get the landing page and check only the sessions where there are at least home and shop_list.loaded. check how many of them are directly going from home to shop list.


select
*
from


	(SELECT
		fullVisitorId,
		visitId,
		Platform,
		CONCAT(STRING(IF(home > 0,1,0)), STRING(IF(listing > 0,1,0)), STRING(IF(shop_details > 0,1,0)), STRING(IF(add_cart > 0,1,0)), STRING(IF(checkout > 0,1,0)), STRING(IF(transaction > 0,1,0))) AS full_funnel,
		FIRST(IF(hits.type == "PAGE" OR hits.type == "APPVIEW", p_e_info, NULL)) AS landing_page,
		COUNT(IF(hits.hitNumber > first_home_hit AND hits.hitNumber < first_list_hit AND (p_e_info == "checkout.loaded" OR p_e_info == "transaction" OR p_e_info == "shop_list.loaded"),p_e_info,NULL)) out_mcvr,
  		COUNT(IF(p_e_info == "add_cart.clicked",p_e_info,NULL)) AS add_cart_count,
  		COUNT(IF(p_e_info == "shop.clicked",p_e_info,NULL)) AS shop_list_clicked_count,
  		ROUND((first_list_time-first_home_time)/1000/60,3) AS time_spent,
      		total_transaction

	FROM
		(SELECT
			fullVisitorId,
			visitId,
			CONCAT("Lieferheld ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform,
			hits.hitNumber,
			hits.type,
			hits.time,
     		SUM(totals.transactions) AS total_transaction,
			MAX(IF(hits.eventInfo.eventAction = 'checkout.loaded' AND hits.customDimensions.index = 20, hits.customDimensions.value, IF(hits.eventInfo.eventAction = 'shop_details.loaded', hits.eventInfo.eventLabel, NULL))) AS shopID,
			UNIQUE(IF(hits.type == "PAGE" OR hits.type == "APPVIEW",hits.customDimensions.value,hits.eventInfo.eventAction)) p_e_info,
			SUM(if(p_e_info = 'home', 1, 0)) OVER (PARTITION BY Platform, fullvisitorId, visitID) AS home,
    	    SUM(if(p_e_info = 'shop_list.loaded', 1, 0)) OVER (PARTITION BY Platform, fullvisitorId, visitID)  AS listing,
    		SUM(if(p_e_info = 'shop.clicked', 1, 0)) OVER (PARTITION BY Platform, fullvisitorId, visitID)  AS shop_clicked,
    		SUM(if(p_e_info = 'shop_details.loaded', 1, 0)) OVER (PARTITION BY Platform, fullvisitorId, visitID)  AS shop_details,
    		SUM(if(p_e_info = 'add_cart.clicked', 1, 0)) OVER (PARTITION BY Platform, fullvisitorId, visitID)  AS add_cart,
    		SUM(if(p_e_info = 'checkout.loaded', 1, 0)) OVER (PARTITION BY Platform, fullvisitorId, visitID)  AS checkout,
			SUM(if(p_e_info = 'transaction', 1, 0)) OVER (PARTITION BY Platform, fullvisitorId, visitID) AS transaction,
			MIN(IF(p_e_info == "home",hits.time,NULL)) OVER (PARTITION BY Platform, fullvisitorId, visitID) AS first_home_time,
			MIN(IF(p_e_info == "home",hits.hitNumber,NULL)) OVER (PARTITION BY Platform, fullvisitorId, visitID) AS first_home_HIT,
            MIN(IF(p_e_info == "shop_list.loaded",hits.hitNumber,NULL)) OVER (PARTITION BY Platform, fullvisitorId, visitID) AS first_list_hit,
            MIN(IF(p_e_info == "shop_list.loaded",hits.time,NULL)) OVER (PARTITION BY Platform, fullvisitorId, visitID) AS first_list_time,
--    		MIN(IF(p_e_info == "shop_details.loaded",hits.hitNumber,NULL)) OVER (PARTITION BY Platform, fullvisitorId, visitID) AS first_details_hit,
--    		MIN(IF(p_e_info == "checkout.loaded",hits.hitNumber,NULL)) OVER (PARTITION BY Platform, fullvisitorId, visitID) AS first_checkout_hit,
--    		MIN(IF(p_e_info == "shop_details.loaded",hits.time,NULL)) OVER (PARTITION BY Platform, fullvisitorId, visitID) AS first_details_time,
--    		MIN(IF(p_e_info == "shop.clicked",hits.hitNumber,NULL)) OVER (PARTITION BY Platform, fullvisitorId, visitID) AS first_shopClicked_hit,
--    		MIN(IF(p_e_info == "checkout.loaded",hits.time,NULL)) OVER (PARTITION BY Platform, fullvisitorId, visitID) AS first_checkout_time,
--            MIN(IF(p_e_info == "shop.clicked",hits.time,NULL)) OVER (PARTITION BY Platform, fullvisitorId, visitID) AS first_shopClicked_time
		FROM TABLE_DATE_RANGE([blh---lieferheld:38642300.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-2,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-2,"DAY")))
		WHERE
			(hits.eventInfo.eventAction = 'shop_list.loaded' OR
			hits.eventInfo.eventAction = 'shop_details.loaded' OR
			hits.eventInfo.eventAction = 'add_cart.clicked' OR
			hits.eventInfo.eventAction = 'checkout.loaded' OR
			hits.eventInfo.eventAction = 'transaction' OR
			hits.eventInfo.eventAction = 'shop.clicked' OR
			((hits.type == "PAGE" OR hits.type == "APPVIEW") AND hits.customDimensions.index = 11))
   		GROUP BY 1,2,3,4,5,6
		ORDER BY 1,2,4)
,
		(SELECT
			fullVisitorId,
			visitId,
			"Lieferheld Android" AS Platform,
			hits.hitNumber,
			hits.type,
			hits.time,
     		SUM(totals.transactions) AS total_transaction,
			MAX(IF(hits.eventInfo.eventAction = 'checkout.loaded' AND hits.customDimensions.index = 20, hits.customDimensions.value, IF(hits.eventInfo.eventAction = 'shop_details.loaded', hits.eventInfo.eventLabel, NULL))) AS shopID,
			UNIQUE(IF(hits.type == "PAGE" OR hits.type == "APPVIEW",hits.customDimensions.value,hits.eventInfo.eventAction)) p_e_info,
			SUM(if(p_e_info = 'home', 1, 0)) OVER (PARTITION BY Platform, fullvisitorId, visitID) AS home,
    	    SUM(if(p_e_info = 'shop_list.loaded', 1, 0)) OVER (PARTITION BY Platform, fullvisitorId, visitID)  AS listing,
    		SUM(if(p_e_info = 'shop.clicked', 1, 0)) OVER (PARTITION BY Platform, fullvisitorId, visitID)  AS shop_clicked,
    		SUM(if(p_e_info = 'shop_details.loaded', 1, 0)) OVER (PARTITION BY Platform, fullvisitorId, visitID)  AS shop_details,
    		SUM(if(p_e_info = 'add_cart.clicked', 1, 0)) OVER (PARTITION BY Platform, fullvisitorId, visitID)  AS add_cart,
    		SUM(if(p_e_info = 'checkout.loaded', 1, 0)) OVER (PARTITION BY Platform, fullvisitorId, visitID)  AS checkout,
			SUM(if(p_e_info = 'transaction', 1, 0)) OVER (PARTITION BY Platform, fullvisitorId, visitID) AS transaction,
			MIN(IF(p_e_info == "home",hits.time,NULL)) OVER (PARTITION BY Platform, fullvisitorId, visitID) AS first_home_time,
			MIN(IF(p_e_info == "home",hits.hitNumber,NULL)) OVER (PARTITION BY Platform, fullvisitorId, visitID) AS first_home_HIT,
            MIN(IF(p_e_info == "shop_list.loaded",hits.hitNumber,NULL)) OVER (PARTITION BY Platform, fullvisitorId, visitID) AS first_list_hit,
            MIN(IF(p_e_info == "shop_list.loaded",hits.time,NULL)) OVER (PARTITION BY Platform, fullvisitorId, visitID) AS first_list_time,
--    		MIN(IF(p_e_info == "shop_details.loaded",hits.hitNumber,NULL)) OVER (PARTITION BY Platform, fullvisitorId, visitID) AS first_details_hit,
--    		MIN(IF(p_e_info == "checkout.loaded",hits.hitNumber,NULL)) OVER (PARTITION BY Platform, fullvisitorId, visitID) AS first_checkout_hit,
--    		MIN(IF(p_e_info == "shop_details.loaded",hits.time,NULL)) OVER (PARTITION BY Platform, fullvisitorId, visitID) AS first_details_time,
--    		MIN(IF(p_e_info == "shop.clicked",hits.hitNumber,NULL)) OVER (PARTITION BY Platform, fullvisitorId, visitID) AS first_shopClicked_hit,
--    		MIN(IF(p_e_info == "checkout.loaded",hits.time,NULL)) OVER (PARTITION BY Platform, fullvisitorId, visitID) AS first_checkout_time,
--            MIN(IF(p_e_info == "shop.clicked",hits.time,NULL)) OVER (PARTITION BY Platform, fullvisitorId, visitID) AS first_shopClicked_time
		FROM TABLE_DATE_RANGE([blh---lieferheld:107101250.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-2,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-2,"DAY")))
		WHERE
			(hits.eventInfo.eventAction = 'shop_list.loaded' OR
			hits.eventInfo.eventAction = 'shop_details.loaded' OR
			hits.eventInfo.eventAction = 'add_cart.clicked' OR
			hits.eventInfo.eventAction = 'checkout.loaded' OR
			hits.eventInfo.eventAction = 'transaction' OR
			hits.eventInfo.eventAction = 'shop.clicked' OR
			((hits.type == "PAGE" OR hits.type == "APPVIEW") AND hits.customDimensions.index = 11))
   		GROUP BY 1,2,3,4,5,6
		ORDER BY 1,2,4)
,
		(SELECT
			fullVisitorId,
			visitId,
			"Lieferheld iOS" AS Platform,
			hits.hitNumber,
			hits.type,
			hits.time,
     		SUM(totals.transactions) AS total_transaction,
			MAX(IF(hits.eventInfo.eventAction = 'checkout.loaded' AND hits.customDimensions.index = 20, hits.customDimensions.value, IF(hits.eventInfo.eventAction = 'shop_details.loaded', hits.eventInfo.eventLabel, NULL))) AS shopID,
			UNIQUE(IF(hits.type == "PAGE" OR hits.type == "APPVIEW",hits.customDimensions.value,hits.eventInfo.eventAction)) p_e_info,
			SUM(if(p_e_info = 'home', 1, 0)) OVER (PARTITION BY Platform, fullvisitorId, visitID) AS home,
    	    SUM(if(p_e_info = 'shop_list.loaded', 1, 0)) OVER (PARTITION BY Platform, fullvisitorId, visitID)  AS listing,
    		SUM(if(p_e_info = 'shop.clicked', 1, 0)) OVER (PARTITION BY Platform, fullvisitorId, visitID)  AS shop_clicked,
    		SUM(if(p_e_info = 'shop_details.loaded', 1, 0)) OVER (PARTITION BY Platform, fullvisitorId, visitID)  AS shop_details,
    		SUM(if(p_e_info = 'add_cart.clicked', 1, 0)) OVER (PARTITION BY Platform, fullvisitorId, visitID)  AS add_cart,
    		SUM(if(p_e_info = 'checkout.loaded', 1, 0)) OVER (PARTITION BY Platform, fullvisitorId, visitID)  AS checkout,
			SUM(if(p_e_info = 'transaction', 1, 0)) OVER (PARTITION BY Platform, fullvisitorId, visitID) AS transaction,
			MIN(IF(p_e_info == "home",hits.time,NULL)) OVER (PARTITION BY Platform, fullvisitorId, visitID) AS first_home_time,
			MIN(IF(p_e_info == "home",hits.hitNumber,NULL)) OVER (PARTITION BY Platform, fullvisitorId, visitID) AS first_home_HIT,
            MIN(IF(p_e_info == "shop_list.loaded",hits.hitNumber,NULL)) OVER (PARTITION BY Platform, fullvisitorId, visitID) AS first_list_hit,
            MIN(IF(p_e_info == "shop_list.loaded",hits.time,NULL)) OVER (PARTITION BY Platform, fullvisitorId, visitID) AS first_list_time,
--    		MIN(IF(p_e_info == "shop_details.loaded",hits.hitNumber,NULL)) OVER (PARTITION BY Platform, fullvisitorId, visitID) AS first_details_hit,
--    		MIN(IF(p_e_info == "checkout.loaded",hits.hitNumber,NULL)) OVER (PARTITION BY Platform, fullvisitorId, visitID) AS first_checkout_hit,
--    		MIN(IF(p_e_info == "shop_details.loaded",hits.time,NULL)) OVER (PARTITION BY Platform, fullvisitorId, visitID) AS first_details_time,
--    		MIN(IF(p_e_info == "shop.clicked",hits.hitNumber,NULL)) OVER (PARTITION BY Platform, fullvisitorId, visitID) AS first_shopClicked_hit,
--    		MIN(IF(p_e_info == "checkout.loaded",hits.time,NULL)) OVER (PARTITION BY Platform, fullvisitorId, visitID) AS first_checkout_time,
--            MIN(IF(p_e_info == "shop.clicked",hits.time,NULL)) OVER (PARTITION BY Platform, fullvisitorId, visitID) AS first_shopClicked_time
		FROM TABLE_DATE_RANGE([blh---lieferheld:116747487.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-2,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-2,"DAY")))
		WHERE
			(hits.eventInfo.eventAction = 'shop_list.loaded' OR
			hits.eventInfo.eventAction = 'shop_details.loaded' OR
			hits.eventInfo.eventAction = 'add_cart.clicked' OR
			hits.eventInfo.eventAction = 'checkout.loaded' OR
			hits.eventInfo.eventAction = 'transaction' OR
			hits.eventInfo.eventAction = 'shop.clicked' OR
			((hits.type == "PAGE" OR hits.type == "APPVIEW") AND hits.customDimensions.index = 11))
   		GROUP BY 1,2,3,4,5,6
		ORDER BY 1,2,4)

	GROUP BY 1,2,3,4,9,10)


where landing_page = 'home' --and shop_clicked_count>0