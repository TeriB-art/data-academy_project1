--OTÁZKA 3: Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? 
--Skript 1 - preferovaná varianta, porovnání prvního a posledního roku ve vybraném období

SELECT date_part ('year', DATE_FROM ) AS food_price_year, 
       tb1.FOOD_CODE, tb1.FOOD_NAME, 
       AVG(tb1.FOOD_PRICE) AS avg_food_price,
       LAG(date_part('year',date_from)) OVER (PARTITION BY tb1.FOOD_CODE ORDER BY date_part('year',date_from)) previous_year,
       AVG(tb1.FOOD_PRICE)/LAG(AVG(tb1.FOOD_PRICE)) OVER (PARTITION BY tb1.food_code ORDER BY date_part('year',date_from)) price_change  
FROM T_TEREZA_BOHMOVA_PROJECT_SQL_PRIMARY_FINAL tb1
WHERE date_part ('year', DATE_FROM ) IN (2006,2018)
GROUP BY date_part ('year', DATE_FROM ), tb1.FOOD_CODE , tb1.FOOD_NAME 
ORDER BY PRICE_CHANGE; 

    --je nutno ale ověřit, že nezlevnilo víno (Skript1b)

SELECT date_part ('year', DATE_FROM ) AS food_price_year, 
       tb1.FOOD_CODE, tb1.FOOD_NAME, 
       AVG(tb1.FOOD_PRICE) AS avg_food_price,
       LAG(date_part('year',date_from)) OVER (PARTITION BY tb1.FOOD_CODE ORDER BY date_part('year',date_from)) previous_year,
       AVG(tb1.FOOD_PRICE)/LAG(AVG(tb1.FOOD_PRICE)) OVER (PARTITION BY tb1.food_code ORDER BY date_part('year',date_from)) price_change  
FROM T_TEREZA_BOHMOVA_PROJECT_SQL_PRIMARY_FINAL tb1
WHERE date_part ('year', DATE_FROM ) IN (2015,2018) AND tb1.FOOD_CODE = '212101'
GROUP BY date_part ('year', DATE_FROM ), tb1.FOOD_CODE , tb1.FOOD_NAME; 

--Skript 2 - další možný pohled (vychází ze skriptu výše, jen tabulka je za celé období a je vypočten průměr změny cen)

WITH avg_price_change AS (
                  SELECT date_part ('year', DATE_FROM ) AS food_price_year, 
                         tb1.FOOD_CODE AS fcode, tb1.FOOD_NAME AS fname , 
                         AVG(tb1.FOOD_PRICE) AS avg_food_price,
                         LAG(date_part('year',date_from)) OVER (PARTITION BY tb1.FOOD_CODE ORDER BY date_part('year',date_from)) previous_year,
                         AVG(tb1.FOOD_PRICE)/LAG(AVG(tb1.FOOD_PRICE)) OVER (PARTITION BY tb1.food_code ORDER BY date_part('year',date_from)) price_change  
                  FROM T_TEREZA_BOHMOVA_PROJECT_SQL_PRIMARY_FINAL tb1
                  GROUP BY date_part ('year', DATE_FROM ), tb1.FOOD_CODE, tb1.FOOD_NAME
                  )
SELECT apc.FCODE, apc.fname, avg(apc.PRICE_CHANGE) AS avg_price_change
FROM avg_price_change apc
GROUP BY apc.FCODE, apc.FNAME
ORDER BY AVG_PRICE_CHANGE; 
  
