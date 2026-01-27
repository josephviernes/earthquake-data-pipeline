DELETE FROM `earthquake_etl_dataset.provinces`
WHERE province LIKE 'Maguindanao';


INSERT INTO `earthquake_etl_dataset.provinces` (id, region, province)
VALUES (3, 'Bangsamoro Autonomous Region In Muslim Mindanao (BARMM)', 'Maguindanao');


UPDATE `earthquake_etl_dataset.provinces`
SET region = 'IV-B'
WHERE region = 'REGION IV-B (MIMAROPA)';

UPDATE `earthquake_etl_dataset.provinces`
SET region = 'XIII'
WHERE region = 'Region XIII (Caraga)';

UPDATE `earthquake_etl_dataset.provinces`
SET region = 'XII'
WHERE region = 'Region XII (SOCCSKSARGEN)';

UPDATE `earthquake_etl_dataset.provinces`
SET region = 'XI'
WHERE region = 'Region XI (Davao Region)';

UPDATE `earthquake_etl_dataset.provinces`
SET region = 'X'
WHERE region = 'Region X (Northern Mindanao)';

UPDATE `earthquake_etl_dataset.provinces`
SET region = 'VIII'
WHERE region = 'Region VIII (Eastern Visayas)';

UPDATE `earthquake_etl_dataset.provinces`
SET region = 'VII'
WHERE region = 'Region VII (Central Visayas)';

UPDATE `earthquake_etl_dataset.provinces`
SET region = 'VI'
WHERE region = 'Region VI (Western Visayas)';

UPDATE `earthquake_etl_dataset.provinces`
SET region = 'V'
WHERE region = 'Region V (Bicol Region)';

UPDATE `earthquake_etl_dataset.provinces`
SET region = 'IX'
WHERE region = 'Region IX (Zamboanga Peninsula)';

UPDATE `earthquake_etl_dataset.provinces`
SET region = 'IV-A'
WHERE region = 'Region IV-A (CALABARZON)';

UPDATE `earthquake_etl_dataset.provinces`
SET region = 'III'
WHERE region = 'Region III (Central Luzon)';

UPDATE `earthquake_etl_dataset.provinces`
SET region = 'II'
WHERE region = 'Region II (Cagayan Valley)';

UPDATE `earthquake_etl_dataset.provinces`
SET region = 'I'
WHERE region = 'Region I (Ilocos Region)';

UPDATE `earthquake_etl_dataset.provinces`
SET region = 'NIR'
WHERE region = 'Negros Island Region (NIR)';

UPDATE `earthquake_etl_dataset.provinces`
SET region = 'NCR'
WHERE region = 'National Capital Region (NCR)';

UPDATE `earthquake_etl_dataset.provinces`
SET region = 'CAR'
WHERE region = 'Cordillera Administrative Region (CAR)';

UPDATE `earthquake_etl_dataset.provinces`
SET region = 'CAR'
WHERE region = 'Bangsamoro Autonomous Region In Muslim Mindanao (BARMM)';