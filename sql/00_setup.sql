--Module 0: latest year in the public table
SELECT MAX(year) AS latest_year
FROM `bigquery-public-data.chicago_crime.crime`;
