SELECT COUNT(*)
FROM `my_crime.raw_crime`
WHERE location_description IS NULL or location_description=''

SELECT COUNT(DISTINCT NULLIF(UPPER(TRIM(location_description)),'')) AS location_values
FROM `my_crime.raw_crime`

SELECT COUNTIF(SAFE.PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', date)IS NULL) AS failed_dates
FROM `my_crime.raw_crime`

--Needed help from AI
WITH parsed AS (
  SELECT 
    SAFE.PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', date) AS occurred_at
  FROM `my_crime.raw_crime`
)
SELECT
  EXTRACT(HOUR FROM occurred_at) AS hour,
  COUNT(*) AS report_count
FROM parsed
WHERE occurred_at IS NOT NULL
GROUP BY hour
ORDER BY report_count DESC

--Needed help from AI
SELECT
  COUNT(*) AS midnight_reports
FROM `my_crime.raw_crime`
WHERE EXTRACT(HOUR FROM
  SAFE.PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', date)
) = 0
AND EXTRACT(MINUTE FROM
  SAFE.PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', date)
) = 0
AND EXTRACT(SECOND FROM
  SAFE.PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', date)
) = 0;

--Needed help from AI
SELECT 
COUNT(*)AS invalid_districts
FROM `my_crime.raw_crime`
WHERE SAFE_CAST(district AS INT64) NOT IN (
  1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,
  14, 15, 16, 17, 18, 19, 20, 22, 24, 25
);

SELECT 
COUNT(*) - COUNT(DISTINCT id)
FROM `my_crime.raw_crime`

SELECT COUNT(*)
FROM `my_crime.raw_crime`
GROUP BY case_number HAVING COUNT(*)>1

--Needed help from AI
SELECT
  primary_type,
  COUNT(*) AS shared_case_rows
FROM `my_crime.raw_crime`
WHERE case_number IN (
  SELECT case_number
  FROM `my_crime.raw_crime`
  GROUP BY case_number
  HAVING COUNT(*) > 1
)
GROUP BY primary_type
ORDER BY shared_case_rows DESC;

--Creating clean data table
--Needed so much help from AI with this one
CREATE OR REPLACE TABLE `my_crime.clean_crime` AS

WITH typed AS (
  SELECT
    SAFE_CAST(id AS INT64) AS id,
    TRIM(case_number) AS case_number,
    SAFE.PARSE_TIMESTAMP(
      '%m/%d/%Y %I:%M:%S %p', date
    ) AS occurred_at,
    TRIM(block) AS block,
    TRIM(iucr) AS iucr,
    UPPER(TRIM(primary_type)) AS primary_type,
    TRIM(description) AS description,
    UPPER(TRIM(location_description)) AS location_description,
    LOWER(TRIM(arrest)) = 'true' AS arrest,
    LOWER(TRIM(domestic)) = 'true' AS domestic,
    SAFE_CAST(beat AS INT64) AS beat,
    SAFE_CAST(district AS INT64) AS district,
    SAFE_CAST(ward AS INT64) AS ward,
    SAFE_CAST(community_area AS INT64) AS community_area,
    TRIM(fbi_code) AS fbi_code,
    SAFE_CAST(x_coordinate AS FLOAT64) AS x_coordinate,
    SAFE_CAST(y_coordinate AS FLOAT64) AS y_coordinate,
    SAFE_CAST(year AS INT64) AS year,
    SAFE.PARSE_TIMESTAMP(
      '%m/%d/%Y %I:%M:%S %p', updated_on
    ) AS updated_on,
    SAFE_CAST(latitude AS FLOAT64) AS latitude,
    SAFE_CAST(longitude AS FLOAT64) AS longitude,
    TRIM(location) AS location
  FROM `my_crime.raw_crime`
),

ranked AS (
  SELECT
    *,
    ROW_NUMBER() OVER (
      PARTITION BY id
      ORDER BY updated_on DESC
    ) AS copy_no
  FROM typed
),

deduped AS (
  SELECT * EXCEPT (copy_no)
  FROM ranked
  WHERE copy_no = 1
)

SELECT
  * REPLACE (
    CASE
      WHEN location_description IS NULL
        OR TRIM(location_description) = ''
        THEN 'UNKNOWN'
      -- add location mappings here
      ELSE UPPER(TRIM(location_description))
    END AS location_description
  ),
  SAFE_CAST(district AS INT64) NOT IN (
    1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,
    14, 15, 16, 17, 18, 19, 20, 22, 24, 25
  ) AS flag_non_patrol_district,
  latitude IS NULL OR longitude IS NULL AS flag_no_coordinates,
  FORMAT_TIMESTAMP('%H:%M', occurred_at) = '00:00' AS flag_midnight,
  occurred_at > CURRENT_TIMESTAMP() AS flag_future_date,
  occurred_at IS NULL AS flag_bad_date
FROM deduped;

--Something was wrong with this. When I asked how many distinct location descriptions there were, it returned 130, but the correct 
--answer was 125. I got there by guessing.
