SELECT year, COUNT(*) AS reports
FROM `bigquery-public-data.chicago_crime.crime`
WHERE year BETWEEN 2019 AND 2024
GROUP BY year
ORDER BY year;

SELECT COUNT(DISTINCT primary_type) AS different_crime_types
FROM `bigquery-public-data.chicago_crime.crime`
WHERE year = 2024

SELECT COUNT(DISTINCT primary_type) AS different_crime_types
FROM `bigquery-public-data.chicago_crime.crime`
WHERE year = 2001

SELECT primary_type, 
COUNT(*) AS reports,
COUNTIF(arrest) AS total_arrests,
SAFE_DIVIDE(COUNTIF(arrest), COUNT(*)) AS arrest_rate
FROM `bigquery-public-data.chicago_crime.crime`
WHERE year = 2024
GROUP BY primary_type
HAVING COUNT(*) > 1000
ORDER BY arrest_rate ASC;

SELECT
  SAFE_DIVIDE(
    COUNTIF(
      arrest = TRUE
      AND primary_type IN ('NARCOTICS', 'WEAPONS VIOLATION')
    ),
    COUNTIF(arrest = TRUE)
  ) * 100 AS percentage_of_arrests
FROM `bigquery-public-data.chicago_crime.crime`
WHERE year = 2024;
