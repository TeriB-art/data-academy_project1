--script - vytvoření tabulky cen potravin a mezd za ČR

CREATE TABLE  t_tereza_bohmova_project_SQL_primary_final AS (
SELECT cp.DATE_FROM, cp.DATE_TO, 
       cp.CATEGORY_CODE AS food_code, cpc.name AS food_name, cp.value AS food_price, 
       cpc.price_value AS food_quantity, cpc.price_unit AS food_unit,
       cr."name" AS region_name,cp.REGION_CODE,  
       cpay.VALUE_TYPE_CODE, cpvt."name" AS value_name, cpay.VALUE, cpay.unit_code, cpu.name AS unit_name, cpay.CALCULATION_CODE, cpcal."name" AS calculation_name, 
       cpay.INDUSTRY_BRANCH_CODE, cpib."name" industry_branch_name,
       cpay.PAYROLL_YEAR, cpay.PAYROLL_QUARTER 
FROM CZECHIA_PRICE CP 
LEFT JOIN CZECHIA_PRICE_CATEGORY CPC 
    ON cp.CATEGORY_CODE = cpc.CODE
LEFT JOIN CZECHIA_REGION CR 
   ON cp.REGION_CODE = cr.CODE
LEFT JOIN  CZECHIA_PAYROLL cpay
   ON date_part('year',CP.DATE_TO) = cpay.PAYROLL_YEAR
   AND date_part('quarter', CP.DATE_TO) = cpay.PAYROLL_QUARTER
LEFT JOIN CZECHIA_PAYROLL_INDUSTRY_BRANCH CPIB 
   ON cpay.INDUSTRY_BRANCH_CODE = cpib.CODE 
LEFT JOIN CZECHIA_PAYROLL_VALUE_TYPE CPVT 
   ON cpay.VALUE_TYPE_CODE = cpvt.CODE
LEFT JOIN CZECHIA_PAYROLL_CALCU*>LATION cpcal
  ON cpay.CALCULATION_CODE = cpcal.code
LEFT JOIN CZECHIA_PAYROLL_UNIT CPU 
  ON cpay.UNIT_CODE = cpu.CODE
  );



