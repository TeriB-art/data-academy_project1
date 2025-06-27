--OTÁZKA 5: Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, 
--projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

--Skript 1: dočasná tabulka - změny cen potravin 

CREATE TEMP TABLE price_change AS (
       SELECT date_part ('year', DATE_FROM ) AS food_price_year, tb1.FOOD_CODE, tb1.FOOD_NAME, 
       AVG(tb1.FOOD_PRICE) AS avg_food_price,
       LEAD(date_part('year',date_from)) OVER (PARTITION BY tb1.FOOD_CODE ORDER BY date_part('year',date_from)) next_year,
       LEAD(AVG(tb1.FOOD_PRICE)) OVER (PARTITION BY tb1.food_code ORDER BY date_part('year',date_from)) next_year_price 
FROM T_TEREZA_BOHMOVA_PROJECT_SQL_PRIMARY_FINAL tb1
GROUP BY date_part ('year', DATE_FROM ), tb1.FOOD_CODE , tb1.FOOD_NAME
);

--Skript 2: dočasná tabulka - změny mezd 

CREATE TEMP TABLE payroll_change AS ( 
       SELECT tb1.VALUE_NAME,
       tb1.PAYROLL_YEAR,
       round(avg(tb1.VALUE)) AS avg_payroll_per_year,
       LEAD(payroll_year) OVER (PARTITION BY tb1.VALUE_NAME ORDER BY payroll_year) payroll_next_year, 
       LEAD(avg(tb1.VALUE)) OVER (PARTITION BY tb1.VALUE_NAME ORDER BY payroll_year) AS next_year_payroll
FROM T_TEREZA_BOHMOVA_PROJECT_SQL_PRIMARY_FINAL tb1
WHERE tb1.INDUSTRY_BRANCH_CODE IS NULL AND tb1.VALUE_TYPE_CODE = '5958' AND tb1.CALCULATION_CODE ='200'
GROUP BY tb1.value_name, tb1.PAYROLL_YEAR
);

--Skript 3: potřebná data HDP (GDP)

SELECT DISTINCT tb2.COUNTRY, tb2."year", tb2.GDP
FROM T_TEREZA_BOHMOVA_PROJECT_SQL_SECONDARY_FINAL tb2
WHERE (tb2."year" >= '2006' AND tb2."year" <'2018') AND tb2.COUNTRY = 'Czech Republic'
ORDER BY tb2."year";

--vlastní skripty pro výpočet výsledků 

--Skript 4: HDP a ceny potravin v tomto roce 

 WITH gdp_price_cor AS ( 
            SELECT *
            FROM price_change
            LEFT JOIN ( 
                   SELECT DISTINCT tb2.COUNTRY, tb2."year", tb2.GDP
                   FROM T_TEREZA_BOHMOVA_PROJECT_SQL_SECONDARY_FINAL tb2
                   WHERE (tb2."year" >= '2006' AND tb2."year" <'2018') AND tb2.COUNTRY = 'Czech Republic'
                   ORDER BY tb2."year"
                       ) cz_gdp 
                ON price_change.food_price_year = cz_gdp."year"
   )
SELECT gpc.food_name, corr(gpc.gdp, gpc.avg_food_price) AS cor_coef
FROM gdp_price_cor gpc
GROUP by gpc.food_name
HAVING corr(gpc.gdp, gpc.avg_food_price) >= 0.8
ORDER BY cor_coef DESC;

--Skript 5: HDP a ceny potravin v následujícím roce

WITH gdp_price_cor AS ( 
            SELECT *
            FROM price_change
            LEFT JOIN ( 
                   SELECT DISTINCT tb2.COUNTRY, tb2."year", tb2.GDP
                   FROM T_TEREZA_BOHMOVA_PROJECT_SQL_SECONDARY_FINAL tb2
                   WHERE (tb2."year" >= '2006' AND tb2."year" <'2018') AND tb2.COUNTRY = 'Czech Republic'
                   ORDER BY tb2."year"
                       ) cz_gdp 
                ON price_change.food_price_year = cz_gdp."year"
   )
SELECT gpc.food_name, corr(gpc.gdp, gpc.next_year_price) AS cor_coef
FROM gdp_price_cor gpc    
GROUP by gpc.food_name
HAVING corr(gpc.gdp, gpc.next_year_price) >= 0.8
ORDER BY cor_coef DESC;

--Skript 6: HDP a mzdy v tomto roce

WITH gdp_payroll_cor AS ( 
               SELECT *
               FROM payroll_change
               LEFT JOIN ( 
                     SELECT DISTINCT tb2.COUNTRY, tb2."year", tb2.GDP
                     FROM T_TEREZA_BOHMOVA_PROJECT_SQL_SECONDARY_FINAL tb2
                     WHERE (tb2."year" >= '2006' AND tb2."year" <'2018') AND tb2.COUNTRY = 'Czech Republic'
                     ORDER BY tb2."year"
                        ) cz_gdp 
                  ON payroll_change.payroll_year = cz_gdp."year"
         )
  SELECT CORR (gpayc.gdp, gpayc.avg_payroll_per_year)
  FROM gdp_payroll_cor gpayc;
  
  --Skript 7: HDP a mzdy v následujícím roce 
  
  WITH gdp_payroll_ny_cor AS ( 
               SELECT *
               FROM payroll_change
               LEFT JOIN ( 
                     SELECT DISTINCT tb2.COUNTRY, tb2."year", tb2.GDP
                     FROM T_TEREZA_BOHMOVA_PROJECT_SQL_SECONDARY_FINAL tb2
                     WHERE (tb2."year" >= '2006' AND tb2."year" <'2018') AND tb2.COUNTRY = 'Czech Republic'
                     ORDER BY tb2."year"
                        ) cz_gdp 
                  ON payroll_change.payroll_year = cz_gdp."year"
         )
  SELECT CORR (gpayny.gdp, gpayny.next_year_payroll)
  FROM gdp_payroll_ny_cor gpayny;
