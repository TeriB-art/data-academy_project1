--script na tvorbu tabulky s vybranými daty pro další evropské státy za stejné období jako tabulka 1

CREATE TABLE t_tereza_bohmova_project_SQL_secondary_final AS ( 
       SELECT e.country, e."year", e.gdp, e.gini, e.population
       FROM economies e 
       WHERE (e."year" >=2006 AND e."year" <=2018) 
             AND (e.country IN(SELECT c.country
                     FROM countries c
                     WHERE c.continent = 'Europe'))
     );
