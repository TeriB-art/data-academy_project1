--OTÁZKA 4: Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

--Skript 1: Změna ceny potravin oproti předchozímu roku 

CREATE TEMP TABLE price_change AS (
                    SELECT date_part ('year', DATE_FROM ) AS food_price_year, tb1.FOOD_CODE , tb1.FOOD_NAME, 
                           AVG(tb1.FOOD_PRICE) AS avg_food_price,
                           LAG(date_part('year',date_from)) OVER (PARTITION BY tb1.FOOD_CODE ORDER BY date_part('year',date_from)) previous_year,
                           AVG(tb1.FOOD_PRICE)/LAG(AVG(tb1.FOOD_PRICE)) OVER (PARTITION BY tb1.food_code ORDER BY date_part('year',date_from)) price_change  
                    FROM T_TEREZA_BOHMOVA_PROJECT_SQL_PRIMARY_FINAL tb1
                    GROUP BY date_part ('year', DATE_FROM ), tb1.FOOD_CODE , tb1.FOOD_NAME
                   );

--Skript 2: Změna výše mezd oproti předchozímu roku 

CREATE TEMP TABLE payroll_change AS ( 
                   SELECT tb1.VALUE_NAME, tb1.PAYROLL_YEAR,
                          round(avg(tb1.VALUE)) AS avg_payroll_per_year,
                          LAG(payroll_year) OVER (PARTITION BY tb1.VALUE_NAME ORDER BY payroll_year) payroll_previous_year, 
                          round(avg(tb1.VALUE))/lag(avg(tb1.VALUE)) OVER (PARTITION BY tb1.VALUE_NAME ORDER BY payroll_year) AS payroll_change
                   FROM T_TEREZA_BOHMOVA_PROJECT_SQL_PRIMARY_FINAL tb1
                   WHERE tb1.INDUSTRY_BRANCH_CODE IS NULL AND tb1.VALUE_TYPE_CODE = '5958' AND tb1.CALCULATION_CODE ='200'
                   GROUP BY tb1.value_name, tb1.PAYROLL_YEAR
                  );

--Skript 3: Porovnání změny cen potravin a výše mezd

WITH price_payroll_change AS (
                       SELECT *
                       FROM price_change pc
                       JOIN payroll_change payc
                          ON pc.food_price_year = payc.payroll_year
                       )
SELECT DISTINCT ppc.food_price_year, ppc.food_name, ppc.price_change/ppc.payroll_change AS price_payroll_rate
FROM price_payroll_change ppc
WHERE ppc.price_change/ppc.payroll_change > 1.1
ORDER BY price_payroll_rate desc, ppc.food_price_year;

--Skript 4: výpis pouze roků

WITH price_payroll_change AS (
                       SELECT *
                       FROM price_change pc
                       JOIN payroll_change payc
                          ON pc.food_price_year = payc.payroll_year
                       )
SELECT DISTINCT ppc.food_price_year
FROM price_payroll_change ppc
WHERE ppc.price_change/ppc.payroll_change > 1.1
ORDER BY ppc.food_price_year;


