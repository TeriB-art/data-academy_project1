--OTÁZKA 2: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

SELECT tb1.DATE_FROM, tb1.FOOD_NAME, tb1.FOOD_QUANTITY, tb1.FOOD_UNIT, round (AVG(tb1.FOOD_PRICE)::numeric,2) AS avg_price, 
       tb1.value AS payroll,
       round(tb1.value/AVG(tb1.FOOD_PRICE)::numeric,0) AS quantity_to_buy
FROM T_TEREZA_BOHMOVA_PROJECT_SQL_PRIMARY_FINAL tb1
WHERE (to_char(tb1.DATE_FROM , 'YYYY-MM-DD') IN ('2006-01-02', '2018-12-10'))
     AND tb1.FOOD_CODE IN ('114201','111301')  
     AND tb1.INDUSTRY_BRANCH_CODE IS NULL
      AND tb1.value_type_code = '5958'
     AND tb1.CALCULATION_CODE = '100'    
GROUP BY tb1.DATE_FROM, tb1.FOOD_NAME, tb1.FOOD_QUANTITY, tb1.FOOD_UNIT, tb1.value