--OTÁZKA 2: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

SELECT date_from,
       food_name,
       food_quantity,
       food_unit,
       round (AVG(food_price)::numeric, 2) AS avg_price,
       value AS payroll,
       round(value/AVG(food_price)::numeric, 0) AS quantity_to_buy
FROM T_TEREZA_BOHMOVA_PROJECT_SQL_PRIMARY_FINAL tb1
WHERE (to_char(date_from, 'YYYY-MM-DD') IN ('2006-01-02',
                                            '2018-12-10'))
  AND food_code IN ('114201',   --mléko polotučné pasterované
                    '111301')   -- chléb konzumní kmínový
  AND industry_branch_code IS NULL
  AND value_type_code = '5958'    -- průměrná hrubá mzda na zaměstnance
  AND calculation_code = '100'    -- mzda přepočtená na fyzický počet zaměstnanců
GROUP BY date_from,
         food_name,
         food_quantity,
         food_unit,
         value;