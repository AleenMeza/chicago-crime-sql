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

