

-- Ukol cislo 3 
-- Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?




SELECT 	
	*
FROM t_ales_korvas_project_SQL_primary_final
;




WITH annual_changes AS (
		SELECT 
			_year,
			food_categories,
			avg_price_of_food_in_czk,
			lag (avg_price_of_food_in_czk) OVER (PARTITION BY food_categories ORDER BY _year) AS prev_avg_price_of_food_in_czk
		FROM t_ales_korvas_project_sql_primary_final takpspf 
		WHERE 
			_year BETWEEN '2006' AND '2018'
),
annual_changes_in_percent AS (
		SELECT 
				_year,
			    food_categories,
			    avg_price_of_food_in_czk,
			    prev_avg_price_of_food_in_czk,
			    (avg_price_of_food_in_czk - prev_avg_price_of_food_in_czk) / prev_avg_price_of_food_in_czk * 100 AS price_change_percent
			FROM annual_changes
		)
		SELECT 
		    food_categories,
		    ROUND(AVG(price_change_percent), 2) AS avg_percent_change
		FROM annual_changes_in_percent
		GROUP BY 
		    food_categories
		ORDER BY
		    avg_percent_change
;


	
