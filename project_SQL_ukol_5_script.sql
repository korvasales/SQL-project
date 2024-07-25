-- Ukol cislo 5
-- Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, 
-- projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?




WITH pfd AS(
  SELECT 
    _year,
    ROUND(AVG(avg_salary_in_czk), 0) AS average_salary, -- calculated as an average of all categories
    ROUND(AVG(avg_price_of_food_in_czk), 2) AS average_food_price -- calculated as an average of all food categories
  FROM t_ales_korvas_project_SQL_primary_final
  GROUP BY _year
),
gdp AS(
  SELECT 
    country,
    _year,
    GDP_in_billion,
    gini_coefficient,
    population_in_million
  FROM t_ales_korvas_project_SQL_secondary_final
  WHERE country = 'Czech Republic'
),
combined_data AS (
  SELECT 
    pfd._year,
    pfd.average_food_price,
    pfd.average_salary,
    gdp.GDP_in_billion,
    gdp.gini_coefficient,
    gdp.population_in_million
  FROM pfd
  LEFT JOIN gdp ON pfd._year = gdp._year
  ORDER BY pfd._year
),
percent_change AS(
  SELECT
    _year,
    average_salary,
    LAG(average_salary) OVER (ORDER BY _year) AS prev_average_payroll,
    average_food_price,
    LAG(average_food_price) OVER (ORDER BY _year) AS prev_average_food_price,
    GDP_in_billion,
    LAG(GDP_in_billion) OVER (ORDER BY _year) AS prev_GDP_in_billion,
    gini_coefficient,
    population_in_million,
    (average_salary - LAG(average_salary) OVER (ORDER BY _year)) / LAG(average_salary) OVER (ORDER BY _year) * 100 AS percent_change_salary,
    (average_food_price - LAG(average_food_price) OVER (ORDER BY _year)) / LAG(average_food_price) OVER (ORDER BY _year) * 100 AS percent_change_food_price,
    (GDP_in_billion - LAG(GDP_in_billion) OVER (ORDER BY _year)) / LAG(GDP_in_billion) OVER (ORDER BY _year) * 100 AS percent_change_GDP
  FROM combined_data
)
SELECT 
  _year,
  average_salary,
  average_food_price,
  GDP_in_billion,
  ROUND(percent_change_salary, 2) AS percent_change_salary,
  ROUND(percent_change_food_price, 2) AS percent_change_food_price,
  ROUND(percent_change_GDP, 2) AS percent_change_GDP
FROM percent_change
ORDER BY _year;











