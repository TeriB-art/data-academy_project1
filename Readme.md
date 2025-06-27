# Projekt SQL - Datová akademie Engeto

## Téma projektu
Projekt se zabývá dostupností základních potravin široké veřejnosti. Zadané výzkumné otázky a odpovědi na ně jsou v samostatném dokumentu: 

## Obsah
Projekt tvoří celkem 7 souborů.
- table1_prices+payroll.sql: vytvoření první podkladové tabulky "data mezd a cen potravin za Českou republiku sjednocených na totožné porovnatelné období – společné roky" (roky 2006-2018)
- table2_europe-countries-data.sql: vytvoření druhé podkladové tabulky  dodatečná data o dalších evropských státech za stejné období
- skripty poskytující odpovědi na jednotlivé otázky

## Technické informace
Zpracováno v Postresql.
### Výchozí datové sady: 
**Primární tabulky:**
- czechia_payroll (Informace o mzdách v různých odvětvích za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR.)
- czechia_payroll_calculation (Číselník kalkulací v tabulce mezd.)
- czechia_payroll_industry_branch (Číselník odvětví v tabulce mezd.)
- czechia_payroll_unit (Číselník jednotek hodnot v tabulce mezd.)
- czechia_payroll_value_type (Číselník typů hodnot v tabulce mezd.)
- czechia_price (Informace o cenách vybraných potravin za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR.)
- czechia_price_category (Číselník kategorií potravin, které se vyskytují v našem přehledu.)

**Číselníky sdílených informací o ČR:**
- czechia_region (Číselník krajů České republiky dle normy CZ-NUTS 2)
- czechia_district (Číselník okresů České republiky dle normy LAU.)

**Dodatečné tabulky:**
- countries (Všemožné informace o zemích na světě, například hlavní město, měna, národní jídlo nebo průměrná výška populace.)
- economies (HDP, GINI, daňová zátěž atd. pro daný stát a rok.)

Tyto datové sady jsou součástí databáze používané v kurzu. 



