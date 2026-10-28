SELECT year, COUNT(*) AS reports
FROM `bigquery-public-data.chicago_crime.crime`
WHERE primary_type = 'CRIMINAL SEXUAL ASSAULT'
GROUP BY year
ORDER BY year

SELECT DATE_TRUNC(DATE(date), MONTH) AS month, COUNTIF(primary_type='CRIMINAL SEXUAL ASSAULT') AS reports_criminal, COUNTIF(primary_type='CRIM SEXUAL ASSAULT') AS reports_crim
FROM `bigquery-public-data.chicago_crime.crime`
WHERE year>=2018 AND year<=2020
GROUP BY month
ORDER BY month;

SELECT year, COUNT(*)
FROM `bigquery-public-data.chicago_crime.crime`
WHERE primary_type='CONCEALED CARRY LICENSE VIOLATION'
GROUP BY year
ORDER BY year;

SELECT year, COUNT(*)
FROM `bigquery-public-data.chicago_crime.crime`
WHERE primary_type='RITUALISM'
GROUP BY year
ORDER BY year desc;

SELECT year, COUNT(*) AS reports, COUNTIF(arrest IS true)AS arrests,
COUNTIF(arrest IS true)/COUNT(*) AS rate
FROM `bigquery-public-data.chicago_crime.crime`
WHERE year=2001
GROUP BY year
ORDER BY year desc;

SELECT year, COUNT(*)
FROM `bigquery-public-data.chicago_crime.crime`
GROUP BY year
ORDER BY year ASC;
