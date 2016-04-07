SELECT integration.sample->>'subject' AS subject,
       integration.landmark,
       integration.location,
       integration.ltr,
       integration.orientation_in_landmark AS orient,
	   count(distinct integration.*) AS multiplicity,
       string_agg(distinct (nearby.location - integration.location)::text, '; ') AS nearby_dists,
       string_agg(distinct nearby.location::text, '; ') AS nearby_loc

FROM integration
JOIN integration AS nearby ON (
      nearby.sample->>'subject' = integration.sample->>'subject'
  AND nearby.landmark = integration.landmark
  AND nearby.location != integration.location
  AND nearby.orientation_in_landmark = integration.orientation_in_landmark
  AND nearby.ltr != integration.ltr
  AND nearby.location BETWEEN integration.location - 6 AND integration.location + 6
)

WHERE integration.sample->>'subject' != ''
  AND integration.sample->>'pubmed_id' = '24968937'
  AND nearby.sample->>'pubmed_id'      = '24968937'

GROUP BY integration.sample->>'subject',
		 integration.landmark,
         integration.location,
         integration.ltr,
         integration.orientation_in_landmark

ORDER BY subject, landmark, location, ltr, orient;
