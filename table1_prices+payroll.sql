--script - vytvoření tabulky cen potravin a mezd za ČR

CREATE TABLE t_tereza_bohmova_project_SQL_primary_final AS (
SELECT
	cp.date_from,
	cp.date_to,
	cp.category_code AS food_code,
	cpc.name AS food_name,
	cp.value AS food_price,
	cpc.price_value AS food_quantity,
	cpc.price_unit AS food_unit,
	cr.name AS region_name,
	cp.region_code,
	cpay.value_type_code,
	cpvt.name AS value_name,
	cpay.value,
	cpay.unit_code,
	cpu.name AS unit_name,
	cpay.calculation_code,
	cpcal.name AS calculation_name,
	cpay.industry_branch_code,
	cpib.name AS industry_branch_name,
	cpay.payroll_year,
	cpay.payroll_quarter 
FROM
	czechia_price cp
LEFT JOIN czechia_price_category cpc 
    ON
	cp.category_code = cpc.code
LEFT JOIN czechia_region cr 
   ON
	cp.region_code = cr.code
LEFT JOIN czechia_payroll cpay
   ON
	date_part('year', cp.date_to) = cpay.payroll_year
	AND date_part('quarter', cp.date_to) = cpay.payroll_quarter
LEFT JOIN czechia_payroll_industry_branch CPIB 
   ON
	cpay.industry_branch_code = cpib.code
LEFT JOIN czechia_payroll_value_type CPVT 
   ON
	cpay.value_type_code = cpvt.code
LEFT JOIN czechia_payroll_calculation cpcal
  ON
	cpay.calculation_code = cpcal.code
LEFT JOIN czechia_payroll_unit CPU 
  ON
	cpay.unit_code = cpu.code
  );



