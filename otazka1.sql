--OTÁZKA 1:Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

--skript1: zobrazení odvětví, kde došlo k poklesu mzdy mezi roky

WITH payroll_comparison AS ( 
  SELECT tb1.INDUSTRY_BRANCH_CODE, tb1.INDUSTRY_BRANCH_NAME, tb1.PAYROLL_YEAR, AVG(value) AS avg_payroll,
      LAG(tb1.payroll_year) OVER (PARTITION BY tb1.industry_branch_code ORDER BY tb1.PAYROLL_YEAR) previous_payroll_year,
      AVG(value) - lag(AVG(value)) OVER (PARTITION BY tb1.industry_branch_code ORDER BY tb1.PAYROLL_YEAR) payroll_change
FROM T_TEREZA_BOHMOVA_PROJECT_SQL_PRIMARY_FINAL tb1
WHERE tb1.VALUE_TYPE_CODE = '5958' AND tb1.CALCULATION_CODE = '200'
GROUP BY tb1.INDUSTRY_BRANCH_CODE, tb1.INDUSTRY_BRANCH_NAME, tb1.PAYROLL_YEAR
)
SELECT DISTINCT pc.INDUSTRY_BRANCH_NAME 
FROM payroll_comparison pc
WHERE pc.payroll_change < 0;

--skript2: komplexnější tabulka - přehled odvětví a roků, kdy došlo k poklesu mzdy, seřazeno od největšího poklesu po nejmenší
WITH payroll_comparison AS ( 
  SELECT tb1.INDUSTRY_BRANCH_CODE, tb1.INDUSTRY_BRANCH_NAME, tb1.PAYROLL_YEAR, AVG(value) AS avg_payroll,
      LAG(tb1.payroll_year) OVER (PARTITION BY tb1.industry_branch_code ORDER BY tb1.PAYROLL_YEAR) previous_payroll_year,
      AVG(value) - lag(AVG(value)) OVER (PARTITION BY tb1.industry_branch_code ORDER BY tb1.PAYROLL_YEAR) payroll_change
FROM T_TEREZA_BOHMOVA_PROJECT_SQL_PRIMARY_FINAL tb1
WHERE tb1.VALUE_TYPE_CODE = '5958' AND tb1.CALCULATION_CODE = '200'
GROUP BY tb1.INDUSTRY_BRANCH_CODE, tb1.INDUSTRY_BRANCH_NAME, tb1.PAYROLL_YEAR
)
SELECT *
FROM payroll_comparison pc
WHERE pc.payroll_change < 0
ORDER BY pc.payroll_change;

--skript 3: U kolika odvětví došlo v daném roce k poklesu mzdy? 

WITH payroll_comparison AS ( 
  SELECT tb1.INDUSTRY_BRANCH_CODE, tb1.INDUSTRY_BRANCH_NAME, tb1.PAYROLL_YEAR, AVG(value) AS avg_payroll,
      LAG(tb1.payroll_year) OVER (PARTITION BY tb1.industry_branch_code ORDER BY tb1.PAYROLL_YEAR) previous_payroll_year,
      AVG(value) - lag(AVG(value)) OVER (PARTITION BY tb1.industry_branch_code ORDER BY tb1.PAYROLL_YEAR) payroll_change
FROM T_TEREZA_BOHMOVA_PROJECT_SQL_PRIMARY_FINAL tb1
WHERE tb1.VALUE_TYPE_CODE = '5958' AND tb1.CALCULATION_CODE = '200'
GROUP BY tb1.INDUSTRY_BRANCH_CODE, tb1.INDUSTRY_BRANCH_NAME, tb1.PAYROLL_YEAR
)
SELECT pc.payroll_year , count (*)
FROM payroll_comparison pc
WHERE pc.payroll_change < 0
GROUP BY pc.payroll_year
ORDER BY count DESC;


--skript4: Kolikrát došlo za celé období v daném odvětvéí k poklesu mzdy?

WITH payroll_comparison AS ( 
  SELECT tb1.INDUSTRY_BRANCH_CODE, tb1.INDUSTRY_BRANCH_NAME, tb1.PAYROLL_YEAR, AVG(value) AS avg_payroll,
      LAG(tb1.payroll_year) OVER (PARTITION BY tb1.industry_branch_code ORDER BY tb1.PAYROLL_YEAR) previous_payroll_year,
      AVG(value) - lag(AVG(value)) OVER (PARTITION BY tb1.industry_branch_code ORDER BY tb1.PAYROLL_YEAR) payroll_change
FROM T_TEREZA_BOHMOVA_PROJECT_SQL_PRIMARY_FINAL tb1
WHERE tb1.VALUE_TYPE_CODE = '5958' AND tb1.CALCULATION_CODE = '200'
GROUP BY tb1.INDUSTRY_BRANCH_CODE, tb1.INDUSTRY_BRANCH_NAME, tb1.PAYROLL_YEAR
)
SELECT pc.industry_branch_name , count (*)
FROM payroll_comparison pc
WHERE pc.payroll_change < 0
GROUP BY pc.INDUSTRY_BRANCH_NAME
ORDER BY count DESC;
