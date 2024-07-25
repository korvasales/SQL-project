
-- Ukol cislo 2

-- Kolik litru mleka a kolik kg chleba si je mozne koupit za prvni a posledni srovnatelne obdobi (2006 a 2018)



SELECT 
	_year,
	food_categories,
	avg_price_of_food_in_czk,
	ROUND(AVG(avg_salary_in_czk), 0) AS avg_salary_in_CZ,
	CONCAT( ROUND(price_value * (ROUND(AVG(avg_salary_in_czk)) / avg_price_of_food_in_czk), 0), ' ', price_unit) AS food_purchase
FROM t_ales_korvas_project_SQL_primary_final
WHERE 
	_year IN ('2006', '2018') -- first and last period
	AND food_categories IN ('114201  -  Mléko polotučné pasterované',
							'111301  -  Chléb konzumní kmínový')
GROUP BY
	_year,
	food_categories,
	avg_price_of_food_in_czk
ORDER BY
	food_categories, 
	_year
;


