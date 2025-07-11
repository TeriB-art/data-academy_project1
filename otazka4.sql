--OTÁZKA 4: Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

--Skript 1: Změna ceny potravin oproti předchozímu roku 

CREATE TEMP TABLE price_change AS
  (SELECT date_part ('year', date_from) AS food_price_year,
          food_code,
          food_name,
          AVG(food_price) AS avg_food_price,
          LAG(date_part('year', date_from)) OVER (PARTITION BY food_code
                                                  ORDER BY date_part('year', date_from)) AS previous_year,
          AVG(food_price)/LAG(AVG(food_price)) OVER (PARTITION BY food_code
                                                     ORDER BY date_part('year', date_from)) AS price_change
   FROM T_TEREZA_BOHMOVA_PROJECT_SQL_PRIMARY_FINAL tb1
   GROUP BY date_part ('year', date_from),
            food_code,
            food_name);

--Skript 2: Změna výše mezd oproti předchozímu roku 

CREATE TEMP TABLE payroll_change AS
  (SELECT value_name,
          payroll_year,
          round(avg(value)) AS avg_payroll_per_year,
          LAG(payroll_year) OVER (PARTITION BY value_name
                                  ORDER BY payroll_year) AS payroll_previous_year,
          round(avg(value))/lag(avg(value)) OVER (PARTITION BY value_name
                                                  ORDER BY payroll_year) AS payroll_change
   FROM T_TEREZA_BOHMOVA_PROJECT_SQL_PRIMARY_FINAL tb1
   WHERE industry_branch_code IS NULL
     AND value_type_code = '5958'   -- kód pro mzdy 
     AND calculation_code ='200'    -- přepočtený typ výpočtu mzdy
   GROUP BY value_name,
            payroll_year);


--Skript 3: Porovnání změny cen potravin a výše mezd

WITH price_payroll_change AS
  (SELECT *
   FROM price_change pc
   JOIN payroll_change payc ON pc.food_price_year = payc.payroll_year)
SELECT DISTINCT ppc.food_price_year,
                ppc.food_name,
                ppc.price_change/ppc.payroll_change AS price_payroll_rate
FROM price_payroll_change ppc
WHERE ppc.price_change/ppc.payroll_change > 1.1
ORDER BY price_payroll_rate DESC,
         ppc.food_price_year;

--Skript 4: výpis pouze roků

WITH price_payroll_change AS
  (SELECT *
   FROM price_change pc
   JOIN payroll_change payc ON pc.food_price_year = payc.payroll_year)
SELECT DISTINCT ppc.food_price_year
FROM price_payroll_change ppc
WHERE ppc.price_change/ppc.payroll_change > 1.1
ORDER BY ppc.food_price_year;

