--determine duplicate entires by id
SELECT
  id,
  COUNT(*) AS duplicate_count
FROM `earthquake_etl_dataset.phivolcs_earthquake`
GROUP BY id
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

--determine duplicate entires by different columns
SELECT
  date_time,
  latitude,
  longitude,
  depth,
  magnitude,
  COUNT(*) AS r
FROM `earthquake_etl_dataset.phivolcs_earthquake`
GROUP BY 1,2,3,4,5
HAVING COUNT(*) > 1
ORDER BY r DESC;

--delete duplicate entries
DELETE FROM `earthquake_etl_dataset.phivolcs_earthquake`
WHERE id IN (
  SELECT id
  FROM (
    SELECT
      id,
      ROW_NUMBER() OVER (PARTITION BY id ORDER BY id) AS rn
    FROM `earthquake_etl_dataset.phivolcs_earthquake`
  )
  WHERE rn > 1 OR rn IS NULL
);