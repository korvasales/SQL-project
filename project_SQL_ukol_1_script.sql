
-- Ukol cislo 1

-- Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?



	WITH salaries AS(
	SELECT 
		_year,
		code_and_industry_name,
		avg_salary_in_czk,
		LAG(avg_salary_in_czk) OVER (PARTITION BY code_and_industry_name ORDER BY _year) AS prev_avg_salary_in_czk
	FROM t_ales_korvas_project_SQL_primary_final
)
SELECT 
	_year,
	code_and_industry_name,
	avg_salary_in_czk,
	ROUND(
		((avg_salary_in_czk - prev_avg_salary_in_czk) / prev_avg_salary_in_czk) * 100, 1
	) AS percent_change
FROM salaries
WHERE 
	prev_avg_salary_in_czk IS NOT NULL
GROUP BY 
	code_and_industry_name,
	avg_salary_in_czk,
	_year
ORDER BY 
	code_and_industry_name,
	_year
;
	

