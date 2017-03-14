--# convert micro funnel events into string sequence and count the events inside the sequence string


--####################################################
--#⊂(・(ェ)・)⊃  D E F I N I T I O N S   ⊂(・(ェ)・)⊃ #
--#__________________________________________________#
--# home = 0                                         #
--# shop_list.loaded = 1                             #
--# shop.clicked = 2                                 #
--# shop_details.loaded = 3                          #
--# add_cart.clicked = 4                             #
--# checkout = 5                                     #
--# transaction = 6                                  #
--# if none of them = !                              #
--####################################################


select
        fullvisitorid,
        visitid,
        Platform,
        User_type,

        --FULL FUNNEL
        CONCAT(STRING(IF((LENGTH(sequence) - LENGTH(REGEXP_REPLACE(sequence, '0', ''))) > 0,1,0)),
            STRING(IF((LENGTH(sequence) - LENGTH(REGEXP_REPLACE(sequence, '1', ''))) > 0,1,0)),
            STRING(IF((LENGTH(sequence) - LENGTH(REGEXP_REPLACE(sequence, '3', ''))) > 0,1,0)),
            STRING(IF((LENGTH(sequence) - LENGTH(REGEXP_REPLACE(sequence, '4', ''))) > 0,1,0)),
            STRING(IF((LENGTH(sequence) - LENGTH(REGEXP_REPLACE(sequence, '5', ''))) > 0,1,0)),
            STRING(IF((LENGTH(sequence) - LENGTH(REGEXP_REPLACE(sequence, '6', ''))) > 0,1,0)))
            as full_funnel,

        if (LEFT(sequence, 1)='0','Home',
            if (LEFT(sequence, 1)='1','Listing',
            if(LEFT(sequence, 1)='3','Details',
            if(LEFT(sequence, 1)='5','Checkout','Else'))))
            as landing_page,
        --COUNT EVENTS ON SEQUENCE
        LENGTH(sequence) - LENGTH(REGEXP_REPLACE(sequence, '0', '')) as home_count ,
        LENGTH(sequence) - LENGTH(REGEXP_REPLACE(sequence, '1', '')) as shop_list_count ,
        LENGTH(sequence) - LENGTH(REGEXP_REPLACE(sequence, '2', '')) as shop_clicked_count ,
        LENGTH(sequence) - LENGTH(REGEXP_REPLACE(sequence, '3', '')) as shop_loaded_count ,
        LENGTH(sequence) - LENGTH(REGEXP_REPLACE(sequence, '4', '')) as add_cart_clicked_count ,
        LENGTH(sequence) - LENGTH(REGEXP_REPLACE(sequence, '5', '')) as checkout_count ,
        LENGTH(sequence) - LENGTH(REGEXP_REPLACE(sequence, '6', '')) as transaction_count ,
        LENGTH(sequence) - LENGTH(REGEXP_REPLACE(sequence, '!', '')) as error_count ,
        --COUNT EVENTS SEQUENCE ON SEQUENCE
        ( LENGTH(sequence) - LENGTH(REGEXP_REPLACE(sequence, '0>1', '')) ) / 3  as home_to_list_count ,
        ( LENGTH(sequence) - LENGTH(REGEXP_REPLACE(sequence, '1>3', '')) ) / 3 as list_to_home_without_shop_clicked ,
        ( LENGTH(sequence) - LENGTH(REGEXP_REPLACE(sequence, '1>2>3', '')) ) / 5 as list_to_home_with_shop_clicked ,
        ( LENGTH(sequence) - LENGTH(REGEXP_REPLACE(sequence, '3>4', '')) ) / 3 as details_to_add_to_cart ,
        ( LENGTH(sequence) - LENGTH(REGEXP_REPLACE(sequence, '4>5', '')) ) / 3 as add_to_cart_to_checkout ,
        ( LENGTH(sequence) - LENGTH(REGEXP_REPLACE(sequence, '3>4>5', '')) ) / 5 as details_to_checkout ,
        ( LENGTH(sequence) - LENGTH(REGEXP_REPLACE(sequence, '5>6', '')) ) / 3 as checout_to_transaction ,

        (( LENGTH(sequence) - LENGTH(REGEXP_REPLACE(sequence, '0>1', '')) ) / 3)/(LENGTH(sequence) - LENGTH(REGEXP_REPLACE(sequence, '0', ''))) as test,
                sequence

from


		(SELECT
			fullVisitorId,
			visitId,
			CONCAT("Lieferheld ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform,

--			case when visitnumber=1 then "New Visitors" else "Returning Visitors" end as Users,
			if (visitnumber=1,'New Visitors','Returning Visitors') as User_type,
            --MAKE A STRING THE FUNNEL SEQUENCE--
			GROUP_CONCAT(IF(hits.eventInfo.eventAction = 'shop_list.loaded' OR
			hits.eventInfo.eventAction = 'shop_details.loaded' OR
			hits.eventInfo.eventAction = 'add_cart.clicked' OR
			hits.eventInfo.eventAction = 'checkout.loaded' OR
			hits.eventInfo.eventAction = 'transaction' OR
			hits.eventInfo.eventAction = 'shop.clicked',if (hits.eventInfo.eventAction='shop_list.loaded','1',
                                                        if(hits.eventInfo.eventAction='shop.clicked','2',
                                                        if(hits.eventInfo.eventAction='shop_details.loaded','3',
                                                        if(hits.eventInfo.eventAction='add_cart.clicked','4',
                                                        if(hits.eventInfo.eventAction='checkout.loaded','5',
                                                        if(hits.eventInfo.eventAction='transaction','6','!')))))),'0'), '>') within record as sequence,
		FROM TABLE_DATE_RANGE([blh---lieferheld:38642300.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-4,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-4,"DAY")))
		WHERE
			(hits.eventInfo.eventAction = 'shop_list.loaded' OR
			hits.eventInfo.eventAction = 'shop_details.loaded' OR
			hits.eventInfo.eventAction = 'add_cart.clicked' OR
			hits.eventInfo.eventAction = 'checkout.loaded' OR
			hits.eventInfo.eventAction = 'transaction' OR
			hits.eventInfo.eventAction = 'shop.clicked' OR
		    ((hits.type == "PAGE" OR hits.type == "APPVIEW") AND hits.customDimensions.index = 11 and hits.customDimensions.value='home'))
		    and fullvisitorid = '1047737907339007755'
      )