# Sessions starting over again in 30 minutes, and their relation to traffic source.

SELECT
	Platform,
	Total_sessions,
	ROUND(tot_30_min/Total_sessions*100,3) AS perc_30_min_ses,
	ROUND(tot_traffic_related/tot_30_min*100,3) AS perc_traffic_related,
	trafficSource.source,
	trafficSource.medium,
	ROUND(duplicated_ses/tot_traffic_related*100,3) AS source_medium_share

FROM
	(SELECT
		Platform,
		Total_sessions,
		tot_30_min,
		trafficSource.source,
		trafficSource.medium,
		COUNT(IF(sequence_diff > 0 AND sequence_diff < 30 AND (traffic_m_related == 2 OR traffic_s_related == 2), fullvisitorID, NULL)) AS duplicated_ses,
		ROUND((COUNT(IF(sequence_diff > 0 AND sequence_diff < 30 AND (traffic_m_related == 2 OR traffic_s_related == 2), fullvisitorID, NULL))/Total_sessions*100),3) AS perc_ses_in_30_min,
		ROW_NUMBER() OVER (PARTITION BY Platform ORDER BY Platform, duplicated_ses DESC) AS Share_Rate_index,
		SUM(duplicated_ses) OVER (PARTITION BY Platform) AS tot_traffic_related

	FROM
		(SELECT
			Platform,
			fullvisitorID,
			visitStartTime,
			diff_min,
			diff_min-prev_diff_min AS sequence_diff,
			trafficSource.source,
			trafficSource.medium,
			Total_sessions,
			COUNT(DISTINCT trafficSource.medium) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS traffic_m_related,
			COUNT(DISTINCT trafficSource.source) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS traffic_s_related,
			COUNT(IF(sequence_diff > 0 AND sequence_diff < 30,1,NULL)) OVER (PARTITION BY Platform) AS tot_30_min
		FROM
			(SELECT
				Platform,
				fullvisitorID,
				visitStartTime,
				ROUND(((visitStartTime-min_start_time)/60),2) diff_min,
				trafficSource.source,
				trafficSource.medium,
				Total_sessions,
				MIN(diff_min) OVER (PARTITION BY Platform,fullvisitorID ORDER BY visitStartTime ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS prev_diff_min

			FROM
    				(SELECT
					fullVisitorId,
					visitStartTime,
					trafficSource.source,
					trafficSource.medium,
					CONCAT("Lieferheld ",IF(device.isMobile == false, "Web", "mWeb")) AS Platform,

--					MAX(hits.time) over (partition by Platform,fullvisitorID) as min_start_time1,
					COUNT(*) OVER (PARTITION BY Platform ORDER BY Platform) AS Total_sessions,
					COUNT(visitStartTime) OVER (PARTITION BY Platform,fullvisitorID) AS session_per_user
				FROM TABLE_DATE_RANGE([blh---lieferheld:38642300.ga_sessions_], TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-2,"DAY")), TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-2,"DAY")))
				GROUP BY 1,2,3,4,5,6
    				ORDER BY 1,2)
    		left join
    		)

    			ORDER BY 2 DESC, 3,4)
		ORDER BY 2 DESC, 3,4)
	GROUP BY 1,2,3,4,5
	ORDER BY 1,6 DESC)

WHERE Share_Rate_index < 6