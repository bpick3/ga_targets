SELECT 
  s.sos_id as state_voter_id,
  p.person_id,
  p.first_name,
  p.middle_name,
  p.last_name,
  CASE
    WHEN s.source_Party IS NULL THEN s.ballot_party
    ELSE s.source_Party 
  END as party,
  e.email,
  p.primary_phone_number as phone_number,
  p.date_of_birth_combined as date_of_birth,
  p.voting_street_address,
  p.voting_city,
  p.voting_zip,
  s.state_code as state,
  p.mailing_street_address,
  p.mailing_city,
  p.mailing_zip,
  o.dnc_2024_dem_party_support_v0 as dnc_2024_support_score,
  o.turnout_2024_v2 as turnout_score
FROM
  democrats.av_ev_ga_20240312_pres_primary.GA_statewide_31_standard as s
LEFT JOIN
  demsgasp.vansync.contacts_emails_myv as e
    ON s.VanID = e.myv_van_id AND e.datetime_suppressed IS NULL AND e.email IS NOT NULL AND s.VanID IS NOT NULL
LEFT JOIN
  democrats.analytics_ga.person as p  
    ON s.person_id = p.person_id AND p.reg_voter_flag
LEFT JOIN 
  democrats.scores_ga.all_scores_2024 as o
    ON s.person_id = o.person_id
WHERE 
  1 = 1
  AND s.source_Ballot_Style IN ('ELECTRONIC BALLOT DELIVERY')
  AND p.first_name IS NOT NULL
QUALIFY ROW_NUMBER() OVER(PARTITION BY s.sos_id ORDER BY e.datetime_created DESC) = 1
