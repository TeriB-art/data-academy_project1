--OTÁZKA 3: Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? 
--Skript 1 - preferovaná varianta, porovnání prvního a posledního roku ve vybraném období

SELECT date_part ('year', date_from) AS food_price_year,
       food_code,
       food_name,
       AVG(food_price) AS avg_food_price,
       LAG(date_part('year', date_from)) OVER (PARTITION BY food_code
                                               ORDER BY date_part('year', date_from)) previous_year,
       AVG(food_price)/LAG(AVG(food_price)) OVER (PARTITION BY food_code
                                                  ORDER BY date_part('year', date_from)) price_change
FROM T_TEREZA_BOHMOVA_PROJECT_SQL_PRIMARY_FINAL tb1
WHERE date_part ('year', date_from) IN (2006,
                                        2018)
GROUP BY date_part ('year', date_from),
         food_code,
         food_name
ORDER BY price_change;

    --je nutno ale ověřit, že nezlevnilo víno (Skript1b)

SELECT date_part ('year', date_from) AS food_price_year,
       food_code,
       food_name,
       AVG(food_price) AS avg_food_price,
       LAG(date_part('year', date_from)) OVER (PARTITION BY food_code
                                               ORDER BY date_part('year', date_from)) previous_year,
       AVG(food_price)/LAG(AVG(food_price)) OVER (PARTITION BY tb1.food_code
                                                      ORDER BY date_part('year', date_from)) price_change
FROM T_TEREZA_BOHMOVA_PROJECT_SQL_PRIMARY_FINAL tb1
WHERE date_part ('year', date_from) IN (2015,
                                        2018)
  AND food_code = '212101'              --kód pro víno
GROUP BY date_part ('year', date_from),
         food_code,
         food_name;

--Skript 2 - další možný pohled (vychází ze skriptu výše, jen tabulka je za celé období a je vypočten průměr změny cen)

WITH avg_price_change AS
  (SELECT date_part ('year', date_from) AS food_price_year,
          food_code AS fcode,
          food_name AS fname,
          AVG(food_price) AS avg_food_price,
          LAG(date_part('year', date_from)) OVER (PARTITION BY food_code
                                                  ORDER BY date_part('year', date_from)) previous_year,
          AVG(food_price)/LAG(AVG(food_price)) OVER (PARTITION BY food_code
                                                     ORDER BY date_part('year', date_from)) price_change
   FROM T_TEREZA_BOHMOVA_PROJECT_SQL_PRIMARY_FINAL tb1
   GROUP BY date_part ('year', date_from),
            food_code,
            food_name)
SELECT apc.fcode,
       apc.fname,
       avg(apc.price_change) AS avg_price_change
FROM avg_price_change apc
GROUP BY apc.fcode,
         apc.fname
ORDER BY avg_price_change;
  
