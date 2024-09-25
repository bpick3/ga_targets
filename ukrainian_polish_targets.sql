CREATE OR REPLACE TABLE `stac-labs.ga_sharing.ukrainian_polish_targets` AS
SELECT
    ts.*,
    p.sos_id,
    p.myv_van_id,
    p.first_name,
    p.middle_name,
    p.last_name,
    p.suffix,
    p.age_combined,
    p.date_of_birth_combined,
    p.gender_vf,
    p.ethnicity_combined,
    p.ethnicity_modeled_confidence_level,
    p.county_name,
    p.voting_street_address,
    p.voting_street_address_2,
    p.voting_zip,
    p.voting_city,
    p.primary_phone_number,
    p.us_cong_district_latest,
    p.state_house_district_latest,
    p.state_senate_district_latest,
    s.support,
    s.turnout
FROM `democrats.consumer_ga.tsmart_ethnicity_plus` ts
LEFT JOIN `democrats.analytics_ga.person` p
    ON ts.person_id = p.person_id
LEFT JOIN `democrats.scores_ga.current_scores` s
    ON ts.person_id = s.person_id
WHERE ts.sub_ethnicity IN ('Ukrainian', 'Polish')
AND p.person_id IS NOT NULL
AND p.is_deceased = false
