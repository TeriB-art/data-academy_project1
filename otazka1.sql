--OTÁZKA 1:Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

--Skript 1: zobrazení odvětví, kde došlo k poklesu mzdy mezi roky

WITH payroll_comparison AS
  (SELECT industry_branch_code, 
          industry_branch_name, 
          payroll_year, 
          AVG(value) AS avg_payroll,
          LAG(payroll_year) OVER (PARTITION BY industry_branch_code
                                      ORDER BY payroll_year) previous_payroll_year,
          AVG(value) - lag(AVG(value)) OVER (PARTITION BY industry_branch_code
                                             ORDER BY payroll_year) payroll_change
   FROM T_TEREZA_BOHMOVA_PROJECT_SQL_PRIMARY_FINAL tb1
   WHERE value_type_code = '5958'    --průměrná hrubá mzda na zaměstnance
     AND calculation_code = '200'   --mzda na přepočtený počet zaměstnanců
   GROUP BY industry_branch_code, 
            industry_branch_name,
            payroll_year)   
SELECT DISTINCT pc.industry_branch_name
FROM payroll_comparison pc
WHERE pc.payroll_change < 0;


--Skript 2: komplexnější tabulka - přehled odvětví a roků, kdy došlo k poklesu mzdy, seřazeno od největšího poklesu po nejmenší

WITH payroll_comparison AS
  (SELECT industry_branch_code,
          industry_branch_name,
          payroll_year,
          AVG(value) AS avg_payroll,
          LAG(payroll_year) OVER (PARTITION BY industry_branch_code
                                      ORDER BY payroll_year) previous_payroll_year,
          AVG(value) - lag(AVG(value)) OVER (PARTITION BY tb1.industry_branch_code
                                             ORDER BY payroll_year) payroll_change
   FROM T_TEREZA_BOHMOVA_PROJECT_SQL_PRIMARY_FINAL tb1
   WHERE value_type_code = '5958'   --průměrná hrubá mzda na zaměstnance
     AND calculation_code = '200'   --mzda na přepočtený počet zaměstnanců
   GROUP BY industry_branch_code,
            industry_branch_name,
            payroll_year)
SELECT *
FROM payroll_comparison pc
WHERE pc.payroll_change < 0
ORDER BY pc.payroll_change;


--Skript 3: U kolika odvětví došlo v daném roce k poklesu mzdy? 

WITH payroll_comparison AS
  (SELECT industry_branch_code,
          industry_branch_name,
          payroll_year,
          AVG(value) AS avg_payroll,
          LAG(payroll_year) OVER (PARTITION BY industry_branch_code
                                      ORDER BY payroll_year) previous_payroll_year,
          AVG(value) - lag(AVG(value)) OVER (PARTITION BY industry_branch_code
                                             ORDER BY payroll_year) payroll_change
   FROM T_TEREZA_BOHMOVA_PROJECT_SQL_PRIMARY_FINAL tb1
   WHERE value_type_code = '5958'     --průměrná hrubá mzda na zaměstnance
     AND calculation_code = '200'     --mzda na přepočtený počet zaměstnanců
   GROUP BY industry_branch_code,
            industry_branch_name,
            payroll_year)
SELECT pc.payroll_year,
       COUNT (*)
FROM payroll_comparison pc
WHERE pc.payroll_change < 0
GROUP BY pc.payroll_year
ORDER BY COUNT DESC;


--Skript 4: Kolikrát došlo za celé období v daném odvětví k poklesu mzdy?

WITH payroll_comparison AS
  (SELECT industry_branch_code,
          industry_branch_name,
          payroll_year,
          AVG(value) AS avg_payroll,
          LAG(payroll_year) OVER (PARTITION BY industry_branch_code
                                      ORDER BY payroll_year) previous_payroll_year,
          AVG(value) - lag(AVG(value)) OVER (PARTITION BY industry_branch_code
                                             ORDER BY payroll_year) payroll_change
   FROM T_TEREZA_BOHMOVA_PROJECT_SQL_PRIMARY_FINAL tb1
   WHERE value_type_code = '5958'     --průměrná hrubá mzda na zaměstnance
     AND calculation_code = '200'     --mzda na přepočtený počet zaměstnanců
   GROUP BY industry_branch_code,
            industry_branch_name,
            payroll_year)
SELECT pc.industry_branch_name,
       COUNT (*)
FROM payroll_comparison pc
WHERE pc.payroll_change < 0
GROUP BY pc.industry_branch_name
ORDER BY COUNT DESC;