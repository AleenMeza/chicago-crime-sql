SELECT COUNT(*)
FROM `bigquery-public-data.chicago_crime.crime`
WHERE year = 2024
  AND latitude IS NULL

SELECT COUNT(*)
FROM `bigquery-public-data.chicago_crime.crime`
WHERE year = 2024
  AND primary_type = 'NARCOTICS'
  AND arrest

SELECT COUNT(*)
FROM `bigquery-public-data.chicago_crime.crime`
WHERE year = 2019
  AND primary_type = 'CRIM SEXUAL ASSAULT'

SELECT COUNT(*)
FROM `bigquery-public-data.chicago_crime.crime`
WHERE year = 2019
  AND primary_type = 'CRIMINAL SEXUAL ASSAULT'

SELECT COUNT(*)
FROM `bigquery-public-data.chicago_crime.crime`
WHERE year = 2024
  AND latitude IS NULL
