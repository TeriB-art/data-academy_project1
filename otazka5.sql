--OTÁZKA 5: Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, 
--projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

--Skript 1: dočasná tabulka - změny cen potravin 

CREATE TEMP TABLE price_change2 AS
  (SELECT date_part ('year', date_from) AS food_price_year,
          food_code,
          food_name,
          AVG(food_price) AS avg_food_price,
          LEAD(date_part('year', date_from)) OVER (PARTITION BY food_code
                                                   ORDER BY date_part('year', date_from)) AS next_year,
          LEAD(AVG(food_price)) OVER (PARTITION BY food_code
                                      ORDER BY date_part('year', date_from)) AS next_year_price
   FROM T_TEREZA_BOHMOVA_PROJECT_SQL_PRIMARY_FINAL tb1
   GROUP BY date_part ('year', date_from),
            food_code,
            food_name);


--Skript 2: dočasná tabulka - změny mezd 

CREATE TEMP TABLE payroll_change2 AS
  (SELECT value_name,
          payroll_year,
          round(avg(value)) AS avg_payroll_per_year,
          LEAD(payroll_year) OVER (PARTITION BY value_name
                                   ORDER BY payroll_year) AS payroll_next_year,
          LEAD(avg(value)) OVER (PARTITION BY value_name
                                 ORDER BY payroll_year) AS next_year_payroll
   FROM T_TEREZA_BOHMOVA_PROJECT_SQL_PRIMARY_FINAL tb1
   WHERE industry_branch_code IS NULL
     AND value_type_code = '5958'    --průměrná mzda
     AND calculation_code ='200'     --přepočtený typ výpočtu mzdy na plný úvazek
   GROUP BY value_name,
            payroll_year);

--Skript 3: potřebná data HDP (GDP)

SELECT DISTINCT country,
                year,
                gdp
FROM T_TEREZA_BOHMOVA_PROJECT_SQL_SECONDARY_FINAL tb2
WHERE (year >= 2006
       AND year <2018)
  AND country = 'Czech Republic'
ORDER BY year;

--vlastní skripty pro výpočet výsledků 

--Skript 4: HDP a ceny potravin v tomto roce 

WITH gdp_price_cor AS
  (SELECT *
   FROM price_change2
   LEFT JOIN
     (SELECT DISTINCT country,
                      year,
                      gdp
      FROM T_TEREZA_BOHMOVA_PROJECT_SQL_SECONDARY_FINAL tb2
      WHERE (year >= 2006
             AND year <2018)
        AND country = 'Czech Republic'
      ORDER BY year) cz_gdp 
          ON price_change2.food_price_year = cz_gdp.year)
SELECT gpc.food_name,
       corr(gpc.gdp, gpc.avg_food_price) AS cor_coef
FROM gdp_price_cor gpc
GROUP BY gpc.food_name
HAVING corr(gpc.gdp, gpc.avg_food_price) >= 0.8
ORDER BY cor_coef DESC;

--Skript 5: HDP a ceny potravin v následujícím roce

WITH gdp_price_cor AS
  (SELECT *
   FROM price_change2
   LEFT JOIN
     (SELECT DISTINCT country,
                      year,
                      gdp
      FROM T_TEREZA_BOHMOVA_PROJECT_SQL_SECONDARY_FINAL tb2
      WHERE (year >= 2006
             AND year <2018)
        AND country = 'Czech Republic'
      ORDER BY year) cz_gdp ON price_change2.food_price_year = cz_gdp.year)
SELECT gpc.food_name,
       corr(gpc.gdp, gpc.next_year_price) AS cor_coef
FROM gdp_price_cor gpc
GROUP BY gpc.food_name
HAVING corr(gpc.gdp, gpc.next_year_price) >= 0.8
ORDER BY cor_coef DESC;

--Skript 6: HDP a mzdy v tomto roce

WITH gdp_payroll_cor AS
  (SELECT *
   FROM payroll_change2
   LEFT JOIN
     (SELECT DISTINCT country,
                      year,
                      gdp
      FROM T_TEREZA_BOHMOVA_PROJECT_SQL_SECONDARY_FINAL tb2
      WHERE (year >= 2006
             AND year <2018)
        AND country = 'Czech Republic'
      ORDER BY year) cz_gdp 
         ON payroll_change2.payroll_year = cz_gdp.year)
SELECT corr (gpayc.gdp, gpayc.avg_payroll_per_year)
FROM gdp_payroll_cor gpayc;


  --Skript 7: HDP a mzdy v následujícím roce 
   
  WITH gdp_payroll_cor AS
  (SELECT *
   FROM payroll_change2
   LEFT JOIN
     (SELECT DISTINCT country,
                      year,
                      gdp
      FROM T_TEREZA_BOHMOVA_PROJECT_SQL_SECONDARY_FINAL tb2
      WHERE (year >= 2006
             AND year <2018)
        AND country = 'Czech Republic'
      ORDER BY year) cz_gdp 
         ON payroll_change2.payroll_year = cz_gdp.year)
  SELECT corr (gpayc.gdp, gpayc.next_year_payroll)
  FROM gdp_payroll_cor gpayc;
