CREATE OR REPLACE VIEW `earthquake-etl.earthquake_etl_dataset.phivolcs_earthquake_looker`
AS
SELECT m.id,
       m.date_time,
       m.latitude,
       m.longitude,
       m.depth,
       m.magnitude,
       m.relative_location,
       t.province,
       t.region
FROM `earthquake-etl.earthquake_etl_dataset.phivolcs_earthquake` m
LEFT JOIN `earthquake-etl.earthquake_etl_dataset.provinces` t
ON m.province_id = t.id;