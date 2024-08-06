
-- Ukol cislo 4

-- Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?




WITH aggregated_data AS (
  SELECT
    _year,
    ROUND(AVG(avg_price_of_food_in_czk), 2) AS average_price_of_food_in_czk,
    ROUND(AVG(avg_salary_in_czk), 2) AS avg_salary_in_czk
  FROM t_ales_korvas_project_SQL_primary_final
  WHERE _year BETWEEN '2005' AND '2018'
  GROUP BY _year
),
diff_changes AS (
  SELECT
    _year,
    average_price_of_food_in_czk,
    LAG(average_price_of_food_in_czk) OVER (ORDER BY _year) AS prev_average_price_of_food,
    avg_salary_in_czk,
    LAG(avg_salary_in_czk) OVER (ORDER BY _year) AS prev_avg_salary
  FROM aggregated_data
)
SELECT 
  _year,
  ROUND(((average_price_of_food_in_czk - prev_average_price_of_food) / prev_average_price_of_food) * 100, 2) AS food_change_in_percent,
  ROUND(((avg_salary_in_czk - prev_avg_salary) / prev_avg_salary) * 100, 2) AS salary_change_in_percent
FROM diff_changes
ORDER BY _year;

