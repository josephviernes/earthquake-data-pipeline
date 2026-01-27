CREATE OR REPLACE PROCEDURE `earthquake-etl.earthquake_etl_dataset.update_earthquakes`()
BEGIN
  -- add an id column
  ALTER TABLE `earthquake_etl_dataset.temp_table`
  ADD COLUMN IF NOT EXISTS id INT64;

  UPDATE `earthquake_etl_dataset.temp_table`
  SET id = FARM_FINGERPRINT(CONCAT(datetime, latitude, longitude, depth_km, magnitude))
  WHERE TRUE;
  
  -- simplify and/or correct province values on temp_table before merge
  UPDATE `earthquake-etl.earthquake_etl_dataset.temp_table`
  SET province = CASE
    WHEN province = 'Licuan' THEN 'Abra'
    WHEN province = 'San Nicolas / Talisay' THEN 'Batangas'
    WHEN province = 'Bitulok & Sabani' THEN 'Kalinga'
    WHEN province = 'Balatan' THEN 'Camarines Sur'
    WHEN province = 'Sugbay' THEN 'Southern Leyte'
    WHEN province = 'Don Mariano Marcos' THEN 'Ilocos Norte'
    WHEN province = 'Masbate (Ticao Island)' THEN 'Masbate'
    WHEN province = 'North Cotabato' THEN 'Cotabato'
    WHEN province = 'Western Samar' THEN 'Samar'
    WHEN province = 'Saug' THEN 'Zamboanga del Sur'
    WHEN province = 'Doña Alicia' THEN 'Zamboanga Sibugay'
    WHEN province = 'Compostela Valley' THEN 'Davao de Oro'
    WHEN province = 'Municipality of Saranani' THEN 'Sarangani'
    WHEN province = 'Calayan' THEN 'Cagayan'
    WHEN province = 'Vinzons' THEN 'Camarines Norte'
    WHEN province = 'Guiuan' THEN 'Eastern Samar'
    WHEN province = 'Masbate (Ticao Island' THEN 'Masbate'
    WHEN province = 'Island Garden City Of Samal' THEN 'Davao Del Norte'
    WHEN province = 'Albor' THEN 'Dinagat Islands'
    WHEN province = 'Polillo' THEN 'Quezon'
    WHEN province = 'Batangas City' THEN 'Batangas'
    WHEN province = 'Aparri' THEN 'Cagayan'
    WHEN province = 'Tawi-tawi' THEN 'Tawi-Tawi'
    WHEN province = 'Zamboanga Del Norte' THEN 'Zamboanga del Norte'
    WHEN province = 'Zamboanga Del Sur' THEN 'Zamboanga del Sur'
    WHEN province = 'Maguindanao Del Norte' THEN 'Maguindanao'
    WHEN province = 'Maguindanao Del Sur' THEN 'Maguindanao'
    WHEN province = 'Maguindanao del Norte' THEN 'Maguindanao'
    WHEN province = 'Maguindanao del Sur' THEN 'Maguindanao'
    WHEN province = 'Lanao Del Norte' THEN 'Lanao del Norte'
    WHEN province = 'Lanao Del Sur' THEN 'Lanao del Sur'
    WHEN province = 'Davao Del Sur' THEN 'Davao del Sur'
    WHEN province = 'Surigao Del Norte' THEN 'Surigao del Norte'
    WHEN province = 'Agusan Del Norte' THEN 'Agusan del Norte'
    WHEN province = 'Davao Del Norte' THEN 'Davao del Norte'
    WHEN province = 'Agusan Del Sur' THEN 'Agusan del Sur'
    WHEN province = 'Surigao Del Sur' THEN 'Surigao del Sur'
    WHEN province = 'Davao De Oro' THEN 'Davao de Oro'
    ELSE province
  END
  WHERE TRUE;

  -- add province_id column
  ALTER TABLE `earthquake_etl_dataset.temp_table`
  ADD COLUMN IF NOT EXISTS province_id INT64;

  -- populate province_id column of temp_table with values from provinces table
  UPDATE `earthquake-etl.earthquake_etl_dataset.temp_table` m
  SET m.province_id = s.id
  FROM `earthquake_etl_dataset.provinces` s
  WHERE m.province = s.province;

  -- merge temp_table data to main table
  MERGE `earthquake_etl_dataset.phivolcs_earthquake` AS main
  USING `earthquake_etl_dataset.temp_table` AS temp
  ON main.id = temp.id
  WHEN NOT MATCHED THEN
    INSERT (id, date_time, latitude, longitude, depth, magnitude, province_id, relative_location)
    VALUES (temp.id, temp.datetime, temp.latitude, temp.longitude, temp.depth_km, temp.magnitude, temp.province_id, temp.relative_location);
END