select visitStartTime, hits.type, hits.hitNumber, fullVisitorId, visitId, hits.customDimensions.index, hits.customDimensions.value, hits.page.pagePath, hits.eventInfo.eventAction, hits.eventInfo.eventLabel
 from  [74773001.ga_sessions_20160730]
where fullVisitorId = '10422733866941568482' and visitId = 1469875049
order by hits.hitNumber