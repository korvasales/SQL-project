-- CREATION OF THE SECONDARY TABLE



	CREATE OR REPLACE TABLE t_Ales_Korvas_project_SQL_secondary_final AS
	SELECT 
		e.`year`,	
		e.country,
		FORMAT (e.GDP / 1000000000, 2) AS gdp_in_billion, -- alternatively "FORMAT(e.GDP / 1e9, 2) AS gdp_in_billion,
		e.gini AS GINI_coefficient,
		FORMAT (e.population / 1000000, 2) AS population_in_million, -- alternatively "FORMAT(e.population / 1e6, 2) AS population_in_million"
		FORMAT (e.taxes, 2) AS taxation_in_percent,
		c.continent	
	FROM economies AS e
	LEFT JOIN
		countries c 
		ON c.country = e.country 
	WHERE 
		c.continent = 'Europe' -- European countries
		
	ORDER BY 
		e.country,
		e.`year`,
		e.gini
;

SELECT * 
FROM 
t_Ales_Korvas_project_SQL_secondary_final
;