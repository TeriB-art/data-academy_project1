--script na tvorbu tabulky s vybranými daty pro další evropské státy za stejné období jako tabulka 1

CREATE TABLE t_tereza_bohmova_project_SQL_secondary_final AS ( 
       SELECT e.COUNTRY, e."year", e.GDP, e.GINI, e.POPULATION
       FROM ECONOMIES E 
       WHERE (E."year" >=2006 AND e."year" <=2018) 
             AND (e.country IN(SELECT c.COUNTRY
                     FROM COUNTRIES C
                     WHERE c.CONTINENT = 'Europe'))
     );