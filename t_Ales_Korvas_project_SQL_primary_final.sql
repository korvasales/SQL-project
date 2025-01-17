


-- Creating the joined primary table




CREATE OR REPLACE TABLE t_ales_korvas_project_SQL_primary_final AS
WITH czechia_price_table AS (
    SELECT
        YEAR(date_from) AS price_year,
        category_code,
   value
    FROM 
        czechia_price
),
selected_data AS (
    SELECT 
        cprl.payroll_year AS _year,
        CONCAT(cprl.industry_branch_code, ' - ', cpib.name) AS code_and_industry_name,
        CONCAT(cpt.category_code, '  -  ', cpc.name) AS food_categories,
        cpc.price_value,
        cpc.price_unit,
        ROUND(AVG(cpt.value), 1) AS avg_price_of_food_in_czk,
        ROUND(AVG(cprl.value), 0) AS avg_salary_in_czk
    FROM 
        czechia_payroll AS cprl 
    LEFT JOIN
        czechia_payroll_industry_branch AS cpib ON cpib.code = cprl.industry_branch_code 
    LEFT JOIN
        czechia_price_table AS cpt ON cpt.price_year = cprl.payroll_year
    LEFT JOIN 
        czechia_price_category AS cpc ON cpc.code = cpt.category_code
    WHERE
        cprl.industry_branch_code IS NOT NULL
        AND cprl.calculation_code = 200 --  full-time salary
        AND cprl.unit_code = 200 -- salary in CZK
        AND cprl.value_type_code = 5958 -- avg gross salary
    GROUP BY
        cprl.industry_branch_code,
        cprl.payroll_year,
        cpt.category_code
)
SELECT * FROM selected_data;


SELECT *
FROM t_ales_korvas_project_SQL_primary_final




-- THE SAME YEAR 2006 - 2018 

SELECT 
	payroll_year, 
	MIN(payroll_year) AS oldest_payrol_year,
	MAX(payroll_year) AS newest_payrol_year
FROM czechia_payroll cp ;




SELECT 
	MIN(YEAR(date_from)) AS start_date_from,
	MIN(YEAR(date_to)) AS start_date_to,
	MAX(YEAR(date_from)) AS end_date_from,
	MAX(YEAR(date_to)) AS end_date_to
FROM czechia_price;

